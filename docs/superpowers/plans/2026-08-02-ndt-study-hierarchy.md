# NDT Study Hierarchy Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add Component-owned Study and Study-owned Series persistence, launch OHIF per Study, and provide a repeatable DICOM test-data cleanup script.

**Architecture:** Stable inspection positions remain children of a workpiece. DICOM upload resolves the workpiece through the selected position, registers the file's Study and Series with strict ownership checks, and stores the SOP object under the Series. RuoYi lists Studies below a workpiece and launches one Study at a time.

**Tech Stack:** MySQL 8.0, Java 17, Spring Boot, MyBatis, Vue 3, Element Plus, OHIF URL integration.

## Global Constraints

- Every MySQL write path and SQL file uses UTF-8/`utf8mb4`.
- Preserve customers, tasks, workpieces, positions, task members, WORKPIECE evaluations, reports, and configuration tables.
- Do not rewrite DICOM Study, Series, or SOP UIDs.
- One Study belongs to exactly one workpiece; one Series belongs to exactly one Study and one stable position.
- Do not commit unrelated existing worktree changes.

---

### Task 1: Cleanup and schema migration SQL

**Files:**
- Create: `sql/clear_ndt_dicom_test_data.sql`
- Create: `sql/ndt_study_hierarchy_20260802.sql`
- Modify: `sql/ndt_schema_redesign_20260728.sql`
- Modify: `sql/verify_ndt_schema_redesign_20260728.sql`

**Interfaces:**
- Produces tables `ndt_inspection_study`, `ndt_dicom_series` and column `ndt_dicom_object.series_id`.
- Preserves the current stable-position table and configuration data.

- [ ] Write SQL verification queries that fail while Study/Series tables are absent.
- [ ] Write an idempotent cleanup script with ordered deletes and `utf8mb4` guards.
- [ ] Write the empty-data schema migration and foreign keys.
- [ ] Run cleanup and migration through the configured MySQL MCP connection.
- [ ] Verify table charset, foreign keys, unique indexes, and zero DICOM business rows.

### Task 2: Backend Study and Series persistence

**Files:**
- Create: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/study/domain/NdtInspectionStudy.java`
- Create: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/study/mapper/NdtInspectionStudyMapper.java`
- Create: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/study/service/INdtInspectionStudyService.java`
- Create: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/study/service/impl/NdtInspectionStudyServiceImpl.java`
- Create: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/study/controller/NdtInspectionStudyController.java`
- Create: `ruoyi-dcm/src/main/resources/mapper/ndt/study/NdtInspectionStudyMapper.xml`
- Create: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/series/domain/NdtDicomSeries.java`
- Create: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/series/mapper/NdtDicomSeriesMapper.java`
- Create: `ruoyi-dcm/src/main/resources/mapper/ndt/series/NdtDicomSeriesMapper.xml`
- Test: `ruoyi-dcm/src/test/java/com/ruoyi/ndt/study/NdtStudyOwnershipTest.java`

**Interfaces:**
- Produces `selectByWorkpieceId(Long)`, `selectById(Long)`, `selectByStudyInstanceUid(String)`, and Study-specific OHIF URL generation.
- Produces Series lookup/insert by Series Instance UID.

- [ ] Write failing ownership and Study URL tests.
- [ ] Run the focused tests and confirm failure.
- [ ] Implement Study/Series entities, mappers, service, and controller.
- [ ] Run focused tests and confirm pass.

### Task 3: Upload registration and normalized object queries

**Files:**
- Modify: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/dicom/domain/NdtDicomObject.java`
- Modify: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/dicom/service/impl/NdtDicomObjectServiceImpl.java`
- Modify: `ruoyi-dcm/src/main/resources/mapper/ndt/dicom/NdtDicomObjectMapper.xml`
- Modify: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/task/service/impl/NdtInspectionTaskServiceImpl.java`
- Modify: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/task/controller/NdtInspectionTaskController.java`
- Test: `ruoyi-dcm/src/test/java/com/ruoyi/ndt/dicom/NdtDicomHierarchyRegistrationTest.java`

**Interfaces:**
- Consumes Study/Series mappers from Task 2.
- Produces object rows keyed by `series_id`, while returning Study/Series UIDs through joins.

- [ ] Write failing tests for cross-workpiece Study and cross-position Series rejection.
- [ ] Run focused tests and confirm failure.
- [ ] Implement transactional Study/Series registration during upload.
- [ ] Remove task-level OHIF endpoint and service method.
- [ ] Run focused and existing NDT tests.

### Task 4: RuoYi Study UI and Study OHIF launch

**Files:**
- Create: `ruoyi-ui/RuoYi-Vue3/src/api/ndt/study.js`
- Modify: `ruoyi-ui/RuoYi-Vue3/src/views/ndt/task/index.vue`
- Modify: `ruoyi-ui/RuoYi-Vue3/src/api/ndt/task.js`

**Interfaces:**
- Consumes `GET /ndt/study/list` and `GET /ndt/study/{id}/ohif`.
- Removes use of `GET /ndt/task/{id}/ohif`.

- [ ] Add Study API functions.
- [ ] Remove the task-row OHIF button and launcher.
- [ ] Add a Study table below the selected workpiece with one OHIF action per Study.
- [ ] Run the Vue production build.

### Task 5: Baseline, live database, and end-to-end verification

**Files:**
- Modify: `sql/ry-vue.sql`
- Modify: `README-NDT-REDESIGN.md`

**Interfaces:**
- Produces a reproducible clean database baseline and operating instructions.

- [ ] Execute the cleanup script through MySQL MCP.
- [ ] Execute the hierarchy migration through MySQL MCP.
- [ ] Perform the mandated `中文测试🚀` parameterized write/read/HEX check in a temporary table and remove it.
- [ ] Run schema verification, Java tests/package, and Vue build.
- [ ] Dump the verified live schema into `sql/ry-vue.sql` using `--default-character-set=utf8mb4`.
- [ ] Review the final diff and report remaining risks without committing unrelated changes.
