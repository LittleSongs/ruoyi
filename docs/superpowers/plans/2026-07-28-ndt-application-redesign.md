# NDT Application Redesign Implementation Plan

> Execute directly in the current session. User has approved destructive replacement and explicitly does not want compatibility work or further confirmation.

**Goal:** Update the RuoYi backend and Vue frontend plus the OHIF industrial extension to use the rebuilt NDT schema, then document and verify the complete workflow.

**Architecture:** Build one normalized vertical slice around customer/task/workpiece/position/object navigation. Layer defect, evaluation, append-only review, DICOM SR relationships, and versioned report storage on that slice. Remove legacy DCM study/series/instance APIs and models.

**Tech stack:** Java 17, Spring Boot, MyBatis, MySQL 8, Vue 3, Element Plus, TypeScript, OHIF, Orthanc.

---

### Task 1: Establish implementation safety and executable specifications

- [x] Preserve existing dirty worktree changes.
- [x] Use `codex/ndt-schema-redesign-20260728` in both repositories.
- [x] Add backend business-rule tests for evaluation targets, object types, and access boundaries.
- [x] Update OHIF object-tree/client tests to express the new API and hierarchy.

### Task 2: Replace backend core hierarchy

- [x] Add customer entity/DTO/mapper/service/controller.
- [x] Replace task fields and remove department/public-sample behavior.
- [x] Add workpiece and inspection-position modules.
- [x] Add a task object-tree VO and endpoint.
- [x] Rewrite task access to use administrator or `ndt_task_user` membership.

### Task 3: Replace DICOM object and relation services

- [x] Replace old instance/organization models with `ndt_dicom_object`.
- [x] Implement validated Orthanc upload, metadata persistence, hash/integrity recording, tags, download, and derived-object creation.
- [x] Rewrite relations around source/target object IDs.
- [x] Remove old study/series/instance/upload code.

### Task 4: Replace defect, evaluation, review, and report services

- [x] Add defect CRUD and original-image validation.
- [x] Replace mixed annotation/evaluation storage with mutually exclusive defect/workpiece evaluation targets.
- [x] Add evaluation submit and SR submission workflow.
- [x] Add append-only review endpoints.
- [x] Add task report list/upload/download/delete with monotonically increasing versions and SHA-256.
- [x] Remove obsolete evaluation/history models.

### Task 5: Replace RuoYi Vue APIs and pages

- [x] Add APIs for customer, workpiece, position, object, relation, defect, review, and report.
- [x] Rewrite customer, task, DICOM, evaluation, report, and OHIF launcher pages.
- [x] Adapt retained validation, integrity, Orthanc, UID, private-tag, and inspector pages where identifiers changed.
- [x] Delete old DCM APIs/pages and update menu/permission seed data.

### Task 6: Replace OHIF industrial extension contracts

- [x] Replace part/unassigned tree types with workpiece/position/object types.
- [x] Rewrite NDT API client endpoints and payloads.
- [x] Rewrite object browser and defect/evaluation panels.
- [x] Persist defect geometry and evaluation separately; support SR object submission.
- [x] Consume the real RuoYi token and remove it from the browser address bar.

### Task 7: Verify and document

- [x] Run backend tests and package/compile validation.
- [x] Run Vue build.
- [x] Run targeted OHIF unit tests and TypeScript/build checks.
- [x] Search for deleted tables, endpoints, fields, and compatibility aliases.
- [x] Add root operator README with change inventory, configuration, startup, API and UI test cases, SQL checks, and known limitations.
