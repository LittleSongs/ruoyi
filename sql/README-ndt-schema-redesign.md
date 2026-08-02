# NDT 核心业务数据库重构说明

## 1. 本次修改结论

本次直接重建了 `ry-vue` 数据库中的 NDT 核心业务结构：

```text
客户
└─检测任务
  ├─工件
  │ ├─稳定检测部位（工件主数据）
  │ ├─检测Study（工件的一次检测/一种检测方法）
  │ │ └─Series（关联一个稳定检测部位）
  │ │   └─DICOM及派生对象
  │ │     └─缺陷
  │ │       └─缺陷评定
  │ └─工件总体评定
  └─任务级PDF报告

评定
└─复核记录
```

现有核心业务数据已按要求放弃，没有执行历史数据迁移，也没有保留旧结构双读兼容。

本次没有修改任何 `sys_*` 表结构。该限制只针对本轮数据库结构重构；后续实现菜单、角色权限和业务字典时，可以根据功能需要修改相应的 `sys_*` 数据。

## 2. 相关文件

| 文件 | 用途 |
|---|---|
| `sql/ndt_schema_redesign_20260728.sql` | 集中重建脚本，会删除旧核心业务数据 |
| `sql/verify_ndt_schema_redesign_20260728.sql` | 结构、外键和空表验证脚本 |
| `sql/ndt_study_hierarchy_20260802.sql` | 从旧对象直连部位结构迁移到 Study/Series 层级 |
| `sql/ndt_series_object_placement_20260802.sql` | 删除 `series_role` 并约束每个 Series 仅一张有效原始图 |
| `sql/clear_ndt_dicom_test_data.sql` | 日常测试一键清理 DICOM 业务数据，保留任务、工件和稳定部位 |
| `sql/ry-vue.sql` | 根据修改后的实际 `ry-vue` 重新导出的完整数据库基线 |
| `sql/README-ndt-schema-redesign.md` | 本说明文档 |

执行重建脚本前，应先对目标数据库做全量备份。脚本需要 MySQL 8.0 或更高版本。

## 3. 新核心表

### 3.1 `ndt_customer`

客户主数据。

主要字段：

- `id`
- `name`
- `contact_name`
- `contact_phone`
- `remark`
- RuoYi 创建、更新和逻辑删除字段

`name` 建普通查询索引，允许现实业务中存在同名客户。

### 3.2 `ndt_inspection_task`

检测任务，只保存任务自身信息，不再保存工件名称、Study UID 或 Orthanc Study ID。

主要字段：

- `id`
- `customer_id`
- `task_name`
- `task_no`
- `status`
- `start_time`
- `finish_time`
- `description`
- RuoYi 创建、更新和逻辑删除字段

约束：

- `task_no` 唯一
- `customer_id` 外键关联 `ndt_customer.id`

### 3.3 `ndt_workpiece`

任务下的工件。不包含产品型号、批次和具体单件等额外层级。

主要字段：

- `id`
- `task_id`
- `workpiece_name`
- `sort_no`
- `status`
- `remark`
- RuoYi 创建、更新和逻辑删除字段

`task_id` 外键关联 `ndt_inspection_task.id`。

### 3.4 `ndt_inspection_position`

工件下的检测部位，不引入“检测轮次”。

主要字段：

- `id`
- `workpiece_id`
- `position_name`
- `position_code`
- `sort_no`
- `remark`
- RuoYi 创建、更新和逻辑删除字段

约束：

- `workpiece_id + position_code` 唯一
- `workpiece_id` 外键关联 `ndt_workpiece.id`

### 3.5 `ndt_inspection_study`

一个 Study 只属于一个工件，表达该工件的一次检测研究或一种检测方法形成的影像集合。`study_instance_uid` 全局唯一。

### 3.6 `ndt_dicom_series`

Series 属于一个 Study，并关联该工件下的一个稳定检测部位。复合外键同时保证 Study、部位和 Series 的 `workpiece_id` 一致，避免跨工件错误绑定。

图像 Series 的业务规则是“一部位一 Series，一张原始图带若干派生图”：第一张业务对象必须是 `ORIGINAL_IMAGE`，后续 `PROCESSED_IMAGE`、`SCREENSHOT`、`ANNOTATION_IMAGE` 必须引用该原始图并保存在同一个 Series。`ndt_dicom_series` 不再使用 `series_role` 字段，角色由 Series 内对象及其关系决定。

原始图上传事务会先锁定部位记录，再查询同一 Study、同一部位是否已经存在原始图，以防并发创建第二个影像 Series。SR 独立 Series 不包含 `ORIGINAL_IMAGE`，因此不会被该规则误拦截。

SR 等非图像 DICOM 对象使用独立 Series，但保持与来源原始图相同的 Study 和部位，并通过对象关系表关联来源原始图。任务级普通 PDF 报告仍保存在 `ndt_task_report`，不进入 DICOM 层级。

### 3.7 `ndt_dicom_object`

统一保存原始图、处理图、截图、标注图、显示状态对象、SR 和其他派生对象的索引。

主要字段：

- `id`
- `series_id`
- `object_type`
- `object_name`
- `storage_type`
- `orthanc_instance_id`
- `file_path`
- `object_key`
- `mime_type`
- `sop_instance_uid`
- `sop_class_uid`
- `parameters_json`
- `metadata_json`
- `sha256`
- RuoYi 创建、更新和逻辑删除字段

`object_type` 允许值：

```text
ORIGINAL_IMAGE
PROCESSED_IMAGE
SCREENSHOT
ANNOTATION_IMAGE
PRESENTATION_STATE
SR
OTHER
```

`storage_type` 允许值：

```text
ORTHANC
FILE_SYSTEM
OBJECT_STORAGE
DATABASE_JSON
```

约束：

- `sop_instance_uid` 唯一；MySQL 允许多条 `NULL`，因此普通图片或 JSON 对象可以没有 SOP UID。
- 每个 Series 最多只能存在一条未删除的 `ORIGINAL_IMAGE`，由函数唯一索引 `uk_ndt_object_active_original_series` 保证。
- `series_id` 外键关联 `ndt_dicom_series.id`。
- Study UID 和 Series UID 分别只保存在 Study、Series 表，避免在每个对象上重复并产生归属冲突。

### 3.8 `ndt_dicom_object_relation`

统一表达对象之间的多对多派生或引用关系。

主要字段：

- `id`
- `source_object_id`
- `target_object_id`
- `relation_type`
- `remark`
- `create_by`
- `create_time`

`relation_type` 允许值：

```text
DERIVED_FROM
REFERENCES
GENERATED_FROM
```

统一方向为：

```text
source_object_id = 来源对象
target_object_id = 衍生对象或引用对象
```

同一对象不能关联自身；相同的来源、目标和关系类型不能重复。

### 3.9 `ndt_defect`

缺陷从旧评定表中拆出，必须关联一张原始图对象。

主要字段：

- `id`
- `original_object_id`
- `defect_no`
- `defect_type`
- `roi_type`
- `roi_data_json`
- `description`
- RuoYi 创建、更新和逻辑删除字段

约束：

- `original_object_id + defect_no` 唯一
- `original_object_id` 外键关联 `ndt_dicom_object.id`

数据库外键只能保证对象存在，不能保证对象类型。后端保存缺陷时仍必须校验该对象的 `object_type = ORIGINAL_IMAGE`。

### 3.10 `ndt_evaluation`

同时保存缺陷评定和工件总体评定，但通过类型和关联字段严格区分。

主要字段：

- `id`
- `evaluation_type`
- `defect_id`
- `workpiece_id`
- `level`
- `conclusion`
- `description`
- `evaluator_id`
- `evaluation_time`
- `status`
- RuoYi 创建、更新和逻辑删除字段

数据库检查约束：

```text
evaluation_type = DEFECT
  defect_id 必填
  workpiece_id 必须为空

evaluation_type = WORKPIECE
  workpiece_id 必填
  defect_id 必须为空
```

`evaluator_id` 是对 `sys_user.user_id` 的逻辑引用，没有建立跨框架表物理外键。

### 3.11 `ndt_evaluation_review`

保存评定复核历史。

主要字段：

- `id`
- `evaluation_id`
- `review_result`
- `review_comment`
- `reviewer_id`
- `review_time`
- `create_by`
- `create_time`

`review_result` 允许值：

```text
PASS
REJECT
```

该表没有更新和逻辑删除字段。后端应只提供新增和查询能力，不能用复核结果覆盖原评定。

### 3.12 `ndt_task_report`

保存任务级 PDF 报告及其版本。

主要字段：

- `id`
- `task_id`
- `report_name`
- `version`
- `file_path`
- `object_key`
- `sha256`
- `status`
- `generate_by`
- `generate_time`
- RuoYi 创建和更新字段

`task_id + version` 唯一，一个任务可以生成多个报告版本。

## 4. 删除的旧表

以下旧表已被新模型完全替代，已从实际数据库和完整 SQL 基线中删除：

| 删除表 | 替代方式 |
|---|---|
| `dcm_study` | 由 `ndt_inspection_study` 替代 |
| `dcm_series` | 由 `ndt_dicom_series` 替代 |
| `dcm_instance` | 由 `ndt_dicom_object` 统一保存 |
| `dcm_evaluation` | 由新 `ndt_evaluation` 保存 |
| `ndt_inspection_part` | 由 `ndt_workpiece` 和 `ndt_inspection_position` 替代 |
| `ndt_dicom_instance` | 由 `ndt_dicom_object` 替代 |
| `ndt_part_dicom_object` | 对象通过 `position_id` 直接关联检测部位 |

以下同名表因职责变化被删除后按新结构重建：

- `ndt_inspection_task`
- `ndt_dicom_object_relation`
- `ndt_evaluation`

## 5. 保留的表

以下独立功能表不属于本次核心模型替换范围，表结构保持不变：

- `dcm_validation_rule`
- `dcm_validation_record`
- `ndt_dicom_integrity_record`
- `ndt_dicom_private_tag`
- `ndt_uid_rule`
- `ndt_inspector_profile`
- `ndt_task_user`

`ndt_task_user` 仍需用于任务人员分配，但其原有数据引用旧任务主键，因此数据已清空。

## 6. 外键策略

新核心表之间共建立 14 个物理外键，全部使用：

```text
ON DELETE RESTRICT
ON UPDATE RESTRICT
```

这样可以避免误删客户、任务、工件、部位、对象、缺陷或评定后产生孤立数据。

涉及 RuoYi 用户的以下字段不建立物理外键：

- `ndt_evaluation.evaluator_id`
- `ndt_evaluation_review.reviewer_id`
- `ndt_task_report.generate_by`

后端代码需要校验这些用户 ID 是否有效。

## 7. 执行和验证

对现有数据库执行：

```bash
mysql -u<user> -p <database> < sql/ndt_schema_redesign_20260728.sql
mysql -u<user> -p <database> < sql/verify_ndt_schema_redesign_20260728.sql
```

验证脚本中：

    - 所有异常结果集均应返回 0 行，包括废弃字段、必需索引和重复有效原始图检查。
- 汇总结果应为 `target_table_count = 12`。
- 汇总结果应为 `ndt_foreign_key_count = 14`。

本次执行前先在由全量备份恢复的临时数据库 `ry_vue_ndt_schema_test` 中完成了演练，再对实际 `ry-vue` 执行。

实际验证结果：

| 验证项 | 结果 |
|---|---|
| 目标核心表数量 | 12 |
| 核心外键数量 | 14 |
| 旧核心表残留 | 0 |
| 缺失必需字段 | 0 |
| 目标核心表数据 | 0 行 |
| `ndt_task_user` 数据 | 0 行 |
| `sys_*` 列元数据数量 | 修改前后均为 182 |
| `sys_*` 列元数据 SHA-256 | `56e89591e5c5d280aa28a0d748ca8593381ed9a50979888616a4454366c1afa4` |
| `sys_*` 索引元数据数量 | 修改前后均为 32 |
| `sys_*` 索引元数据 SHA-256 | `4253b411f8ce1be1d68ec538283bc7c82be4c1956e24dbba31a7d16c4e87c183` |
| RuoYi 前端生产构建 | Vite 生产构建通过，2568 个模块完成转换 |
| Java 后端测试 | Maven 完整打包执行 26 个测试，失败与错误均为 0 |
| Java 后端启动 | 使用随机端口连接实际 MySQL/Redis 启动成功，Study/Series/Object Mapper 加载成功 |

元数据指纹一致，说明本次没有改变 `sys_*` 表结构或索引。

现有核心业务接口与新表结构尚未匹配，因此本轮没有把旧接口运行结果作为数据库重构的通过条件。应在下一阶段完成后端代码替换后再执行关键接口测试。

## 8. 备份与回滚

执行前的完整数据库备份：

```text
C:\Users\china\Code\DICOM-SYS\.dev-state\backups\ry-vue-before-ndt-redesign-20260728-222048.sql
```

原 `sql/ry-vue.sql` 文件副本：

```text
C:\Users\china\Code\DICOM-SYS\.dev-state\backups\ry-vue.sql.before-ndt-schema-redesign-20260728.sql
```

由于本次明确放弃旧业务数据，回滚不能只执行逆向 `ALTER TABLE`。完整回滚步骤是：

1. 停止后端服务，禁止继续写库。
2. 再次备份当前重构后的数据库，避免丢失重构后新增数据。
3. 删除并重建目标数据库。
4. 从 `ry-vue-before-ndt-redesign-20260728-222048.sql` 完整恢复。
5. 使用恢复后的旧后端、前端和 OHIF 代码。

回滚会恢复旧表和旧数据，也会丢弃回滚点之后写入新结构的数据。

## 9. 代码适配状态

2026-08-02 已完成 Java、MyBatis 和 Vue 适配：上传 DICOM 时依据文件内 UID 自动登记 Study/Series；同一 Study UID 不能跨工件，同一 Series UID 不能跨 Study 或稳定部位。任务级 OHIF 聚合入口已删除，任务页和独立 OHIF 页均按“工件→Study”选择并打开单一 Study。

同日补充了 Series 对象归档规则：原始图上传入口只允许同一 Series 一张有效原始图；处理图、截图、标注图通过来源原始图上传并强制使用同一 Series；SR 从评定提交入口上传，强制使用独立 Series并建立 `GENERATED_FROM` 关系。服务只校验和登记 DICOM 文件，不主动改写文件内的 Study、Series、SOP 或 Instance Number 等标签。
