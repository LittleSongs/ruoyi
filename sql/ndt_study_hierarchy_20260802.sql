-- NDT Component -> Study -> Series -> SOP 层级迁移
-- 前提：先清理现有 DICOM 测试业务数据；本脚本不迁移旧对象。

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE `ndt_inspection_study` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '检测Study主键',
  `workpiece_id` bigint NOT NULL COMMENT '所属工件主键',
  `study_instance_uid` varchar(128) NOT NULL COMMENT 'DICOM Study Instance UID',
  `inspection_method_code` varchar(32) DEFAULT NULL COMMENT '业务检测方法代码，如DX、CR、CT、UT',
  `study_no` varchar(64) DEFAULT NULL COMMENT 'Study业务编号',
  `study_description` varchar(255) DEFAULT NULL COMMENT 'Study描述',
  `study_date` varchar(8) DEFAULT NULL COMMENT 'DICOM Study Date',
  `study_time` varchar(16) DEFAULT NULL COMMENT 'DICOM Study Time',
  `orthanc_study_id` varchar(100) DEFAULT NULL COMMENT 'Orthanc Study ID',
  `status` varchar(32) NOT NULL DEFAULT 'ACTIVE' COMMENT 'Study状态',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_study_uid` (`study_instance_uid`) USING BTREE,
  UNIQUE KEY `uk_ndt_study_id_workpiece` (`id`, `workpiece_id`) USING BTREE,
  KEY `idx_ndt_study_workpiece` (`workpiece_id`, `create_time`) USING BTREE,
  KEY `idx_ndt_study_method` (`inspection_method_code`) USING BTREE,
  CONSTRAINT `fk_ndt_study_workpiece`
    FOREIGN KEY (`workpiece_id`) REFERENCES `ndt_workpiece` (`id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT工件检测Study表';

ALTER TABLE `ndt_inspection_position`
  ADD UNIQUE KEY `uk_ndt_position_id_workpiece` (`id`, `workpiece_id`) USING BTREE;

CREATE TABLE `ndt_dicom_series` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'DICOM Series主键',
  `study_id` bigint NOT NULL COMMENT '所属检测Study主键',
  `workpiece_id` bigint NOT NULL COMMENT '所属工件主键，用于数据库层一致性约束',
  `position_id` bigint NOT NULL COMMENT '关联稳定检测部位主键',
  `series_instance_uid` varchar(128) NOT NULL COMMENT 'DICOM Series Instance UID',
  `modality` varchar(32) DEFAULT NULL COMMENT 'DICOM Modality',
  `series_number` varchar(64) DEFAULT NULL COMMENT 'DICOM Series Number',
  `series_description` varchar(255) DEFAULT NULL COMMENT 'DICOM Series Description',
  `orthanc_series_id` varchar(100) DEFAULT NULL COMMENT 'Orthanc Series ID',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_series_uid` (`series_instance_uid`) USING BTREE,
  KEY `idx_ndt_series_study` (`study_id`, `create_time`) USING BTREE,
  KEY `idx_ndt_series_position` (`position_id`, `create_time`) USING BTREE,
  KEY `idx_ndt_series_study_workpiece` (`study_id`, `workpiece_id`) USING BTREE,
  KEY `idx_ndt_series_position_workpiece` (`position_id`, `workpiece_id`) USING BTREE,
  CONSTRAINT `fk_ndt_series_study_workpiece`
    FOREIGN KEY (`study_id`, `workpiece_id`)
    REFERENCES `ndt_inspection_study` (`id`, `workpiece_id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ndt_series_position_workpiece`
    FOREIGN KEY (`position_id`, `workpiece_id`)
    REFERENCES `ndt_inspection_position` (`id`, `workpiece_id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT DICOM物理Series表';

ALTER TABLE `ndt_dicom_object`
  DROP FOREIGN KEY `fk_ndt_object_position`,
  DROP INDEX `idx_ndt_object_position_type`,
  DROP INDEX `idx_ndt_object_study_uid`,
  DROP INDEX `idx_ndt_object_series_uid`,
  DROP COLUMN `position_id`,
  DROP COLUMN `study_uid`,
  DROP COLUMN `series_uid`,
  ADD COLUMN `series_id` bigint NOT NULL AFTER `id`,
  ADD KEY `idx_ndt_object_series_type` (`series_id`, `object_type`) USING BTREE,
  ADD UNIQUE KEY `uk_ndt_object_active_original_series`
    ((CASE WHEN `object_type` = 'ORIGINAL_IMAGE' AND `del_flag` = '0' THEN `series_id` ELSE NULL END)),
  ADD CONSTRAINT `fk_ndt_object_series`
    FOREIGN KEY (`series_id`) REFERENCES `ndt_dicom_series` (`id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT;
