# NDT DICOM/DICONDE 业务重构说明

## 1. 本次改造原则

本次改造直接切换到新模型，不迁移旧业务数据，不保留旧接口，不做双读、字段别名或兼容适配。

- `sys_*` 表结构未修改。
- `sys_menu`、`sys_role_menu`、`sys_dict_type`、`sys_dict_data` 仅更新了业务菜单、权限和字典数据。
- 旧 `dcm_*`、`ndt_*` 核心业务数据可直接丢弃。
- RuoYi 后端、RuoYi-Vue3、OHIF 工业扩展统一使用新字段和新接口。

## 2. 新业务模型

新的主业务链路如下：

```text
客户 ndt_customer
└─ 检测任务 ndt_inspection_task
   ├─ 任务成员 ndt_task_user
   ├─ 工件 ndt_workpiece
   │  ├─ 检测部位 ndt_inspection_position
   │  │  └─ DICOM/派生对象 ndt_dicom_object
   │  │     ├─ 对象关系 ndt_dicom_object_relation
   │  │     └─ 缺陷 ndt_defect
   │  │        └─ 评定 ndt_evaluation
   │  │           └─ 复核记录 ndt_evaluation_review
   │  └─ 工件级评定 ndt_evaluation
   └─ PDF报告 ndt_task_report
```

### 新建或重建的核心表

| 表 | 用途 |
| --- | --- |
| `ndt_customer` | 独立客户主数据，不再借用 RuoYi 部门表达客户 |
| `ndt_inspection_task` | 客户下的检测任务 |
| `ndt_workpiece` | 任务内工件 |
| `ndt_inspection_position` | 工件检测部位 |
| `ndt_dicom_object` | 原始图、处理图、截图、标注图、PR、SR 等统一对象 |
| `ndt_dicom_object_relation` | 来源对象与派生对象关系 |
| `ndt_defect` | 与原始图对象关联的 ROI 缺陷 |
| `ndt_evaluation` | 缺陷评定或工件评定 |
| `ndt_evaluation_review` | 只追加、不覆盖的复核历史 |
| `ndt_task_report` | 任务级 PDF 报告及版本 |

### 保留的辅助表

以下表结构继续使用，但不再保存旧核心模型主键：

- `dcm_validation_rule`
- `dcm_validation_record`
- `ndt_dicom_integrity_record`
- `ndt_dicom_private_tag`
- `ndt_uid_rule`
- `ndt_inspector_profile`
- `ndt_task_user`

重构脚本会清空旧任务成员、人员档案、完整性记录、校验记录和旧测试校验规则。UID 规则和私有 Tag 配置保留。

### 删除的旧表

- `dcm_study`
- `dcm_series`
- `dcm_instance`
- `dcm_evaluation`
- `ndt_inspection_part`
- `ndt_dicom_series`
- `ndt_dicom_instance`
- `ndt_part_dicom_object`

## 3. 数据库文件

| 文件 | 说明 |
| --- | --- |
| `sql/ry-vue.sql` | 已按当前数据库重新导出的完整、干净基线 |
| `sql/ndt_schema_redesign_20260728.sql` | 对已有库直接执行的破坏性业务表重构脚本 |
| `sql/ndt_application_menu_update_20260728.sql` | 新菜单、按钮权限、角色授权和业务字典 |
| `sql/verify_ndt_schema_redesign_20260728.sql` | 新表、旧表和外键验证 |

数据库改造前备份位于：

```text
C:\Users\china\Code\DICOM-SYS\.dev-state\backups\ry-vue-before-ndt-redesign-20260728-222048.sql
```

### 推荐初始化方式

新环境直接导入完整基线：

```powershell
Get-Content .\sql\ry-vue.sql -Raw -Encoding utf8 |
  docker exec -i mysql-dev mysql -uroot -p123123 ry-vue
```

已有但允许丢弃业务数据的环境，依次执行：

```powershell
Get-Content .\sql\ndt_schema_redesign_20260728.sql -Raw -Encoding utf8 |
  docker exec -i mysql-dev mysql -uroot -p123123 ry-vue

Get-Content .\sql\ndt_application_menu_update_20260728.sql -Raw -Encoding utf8 |
  docker exec -i mysql-dev mysql -uroot -p123123 ry-vue

Get-Content .\sql\verify_ndt_schema_redesign_20260728.sql -Raw -Encoding utf8 |
  docker exec -i mysql-dev mysql -uroot -p123123 --table ry-vue
```

验证结果应为：

- `target_table_count = 10`
- `ndt_foreign_key_count = 11`
- 8 张旧核心表均不存在

## 4. RuoYi 后端修改

`ruoyi-dcm` 已按业务域拆分 Entity、DTO、VO、Mapper、Service 和 Controller：

- 客户：`/ndt/customer`
- 任务和任务成员：`/ndt/task`
- 工件：`/ndt/workpiece`
- 检测部位：`/ndt/position`
- DICOM/派生对象：`/ndt/dicom/object`
- 对象关系：`/ndt/dicom/relation`
- 缺陷：`/ndt/defect`
- 评定及 DICOM SR 提交：`/ndt/evaluation`
- 评定复核：`/ndt/evaluation/review`
- 任务 PDF 报告：`/ndt/report`
- 完整性校验：`/ndt/integrity`
- Orthanc 层级和只读 Tag：`/ndt/orthanc`

主要行为：

- 上传原始 DICOM 时必须指定 `positionId`。
- 文件先完成 DICOM 元数据及规则校验，通过后上传 Orthanc。
- 上传成功后建立 `ORIGINAL_IMAGE` 对象、SHA-256 和完整性记录。
- SR 等派生 DICOM 建立统一对象记录及来源关系。
- 派生对象不能伪装成 `ORIGINAL_IMAGE`，也不能跨任务关联。
- 缺陷只允许关联 `ORIGINAL_IMAGE`。
- 评定必须且只能关联一个缺陷或一个工件。
- 已提交评定不可修改或删除；复核采用追加记录。
- PDF 报告按任务自动递增版本并保存 SHA-256。
- 非管理员只能访问 `ndt_task_user` 明确分配且 `can_view=1` 的任务。
- 上传、评定、管理分别检查 `can_upload`、`can_evaluate` 和创建者/公司管理员权限。

已删除旧 Study/Series/Instance/Evaluation Controller、Service、Mapper 和对应旧测试代码。

## 5. RuoYi-Vue3 修改

业务页面已切换为：

- 客户管理：真实 `ndt_customer` CRUD。
- 任务管理：任务、工件、检测部位和任务成员集中管理。
- DICOM 对象：按检测部位上传，查看 Tag、关系、下载和删除。
- 缺陷评定：缺陷、评定草稿、提交和复核记录。
- 报告管理：任务 PDF 上传、版本、下载、发布和删除。
- OHIF 入口：按任务打开工业阅片。
- Orthanc 浏览：按任务展示 Study/Series/Object 层级，Tag 只读。
- 完整性页面：统一使用 `objectId`。

旧 `/dcm/study`、`/dcm/upload`、`/dcm/evaluation` 页面及 API 已删除。

## 6. OHIF Viewer 修改

修改目录：

```text
C:\Users\china\Code\DICOM-SYS\Viewers\extensions\industrial-review
```

主要修改：

- 对象树固定为 `workpieces -> positions -> objects`，不再解析旧 `part`、`instance` 或 snake_case 别名。
- 对象类型固定为：
  `ORIGINAL_IMAGE`、`PROCESSED_IMAGE`、`SCREENSHOT`、`ANNOTATION_IMAGE`、`PRESENTATION_STATE`、`SR`、`OTHER`。
- 当前影像通过 SOP Instance UID 映射到 `ndt_dicom_object.id`。
- OHIF ROI 几何保存到 `ndt_defect.roi_data_json`。
- 缺陷结论单独保存到 `ndt_evaluation`。
- 同一 ROI 再次保存时更新原缺陷和草稿评定，避免重复插入。
- “保存并提交 DICOM SR”会生成真实 SR Blob，上传为 `SR` 对象并建立来源关系。
- RuoYi 登录令牌只使用启动参数 `token` 和会话键 `ndt.ruoyiToken`。
- OHIF 读取令牌后立即通过 `history.replaceState` 从地址栏移除。
- 已删除旧评定历史和旧对象关系兼容 Hook。

## 7. 权限与菜单

没有修改任何 `sys_*` 表结构。

业务数据脚本完成了：

- 删除旧 DCM 菜单 `2000-2012`。
- 将原“公司管理”页面改为“客户管理”。
- 增加客户、工件、部位、对象、缺陷、提交、复核和报告按钮权限。
- `ndt_company_admin` 获得全部 NDT 菜单和动作。
- `ndt_inspector` 获得被分配任务的上传、评定、复核和报告相关权限。
- `ndt_customer` 获得被分配任务的只读对象、评定、复核和报告权限。
- 删除已废弃的 DCM Study/旧评定字典，增加新任务、工件、对象、评定类型、报告和复核字典。

超级管理员仍由 RuoYi 自带的管理员逻辑拥有全部权限。

## 8. 配置要求

后端配置位于：

```text
ruoyi-admin/src/main/resources/application.yml
ruoyi-admin/src/main/resources/application-druid.yml
```

重点配置：

```yaml
dcm:
  validation:
    official-enabled: true
    official-command: validate_iods

ndt:
  orthanc:
    base-url: http://localhost:8042
  ohif:
    viewer-url: http://localhost:3000/industrial-viewer
```

生产环境建议安装 dicom3tools 并保证 `validate_iods` 在后端进程 PATH 中。开发机未安装该命令时，可临时设置：

```yaml
dcm:
  validation:
    official-enabled: false
```

关闭官方命令只适合本地联调，自定义规则校验仍会执行。

PDF 报告保存在：

```text
${ruoyi.profile}/ndt-reports/{taskId}/
```

生产环境必须把 `ruoyi.profile` 配置为持久化目录。

## 9. 启动方式

先启动 MySQL、Redis 和 Orthanc，再启动后端：

```powershell
cd C:\Users\china\Code\DICOM-SYS\ruoyi
mvn -pl ruoyi-admin -am clean package
java -jar .\ruoyi-admin\target\ruoyi-admin.jar
```

两个前端可从工作区根目录一键启动：

```powershell
cd C:\Users\china\Code\DICOM-SYS
.\dev.ps1 start
```

也可以分别启动：

```powershell
cd C:\Users\china\Code\DICOM-SYS\ruoyi\ruoyi-ui\RuoYi-Vue3
yarn dev

cd C:\Users\china\Code\DICOM-SYS\Viewers
yarn dev:orthanc
```

若 OHIF 出现旧 Webpack 热更新缓存错误，使用：

```powershell
cd C:\Users\china\Code\DICOM-SYS\Viewers
yarn workspace @ohif/app dev:orthanc:no:cache
```

## 10. 自动化验证命令

后端测试和完整打包：

```powershell
docker run --rm `
  -v "C:\Users\china\Code\DICOM-SYS\ruoyi:/workspace" `
  -v "C:\Users\china\.m2:/root/.m2" `
  -w /workspace maven:3.9.9-eclipse-temurin-17 `
  mvn -pl ruoyi-admin -am clean test package
```

RuoYi-Vue3：

```powershell
cd C:\Users\china\Code\DICOM-SYS\ruoyi\ruoyi-ui\RuoYi-Vue3
yarn build:prod
```

OHIF 工业扩展测试：

```powershell
cd C:\Users\china\Code\DICOM-SYS\Viewers
yarn jest `
  extensions/industrial-review/src/api/ndtClient.test.ts `
  extensions/industrial-review/src/utils/ndtObjectTree.test.ts `
  extensions/industrial-review/src/utils/serializeNdtAnnotation.test.ts `
  extensions/industrial-review/src/panels/PanelDefectList.test.ts `
  --runInBand --coverage=false
```

OHIF 构建：

```powershell
yarn workspace @ohif/extension-industrial-review build
yarn workspace @ohif/mode-industrial-longitudinal build
yarn workspace @ohif/app clean
yarn workspace @ohif/app build --no-cache
```

## 11. 手工功能测试顺序

1. 使用管理员登录 RuoYi，确认“客户管理”可新增、编辑、删除。
2. 新建任务，选择客户；进入“工件/部位”新增一个工件和至少一个检测部位。
3. 在“成员”中分配上传者、评定者或查看者，确认三个权限开关。
4. 在 DICOM 对象页选择检测部位并上传 DICOM：
   - 合法文件应进入 Orthanc并生成对象及完整性记录；
   - 缺少必备 Tag 的文件应只生成失败校验记录，不进入 Orthanc。
5. 查看对象 Tag、下载文件和对象关系列表。
6. 从任务页或 OHIF 入口打开工业阅片：
   - 地址必须包含 `taskId`；
   - 页面载入后地址栏中的 `token` 应立即消失；
   - 左侧对象树应显示工件、部位和对象。
7. 使用 Rectangle ROI、Freehand ROI 或 Probe 标注缺陷，填写类型、等级、结论：
   - “保存草稿”应生成一条缺陷和一条 `DRAFT` 评定；
   - 再次保存同一 ROI 应更新草稿，不应产生重复缺陷；
   - “保存并提交 DICOM SR”应把评定改为 `SUBMITTED`，并新增 `SR` 对象和关系。
8. 在 RuoYi 缺陷评定页追加 `PASS` 或 `REJECT` 复核，确认历史只追加。
9. 上传任务 PDF 报告，确认版本递增、SHA-256、下载和发布状态。
10. 使用普通检测员或客户账号验证：只可看到 `ndt_task_user` 已分配的任务，并受上传/评定开关限制。

## 12. 已完成的验证

本次修改完成时已执行：

- MySQL 结构验证：10 张目标表、11 个 NDT 外键、8 张旧表均不存在。
- Java 全 Reactor 编译、14 个后端测试和 `ruoyi-admin` 打包通过。
- 后端真实启动并连接 MySQL、Redis、Orthanc。
- API 联调通过：客户、任务、工件、部位、对象树。
- 真实 DICOM 联调通过：校验、Orthanc 上传、对象记录、完整性记录。
- API 联调通过：缺陷新增、评定新增并返回主键、提交、复核追加。
- RuoYi-Vue3 生产构建通过。
- OHIF 新契约 13 个测试通过。
- OHIF 工业扩展、工业 mode 和完整 app 构建通过；完整 app 使用 `--no-cache` 避免仓库已有缓存污染。

构建期间仅出现 OHIF/Jest 现有配置警告、Browserslist 数据过期提示和 bundle 体积提示，不影响本次构建结果。

## 13. 当前实现边界

- 不提供旧接口、旧字段或旧表兼容。
- DICOM Tag 浏览为只读；私有 Tag 规则仍在独立配置页维护。
- 删除业务对象采用 RuoYi 风格逻辑删除，默认不联动删除 Orthanc 原文件。
- 报告当前由用户上传 PDF，不在后端自动排版生成。
- 报告默认使用本地文件系统，若部署多实例，应把报告目录换成共享卷或对象存储。
- 任务可以包含多个 Study；OHIF 启动时会合并任务内去重后的 Study Instance UID。
