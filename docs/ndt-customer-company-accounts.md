# 客户公司与 OHIF 客户访问

更新日期：2026-10-14。

## 已实现的行为

- “无损检测管理 → 客户公司管理”：上层管理客户公司；选中公司后，下层管理它的客户账号。
- 公司支持新增、编辑、删除；存在未删除账号（含停用账号）或未删除检测任务时，禁止删除公司。
- 客户账号支持新增、编辑资料、停用、删除、重置密码。登录名创建后固定，所属公司创建后固定，不提供转移公司操作。
- 登录账号仍存放在 `sys_user`，密码、认证和角色复用若依。客户账号的部门为空，自动分配 `ndt_customer` 角色。
- 内部“用户管理”列表及导出不包含已绑定客户公司的账号；其编辑、删除、停用、重置密码和授权操作引导到客户公司管理。普通用户管理不允许直接创建或授予客户角色。
- 客户登录页面为 OHIF 的 `/customer-login`，调用若依 `/login`，随后校验 `/ndt/viewer/session`，成功进入 OHIF 列表。
- token 保存在 OHIF 的 `sessionStorage`，键名 `ndt.ruoyiToken`；列表、图像、工业业务接口均携带 `Authorization: Bearer <token>`。已有内部后台打开 OHIF 的 token 启动方式继续支持，并清理地址栏中的 token。
- OHIF 不读取若依管理端的 `Admin-Token` Cookie（同一主机的 Cookie 不按端口隔离）。直接访问首页且没有 OHIF 会话时，跳转 `/customer-login?next=%2F`；客户已登录或通过后台携带 token 打开影像的标签页，在会话有效时刷新仍保持登录。会话过期或退出后，不能回退到管理端登录状态。
- 客户公司由后端从当前账号的绑定记录确定。查询参数、任务分配或额外角色不能扩大客户的数据范围，也不能授予客户写入能力。
- 开发阶段所有角色在 OHIF 工业查看页面使用相同的工具栏、左右面板和本地交互；不再按客户身份裁剪工具或清空右侧面板。评定保存、创建 SR 及派生文件导出在操作时检查权限，无权限则提示原因并停止，不禁用按钮来隐藏反馈；后端继续独立拒绝客户管理和业务写入请求，客户只能查看本公司的图像。
- 查看页面总是从后端解析 Study 归属及操作权限，不采信 URL 中的 `canEvaluate`、任务 ID、Study 数据库 ID 等权限提示。
- 任务编辑原有的客户公司变更功能保留。变更后，图像归属随任务变化；旧公司失去访问权限，新公司获得访问权限。
- 修改账号资料、停用、删除、重置密码会清除其已有登录会话；每次请求还检查账号、客户角色和公司是否有效。

## 数据关系

`sys_user.user_id → ndt_customer_user.customer_id → ndt_customer.id → ndt_inspection_task.customer_id → 工件 / Study / 序列 / 图像`

新增表 `ndt_customer_user`：`user_id` 为主键，`customer_id` 为所属公司，另存创建人和创建时间。一个账号只绑定一家公司；一家公司可有多个账号。

账号和公司仍采用原有软删除方式。删除账号后保留绑定记录，避免尚未失效的旧会话被误认成内部账号。

## 接口

公司 CRUD 继续使用原有 `/ndt/customer` 接口。

| 接口 | 输入 | 返回与用途 |
|---|---|---|
| `GET /ndt/customer/{customerId}/accounts` | `pageNum`、`pageSize` | `rows`、`total`；公司下的账号，不包含密码 |
| `POST /ndt/customer/{customerId}/accounts` | `userName`、`nickName`、`password`；可选邮箱、手机号、状态、备注 | 若依操作结果；创建账号并绑定路径中的公司 |
| `PUT /ndt/customer/{customerId}/accounts/{userId}` | 原登录名、昵称、邮箱、手机号、状态、备注 | 操作结果；不允许修改公司、内部部门或角色 |
| `DELETE /ndt/customer/{customerId}/accounts/{userId}` | 公司 ID、账号 ID | 操作结果；校验归属并软删除账号 |
| `PUT /ndt/customer/{customerId}/accounts/{userId}/password` | `password` | 操作结果；重置密码并使旧会话失效 |
| `POST /login` | `username`、`password`、验证码 `code`、`uuid` | 原若依 `token` |
| `GET /ndt/viewer/session` | Bearer token | 当前账号、公司、客户身份及本地查看能力 |
| `GET /ndt/study/viewer-context` | `studyInstanceUid`、Bearer token | 任务 / Study ID、客户身份、是否可评定 / 创建 SR 等 |
| `GET /ndt/viewer/dicom-web/**` | 标准 DICOMweb 查询参数、Bearer token | QIDO 列表、元数据、图像帧等；独立检查公司或任务访问权限 |

账号控制器：`NdtCustomerAccountController` 的 `listAccounts`、`addAccount`、`editAccount`、`removeAccount`、`resetPassword`。身份及 DICOMweb 控制器：`NdtViewerController.session`、`dicomWeb`。

## 数据库与启动

迁移文件：`sql/ndt_customer_accounts_20261014.sql`。已通过 MySQL MCP 应用于当前 `ry-vue` 数据库，包括绑定表、菜单名称、账号管理权限和客户角色权限收敛；换环境部署时需执行该文件。

若依后端和两个前端需要重新启动或部署最新构建。后台刷新菜单后即可看到“客户公司管理”；如账号管理按钮未出现，重新登录以更新权限。

开发环境使用 `yarn dev:orthanc`。已配置 `/ndt-api` 转发到若依 `http://localhost:8080`，DICOMweb 地址为 `/ndt-api/ndt/viewer/dicom-web`。客户入口通常为 `http://localhost:3000/customer-login`。

Webpack 的开发代理配置不会随页面代码热更新。修改代理后必须停止并重新启动 OHIF 开发服务，再刷新页面。如果验证码返回 401，且错误消息中的后端路径仍是 `/ndt-api/captchaImage`，说明代理没有移除前缀；正常转发后的路径应是 `/captchaImage`。

`docker-nginx-orthanc.js` 和 `ndt-prod-orthanc.js` 已启用上述身份校验。使用其他 OHIF 配置时，也需设置 `ndtAuth: { enabled: true, apiBase: '/ndt-api' }` 并将业务 DICOM 数据源指向鉴权网关。

生产 Nginx 必须提供 `/ndt-api/` 到若依的代理。仓库中的 Nginx-Orthanc 示例使用 `host.docker.internal:8080`；后端位于其他主机或 Docker 网络时，应改为对应内部地址。`ndt.ohif.api-base` 与 OHIF 的 `ndtAuth.apiBase` 需要保持一致，默认均为 `/ndt-api`。

不再将 Orthanc REST 管理接口通过 `/pacs/` 暴露给客户。Orthanc HTTP 端口的 Compose 配置限制到 `127.0.0.1:8042`；部署时也应确保归档 HTTP 服务只供内部后端访问。DICOM 设备接入端口 4242 的配置保留。

OHIF 列表仅展示若依中已有任务归属的 Study。单独存放在 Orthanc、尚未进入若依业务结构的 Study 不会出现在此列表。当前列表代理在归档端查询后先按权限过滤，再分页；大规模数据场景可进一步优化查询性能。

## 验证

- 若依后端 38 项测试通过；OHIF 扩展与认证相关 21 项测试通过；两个前端生产构建通过。
- 覆盖公司数据范围、额外角色不能扩大客户权限、分页保护、接口只读边界、元数据 BulkDataURI 经过网关、URL 权限提示不可信等回归测试。
- 使用当前 MySQL、Redis、Orthanc 完成 52 项接口检查，验证公司 / 账号 CRUD、跨公司阻断、图像元数据与像素读取、账号停用 / 删除 / 重置密码、任务公司变更、内部用户列表隔离，以及错误授予管理员角色也不能扩大客户权限。
- 浏览器验证客户登录、OHIF 列表与查看、页面刷新，以及客户公司账号表单不出现内部部门、所属公司不可编辑。

测试使用临时账号和记录，不修改已有检测任务的客户归属。临时账号、角色、公司、任务和登录会话已清理；验证操作保留审计日志。
