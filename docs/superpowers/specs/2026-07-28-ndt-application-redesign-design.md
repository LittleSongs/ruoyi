# NDT Application Redesign

## Goal

Replace the RuoYi backend, RuoYi Vue frontend, and OHIF industrial extension so they use the rebuilt NDT schema directly. The implementation intentionally removes old APIs, old table mappings, public-sample behavior, department-based customer scope, and all compatibility branches.

## Domain Model

The application follows this hierarchy:

`customer -> inspection task -> workpiece -> inspection position -> DICOM object`

Supporting aggregates are:

- DICOM object relations
- defects attached to original images
- defect or workpiece evaluations
- append-only evaluation reviews
- versioned task report files
- retained validation rules/records, UID rules, private tags, integrity records, inspector profiles, and task-user membership

## Backend Boundaries

Each writable core aggregate has an entity, save/query DTO where useful, mapper, service, and controller:

- `/ndt/customer`
- `/ndt/task`
- `/ndt/workpiece`
- `/ndt/position`
- `/ndt/dicom/object`
- `/ndt/dicom/relation`
- `/ndt/defect`
- `/ndt/evaluation`
- `/ndt/evaluation/review`
- `/ndt/report`

Task object navigation is exposed as:

`GET /ndt/task/{taskId}/object-tree`

The tree contains workpieces, positions, and DICOM objects. Objects cannot be unassigned because `position_id` is required.

## DICOM and OHIF

Original DICOM upload validates the file, uploads it to Orthanc, extracts identifiers and metadata, creates an `ORIGINAL_IMAGE` object, and records integrity information. Derived objects use the same object table and explicit object relations.

OHIF receives a real access token, loads the task object tree, resolves the selected original object by object/SOP identifier, saves defect geometry separately from evaluation conclusions, and can submit an SR object related to its source image.

## Evaluation Rules

- A defect references an original DICOM object.
- A `DEFECT` evaluation references only `defect_id`.
- A `WORKPIECE` evaluation references only `workpiece_id`.
- Reviews are append-only; review updates and deletes are not exposed.
- UI capability flags are advisory. Backend permissions and task membership are authoritative.

## Reports

The first report implementation stores uploaded PDF report files, hashes, status, version, operator, and timestamps. It supports list/upload/download/delete. Automatic PDF rendering is intentionally excluded because no approved report template or rendering library exists.

## Authorization

- Administrators have full access.
- Other users must be members of a task through `ndt_task_user`.
- Company/customer scope no longer depends on `sys_dept`.
- New write endpoints require authentication and RuoYi permission checks.
- Anonymous write access and public-sample behavior are removed.

## Frontend

RuoYi Vue pages directly manage customers, tasks, workpieces, positions, DICOM objects, defects/evaluations/reviews, reports, and OHIF launch. Old `dcm/study`, `dcm/upload`, and `dcm/evaluation` pages and APIs are removed.

## Compatibility

There is no data migration, dual read, endpoint alias, legacy field parsing, or old table fallback. Old clients must be upgraded with this deployment.
