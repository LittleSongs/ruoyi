# NDT 检测部位对象树实施计划

1. 以可重入 SQL 新增物理 Series、检测部位和成员关系表，扩展 Instance，并按“Series → 类型 → Part → 原始成员 → 关系目标成员”回填旧数据。
2. 在 `com.ruoyi.ndt.organization` 建立统一注册和对象树查询服务；原始上传后注册原始对象，SR 关系全部入库后按所有源 SOP 注册多重成员关系。
3. 暴露对象树和按 Part 分组的评定历史 API，并通过独立 Viewer 访问服务处理登录权限与本地匿名开关。
4. 在 OHIF industrial-review 扩展中增加 API 类型、规范化、稳定排序、DisplaySet 解析和 SOP 栈内导航工具。
5. 增加 `PanelNdtObjectBrowser`，仅替换 industrial-longitudinal 模式的左面板。
6. 删除右侧“相关对象”导航及相应临时状态，接入只读评定历史。
7. 运行后端 JUnit、OHIF Jest、两个 workspace build；迁移前后比对全部 DICOM UID，并对多原始 SOP、多源 SR、未关联对象进行人工验收。

验收要求：一个有效原始 SOP 恰好一个 Part 和一个 ORIGINAL 成员；同一旧 Series 的多个原始 SOP 分成多个 Part；多源 SR 出现在每个对应 Part；UID 完全不变；默认 Viewer 和其他 Mode 不受影响。
