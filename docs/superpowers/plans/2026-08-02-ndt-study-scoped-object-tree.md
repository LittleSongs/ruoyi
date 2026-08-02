# NDT Study 范围对象树实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** OHIF 左侧对象树只加载当前 Study 的对象，同时保持若依任务级对象树接口兼容。

**Architecture:** 在现有 `/ndt/task/{taskId}/object-tree` 增加可选 `studyId` 查询参数。后端在参数存在时验证 Study 与任务关系并按 Study+部位过滤；若依生成的 OHIF URL增加 `studyId`，工业检测扩展解析后随对象树请求发送。

**Tech Stack:** Java 17、Spring Boot、MyBatis、JUnit 5/Mockito、TypeScript、React、Jest、webpack。

## Global Constraints

- 不修改数据库结构或 Orthanc 数据。
- 不改变不带 `studyId` 的任务级对象树行为。
- `taskId` 继续承担权限、缺陷和评定上下文。
- 所有新 OHIF 启动 URL 必须包含数据库 Study 主键 `studyId`。
- OHIF 缺少 `studyId` 时不得退回任务级对象树。

---

### Task 1: 后端 Study 范围过滤

**Files:**
- Modify: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/task/controller/NdtInspectionTaskController.java`
- Modify: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/task/service/INdtInspectionTaskService.java`
- Modify: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/task/service/impl/NdtInspectionTaskServiceImpl.java`
- Modify: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/dicom/mapper/NdtDicomObjectMapper.java`
- Modify: `ruoyi-dcm/src/main/resources/mapper/ndt/dicom/NdtDicomObjectMapper.xml`
- Create: `ruoyi-dcm/src/test/java/com/ruoyi/ndt/task/NdtInspectionTaskObjectTreeServiceTest.java`

**Interfaces:**
- Consumes: `selectObjectTree(Long taskId, Long studyId)`，其中 `studyId` 可空。
- Produces: 不传 Study 时保持任务树；传 Study 时仅返回目标 Study 的工件、部位和对象。

- [ ] **Step 1: 写失败测试**

创建服务测试，构造同一任务下两个 Study，断言调用 `selectObjectTree(10L, 101L)` 时只为 Study 101 所属工件调用 `selectByStudyAndPosition(101L, positionId)`，且返回树不包含另一个工件/Study；另测 Study 的 `taskId` 不匹配时抛出 `ServiceException`。

- [ ] **Step 2: 运行测试确认 RED**

Run: `mvn -pl ruoyi-dcm -am -Dtest=NdtInspectionTaskObjectTreeServiceTest -Dsurefire.failIfNoSpecifiedTests=false test`

Expected: FAIL，因为两参数服务方法和 Study+部位 Mapper 方法尚不存在。

- [ ] **Step 3: 实现最小后端修改**

控制器接收 `@RequestParam(required = false) Long studyId`。服务在 Study 范围分支中先校验任务权限，再用 `studyMapper.selectById(studyId)` 验证存在性及 `study.getTaskId().equals(taskId)`，仅构造目标工件，并通过以下 Mapper 查询对象：

```java
List<NdtDicomObject> selectByStudyAndPosition(
        @Param("studyId") Long studyId,
        @Param("positionId") Long positionId);
```

对应 SQL 同时包含：

```sql
ds.study_id = #{studyId} and ds.position_id = #{positionId}
```

- [ ] **Step 4: 运行测试确认 GREEN**

Run: `mvn -pl ruoyi-dcm -am -Dtest=NdtInspectionTaskObjectTreeServiceTest -Dsurefire.failIfNoSpecifiedTests=false test`

Expected: PASS。

---

### Task 2: OHIF URL 与客户端参数传递

**Files:**
- Modify: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/config/NdtProperties.java`
- Modify: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/study/service/impl/NdtInspectionStudyServiceImpl.java`
- Create: `ruoyi-dcm/src/test/java/com/ruoyi/ndt/config/NdtPropertiesTest.java`
- Modify: `../Viewers/extensions/industrial-review/src/types.ts`
- Modify: `../Viewers/extensions/industrial-review/src/api/ndtClient.ts`
- Modify: `../Viewers/extensions/industrial-review/src/api/ndtClient.test.ts`
- Modify: `../Viewers/extensions/industrial-review/src/hooks/useNdtObjectTree.ts`
- Modify: `../Viewers/extensions/industrial-review/src/panels/PanelNdtObjectBrowser.tsx`

**Interfaces:**
- Produces: `NdtRuntimeConfig.studyId?: NdtTaskId`。
- Produces: `getObjectTree(taskId, studyId, config)` 请求 `?studyId={studyId}`。
- Produces: `buildViewerUrl(studyUid, taskId, studyId, canEvaluate)`。

- [ ] **Step 1: 写 URL 和客户端失败测试**

后端测试断言 URL 包含 `taskId=3&studyId=1&canEvaluate=true`。Jest 测试断言运行配置从 `studyId=1` 解析数字 1，并且对象树请求 URL 精确为：

```text
http://localhost:8080/ndt/task/1001/object-tree?studyId=2002
```

- [ ] **Step 2: 分别运行测试确认 RED**

Run backend: `mvn -pl ruoyi-dcm -am -Dtest=NdtPropertiesTest -Dsurefire.failIfNoSpecifiedTests=false test`

Run OHIF: `yarn jest --runInBand --runTestsByPath extensions/industrial-review/src/api/ndtClient.test.ts`

Expected: 两边均因缺少 `studyId` 行为失败。

- [ ] **Step 3: 实现最小参数传递**

从 Study 服务把数据库 `id` 传入 URL builder；OHIF 解析 `studyId`，hook 要求 `taskId` 与 `studyId` 同时存在，并将两者传给对象树客户端。面板缺少参数时显示明确提示。

- [ ] **Step 4: 分别运行测试确认 GREEN**

重复 Step 2 命令，Expected: PASS。

---

### Task 3: 回归与构建验证

**Files:**
- Verify all files modified above.

**Interfaces:**
- Consumes: Task 1、Task 2 的最终接口。
- Produces: 可交付的后端和 OHIF 构建结果及手动验证步骤。

- [ ] **Step 1: 运行后端相关测试**

Run: `mvn -pl ruoyi-dcm -am -Dtest=NdtInspectionTaskObjectTreeServiceTest,NdtPropertiesTest -Dsurefire.failIfNoSpecifiedTests=false test`

- [ ] **Step 2: 运行 OHIF 相关测试**

Run: `yarn jest --runInBand --runTestsByPath extensions/industrial-review/src/api/ndtClient.test.ts platform/app/src/routes/Mode/updateAuthServiceAndCleanUrl.test.ts`

- [ ] **Step 3: 构建后端模块**

Run: `mvn -pl ruoyi-admin -am -DskipTests package`

- [ ] **Step 4: 构建 OHIF**

Run: `yarn build:viewer`（目录 `Viewers/platform/app`）。

- [ ] **Step 5: 检查差异**

对本计划涉及文件运行 `git diff --check`，确认没有空白错误，也没有覆盖用户其他 NDT 重构改动。

- [ ] **Step 6: 输出手动验证流程**

说明如何创建同一工件两个 Study、分别上传对象、打开各 Study、检查网络请求和左侧树互不串数据，以及如何确认不带 `studyId` 的若依 DICOM 管理页仍可用。
