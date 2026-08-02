-- NDT 核心业务数据库集中重构
-- 适用数据库：MySQL 8.0+
-- 重要：本脚本会删除旧核心业务表及其全部数据，执行前必须完成全量备份。
-- 本脚本不修改任何 sys_* 表结构。

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 保留辅助表结构，但按“无旧数据兼容”要求清空事务数据和旧测试规则。
TRUNCATE TABLE `ndt_task_user`;
TRUNCATE TABLE `ndt_inspector_profile`;
TRUNCATE TABLE `ndt_dicom_integrity_record`;
TRUNCATE TABLE `dcm_validation_record`;
TRUNCATE TABLE `dcm_validation_rule`;

-- 删除目标模型的已有版本，保证脚本可重复执行。
DROP TABLE IF EXISTS `ndt_evaluation_review`;
DROP TABLE IF EXISTS `ndt_task_report`;
DROP TABLE IF EXISTS `ndt_evaluation`;
DROP TABLE IF EXISTS `ndt_defect`;
DROP TABLE IF EXISTS `ndt_dicom_object_relation`;
DROP TABLE IF EXISTS `ndt_dicom_object`;
DROP TABLE IF EXISTS `ndt_dicom_series`;
DROP TABLE IF EXISTS `ndt_inspection_study`;
DROP TABLE IF EXISTS `ndt_inspection_position`;
DROP TABLE IF EXISTS `ndt_workpiece`;
DROP TABLE IF EXISTS `ndt_inspection_task`;
DROP TABLE IF EXISTS `ndt_customer`;

-- 删除被新模型替代的旧 NDT 组织和 DICOM 索引表。
DROP TABLE IF EXISTS `ndt_part_dicom_object`;
DROP TABLE IF EXISTS `ndt_inspection_part`;
DROP TABLE IF EXISTS `ndt_dicom_instance`;

-- 删除已废弃且数据为空的旧 dcm_* Study/Series/Instance/Evaluation 链路。
DROP TABLE IF EXISTS `dcm_evaluation`;
DROP TABLE IF EXISTS `dcm_instance`;
DROP TABLE IF EXISTS `dcm_series`;
DROP TABLE IF EXISTS `dcm_study`;

CREATE TABLE `ndt_customer` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '客户主键',
  `name` varchar(200) NOT NULL COMMENT '客户名称',
  `contact_name` varchar(100) DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(50) DEFAULT NULL COMMENT '联系电话',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ndt_customer_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT客户表';

CREATE TABLE `ndt_inspection_task` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '检测任务主键',
  `customer_id` bigint NOT NULL COMMENT '所属客户主键',
  `task_name` varchar(200) NOT NULL COMMENT '任务名称',
  `task_no` varchar(64) NOT NULL COMMENT '任务编号',
  `status` varchar(32) NOT NULL DEFAULT 'DRAFT' COMMENT '任务状态',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `finish_time` datetime DEFAULT NULL COMMENT '完成时间',
  `description` text COMMENT '任务说明',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_task_no` (`task_no`) USING BTREE,
  KEY `idx_ndt_task_customer` (`customer_id`) USING BTREE,
  KEY `idx_ndt_task_status` (`status`) USING BTREE,
  KEY `idx_ndt_task_start_time` (`start_time`) USING BTREE,
  CONSTRAINT `fk_ndt_task_customer`
    FOREIGN KEY (`customer_id`) REFERENCES `ndt_customer` (`id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT检测任务表';

CREATE TABLE `ndt_workpiece` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '工件主键',
  `task_id` bigint NOT NULL COMMENT '所属检测任务主键',
  `workpiece_name` varchar(200) NOT NULL COMMENT '工件名称',
  `sort_no` int NOT NULL DEFAULT 0 COMMENT '排序号',
  `status` varchar(32) NOT NULL DEFAULT 'PENDING' COMMENT '工件状态',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ndt_workpiece_task` (`task_id`) USING BTREE,
  KEY `idx_ndt_workpiece_task_sort` (`task_id`, `sort_no`) USING BTREE,
  CONSTRAINT `fk_ndt_workpiece_task`
    FOREIGN KEY (`task_id`) REFERENCES `ndt_inspection_task` (`id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT工件表';

CREATE TABLE `ndt_inspection_position` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '检测部位主键',
  `workpiece_id` bigint NOT NULL COMMENT '所属工件主键',
  `position_name` varchar(200) NOT NULL COMMENT '部位名称',
  `position_code` varchar(64) NOT NULL COMMENT '部位编码',
  `sort_no` int NOT NULL DEFAULT 0 COMMENT '排序号',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_position_code` (`workpiece_id`, `position_code`) USING BTREE,
  UNIQUE KEY `uk_ndt_position_id_workpiece` (`id`, `workpiece_id`) USING BTREE,
  KEY `idx_ndt_position_workpiece_sort` (`workpiece_id`, `sort_no`) USING BTREE,
  CONSTRAINT `fk_ndt_position_workpiece`
    FOREIGN KEY (`workpiece_id`) REFERENCES `ndt_workpiece` (`id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT检测部位表';

CREATE TABLE `ndt_inspection_study` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '检测Study主键',
  `workpiece_id` bigint NOT NULL COMMENT '所属工件主键',
  `study_instance_uid` varchar(128) NOT NULL COMMENT 'DICOM Study Instance UID',
  `inspection_method_code` varchar(32) DEFAULT NULL COMMENT '检测方法代码，如DX、CR、CT、UT',
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
  CONSTRAINT `fk_ndt_study_workpiece`
    FOREIGN KEY (`workpiece_id`) REFERENCES `ndt_workpiece` (`id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT工件检测Study表';

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
    FOREIGN KEY (`study_id`, `workpiece_id`) REFERENCES `ndt_inspection_study` (`id`, `workpiece_id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ndt_series_position_workpiece`
    FOREIGN KEY (`position_id`, `workpiece_id`) REFERENCES `ndt_inspection_position` (`id`, `workpiece_id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT DICOM物理Series表';

CREATE TABLE `ndt_dicom_object` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'DICOM或派生对象主键',
  `series_id` bigint NOT NULL COMMENT '所属DICOM Series主键',
  `object_type` varchar(32) NOT NULL COMMENT '对象类型',
  `object_name` varchar(255) DEFAULT NULL COMMENT '对象名称',
  `storage_type` varchar(32) NOT NULL COMMENT '存储类型',
  `orthanc_instance_id` varchar(100) DEFAULT NULL COMMENT 'Orthanc Instance ID',
  `file_path` varchar(500) DEFAULT NULL COMMENT '文件系统路径',
  `object_key` varchar(500) DEFAULT NULL COMMENT '对象存储Key',
  `mime_type` varchar(128) DEFAULT NULL COMMENT 'MIME类型',
  `sop_instance_uid` varchar(128) DEFAULT NULL COMMENT 'SOP Instance UID',
  `sop_class_uid` varchar(128) DEFAULT NULL COMMENT 'SOP Class UID',
  `parameters_json` json DEFAULT NULL COMMENT '显示参数或对象参数',
  `metadata_json` json DEFAULT NULL COMMENT '扩展元数据',
  `sha256` char(64) DEFAULT NULL COMMENT '文件SHA-256摘要',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_object_sop_uid` (`sop_instance_uid`) USING BTREE,
  UNIQUE KEY `uk_ndt_object_active_original_series`
    ((CASE WHEN `object_type` = 'ORIGINAL_IMAGE' AND `del_flag` = '0' THEN `series_id` ELSE NULL END)),
  KEY `idx_ndt_object_series_type` (`series_id`, `object_type`) USING BTREE,
  KEY `idx_ndt_object_orthanc` (`orthanc_instance_id`) USING BTREE,
  KEY `idx_ndt_object_sha256` (`sha256`) USING BTREE,
  CONSTRAINT `chk_ndt_object_type`
    CHECK (`object_type` IN (
      'ORIGINAL_IMAGE',
      'PROCESSED_IMAGE',
      'SCREENSHOT',
      'ANNOTATION_IMAGE',
      'PRESENTATION_STATE',
      'SR',
      'OTHER'
    )),
  CONSTRAINT `chk_ndt_object_storage_type`
    CHECK (`storage_type` IN (
      'ORTHANC',
      'FILE_SYSTEM',
      'OBJECT_STORAGE',
      'DATABASE_JSON'
    )),
  CONSTRAINT `fk_ndt_object_series`
    FOREIGN KEY (`series_id`) REFERENCES `ndt_dicom_series` (`id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT DICOM及派生对象表';

CREATE TABLE `ndt_dicom_object_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '对象关系主键',
  `source_object_id` bigint NOT NULL COMMENT '来源对象主键',
  `target_object_id` bigint NOT NULL COMMENT '目标或衍生对象主键',
  `relation_type` varchar(32) NOT NULL COMMENT '关系类型',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_object_relation` (`source_object_id`, `target_object_id`, `relation_type`) USING BTREE,
  KEY `idx_ndt_relation_target` (`target_object_id`) USING BTREE,
  CONSTRAINT `chk_ndt_relation_type`
    CHECK (`relation_type` IN ('DERIVED_FROM', 'REFERENCES', 'GENERATED_FROM')),
  CONSTRAINT `chk_ndt_relation_distinct`
    CHECK (`source_object_id` <> `target_object_id`),
  CONSTRAINT `fk_ndt_relation_source`
    FOREIGN KEY (`source_object_id`) REFERENCES `ndt_dicom_object` (`id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ndt_relation_target`
    FOREIGN KEY (`target_object_id`) REFERENCES `ndt_dicom_object` (`id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT DICOM对象关系表';

CREATE TABLE `ndt_defect` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '缺陷主键',
  `original_object_id` bigint NOT NULL COMMENT '所属原始图对象主键',
  `defect_no` varchar(64) NOT NULL COMMENT '缺陷编号',
  `defect_type` varchar(128) DEFAULT NULL COMMENT '缺陷类型',
  `roi_type` varchar(32) DEFAULT NULL COMMENT 'ROI类型',
  `roi_data_json` json DEFAULT NULL COMMENT 'ROI坐标和几何数据',
  `description` text COMMENT '缺陷描述',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_defect_no` (`original_object_id`, `defect_no`) USING BTREE,
  KEY `idx_ndt_defect_type` (`defect_type`) USING BTREE,
  CONSTRAINT `fk_ndt_defect_original_object`
    FOREIGN KEY (`original_object_id`) REFERENCES `ndt_dicom_object` (`id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT缺陷表';

CREATE TABLE `ndt_evaluation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评定主键',
  `evaluation_type` varchar(32) NOT NULL COMMENT '评定类型（DEFECT或WORKPIECE）',
  `defect_id` bigint DEFAULT NULL COMMENT '缺陷主键',
  `workpiece_id` bigint DEFAULT NULL COMMENT '工件主键',
  `level` varchar(64) DEFAULT NULL COMMENT '评定等级',
  `conclusion` varchar(1000) DEFAULT NULL COMMENT '评定结论',
  `description` text COMMENT '评定说明',
  `evaluator_id` bigint DEFAULT NULL COMMENT '评定人员用户ID',
  `evaluation_time` datetime DEFAULT NULL COMMENT '评定时间',
  `status` varchar(32) NOT NULL DEFAULT 'DRAFT' COMMENT '评定状态',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ndt_evaluation_defect` (`defect_id`) USING BTREE,
  KEY `idx_ndt_evaluation_workpiece` (`workpiece_id`) USING BTREE,
  KEY `idx_ndt_evaluation_evaluator` (`evaluator_id`) USING BTREE,
  KEY `idx_ndt_evaluation_status` (`status`) USING BTREE,
  CONSTRAINT `chk_ndt_evaluation_target`
    CHECK (
      (`evaluation_type` = 'DEFECT' AND `defect_id` IS NOT NULL AND `workpiece_id` IS NULL)
      OR
      (`evaluation_type` = 'WORKPIECE' AND `workpiece_id` IS NOT NULL AND `defect_id` IS NULL)
    ),
  CONSTRAINT `fk_ndt_evaluation_defect`
    FOREIGN KEY (`defect_id`) REFERENCES `ndt_defect` (`id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ndt_evaluation_workpiece`
    FOREIGN KEY (`workpiece_id`) REFERENCES `ndt_workpiece` (`id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT评定表';

CREATE TABLE `ndt_evaluation_review` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '复核主键',
  `evaluation_id` bigint NOT NULL COMMENT '被复核的评定主键',
  `review_result` varchar(32) NOT NULL COMMENT '复核结果（PASS或REJECT）',
  `review_comment` varchar(1000) DEFAULT NULL COMMENT '复核意见',
  `reviewer_id` bigint NOT NULL COMMENT '复核人员用户ID',
  `review_time` datetime NOT NULL COMMENT '复核时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ndt_review_evaluation` (`evaluation_id`) USING BTREE,
  KEY `idx_ndt_review_reviewer` (`reviewer_id`) USING BTREE,
  KEY `idx_ndt_review_time` (`review_time`) USING BTREE,
  CONSTRAINT `chk_ndt_review_result`
    CHECK (`review_result` IN ('PASS', 'REJECT')),
  CONSTRAINT `fk_ndt_review_evaluation`
    FOREIGN KEY (`evaluation_id`) REFERENCES `ndt_evaluation` (`id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT评定复核记录表';

CREATE TABLE `ndt_task_report` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务报告主键',
  `task_id` bigint NOT NULL COMMENT '所属检测任务主键',
  `report_name` varchar(255) NOT NULL COMMENT '报告名称',
  `version` varchar(32) NOT NULL COMMENT '报告版本',
  `file_path` varchar(500) DEFAULT NULL COMMENT '文件系统路径',
  `object_key` varchar(500) DEFAULT NULL COMMENT '对象存储Key',
  `sha256` char(64) DEFAULT NULL COMMENT '报告文件SHA-256摘要',
  `status` varchar(32) NOT NULL DEFAULT 'DRAFT' COMMENT '报告状态',
  `generate_by` bigint DEFAULT NULL COMMENT '生成人员用户ID',
  `generate_time` datetime DEFAULT NULL COMMENT '生成时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_report_version` (`task_id`, `version`) USING BTREE,
  KEY `idx_ndt_report_status` (`status`) USING BTREE,
  KEY `idx_ndt_report_generate_time` (`generate_time`) USING BTREE,
  CONSTRAINT `fk_ndt_report_task`
    FOREIGN KEY (`task_id`) REFERENCES `ndt_inspection_task` (`id`)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT任务级PDF报告表';

SET FOREIGN_KEY_CHECKS = 1;
