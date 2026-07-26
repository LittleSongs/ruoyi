# NDT 检测部位对象树与 Series 组织设计

## 设计结论

系统采用“一张原始 SOP 对应一个检测部位组”的业务组织方式，但不改变 DICOM 的物理层级：原始图、处理图、截图、PR、SR 仍保留各自标准的 Study/Series/SOP UID。左侧看到的检测部位组不是新的 DICOM Series，也不生成客户端 DisplaySet UID。

一个检测部位在 Viewer 中展示为：

```text
检测部位（锚点：一个原始 SOP）
├── 原始图像
├── 处理图像
├── 截图
├── 标注状态（PR）
├── 结构化报告（SR）
└── 其他衍生对象
```

## 持久化模型

- `ndt_dicom_series`：索引真实物理 Series。角色包括 `ORIGINAL`、`PROCESSED_IMAGE`、`SNAPSHOT`、`PRESENTATION_STATE`、`SR`、`OTHER_DERIVED`、`LEGACY_MIXED`。
- `ndt_inspection_part`：每个原始 SOP 一条，编号为 `P-` 加六位 DICOM Instance 数据库 ID。
- `ndt_part_dicom_object`：Part 与 DICOM Instance 的多对多成员关系。多源 SR 可同时属于多个 Part。
- `ndt_dicom_instance.dicom_series_id/object_type`：连接物理 Series 并记录对象类型。
- `ndt_dicom_object_relation`：继续表达来源/派生关系，不承担 Viewer 分组职责。

当旧物理 Series 混合多种对象类型时，Series 角色为 `LEGACY_MIXED`；不拆分 Series，不改写任何 UID。无法可靠确定来源的非原始对象进入 `unassignedObjects`，禁止猜测归属。

## API 与权限

- `GET /ndt/task/{taskId}/object-tree`
- `GET /ndt/evaluation/history?taskId={taskId}&sopInstanceUID={uid}`

登录用户复用任务查看权限。匿名调用仅在 `ndt.security.allow-anonymous-viewer-api=true` 且任务存在时放行；配置默认值为 `false`，仅限本地和测试。

## Viewer 行为

仅 `industrial-viewer` 使用新的左侧对象树，其他 OHIF Mode 保持默认 Study Browser。角色排序固定为原始图 10、处理图 20、截图 30、PR 40、SR 50、其他 60；同角色按 Instance Number、创建时间和数据库 ID 排序。

对象点击以持久 SOP/Series UID 定位 DisplaySet，再定位栈内实例。找不到 DisplaySet 时明确禁用，不跳转到替代图像。右侧 NDT 评定删除“相关对象”导航，只保留当前对象、缺陷清单、评定表单和按 Part 分组的只读评定历史。

## 本批边界

本批不实现处理图、截图、SC、PR 的生成算法或 Orthanc 写入补偿，不实现评定版本化，也不把匿名 Viewer API 作为生产鉴权方案。生产上线前需另行实现短期任务票据。
