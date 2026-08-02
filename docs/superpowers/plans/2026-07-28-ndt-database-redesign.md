# NDT Database Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild the `ry-vue` NDT core business schema around the approved ten-table model and document the destructive change.

**Architecture:** Use one idempotent rebuild SQL file that drops obsolete core tables and recreates the normalized `ndt_*` hierarchy. Validate the script against a restored temporary database before applying it to `ry-vue`, then export the resulting database as the project SQL baseline.

**Tech Stack:** MySQL 8.0, InnoDB, utf8mb4, RuoYi SQL conventions, PowerShell, Docker.

## Global Constraints

- Do not modify any `sys_*` table structure.
- Existing core business data is intentionally discarded.
- Do not implement data migration or dual-read compatibility.
- Preserve independent validation, UID rule, private-tag, integrity, and inspector-profile tables.
- Use physical foreign keys only between the new NDT core tables.

---

### Task 1: Establish safety baseline

**Files:**
- Create: `.dev-state/backups/ry-vue-before-ndt-redesign-<timestamp>.sql` outside the Git repository

**Interfaces:**
- Consumes: running `mysql-dev` Docker container and `ry-vue` database
- Produces: full pre-change database backup and pre-change `sys_*` metadata hashes

- [x] **Step 1:** Create branch `codex/ndt-schema-redesign-20260728`.
- [x] **Step 2:** Dump `ry-vue` with routines, triggers, events, and a single transaction.
- [x] **Step 3:** Record `sys_*` column and index metadata hashes.

### Task 2: Create the rebuild and verification SQL

**Files:**
- Create: `sql/ndt_schema_redesign_20260728.sql`
- Create: `sql/verify_ndt_schema_redesign_20260728.sql`

**Interfaces:**
- Consumes: existing `ry-vue` business schema
- Produces: the ten normalized NDT core tables and executable metadata checks

- [x] **Step 1:** Run the verification query against the old schema and confirm that target tables are missing.
- [x] **Step 2:** Write the destructive rebuild SQL with explicit drop order.
- [x] **Step 3:** Add primary keys, unique keys, query indexes, core foreign keys, and evaluation consistency checks.
- [x] **Step 4:** Write verification queries for target presence, obsolete absence, required columns, foreign keys, and empty core tables.

### Task 3: Rehearse against a temporary database

**Files:**
- Test: `sql/verify_ndt_schema_redesign_20260728.sql`

**Interfaces:**
- Consumes: pre-change backup and rebuild SQL
- Produces: proof that the same backup can be restored and transformed without touching `ry-vue`

- [x] **Step 1:** Restore the backup into `ry_vue_ndt_schema_test`.
- [x] **Step 2:** Apply the rebuild SQL to the temporary database.
- [x] **Step 3:** Run verification SQL and require zero missing/unexpected schema rows.
- [x] **Step 4:** Drop only the validated temporary database.

### Task 4: Apply and export the actual database

**Files:**
- Regenerate: `sql/ry-vue.sql`

**Interfaces:**
- Consumes: tested rebuild SQL
- Produces: rebuilt live `ry-vue` and matching full SQL baseline

- [x] **Step 1:** Apply the tested script to `ry-vue`.
- [x] **Step 2:** Run all schema checks against `ry-vue`.
- [x] **Step 3:** Recompute `sys_*` metadata hashes and compare with the pre-change values.
- [x] **Step 4:** Dump the resulting `ry-vue` database to `sql/ry-vue.sql`.

### Task 5: Document and audit the change

**Files:**
- Create: `sql/README-ndt-schema-redesign.md`

**Interfaces:**
- Consumes: executed schema and verification output
- Produces: operator-facing change inventory, execution instructions, rollback procedure, and code impact statement

- [x] **Step 1:** Document created, rebuilt, dropped, retained, and cleared tables.
- [x] **Step 2:** Document constraints, enum codes, indexes, and foreign keys.
- [x] **Step 3:** Record backup location and full-restore rollback procedure.
- [x] **Step 4:** Record verification results and state that existing backend/frontend mappings now require direct replacement.
