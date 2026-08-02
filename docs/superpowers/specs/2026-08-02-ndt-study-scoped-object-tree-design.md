# NDT Study 范围对象树设计

## 背景

OHIF 每次只通过一个 `StudyInstanceUIDs` 参数加载一个检测 Study，但工业检测左侧对象树当前调用任务级接口 `/ndt/task/{taskId}/object-tree`。该接口按部位查询任务内的全部 DICOM 对象；当同一工件存在多个 Study 时，不同 Study 的对象会被合并到同一个部位节点。

## 目标

- OHIF 左侧对象树只返回当前打开 Study 的工件、部位和 DICOM 对象。
- 保留 `taskId`，继续用于任务权限、缺陷和评定上下文。
- 保持现有任务级对象树接口向后兼容，避免影响若依 DICOM 管理页面。
- 拒绝 `studyId` 与路径中的 `taskId` 不匹配的请求。

## 接口设计

继续使用现有接口：

```text
GET /ndt/task/{taskId}/object-tree
```

增加可选查询参数：

```text
GET /ndt/task/{taskId}/object-tree?studyId={studyId}
```

- 未提供 `studyId`：保持原有任务级返回行为。
- 提供 `studyId`：验证 Study 存在且属于 `{taskId}`，只返回该 Study 所属的一个工件及其部位；每个部位只查询该 Study 下的对象。
- Study 不存在或不属于任务：返回业务错误，不降级为任务级查询。

## OHIF 启动与数据流

若依生成 OHIF 地址时，同时携带数据库主键 `studyId`：

```text
/industrial-viewer?StudyInstanceUIDs={uid}&taskId={taskId}&studyId={studyId}&canEvaluate={value}
```

工业检测扩展从 URL 解析 `studyId`，并在请求对象树时将其作为查询参数发送：

```text
GET /ndt/task/{taskId}/object-tree?studyId={studyId}
```

`StudyInstanceUIDs` 仍负责让 OHIF/DICOMWeb 加载影像，`studyId` 只负责若依业务对象树过滤。两者由后端从同一条 Study 记录生成，避免客户端自行匹配。

## 后端过滤规则

Study 范围请求按以下顺序处理：

1. 检查当前用户是否有任务查看权限。
2. 查询 `studyId`，验证其 `task_id` 等于路径中的 `taskId`。
3. 只构造该 Study 所属工件节点。
4. 保留工件的全部长期部位主数据。
5. 每个部位只查询同时满足 `ds.study_id = studyId` 和 `ds.position_id = positionId` 的对象。
6. 返回结构继续使用现有 `NdtTaskObjectTreeVo`，避免前端树组件重构。

## 兼容性

- 若依 DICOM 管理页继续调用不带 `studyId` 的任务级接口，行为不变。
- 新生成的 OHIF 地址一定包含 `studyId`。
- 不为缺少 `studyId` 的旧 OHIF 链接静默执行任务级查询；OHIF 工业扩展应提示启动 URL 缺少 `studyId`，防止再次出现跨 Study 混合。
- `taskId`、令牌传递及评定权限逻辑保持不变。

## 错误处理

- URL 缺少 `taskId` 或 `studyId`：OHIF 左侧面板显示明确缺少参数提示，不发送对象树请求。
- Study 不存在：后端返回“检测 Study 不存在”。
- Study 不属于任务：后端返回“检测 Study 与任务不匹配”。
- 无查看权限：继续使用现有任务权限错误。

## 测试范围

- 后端服务测试：同一工件存在两个 Study 时，Study 范围树只包含目标 Study 的对象。
- 后端服务测试：拒绝属于其他任务的 `studyId`。
- URL 生成测试：OHIF 地址包含 `studyId`。
- OHIF 客户端测试：解析 `studyId`，并请求带 `studyId` 查询参数的对象树接口。
- 兼容性测试：不传 `studyId` 时，现有任务级对象树调用方式保持可用。

## 非目标

- 不改变数据库表结构。
- 不改变 Orthanc 中的 Study/Series/Instance。
- 不修改任务级 DICOM 管理页面的对象树用途。
- 不重构左侧树的工件、部位和对象展示层级。
