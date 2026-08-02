# NDT Study 层级与 OHIF 入口设计

## 目标

将当前 `任务 -> 工件 -> 部位 -> DICOM 对象` 调整为同时表达真实 DICOM 层级的模型：

```text
检测任务
└─ 工件 Component
   ├─ 稳定检测部位
   └─ Study（该工件的一次检测研究）
      └─ Series（关联一个检测部位）
         └─ DICOM / SOP Instance
```

一个 Study 必须且只能属于一个工件；一个工件可以包含多个 Study。任务是系统业务聚合，不是 DICOM Study。

## 数据库

- 新增 `ndt_inspection_study`，以 `workpiece_id` 关联工件，以全局唯一 `study_instance_uid` 标识 Study。
- 新增 `ndt_dicom_series`，以 `study_id` 关联 Study，以 `position_id` 关联工件的稳定检测部位，以全局唯一 `series_instance_uid` 标识 Series。
- `ndt_dicom_object` 改为通过 `series_id` 关联 Series；查询结果中的 Study/Series UID 由父表联表返回。
- `sop_instance_uid` 保持全局唯一。
- Study 和 Series 在原始 DICOM 上传成功后，依据文件内 UID 自动查找或创建，不允许同一 Study UID 绑定多个工件，也不允许同一 Series UID 跨 Study 或部位。
- 现有 DICOM 测试业务数据清空后直接切换，不迁移旧对象。

## 清理脚本

一键脚本物理删除以下测试数据：

- 缺陷评定的复核记录
- `DEFECT` 类型评定
- 缺陷
- DICOM 对象关系
- DICOM 对象
- 完整性记录
- 上传校验记录

脚本保留客户、任务、工件、部位、任务成员、`WORKPIECE` 总体评定、任务 PDF 报告、UID 规则、私有 Tag 和校验规则。脚本显式设置并校验 `utf8mb4`。

## 后端契约

- `GET /ndt/study/list?workpieceId={id}`：查询工件下 Study。
- `GET /ndt/study/{id}`：查询 Study。
- `GET /ndt/study/{id}/ohif`：生成只包含该 Study UID 的 OHIF 地址。
- 删除任务级 `/ndt/task/{taskId}/ohif`。
- 原始 DICOM 上传继续选择稳定部位；后端从部位定位工件，再注册 Study 和 Series。

## 前端

- 删除任务表格中的 OHIF 按钮。
- 工件详情中同时显示“Study 列表”和“检测部位列表”。
- 每个 Study 行提供 OHIF 按钮，一个按钮只打开一个 Study。
- DICOM 上传页面仍选择任务和部位，Study/Series 由文件元数据自动识别。

## 验证

- 同一工件可注册多个 Study。
- 同一 Study UID 不能属于两个工件。
- 同一 Series UID 不能跨 Study 或部位。
- Study OHIF URL 只含一个 Study UID。
- 任务页不再出现任务级 OHIF。
- 清理脚本执行后 DICOM 对象链、完整性和上传记录均为 0，主数据与配置不变。
