# NDT Series Object Placement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Enforce one original plus image-derived objects in a position Series, place SR DICOM objects in a separate Series, keep task PDFs outside DICOM, and remove `series_role`.

**Architecture:** Centralize placement validation in `NdtBusinessRules`, then make the DICOM object service apply either SAME_SERIES or SEPARATE_SERIES behavior without rewriting uploaded DICOM tags. Preserve the current Study/Series ownership model and represent source relationships in `ndt_dicom_object_relation`.

**Tech Stack:** MySQL 8.0, Java 17, Spring Boot, MyBatis, JUnit 5, Vue 3, Element Plus, Orthanc REST API.

## Global Constraints

- MySQL writes require an end-to-end `utf8mb4` connection and database/table verification.
- Run a `中文测试🚀` round-trip probe before formal database writes and verify bytes with `HEX()`.
- Do not rewrite uploaded DICOM Study/Series/SOP UIDs or pixel data.
- Preserve unrelated dirty-worktree changes; do not create implementation commits that would absorb existing uncommitted redesign files.
- Task-level ordinary PDF reports remain in `ndt_task_report` and do not enter DICOM Series.

---

### Task 1: Placement policy tests and implementation

**Files:**
- Modify: `ruoyi-dcm/src/test/java/com/ruoyi/ndt/common/NdtBusinessRulesTest.java`
- Modify: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/common/NdtBusinessRules.java`

**Interfaces:**
- Produces: `requireOriginalSource(String)`, `requireImageDerivedType(String)`, `requireNonImageDerivedType(String)`, `requireSameSeriesPlacement(...)`, and `requireSeparateSeriesPlacement(...)`.

- [ ] **Step 1: Write failing tests**

Add tests asserting that only `ORIGINAL_IMAGE` may be a source, image-derived types are `PROCESSED_IMAGE`, `SCREENSHOT`, and `ANNOTATION_IMAGE`, SR is non-image, same-Series placement requires equal Study and Series UIDs, and SR placement requires equal Study but a different Series UID.

- [ ] **Step 2: Run the focused test and verify RED**

Run: `mvn -pl ruoyi-dcm -am -Dtest=NdtBusinessRulesTest -Dsurefire.failIfNoSpecifiedTests=false test`

Expected: compilation failure because the new rule methods do not exist.

- [ ] **Step 3: Implement the minimal rules**

Use immutable sets for image and non-image derived types and throw `ServiceException` for invalid source type or UID placement.

- [ ] **Step 4: Run the focused test and verify GREEN**

Run the command from Step 2 and expect all `NdtBusinessRulesTest` cases to pass.

### Task 2: Backend object placement and duplicate-original protection

**Files:**
- Modify: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/dicom/service/INdtDicomObjectService.java`
- Modify: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/dicom/service/impl/NdtDicomObjectServiceImpl.java`
- Modify: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/dicom/controller/NdtDicomObjectController.java`
- Modify: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/dicom/mapper/NdtDicomObjectMapper.java`
- Modify: `ruoyi-dcm/src/main/resources/mapper/ndt/dicom/NdtDicomObjectMapper.xml`
- Modify: `ruoyi-dcm/src/main/java/com/ruoyi/ndt/series/domain/NdtDicomSeries.java`
- Modify: `ruoyi-dcm/src/main/resources/mapper/ndt/series/NdtDicomSeriesMapper.xml`
- Test: `ruoyi-dcm/src/test/java/com/ruoyi/ndt/dicom/NdtDicomPlacementServiceTest.java`

**Interfaces:**
- Produces: `uploadDerivedImageDicom(Long sourceObjectId, String objectType, MultipartFile file, Long userId, String username)`.
- Preserves: `uploadDerivedDicom(...)` as the independent-Series path used by SR submission.

- [ ] **Step 1: Write failing service tests**

Use Mockito-backed mapper/Orthanc dependencies to cover: a second original in one Series is rejected; a processed image with a different Series UID is rejected; an SR reusing the source Series UID is rejected; valid image-derived and SR placements insert `DERIVED_FROM`/`GENERATED_FROM` relations respectively.

- [ ] **Step 2: Run the focused service test and verify RED**

Run: `mvn -pl ruoyi-dcm -am -Dtest=NdtDicomPlacementServiceTest -Dsurefire.failIfNoSpecifiedTests=false test`

Expected: compilation or assertion failures because the placement paths and mapper query do not exist.

- [ ] **Step 3: Add mapper and service behavior**

Add `selectOriginalBySeriesId(Long)`; reject a second original after Series resolution; require an original source for all derived paths; force `/derived` metadata objects into the source Series; add multipart image-derived upload; require SR to share Study UID and use a different Series UID; check duplicate SOP UIDs; always remove a just-uploaded Orthanc instance when placement fails.

- [ ] **Step 4: Remove `seriesRole` from Java and MyBatis**

Delete the domain property/getter/setter, remove the result mapping and insert column, and simplify `resolveSeries` so it no longer receives a role.

- [ ] **Step 5: Expose the derived-image upload endpoint**

Add `POST /ndt/dicom/object/derived/upload` with multipart parameters `sourceObjectId`, `objectType`, and `file` under the existing DICOM upload permission.

- [ ] **Step 6: Run focused and module tests**

Run the Step 2 command, then `mvn -pl ruoyi-dcm -am test`; expect all tests to pass.

### Task 3: MySQL schema and repeatable migration scripts

**Files:**
- Create: `sql/ndt_series_object_placement_20260802.sql`
- Modify: `sql/ry-vue.sql`
- Modify: `sql/ndt_study_hierarchy_20260802.sql`
- Modify: `sql/ndt_schema_redesign_20260728.sql`
- Modify: `sql/verify_ndt_schema_redesign_20260728.sql`
- Modify: `sql/README-ndt-schema-redesign.md`

**Interfaces:**
- Produces: schema without `ndt_dicom_series.series_role` and unique index `uk_ndt_object_active_original_series`.

- [ ] **Step 1: Add SQL verification that currently fails**

Extend verification SQL to return failure rows when `series_role` exists, when the new functional unique index is absent, or when more than one active original exists in any Series.

- [ ] **Step 2: Add the migration and baseline definitions**

Drop `series_role` and create a MySQL 8 functional unique index on:

```sql
(CASE WHEN object_type = 'ORIGINAL_IMAGE' AND del_flag = '0' THEN series_id ELSE NULL END)
```

Update every schema source so a fresh install matches the live migration.

- [ ] **Step 3: Check SQL files for stale references**

Run: `rg -n "series_role|setSeriesRole|getSeriesRole" sql ruoyi-dcm/src/main`

Expected: no production schema or Java/MyBatis references.

### Task 4: Frontend derived image and SR workflows

**Files:**
- Modify: `ruoyi-ui/RuoYi-Vue3/src/api/ndt/dicom.js`
- Modify: `ruoyi-ui/RuoYi-Vue3/src/api/ndt/evaluation.js`
- Modify: `ruoyi-ui/RuoYi-Vue3/src/views/ndt/dicom/index.vue`
- Modify: `ruoyi-ui/RuoYi-Vue3/src/views/ndt/evaluation/index.vue`
- Modify: `ruoyi-ui/RuoYi-Vue3/src/views/ndt/report/index.vue`

**Interfaces:**
- Consumes: `POST /ndt/dicom/object/derived/upload` and existing `POST /ndt/evaluation/{id}/submit-with-sr`.

- [ ] **Step 1: Add frontend API helper**

Create a multipart helper accepting `sourceObjectId`, `objectType`, and `file` for derived image DICOM uploads.

- [ ] **Step 2: Add original-image actions and dialog**

On `ORIGINAL_IMAGE` rows show actions for processed image, screenshot, and annotation image; display source Study/Series/position; accept `.dcm` only; refresh the list after success.

- [ ] **Step 3: Add submit-with-SR interaction**

For draft evaluations add a dialog requiring a source original and SR DICOM file, then call the existing multipart API. Keep ordinary submit available.

- [ ] **Step 4: Clarify the report page**

State that this page stores task-level ordinary PDF versions outside the DICOM Study/Series hierarchy, while DICOM SR is uploaded from the evaluation workflow.

- [ ] **Step 5: Build the frontend**

Run: `npm run build:prod` from `ruoyi-ui/RuoYi-Vue3`; expect a successful production build.

### Task 5: Live database migration and end-to-end verification

**Files:**
- Verify only; no additional files expected.

**Interfaces:**
- Consumes: migration from Task 3 and compiled application from Tasks 2 and 4.

- [ ] **Step 1: Verify all database character sets**

Query connection variables, database default charset/collation, and target table/column charsets; stop if any DICOM business text path is not `utf8mb4`.

- [ ] **Step 2: Run the Unicode round-trip probe**

Create a dedicated `utf8mb4` probe table, insert UTF-8 bytes for `中文测试🚀` using a hex-to-utf8mb4 conversion, read the value and `HEX(value)`, verify the expected bytes, then drop the probe table.

- [ ] **Step 3: Check migration preconditions**

Confirm `series_role` exists, no Series has more than one active original, and the target unique index name is unused.

- [ ] **Step 4: Apply the live DDL through MySQL MCP**

Drop `series_role` and create `uk_ndt_object_active_original_series` only after all checks pass.

- [ ] **Step 5: Verify live schema and constraints**

Query `information_schema.columns`, `information_schema.statistics`, foreign keys, and duplicate-original groups; expect no `series_role`, the new unique index, intact foreign keys, and zero violations.

- [ ] **Step 6: Run final backend and frontend verification**

Run `mvn clean package -DskipTests=false` at repository root and `npm run build:prod` in the Vue project; report exact results and any unverified runtime dependency.
