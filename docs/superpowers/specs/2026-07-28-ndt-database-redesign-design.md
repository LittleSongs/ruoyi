# NDT 核心业务数据库重构设计

## 目标

将客户、检测任务、工件、检测部位、DICOM 对象、对象关系、缺陷、评定、复核和任务报告统一建模为 `ndt_*` 表，放弃现有核心业务数据，不做迁移和兼容读取。

## 约束

- 本次不修改任何 `sys_*` 表结构。
- 只修改 `ndt_*`、`dcm_*` 业务表。
- 不引入检测轮次、产品型号、批次或具体单件层级。
- 原始图和衍生对象统一保存到 `ndt_dicom_object`。
- 缺陷必须关联原始图；该对象类型规则由后续业务服务校验。
- 缺陷评定和工件总体评定共用 `ndt_evaluation`，通过数据库检查约束保证关联对象互斥。
- 复核记录只能追加；后续代码不得提供覆盖原评定的逻辑。
- `sys_user.user_id` 只作为逻辑用户标识，不建立跨框架表外键。

## 新核心表

1. `ndt_customer`
2. `ndt_inspection_task`
3. `ndt_workpiece`
4. `ndt_inspection_position`
5. `ndt_dicom_object`
6. `ndt_dicom_object_relation`
7. `ndt_defect`
8. `ndt_evaluation`
9. `ndt_evaluation_review`
10. `ndt_task_report`

核心层级为：

`ndt_customer -> ndt_inspection_task -> ndt_workpiece -> ndt_inspection_position -> ndt_dicom_object`

对象关系通过 `ndt_dicom_object_relation` 表达；缺陷关联原始对象；评定关联缺陷或工件；复核关联评定；报告关联任务。

## 删除的旧核心表

- `dcm_study`
- `dcm_series`
- `dcm_instance`
- `dcm_evaluation`
- `ndt_inspection_part`
- `ndt_dicom_series`
- `ndt_dicom_instance`
- `ndt_part_dicom_object`

同名但职责发生变化的 `ndt_inspection_task`、`ndt_dicom_object_relation` 和 `ndt_evaluation` 直接删除后重建。

## 保留的独立业务表

- `dcm_validation_rule`
- `dcm_validation_record`
- `ndt_dicom_integrity_record`
- `ndt_dicom_private_tag`
- `ndt_uid_rule`
- `ndt_inspector_profile`
- `ndt_task_user`

`ndt_task_user` 表结构保留，但其现有数据引用旧任务 ID，因此在重建时清空。

## 删除和回滚

本次为集中重建，会删除旧核心业务数据。执行前必须完成 `ry-vue` 全量备份。需要回滚时，删除当前数据库并从该备份完整恢复，不能用逆向 DDL 假装恢复已经删除的数据。

