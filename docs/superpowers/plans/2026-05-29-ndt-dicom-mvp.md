# NDT DICOM MVP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first-stage NDT DICOM management MVP inside the existing RuoYi codebase with independent `ndt_*` database tables and `/ndt/**` APIs.

**Architecture:** Keep the existing `ruoyi-dcm` Maven module as the business module container, but put all new production code under `com.ruoyi.ndt` and all new frontend code under `src/api/ndt` and `src/views/ndt`. Do not call or extend the old `com.ruoyi.dcm` prototype code. Use RuoYi's existing MyBatis XML, `BaseController`, `BaseEntity`, `AjaxResult`, `TableDataInfo`, menu permissions, and Vue3/Element Plus conventions.

**Tech Stack:** Java 17, Spring Boot 4, MyBatis XML, RuoYi security/permission model, MySQL, Orthanc REST, OHIF URL integration, Vue3, Vite, Element Plus.

---

### Task 1: Database, Config, And Shared Infrastructure

**Files:**
- Create: `sql/zz_ndt_phase1.sql`
- Modify: `ruoyi-admin/src/main/resources/application.yml`
- Create: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/config/NdtProperties.java`
- Create: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/common/NdtConstants.java`
- Create: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/security/NdtAccessService.java`

- [ ] Create all `ndt_*` tables, dictionaries, roles, menus, and permissions.
- [ ] Add `ndt.orthanc`, `ndt.ohif`, and `ndt.security.company-root-dept-id` configuration.
- [ ] Add shared constants for roles, task roles, status values, and integrity status values.
- [ ] Add centralized access checks for super admin, company admin, inspector, customer, task visibility, upload permission, and evaluation permission.

### Task 2: UID Rules

**Files:**
- Create: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/uid/domain/NdtUidRule.java`
- Create: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/uid/mapper/NdtUidRuleMapper.java`
- Create: `ruoyi-dcm/src/main/resources/mapper/ndt/uid/NdtUidRuleMapper.xml`
- Create: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/uid/service/INdtUidRuleService.java`
- Create: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/uid/service/impl/NdtUidRuleServiceImpl.java`
- Create: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/uid/controller/NdtUidRuleController.java`
- Test: `ruoyi-dcm/src/test/java/com/ruoyi/ndt/uid/NdtUidRuleServiceImplTest.java`

- [ ] First write tests for `2.25.UUID` UID generation and custom-root UID generation.
- [ ] Implement CRUD and `/ndt/uidRule/generate`.

### Task 3: Tasks And Assignments

**Files:**
- Create task and assignment domain, mapper, service, controller classes under `com.ruoyi.ndt.task`.
- Create mapper XML under `mapper/ndt/task`.

- [ ] Implement task CRUD with `customer_dept_id`.
- [ ] Implement assignment CRUD for `CREATOR`, `UPLOADER`, `EVALUATOR`, `VIEWER` only.
- [ ] Apply list filtering through `NdtAccessService`: super/company all, inspector assigned, customer own department, otherwise none.

### Task 4: Inspector Profiles

**Files:**
- Create inspector domain, mapper, service, controller classes under `com.ruoyi.ndt.inspector`.
- Create mapper XML under `mapper/ndt/inspector`.

- [ ] Implement profile CRUD keyed by `user_id`.
- [ ] Join `sys_user` for username/nickname in list views.
- [ ] Keep `sys_user` schema unchanged.

### Task 5: Orthanc, DICOM Upload, Integrity, And OHIF

**Files:**
- Create Orthanc REST client under `com.ruoyi.ndt.orthanc`.
- Create DICOM instance domain, mapper, service, controller classes under `com.ruoyi.ndt.dicom`.
- Create integrity domain, mapper, service, controller classes under `com.ruoyi.ndt.integrity`.
- Test: `ruoyi-dcm/src/test/java/com/ruoyi/ndt/dicom/NdtDicomUploadServiceImplTest.java`
- Test: `ruoyi-dcm/src/test/java/com/ruoyi/ndt/integrity/NdtIntegrityServiceImplTest.java`

- [ ] Upload `.dcm` to Orthanc `POST /instances`.
- [ ] Read Study/Series/Instance tags from Orthanc simplified tags.
- [ ] Save `ndt_dicom_instance` and `ndt_dicom_integrity_record`.
- [ ] Compute `file_sha256` during upload.
- [ ] Download from Orthanc and re-verify SHA-256.
- [ ] Return OHIF URL only after task access passes.

### Task 6: Evaluation And SR Extension Point

**Files:**
- Create evaluation domain, mapper, service, controller classes under `com.ruoyi.ndt.evaluation`.
- Create `com.ruoyi.ndt.sr.service.DicomSrService`.

- [ ] Save evaluation results only when the user has task `can_evaluate` permission, except super admin.
- [ ] Store `annotation_json` as JSON text.
- [ ] Add SR generation service interface with explicit first-stage TODO.

### Task 7: Frontend

**Files:**
- Create: `ruoyi-ui/RuoYi-Vue3/src/api/ndt/*.js`
- Create: `ruoyi-ui/RuoYi-Vue3/src/views/ndt/task/index.vue`
- Create: `ruoyi-ui/RuoYi-Vue3/src/views/ndt/dicom/index.vue`
- Create: `ruoyi-ui/RuoYi-Vue3/src/views/ndt/inspector/index.vue`
- Create: `ruoyi-ui/RuoYi-Vue3/src/views/ndt/uidRule/index.vue`
- Create: `ruoyi-ui/RuoYi-Vue3/src/views/ndt/integrity/index.vue`
- Create: `ruoyi-ui/RuoYi-Vue3/src/views/ndt/evaluation/index.vue`

- [ ] Implement Vue3 pages using existing RuoYi list/form/dialog style.
- [ ] Add DICOM upload bound to task ID.
- [ ] Add OHIF open buttons driven by backend URL checks.
- [ ] Add integrity recheck action.
- [ ] Add UID test generation action.

### Task 8: Verification

- [ ] Run targeted unit tests in `ruoyi-dcm`.
- [ ] Run Maven compile/package for `ruoyi-admin -am`.
- [ ] Run frontend build in `ruoyi-ui/RuoYi-Vue3`.
- [ ] Test Orthanc upload with a `.dcm` file through the backend endpoint.
- [ ] Test OHIF URL generation for a task with `StudyInstanceUID`.
