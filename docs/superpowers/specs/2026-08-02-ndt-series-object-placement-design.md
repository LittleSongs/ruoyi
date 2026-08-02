# NDT Series 对象放置规则设计

## 目标

明确工件部位、Series 与原始/派生 DICOM 对象之间的规则，并在数据库、后端和前端统一执行：

- 一个工件部位在一次 Study 中对应一个影像 Series。
- 影像 Series 只允许一张原始图作为首个业务对象。
- 该原始图产生的处理图、截图、标注图继续进入同一个 Series。
- SR、DICOM 封装文档等非图像 DICOM 使用独立 Series，并与来源原图建立对象关系。
- 任务级普通 PDF 报告继续由 `ndt_task_report` 管理，不进入 DICOM Series。
- 删除 `ndt_dicom_series.series_role`，对象性质由 `ndt_dicom_object.object_type` 表达。

## 对象分类

### 部位影像 Series

允许的对象类型：

- `ORIGINAL_IMAGE`：每个 Series 恰好一张，作为来源对象。
- `PROCESSED_IMAGE`
- `SCREENSHOT`
- `ANNOTATION_IMAGE`

后三类必须指定一张 `ORIGINAL_IMAGE` 作为来源，继承来源对象的 Study、Series、工件和部位，并记录 `DERIVED_FROM` 关系。

### 独立非图像 Series

当前可上传的明确类型是 `SR`。它必须：

- 指定来源原图；
- 与来源原图使用相同 `StudyInstanceUID`；
- 使用不同于来源影像 Series 的 `SeriesInstanceUID`；
- 继承来源原图的工件和部位；
- 以 `GENERATED_FROM` 关系关联来源原图。

后续若增加 DICOM Encapsulated PDF 等类型，复用相同的独立 Series 规则。普通 PDF 报告不是 DICOM 对象，继续保存在任务报告模块。

## UID 与文件处理

系统不改写上传文件的 `StudyInstanceUID`、`SeriesInstanceUID`、`SOPInstanceUID` 或像素内容。

- 派生影像 DICOM 必须由上游生成程序写入与来源原图相同的 Study UID 和 Series UID，并生成新的 SOP UID。
- SR 必须使用相同 Study UID、新的 Series UID和新的 SOP UID。
- UID 不符合放置规则时拒绝上传，并清理本次已临时写入 Orthanc 的对象。

MySQL 中使用对象创建顺序展示“原图在前、派生图在后”。OHIF 的实例顺序由 DICOM 文件自身的 `InstanceNumber` 等标签决定，系统不通过修改文件强制重排。

## 数据库设计

- 从 `ndt_dicom_series` 删除 `series_role`。
- 保留 `ndt_dicom_object.series_id` 和 `object_type`。
- 保留 `ndt_dicom_object_relation` 表示原图和派生对象的一对多关系。
- 数据库唯一索引继续保证 `StudyInstanceUID`、`SeriesInstanceUID` 和 `SOPInstanceUID` 全局唯一。
- “一个影像 Series 仅一张原始图”由后端事务校验，并使用 MySQL 8 条件函数唯一索引保护：仅当 `object_type='ORIGINAL_IMAGE'` 且 `del_flag='0'` 时索引 `series_id`，避免并发产生第二张有效原始图。

## 后端行为

### 原始图上传

- 用户选择检测部位上传。
- 新 Series 可创建一张 `ORIGINAL_IMAGE`。
- 已含原始图的 Series 再上传原始图时拒绝。

### 派生影像上传

- 新增面向文件的派生影像上传接口，参数为来源原图、派生类型和 DICOM 文件。
- 只接受 `PROCESSED_IMAGE`、`SCREENSHOT`、`ANNOTATION_IMAGE`。
- 强制同 Study、同 Series、同部位，并记录 `DERIVED_FROM`。

### SR 上传

- 评定提交并上传 SR 时，要求 SR 与来源原图同 Study、不同 Series。
- 新建独立 Series 后登记 `SR` 对象，并记录 `GENERATED_FROM`。

### 任务 PDF 报告

- 现有上传、版本、发布和下载逻辑保持不变。
- 页面明确提示该模块保存的是任务级普通 PDF，不属于 DICOM Series。

## 前端行为

- DICOM 对象列表中，原始图提供“上传处理图”“上传截图”“上传标注图”操作。
- 派生图对话框显示来源原图、所属 Study/Series/部位，限制上传 DICOM 文件。
- 评定页面为草稿评定提供“提交并上传 SR”，要求选择来源原图和 SR DICOM 文件。
- 普通“提交”仍保留，不强制每次评定都生成 SR。
- 报告页面说明普通 PDF 与 DICOM SR 的区别。

## 错误处理

- 来源对象不是原始图：拒绝。
- 派生影像使用不同 Study 或 Series UID：拒绝。
- SR 使用不同 Study UID或复用影像 Series UID：拒绝。
- SOP UID重复：拒绝。
- 规则校验失败后删除本次 Orthanc 对象，不留下 MySQL 半成品。

## 验证

- 单元测试覆盖对象分类、同 Series/独立 Series UID规则和第二张原图拒绝。
- 后端 Maven 测试与打包通过。
- 前端生产构建通过。
- SQL 验证 `series_role` 已删除、唯一保护存在、外键完整。
- 使用测试 DICOM 验证原图、同 Series 派生图、独立 Series SR 三条路径。
