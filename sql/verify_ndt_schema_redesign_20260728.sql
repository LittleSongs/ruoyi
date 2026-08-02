-- NDT 核心业务数据库重构验证脚本
-- 使用方式：mysql -u... -p... <database_name> < verify_ndt_schema_redesign_20260728.sql
-- 所有结果集均应返回 0 行；summary 应返回固定计数。

SELECT expected.table_name AS missing_target_table
FROM (
    SELECT 'ndt_customer' AS table_name
    UNION ALL SELECT 'ndt_inspection_task'
    UNION ALL SELECT 'ndt_workpiece'
    UNION ALL SELECT 'ndt_inspection_position'
    UNION ALL SELECT 'ndt_inspection_study'
    UNION ALL SELECT 'ndt_dicom_series'
    UNION ALL SELECT 'ndt_dicom_object'
    UNION ALL SELECT 'ndt_dicom_object_relation'
    UNION ALL SELECT 'ndt_defect'
    UNION ALL SELECT 'ndt_evaluation'
    UNION ALL SELECT 'ndt_evaluation_review'
    UNION ALL SELECT 'ndt_task_report'
) expected
LEFT JOIN information_schema.TABLES actual
    ON actual.TABLE_SCHEMA = DATABASE()
   AND actual.TABLE_NAME = expected.table_name
WHERE actual.TABLE_NAME IS NULL;

SELECT actual.TABLE_NAME AS unexpected_legacy_table
FROM information_schema.TABLES actual
WHERE actual.TABLE_SCHEMA = DATABASE()
  AND actual.TABLE_NAME IN (
      'dcm_study',
      'dcm_series',
      'dcm_instance',
      'dcm_evaluation',
      'ndt_inspection_part',
      'ndt_dicom_instance',
      'ndt_part_dicom_object'
  );

SELECT expected.table_name, expected.column_name AS missing_required_column
FROM (
    SELECT 'ndt_customer' table_name, 'name' column_name
    UNION ALL SELECT 'ndt_inspection_task', 'customer_id'
    UNION ALL SELECT 'ndt_workpiece', 'task_id'
    UNION ALL SELECT 'ndt_inspection_position', 'workpiece_id'
    UNION ALL SELECT 'ndt_inspection_study', 'workpiece_id'
    UNION ALL SELECT 'ndt_inspection_study', 'study_instance_uid'
    UNION ALL SELECT 'ndt_dicom_series', 'study_id'
    UNION ALL SELECT 'ndt_dicom_series', 'position_id'
    UNION ALL SELECT 'ndt_dicom_series', 'series_instance_uid'
    UNION ALL SELECT 'ndt_dicom_object', 'series_id'
    UNION ALL SELECT 'ndt_dicom_object', 'object_type'
    UNION ALL SELECT 'ndt_dicom_object', 'storage_type'
    UNION ALL SELECT 'ndt_dicom_object_relation', 'source_object_id'
    UNION ALL SELECT 'ndt_dicom_object_relation', 'target_object_id'
    UNION ALL SELECT 'ndt_defect', 'original_object_id'
    UNION ALL SELECT 'ndt_evaluation', 'evaluation_type'
    UNION ALL SELECT 'ndt_evaluation', 'defect_id'
    UNION ALL SELECT 'ndt_evaluation', 'workpiece_id'
    UNION ALL SELECT 'ndt_evaluation_review', 'evaluation_id'
    UNION ALL SELECT 'ndt_task_report', 'task_id'
) expected
LEFT JOIN information_schema.COLUMNS actual
    ON actual.TABLE_SCHEMA = DATABASE()
   AND actual.TABLE_NAME = expected.table_name
   AND actual.COLUMN_NAME = expected.column_name
WHERE actual.COLUMN_NAME IS NULL;

SELECT actual.TABLE_NAME, actual.COLUMN_NAME AS deprecated_column
FROM information_schema.COLUMNS actual
WHERE actual.TABLE_SCHEMA = DATABASE()
  AND actual.TABLE_NAME = 'ndt_dicom_series'
  AND actual.COLUMN_NAME = 'series_role';

SELECT 'uk_ndt_object_active_original_series' AS missing_required_index
WHERE NOT EXISTS (
    SELECT 1
    FROM information_schema.STATISTICS actual
    WHERE actual.TABLE_SCHEMA = DATABASE()
      AND actual.TABLE_NAME = 'ndt_dicom_object'
      AND actual.INDEX_NAME = 'uk_ndt_object_active_original_series'
      AND actual.NON_UNIQUE = 0
);

SELECT series_id, COUNT(*) AS active_original_count
FROM ndt_dicom_object
WHERE object_type = 'ORIGINAL_IMAGE'
  AND del_flag = '0'
GROUP BY series_id
HAVING COUNT(*) > 1;

SELECT ds.study_id, ds.position_id, COUNT(DISTINCT o.series_id) AS image_series_count
FROM ndt_dicom_object o
INNER JOIN ndt_dicom_series ds ON ds.id = o.series_id AND ds.del_flag = '0'
WHERE o.object_type = 'ORIGINAL_IMAGE'
  AND o.del_flag = '0'
GROUP BY ds.study_id, ds.position_id
HAVING COUNT(DISTINCT o.series_id) > 1;

SELECT expected.constraint_name AS missing_foreign_key
FROM (
    SELECT 'fk_ndt_task_customer' constraint_name
    UNION ALL SELECT 'fk_ndt_workpiece_task'
    UNION ALL SELECT 'fk_ndt_position_workpiece'
    UNION ALL SELECT 'fk_ndt_study_workpiece'
    UNION ALL SELECT 'fk_ndt_series_study_workpiece'
    UNION ALL SELECT 'fk_ndt_series_position_workpiece'
    UNION ALL SELECT 'fk_ndt_object_series'
    UNION ALL SELECT 'fk_ndt_relation_source'
    UNION ALL SELECT 'fk_ndt_relation_target'
    UNION ALL SELECT 'fk_ndt_defect_original_object'
    UNION ALL SELECT 'fk_ndt_evaluation_defect'
    UNION ALL SELECT 'fk_ndt_evaluation_workpiece'
    UNION ALL SELECT 'fk_ndt_review_evaluation'
    UNION ALL SELECT 'fk_ndt_report_task'
) expected
LEFT JOIN information_schema.REFERENTIAL_CONSTRAINTS actual
    ON actual.CONSTRAINT_SCHEMA = DATABASE()
   AND actual.CONSTRAINT_NAME = expected.constraint_name
WHERE actual.CONSTRAINT_NAME IS NULL;

SELECT counts.table_name AS non_empty_core_table, counts.row_count
FROM (
    SELECT 'ndt_customer' table_name, COUNT(*) row_count FROM ndt_customer
    UNION ALL SELECT 'ndt_inspection_task', COUNT(*) FROM ndt_inspection_task
    UNION ALL SELECT 'ndt_workpiece', COUNT(*) FROM ndt_workpiece
    UNION ALL SELECT 'ndt_inspection_position', COUNT(*) FROM ndt_inspection_position
    UNION ALL SELECT 'ndt_inspection_study', COUNT(*) FROM ndt_inspection_study
    UNION ALL SELECT 'ndt_dicom_series', COUNT(*) FROM ndt_dicom_series
    UNION ALL SELECT 'ndt_dicom_object', COUNT(*) FROM ndt_dicom_object
    UNION ALL SELECT 'ndt_dicom_object_relation', COUNT(*) FROM ndt_dicom_object_relation
    UNION ALL SELECT 'ndt_defect', COUNT(*) FROM ndt_defect
    UNION ALL SELECT 'ndt_evaluation', COUNT(*) FROM ndt_evaluation
    UNION ALL SELECT 'ndt_evaluation_review', COUNT(*) FROM ndt_evaluation_review
    UNION ALL SELECT 'ndt_task_report', COUNT(*) FROM ndt_task_report
    UNION ALL SELECT 'ndt_task_user', COUNT(*) FROM ndt_task_user
) counts
WHERE counts.row_count <> 0;

SELECT
    SUM(TABLE_NAME IN (
        'ndt_customer',
        'ndt_inspection_task',
        'ndt_workpiece',
        'ndt_inspection_position',
        'ndt_inspection_study',
        'ndt_dicom_series',
        'ndt_dicom_object',
        'ndt_dicom_object_relation',
        'ndt_defect',
        'ndt_evaluation',
        'ndt_evaluation_review',
        'ndt_task_report'
    )) AS target_table_count,
    (
        SELECT COUNT(*)
        FROM information_schema.REFERENTIAL_CONSTRAINTS
        WHERE CONSTRAINT_SCHEMA = DATABASE()
          AND CONSTRAINT_NAME LIKE 'fk_ndt_%'
    ) AS ndt_foreign_key_count
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE();
