-- NDT DICOM 测试业务数据一键清理脚本
-- 保留：客户、任务、工件、部位、任务成员、WORKPIECE 总体评定、任务 PDF、规则配置。
-- 清理：Study、Series、DICOM 对象、关系、缺陷、DEFECT 评定及复核、完整性记录、上传校验记录。
-- 推荐执行：mysql --default-character-set=utf8mb4 -u<user> -p <database> < clear_ndt_dicom_test_data.sql

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;

DROP PROCEDURE IF EXISTS `clear_ndt_dicom_test_data`;
DELIMITER $$
CREATE PROCEDURE `clear_ndt_dicom_test_data`()
BEGIN
    DECLARE bad_charset_count INT DEFAULT 0;

    IF @@character_set_client <> 'utf8mb4'
       OR @@character_set_connection <> 'utf8mb4'
       OR @@character_set_results <> 'utf8mb4' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '连接字符集不是 utf8mb4，已停止清理';
    END IF;

    SELECT COUNT(*) INTO bad_charset_count
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME IN (
          'dcm_validation_record',
          'ndt_dicom_integrity_record',
          'ndt_inspection_study',
          'ndt_dicom_series',
          'ndt_dicom_object',
          'ndt_dicom_object_relation',
          'ndt_defect',
          'ndt_evaluation',
          'ndt_evaluation_review'
      )
      AND TABLE_COLLATION NOT LIKE 'utf8mb4%';

    IF bad_charset_count > 0 OR @@collation_database NOT LIKE 'utf8mb4%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '数据库或目标表不是 utf8mb4，已停止清理';
    END IF;

    START TRANSACTION;

    DELETE review_row
    FROM ndt_evaluation_review review_row
    INNER JOIN ndt_evaluation evaluation_row
        ON evaluation_row.id = review_row.evaluation_id
    WHERE evaluation_row.evaluation_type = 'DEFECT';

    DELETE FROM ndt_evaluation WHERE evaluation_type = 'DEFECT';
    DELETE FROM ndt_defect;
    DELETE FROM ndt_dicom_object_relation;
    DELETE FROM ndt_dicom_integrity_record;
    DELETE FROM dcm_validation_record;
    DELETE FROM ndt_dicom_object;
    DELETE FROM ndt_dicom_series;
    DELETE FROM ndt_inspection_study;

    COMMIT;
END$$
DELIMITER ;

CALL `clear_ndt_dicom_test_data`();
DROP PROCEDURE `clear_ndt_dicom_test_data`;

ALTER TABLE `dcm_validation_record` AUTO_INCREMENT = 1;
ALTER TABLE `ndt_dicom_integrity_record` AUTO_INCREMENT = 1;
ALTER TABLE `ndt_inspection_study` AUTO_INCREMENT = 1;
ALTER TABLE `ndt_dicom_series` AUTO_INCREMENT = 1;
ALTER TABLE `ndt_dicom_object` AUTO_INCREMENT = 1;
ALTER TABLE `ndt_dicom_object_relation` AUTO_INCREMENT = 1;
ALTER TABLE `ndt_defect` AUTO_INCREMENT = 1;
ALTER TABLE `ndt_evaluation` AUTO_INCREMENT = 1;
ALTER TABLE `ndt_evaluation_review` AUTO_INCREMENT = 1;

SELECT 'dcm_validation_record' AS table_name, COUNT(*) AS rows_remaining FROM dcm_validation_record
UNION ALL SELECT 'ndt_dicom_integrity_record', COUNT(*) FROM ndt_dicom_integrity_record
UNION ALL SELECT 'ndt_inspection_study', COUNT(*) FROM ndt_inspection_study
UNION ALL SELECT 'ndt_dicom_series', COUNT(*) FROM ndt_dicom_series
UNION ALL SELECT 'ndt_dicom_object', COUNT(*) FROM ndt_dicom_object
UNION ALL SELECT 'ndt_dicom_object_relation', COUNT(*) FROM ndt_dicom_object_relation
UNION ALL SELECT 'ndt_defect', COUNT(*) FROM ndt_defect
UNION ALL SELECT 'ndt_evaluation(DEFECT)', COUNT(*) FROM ndt_evaluation WHERE evaluation_type = 'DEFECT';
