-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: ry-vue
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `dcm_validation_record`
--

DROP TABLE IF EXISTS `dcm_validation_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dcm_validation_record` (
  `record_id` bigint NOT NULL AUTO_INCREMENT,
  `batch_id` bigint DEFAULT NULL,
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `file_size` bigint DEFAULT NULL,
  `temp_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `sop_class_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `media_storage_sop_class_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `study_instance_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `series_instance_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `sop_instance_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `modality` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `official_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'validate_iods结果 PASS/FAIL',
  `custom_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '自定义规则结果 PASS/FAIL',
  `final_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '最终结果 PASS/FAIL',
  `error_count` int DEFAULT '0',
  `warning_count` int DEFAULT '0',
  `official_result_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'validate_iods原始结果',
  `custom_result_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '自定义规则结果',
  `orthanc_instance_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '通过后才有',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`record_id`) USING BTREE,
  KEY `idx_dcm_validation_record_sop` (`sop_instance_uid`) USING BTREE,
  KEY `idx_dcm_validation_record_status` (`final_status`) USING BTREE,
  KEY `idx_dcm_validation_record_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='DICOM上传校验记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dcm_validation_record`
--

LOCK TABLES `dcm_validation_record` WRITE;
/*!40000 ALTER TABLE `dcm_validation_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `dcm_validation_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dcm_validation_rule`
--

DROP TABLE IF EXISTS `dcm_validation_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dcm_validation_rule` (
  `rule_id` bigint NOT NULL AUTO_INCREMENT,
  `rule_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '规则名称',
  `sop_class_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '适用SOPClassUID，*表示通用规则',
  `sop_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'SOP名称',
  `modality` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '可选，CT/DX/CR等',
  `rule_type` tinyint NOT NULL COMMENT '规则类型：1=必备Tag',
  `tag_code` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Tag编号，如00111010',
  `tag_display` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '显示格式，如(0011,1010)',
  `tag_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Tag名称',
  `vr` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'VR，如LO/SH/LT/UI',
  `private_creator` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '私有Tag创建者，如RuoYiNDT',
  `allow_blank` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'N' COMMENT '是否允许空值 Y/N',
  `severity` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'ERROR' COMMENT 'ERROR/WARNING',
  `enabled` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'Y' COMMENT '是否启用',
  `sort_order` int DEFAULT '0',
  `fail_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '失败提示',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`rule_id`) USING BTREE,
  KEY `idx_dcm_validation_rule_sop` (`sop_class_uid`,`rule_type`,`enabled`) USING BTREE,
  KEY `idx_dcm_validation_rule_tag` (`tag_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='DICOM自定义校验规则表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dcm_validation_rule`
--

LOCK TABLES `dcm_validation_rule` WRITE;
/*!40000 ALTER TABLE `dcm_validation_rule` DISABLE KEYS */;
/*!40000 ALTER TABLE `dcm_validation_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '生成功能作者',
  `form_col_num` int DEFAULT '1' COMMENT '表单布局（单列 双列 三列）',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_customer`
--

DROP TABLE IF EXISTS `ndt_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_customer` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `name` varchar(200) NOT NULL COMMENT '????',
  `contact_name` varchar(100) DEFAULT NULL COMMENT '???',
  `contact_phone` varchar(50) DEFAULT NULL COMMENT '????',
  `remark` varchar(500) DEFAULT NULL COMMENT '??',
  `create_by` varchar(64) DEFAULT '' COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '????',
  `update_by` varchar(64) DEFAULT '' COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '????',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '?????0?? 2???',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ndt_customer_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT???';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndt_customer`
--

LOCK TABLES `ndt_customer` WRITE;
/*!40000 ALTER TABLE `ndt_customer` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndt_customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_defect`
--

DROP TABLE IF EXISTS `ndt_defect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_defect` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `original_object_id` bigint NOT NULL COMMENT '?????????',
  `defect_no` varchar(64) NOT NULL COMMENT '????',
  `defect_type` varchar(128) DEFAULT NULL COMMENT '????',
  `roi_type` varchar(32) DEFAULT NULL COMMENT 'ROI??',
  `roi_data_json` json DEFAULT NULL COMMENT 'ROI???????',
  `description` text COMMENT '????',
  `create_by` varchar(64) DEFAULT '' COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '????',
  `update_by` varchar(64) DEFAULT '' COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '????',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '?????0?? 2???',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_defect_no` (`original_object_id`,`defect_no`) USING BTREE,
  KEY `idx_ndt_defect_type` (`defect_type`) USING BTREE,
  CONSTRAINT `fk_ndt_defect_original_object` FOREIGN KEY (`original_object_id`) REFERENCES `ndt_dicom_object` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT???';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndt_defect`
--

LOCK TABLES `ndt_defect` WRITE;
/*!40000 ALTER TABLE `ndt_defect` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndt_defect` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_dicom_integrity_record`
--

DROP TABLE IF EXISTS `ndt_dicom_integrity_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_dicom_integrity_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `study_instance_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'StudyInstanceUID',
  `series_instance_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'SeriesInstanceUID',
  `sop_instance_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'SOPInstanceUID',
  `orthanc_instance_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Orthanc Instance ID',
  `pixel_data_sha256` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'PixelData SHA-256',
  `metadata_sha256` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '元数据 SHA-256',
  `file_sha256` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '原始文件 SHA-256',
  `signed_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '签名内容',
  `signature_algorithm` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '签名算法',
  `signature_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '签名值',
  `public_key_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公钥ID',
  `import_user_id` bigint DEFAULT NULL COMMENT '导入用户ID',
  `import_time` datetime DEFAULT NULL COMMENT '导入时间',
  `last_verify_time` datetime DEFAULT NULL COMMENT '最后校验时间',
  `verify_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'UNKNOWN' COMMENT '校验状态',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_integrity_sop` (`sop_instance_uid`) USING BTREE,
  KEY `idx_ndt_integrity_orthanc` (`orthanc_instance_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT DICOM完整性校验表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndt_dicom_integrity_record`
--

LOCK TABLES `ndt_dicom_integrity_record` WRITE;
/*!40000 ALTER TABLE `ndt_dicom_integrity_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndt_dicom_integrity_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_dicom_object`
--

DROP TABLE IF EXISTS `ndt_dicom_object`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_dicom_object` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'DICOM???????',
  `series_id` bigint NOT NULL COMMENT 'DICOM Series ID',
  `object_type` varchar(32) NOT NULL COMMENT '????',
  `object_name` varchar(255) DEFAULT NULL COMMENT '????',
  `storage_type` varchar(32) NOT NULL COMMENT '????',
  `orthanc_instance_id` varchar(100) DEFAULT NULL COMMENT 'Orthanc Instance ID',
  `file_path` varchar(500) DEFAULT NULL COMMENT '??????',
  `object_key` varchar(500) DEFAULT NULL COMMENT '????Key',
  `mime_type` varchar(128) DEFAULT NULL COMMENT 'MIME??',
  `sop_instance_uid` varchar(128) DEFAULT NULL COMMENT 'SOP Instance UID',
  `sop_class_uid` varchar(128) DEFAULT NULL COMMENT 'SOP Class UID',
  `parameters_json` json DEFAULT NULL COMMENT '?????????',
  `metadata_json` json DEFAULT NULL COMMENT '?????',
  `sha256` char(64) DEFAULT NULL COMMENT '??SHA-256??',
  `create_by` varchar(64) DEFAULT '' COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '????',
  `update_by` varchar(64) DEFAULT '' COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '????',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '?????0?? 2???',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_object_sop_uid` (`sop_instance_uid`) USING BTREE,
  UNIQUE KEY `uk_ndt_object_active_original_series` ((case when ((`object_type` = _utf8mb4'ORIGINAL_IMAGE') and (`del_flag` = _utf8mb4'0')) then `series_id` else NULL end)),
  KEY `idx_ndt_object_series_type` (`series_id`,`object_type`) USING BTREE,
  KEY `idx_ndt_object_orthanc` (`orthanc_instance_id`) USING BTREE,
  KEY `idx_ndt_object_sha256` (`sha256`) USING BTREE,
  CONSTRAINT `fk_ndt_object_series` FOREIGN KEY (`series_id`) REFERENCES `ndt_dicom_series` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_ndt_object_storage_type` CHECK ((`storage_type` in (_utf8mb4'ORTHANC',_utf8mb4'FILE_SYSTEM',_utf8mb4'OBJECT_STORAGE',_utf8mb4'DATABASE_JSON'))),
  CONSTRAINT `chk_ndt_object_type` CHECK ((`object_type` in (_utf8mb4'ORIGINAL_IMAGE',_utf8mb4'PROCESSED_IMAGE',_utf8mb4'SCREENSHOT',_utf8mb4'ANNOTATION_IMAGE',_utf8mb4'PRESENTATION_STATE',_utf8mb4'SR',_utf8mb4'OTHER')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT DICOM??????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndt_dicom_object`
--

LOCK TABLES `ndt_dicom_object` WRITE;
/*!40000 ALTER TABLE `ndt_dicom_object` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndt_dicom_object` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_dicom_object_relation`
--

DROP TABLE IF EXISTS `ndt_dicom_object_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_dicom_object_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??????',
  `source_object_id` bigint NOT NULL COMMENT '??????',
  `target_object_id` bigint NOT NULL COMMENT '?????????',
  `relation_type` varchar(32) NOT NULL COMMENT '????',
  `remark` varchar(500) DEFAULT NULL COMMENT '??',
  `create_by` varchar(64) DEFAULT '' COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_object_relation` (`source_object_id`,`target_object_id`,`relation_type`) USING BTREE,
  KEY `idx_ndt_relation_target` (`target_object_id`) USING BTREE,
  CONSTRAINT `fk_ndt_relation_source` FOREIGN KEY (`source_object_id`) REFERENCES `ndt_dicom_object` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ndt_relation_target` FOREIGN KEY (`target_object_id`) REFERENCES `ndt_dicom_object` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_ndt_relation_distinct` CHECK ((`source_object_id` <> `target_object_id`)),
  CONSTRAINT `chk_ndt_relation_type` CHECK ((`relation_type` in (_utf8mb4'DERIVED_FROM',_utf8mb4'REFERENCES',_utf8mb4'GENERATED_FROM')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT DICOM?????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndt_dicom_object_relation`
--

LOCK TABLES `ndt_dicom_object_relation` WRITE;
/*!40000 ALTER TABLE `ndt_dicom_object_relation` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndt_dicom_object_relation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_dicom_private_tag`
--

DROP TABLE IF EXISTS `ndt_dicom_private_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_dicom_private_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tag_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Orthanc/DICOM标签名称或私有标签关键字',
  `tag_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '显示名称',
  `tag_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'DICOM标签号',
  `vr` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '值表示VR',
  `default_value` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '新增默认值',
  `enabled` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '1' COMMENT '是否启用',
  `builtin` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '是否内置',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_private_tag_name` (`tag_name`) USING BTREE,
  KEY `idx_ndt_private_tag_enabled` (`enabled`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT允许编辑的DICOM私有标签配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndt_dicom_private_tag`
--

LOCK TABLES `ndt_dicom_private_tag` WRITE;
/*!40000 ALTER TABLE `ndt_dicom_private_tag` DISABLE KEYS */;
INSERT INTO `ndt_dicom_private_tag` VALUES (1,'Manufacturer','制造商','0008,0070','LO','','1','1','DICOM标准制造商标签','admin','2026-06-04 17:49:58','',NULL,'0'),(2,'0011,0010','NDT私有标签创建者','0011,0010','LO','RuoYiNDT','0','1','NDT私有标签块创建者','admin','2026-06-04 17:49:58','admin','2026-06-04 19:22:22','2'),(3,'NdtClientName','委托方','0011,1010','LO','','1','1','NDT私有标签：委托方','admin','2026-06-04 17:49:58','admin','2026-06-04 19:22:01','0'),(4,'NdtInspectorName','检测人员','0011,1011','LO','','1','1','NDT私有标签：检测人员','admin','2026-06-04 17:49:58','admin','2026-06-04 19:22:11','0'),(5,'NdtEvaluationConclusion','评定结论','0011,1012','LT','','1','1','NDT私有标签：评定结论','admin','2026-06-04 17:49:58','admin','2026-06-04 19:22:17','0'),(6,'PatientName','工件名称','0010,0010','PN','','1','0',NULL,'admin','2026-06-04 18:55:04','admin','2026-06-04 18:55:04','0');
/*!40000 ALTER TABLE `ndt_dicom_private_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_evaluation`
--

DROP TABLE IF EXISTS `ndt_evaluation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_evaluation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `evaluation_type` varchar(32) NOT NULL COMMENT '?????DEFECT?WORKPIECE?',
  `defect_id` bigint DEFAULT NULL COMMENT '????',
  `workpiece_id` bigint DEFAULT NULL COMMENT '????',
  `level` varchar(64) DEFAULT NULL COMMENT '????',
  `conclusion` varchar(1000) DEFAULT NULL COMMENT '????',
  `description` text COMMENT '????',
  `evaluator_id` bigint DEFAULT NULL COMMENT '??????ID',
  `evaluation_time` datetime DEFAULT NULL COMMENT '????',
  `status` varchar(32) NOT NULL DEFAULT 'DRAFT' COMMENT '????',
  `create_by` varchar(64) DEFAULT '' COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '????',
  `update_by` varchar(64) DEFAULT '' COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '????',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '?????0?? 2???',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ndt_evaluation_defect` (`defect_id`) USING BTREE,
  KEY `idx_ndt_evaluation_workpiece` (`workpiece_id`) USING BTREE,
  KEY `idx_ndt_evaluation_evaluator` (`evaluator_id`) USING BTREE,
  KEY `idx_ndt_evaluation_status` (`status`) USING BTREE,
  CONSTRAINT `fk_ndt_evaluation_defect` FOREIGN KEY (`defect_id`) REFERENCES `ndt_defect` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ndt_evaluation_workpiece` FOREIGN KEY (`workpiece_id`) REFERENCES `ndt_workpiece` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_ndt_evaluation_target` CHECK ((((`evaluation_type` = _utf8mb4'DEFECT') and (`defect_id` is not null) and (`workpiece_id` is null)) or ((`evaluation_type` = _utf8mb4'WORKPIECE') and (`workpiece_id` is not null) and (`defect_id` is null))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT???';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndt_evaluation`
--

LOCK TABLES `ndt_evaluation` WRITE;
/*!40000 ALTER TABLE `ndt_evaluation` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndt_evaluation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_evaluation_review`
--

DROP TABLE IF EXISTS `ndt_evaluation_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_evaluation_review` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `evaluation_id` bigint NOT NULL COMMENT '????????',
  `review_result` varchar(32) NOT NULL COMMENT '?????PASS?REJECT?',
  `review_comment` varchar(1000) DEFAULT NULL COMMENT '????',
  `reviewer_id` bigint NOT NULL COMMENT '??????ID',
  `review_time` datetime NOT NULL COMMENT '????',
  `create_by` varchar(64) DEFAULT '' COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ndt_review_evaluation` (`evaluation_id`) USING BTREE,
  KEY `idx_ndt_review_reviewer` (`reviewer_id`) USING BTREE,
  KEY `idx_ndt_review_time` (`review_time`) USING BTREE,
  CONSTRAINT `fk_ndt_review_evaluation` FOREIGN KEY (`evaluation_id`) REFERENCES `ndt_evaluation` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_ndt_review_result` CHECK ((`review_result` in (_utf8mb4'PASS',_utf8mb4'REJECT')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT???????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndt_evaluation_review`
--

LOCK TABLES `ndt_evaluation_review` WRITE;
/*!40000 ALTER TABLE `ndt_evaluation_review` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndt_evaluation_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_inspection_position`
--

DROP TABLE IF EXISTS `ndt_inspection_position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_inspection_position` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??????',
  `workpiece_id` bigint NOT NULL COMMENT '??????',
  `position_name` varchar(200) NOT NULL COMMENT '????',
  `position_code` varchar(64) NOT NULL COMMENT '????',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '???',
  `remark` varchar(500) DEFAULT NULL COMMENT '??',
  `create_by` varchar(64) DEFAULT '' COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '????',
  `update_by` varchar(64) DEFAULT '' COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '????',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '?????0?? 2???',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_position_code` (`workpiece_id`,`position_code`) USING BTREE,
  UNIQUE KEY `uk_ndt_position_id_workpiece` (`id`,`workpiece_id`) USING BTREE,
  KEY `idx_ndt_position_workpiece_sort` (`workpiece_id`,`sort_no`) USING BTREE,
  CONSTRAINT `fk_ndt_position_workpiece` FOREIGN KEY (`workpiece_id`) REFERENCES `ndt_workpiece` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT?????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndt_inspection_position`
--

LOCK TABLES `ndt_inspection_position` WRITE;
/*!40000 ALTER TABLE `ndt_inspection_position` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndt_inspection_position` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_inspection_study`
--

DROP TABLE IF EXISTS `ndt_inspection_study`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_inspection_study` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `workpiece_id` bigint NOT NULL,
  `study_instance_uid` varchar(128) NOT NULL,
  `inspection_method_code` varchar(32) DEFAULT NULL,
  `study_no` varchar(64) DEFAULT NULL,
  `study_description` varchar(255) DEFAULT NULL,
  `study_date` varchar(8) DEFAULT NULL,
  `study_time` varchar(16) DEFAULT NULL,
  `orthanc_study_id` varchar(100) DEFAULT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'ACTIVE',
  `create_by` varchar(64) DEFAULT '',
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(64) DEFAULT '',
  `update_time` datetime DEFAULT NULL,
  `del_flag` char(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_study_uid` (`study_instance_uid`) USING BTREE,
  UNIQUE KEY `uk_ndt_study_id_workpiece` (`id`,`workpiece_id`) USING BTREE,
  KEY `idx_ndt_study_workpiece` (`workpiece_id`,`create_time`) USING BTREE,
  KEY `idx_ndt_study_method` (`inspection_method_code`) USING BTREE,
  CONSTRAINT `fk_ndt_study_workpiece` FOREIGN KEY (`workpiece_id`) REFERENCES `ndt_workpiece` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT inspection Study';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ndt_inspection_study` WRITE;
/*!40000 ALTER TABLE `ndt_inspection_study` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndt_inspection_study` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_dicom_series`
--

DROP TABLE IF EXISTS `ndt_dicom_series`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_dicom_series` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `study_id` bigint NOT NULL,
  `workpiece_id` bigint NOT NULL,
  `position_id` bigint NOT NULL,
  `series_instance_uid` varchar(128) NOT NULL,
  `modality` varchar(32) DEFAULT NULL,
  `series_number` varchar(64) DEFAULT NULL,
  `series_description` varchar(255) DEFAULT NULL,
  `orthanc_series_id` varchar(100) DEFAULT NULL,
  `create_by` varchar(64) DEFAULT '',
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(64) DEFAULT '',
  `update_time` datetime DEFAULT NULL,
  `del_flag` char(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_series_uid` (`series_instance_uid`) USING BTREE,
  KEY `idx_ndt_series_study` (`study_id`,`create_time`) USING BTREE,
  KEY `idx_ndt_series_position` (`position_id`,`create_time`) USING BTREE,
  KEY `idx_ndt_series_study_workpiece` (`study_id`,`workpiece_id`) USING BTREE,
  KEY `idx_ndt_series_position_workpiece` (`position_id`,`workpiece_id`) USING BTREE,
  CONSTRAINT `fk_ndt_series_study_workpiece` FOREIGN KEY (`study_id`,`workpiece_id`) REFERENCES `ndt_inspection_study` (`id`,`workpiece_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ndt_series_position_workpiece` FOREIGN KEY (`position_id`,`workpiece_id`) REFERENCES `ndt_inspection_position` (`id`,`workpiece_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT DICOM Series';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ndt_dicom_series` WRITE;
/*!40000 ALTER TABLE `ndt_dicom_series` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndt_dicom_series` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_inspection_task`
--

DROP TABLE IF EXISTS `ndt_inspection_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_inspection_task` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??????',
  `customer_id` bigint NOT NULL COMMENT '??????',
  `task_name` varchar(200) NOT NULL COMMENT '????',
  `task_no` varchar(64) NOT NULL COMMENT '????',
  `status` varchar(32) NOT NULL DEFAULT 'DRAFT' COMMENT '????',
  `start_time` datetime DEFAULT NULL COMMENT '????',
  `finish_time` datetime DEFAULT NULL COMMENT '????',
  `description` text COMMENT '????',
  `create_by` varchar(64) DEFAULT '' COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '????',
  `update_by` varchar(64) DEFAULT '' COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '????',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '?????0?? 2???',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_task_no` (`task_no`) USING BTREE,
  KEY `idx_ndt_task_customer` (`customer_id`) USING BTREE,
  KEY `idx_ndt_task_status` (`status`) USING BTREE,
  KEY `idx_ndt_task_start_time` (`start_time`) USING BTREE,
  CONSTRAINT `fk_ndt_task_customer` FOREIGN KEY (`customer_id`) REFERENCES `ndt_customer` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT?????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndt_inspection_task`
--

LOCK TABLES `ndt_inspection_task` WRITE;
/*!40000 ALTER TABLE `ndt_inspection_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndt_inspection_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_inspector_profile`
--

DROP TABLE IF EXISTS `ndt_inspector_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_inspector_profile` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `inspector_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '检测人员编号',
  `certificate_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '证书编号',
  `certificate_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '证书名称',
  `qualification_level` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '资质等级',
  `issue_date` date DEFAULT NULL COMMENT '发证日期',
  `expire_date` date DEFAULT NULL COMMENT '有效期至',
  `certificate_file` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '证书附件地址',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_inspector_user` (`user_id`) USING BTREE,
  KEY `idx_ndt_inspector_no` (`inspector_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT检测人员扩展档案表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndt_inspector_profile`
--

LOCK TABLES `ndt_inspector_profile` WRITE;
/*!40000 ALTER TABLE `ndt_inspector_profile` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndt_inspector_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_task_report`
--

DROP TABLE IF EXISTS `ndt_task_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_task_report` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??????',
  `task_id` bigint NOT NULL COMMENT '????????',
  `report_name` varchar(255) NOT NULL COMMENT '????',
  `version` varchar(32) NOT NULL COMMENT '????',
  `file_path` varchar(500) DEFAULT NULL COMMENT '??????',
  `object_key` varchar(500) DEFAULT NULL COMMENT '????Key',
  `sha256` char(64) DEFAULT NULL COMMENT '????SHA-256??',
  `status` varchar(32) NOT NULL DEFAULT 'DRAFT' COMMENT '????',
  `generate_by` bigint DEFAULT NULL COMMENT '??????ID',
  `generate_time` datetime DEFAULT NULL COMMENT '????',
  `create_by` varchar(64) DEFAULT '' COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '????',
  `update_by` varchar(64) DEFAULT '' COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '????',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_report_version` (`task_id`,`version`) USING BTREE,
  KEY `idx_ndt_report_status` (`status`) USING BTREE,
  KEY `idx_ndt_report_generate_time` (`generate_time`) USING BTREE,
  CONSTRAINT `fk_ndt_report_task` FOREIGN KEY (`task_id`) REFERENCES `ndt_inspection_task` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT???PDF???';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndt_task_report`
--

LOCK TABLES `ndt_task_report` WRITE;
/*!40000 ALTER TABLE `ndt_task_report` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndt_task_report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_task_user`
--

DROP TABLE IF EXISTS `ndt_task_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_task_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `task_id` bigint NOT NULL COMMENT '任务ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `task_role` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务角色：CREATOR/UPLOADER/EVALUATOR/VIEWER',
  `can_evaluate` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '是否可评定',
  `can_upload` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '是否可上传',
  `can_view` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '1' COMMENT '是否可查看',
  `assigned_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '分配人',
  `assigned_time` datetime DEFAULT NULL COMMENT '分配时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ndt_task_user_role` (`task_id`,`user_id`,`task_role`) USING BTREE,
  KEY `idx_ndt_task_user_task` (`task_id`) USING BTREE,
  KEY `idx_ndt_task_user_user` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT检测任务用户分配表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndt_task_user`
--

LOCK TABLES `ndt_task_user` WRITE;
/*!40000 ALTER TABLE `ndt_task_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndt_task_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_uid_rule`
--

DROP TABLE IF EXISTS `ndt_uid_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_uid_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `rule_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '规则名称',
  `uid_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'UID类型',
  `root_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '根类型',
  `uid_root` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'UID根',
  `suffix_pattern` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '后缀模式',
  `enabled` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '1' COMMENT '是否启用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ndt_uid_rule_type` (`uid_type`,`enabled`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT UID规则配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndt_uid_rule`
--

LOCK TABLES `ndt_uid_rule` WRITE;
/*!40000 ALTER TABLE `ndt_uid_rule` DISABLE KEYS */;
INSERT INTO `ndt_uid_rule` VALUES (1,'默认2.25 Study UID','STUDY','UUID_2_25',NULL,NULL,'0','第一阶段默认Study UID规则','admin','2026-05-29 23:34:02','admin','2026-06-02 14:50:39','0'),(2,'默认2.25 Series UID','SERIES','CUSTOM_ROOT','123','study.124123123123.11111','1','第一阶段默认Series UID规则','admin','2026-05-29 23:34:02','admin','2026-06-02 15:07:28','0'),(3,'默认2.25 SOP UID','SOP_INSTANCE','UUID_2_25',NULL,NULL,'1','第一阶段默认SOPInstance UID规则','admin','2026-05-29 23:34:02','',NULL,'0'),(4,'test','STUDY','CUSTOM_ROOT','111.233.45.5','12123','1',NULL,'admin','2026-06-02 15:39:05','admin','2026-06-02 15:39:26','2'),(5,'test444','STUDY','CUSTOM_ROOT','111.222','33333.{random}','1',NULL,'admin','2026-06-02 15:40:00','admin','2026-06-02 15:40:00','0');
/*!40000 ALTER TABLE `ndt_uid_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ndt_workpiece`
--

DROP TABLE IF EXISTS `ndt_workpiece`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ndt_workpiece` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '????',
  `task_id` bigint NOT NULL COMMENT '????????',
  `workpiece_name` varchar(200) NOT NULL COMMENT '????',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '???',
  `status` varchar(32) NOT NULL DEFAULT 'PENDING' COMMENT '????',
  `remark` varchar(500) DEFAULT NULL COMMENT '??',
  `create_by` varchar(64) DEFAULT '' COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '????',
  `update_by` varchar(64) DEFAULT '' COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '????',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '?????0?? 2???',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ndt_workpiece_task` (`task_id`) USING BTREE,
  KEY `idx_ndt_workpiece_task_sort` (`task_id`,`sort_no`) USING BTREE,
  CONSTRAINT `fk_ndt_workpiece_task` FOREIGN KEY (`task_id`) REFERENCES `ndt_inspection_task` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='NDT???';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ndt_workpiece`
--

LOCK TABLES `ndt_workpiece` WRITE;
/*!40000 ALTER TABLE `ndt_workpiece` DISABLE KEYS */;
/*!40000 ALTER TABLE `ndt_workpiece` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_blob_triggers`
--

DROP TABLE IF EXISTS `qrtz_blob_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_blob_triggers` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='Blob类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_blob_triggers`
--

LOCK TABLES `qrtz_blob_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_blob_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_blob_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_calendars`
--

DROP TABLE IF EXISTS `qrtz_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_calendars` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`,`calendar_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='日历信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_calendars`
--

LOCK TABLES `qrtz_calendars` WRITE;
/*!40000 ALTER TABLE `qrtz_calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_cron_triggers`
--

DROP TABLE IF EXISTS `qrtz_cron_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_cron_triggers` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='Cron类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_cron_triggers`
--

LOCK TABLES `qrtz_cron_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_cron_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_cron_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_fired_triggers`
--

DROP TABLE IF EXISTS `qrtz_fired_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_fired_triggers` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`,`entry_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='已触发的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_fired_triggers`
--

LOCK TABLES `qrtz_fired_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_fired_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_fired_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_job_details`
--

DROP TABLE IF EXISTS `qrtz_job_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_job_details` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`job_name`,`job_group`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='任务详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_job_details`
--

LOCK TABLES `qrtz_job_details` WRITE;
/*!40000 ALTER TABLE `qrtz_job_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_job_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_locks`
--

DROP TABLE IF EXISTS `qrtz_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_locks` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`,`lock_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='存储的悲观锁信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_locks`
--

LOCK TABLES `qrtz_locks` WRITE;
/*!40000 ALTER TABLE `qrtz_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_paused_trigger_grps`
--

DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`,`trigger_group`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='暂停的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_paused_trigger_grps`
--

LOCK TABLES `qrtz_paused_trigger_grps` WRITE;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_scheduler_state`
--

DROP TABLE IF EXISTS `qrtz_scheduler_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_scheduler_state` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`,`instance_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='调度器状态表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_scheduler_state`
--

LOCK TABLES `qrtz_scheduler_state` WRITE;
/*!40000 ALTER TABLE `qrtz_scheduler_state` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_scheduler_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simple_triggers`
--

DROP TABLE IF EXISTS `qrtz_simple_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simple_triggers` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='简单触发器的信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simple_triggers`
--

LOCK TABLES `qrtz_simple_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simple_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simple_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simprop_triggers`
--

DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simprop_triggers` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='同步机制的行锁表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simprop_triggers`
--

LOCK TABLES `qrtz_simprop_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_triggers`
--

DROP TABLE IF EXISTS `qrtz_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_triggers` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  KEY `sched_name` (`sched_name`,`job_name`,`job_group`) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='触发器详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_triggers`
--

LOCK TABLES `qrtz_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2026-03-31 17:46:33','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2026-03-31 17:46:33','',NULL,'初始化密码 123456'),(3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y','admin','2026-03-31 17:46:33','',NULL,'深色主题theme-dark，浅色主题theme-light'),(4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2026-03-31 17:46:33','',NULL,'是否开启验证码功能（true开启，false关闭）'),(5,'账号自助-是否开启用户注册功能','sys.account.registerUser','false','Y','admin','2026-03-31 17:46:33','',NULL,'是否开启注册用户功能（true开启，false关闭）'),(6,'用户登录-黑名单列表','sys.login.blackIPList','','Y','admin','2026-03-31 17:46:33','',NULL,'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）'),(7,'用户管理-初始密码修改策略','sys.account.initPasswordModify','1','Y','admin','2026-03-31 17:46:33','',NULL,'0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框'),(8,'用户管理-账号密码更新周期','sys.account.passwordValidateDays','0','Y','admin','2026-03-31 17:46:33','',NULL,'密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '部门名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (100,0,'0','宁波中科检测',0,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-31 17:46:33','',NULL),(101,100,'0,100','宁波总公司',1,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-31 17:46:33','',NULL),(102,100,'0,100','杭州分公司',2,'若依','15888888888','ry@qq.com','0','2','admin','2026-03-31 17:46:33','',NULL),(103,101,'0,100,101','研发部门',1,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-31 17:46:33','',NULL),(104,101,'0,100,101','市场部门',2,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-31 17:46:33','',NULL),(105,101,'0,100,101','测试部门',3,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-31 17:46:33','',NULL),(106,101,'0,100,101','财务部门',4,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-31 17:46:33','',NULL),(107,101,'0,100,101','运维部门',5,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-31 17:46:33','',NULL),(108,102,'0,100,102','市场部门',1,'若依','15888888888','ry@qq.com','0','2','admin','2026-03-31 17:46:33','',NULL),(109,102,'0,100,102','财务部门',2,'若依','15888888888','ry@qq.com','0','2','admin','2026-03-31 17:46:33','',NULL),(200,101,'0,100,101','客户部门',6,'张三',NULL,NULL,'0','0','admin','2026-06-05 13:23:04','',NULL);
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (1,1,'男','0','sys_user_sex','','','Y','0','admin','2026-03-31 17:46:33','',NULL,'性别男'),(2,2,'女','1','sys_user_sex','','','N','0','admin','2026-03-31 17:46:33','',NULL,'性别女'),(3,3,'未知','2','sys_user_sex','','','N','0','admin','2026-03-31 17:46:33','',NULL,'性别未知'),(4,1,'显示','0','sys_show_hide','','primary','Y','0','admin','2026-03-31 17:46:33','',NULL,'显示菜单'),(5,2,'隐藏','1','sys_show_hide','','danger','N','0','admin','2026-03-31 17:46:33','',NULL,'隐藏菜单'),(6,1,'正常','0','sys_normal_disable','','primary','Y','0','admin','2026-03-31 17:46:33','',NULL,'正常状态'),(7,2,'停用','1','sys_normal_disable','','danger','N','0','admin','2026-03-31 17:46:33','',NULL,'停用状态'),(8,1,'正常','0','sys_job_status','','primary','Y','0','admin','2026-03-31 17:46:33','',NULL,'正常状态'),(9,2,'暂停','1','sys_job_status','','danger','N','0','admin','2026-03-31 17:46:33','',NULL,'停用状态'),(10,1,'默认','DEFAULT','sys_job_group','','','Y','0','admin','2026-03-31 17:46:33','',NULL,'默认分组'),(11,2,'系统','SYSTEM','sys_job_group','','','N','0','admin','2026-03-31 17:46:33','',NULL,'系统分组'),(12,1,'是','Y','sys_yes_no','','primary','Y','0','admin','2026-03-31 17:46:33','',NULL,'系统默认是'),(13,2,'否','N','sys_yes_no','','danger','N','0','admin','2026-03-31 17:46:33','',NULL,'系统默认否'),(14,1,'通知','1','sys_notice_type','','warning','Y','0','admin','2026-03-31 17:46:33','',NULL,'通知'),(15,2,'公告','2','sys_notice_type','','success','N','0','admin','2026-03-31 17:46:33','',NULL,'公告'),(16,1,'正常','0','sys_notice_status','','primary','Y','0','admin','2026-03-31 17:46:33','',NULL,'正常状态'),(17,2,'关闭','1','sys_notice_status','','danger','N','0','admin','2026-03-31 17:46:33','',NULL,'关闭状态'),(18,99,'其他','0','sys_oper_type','','info','N','0','admin','2026-03-31 17:46:33','',NULL,'其他操作'),(19,1,'新增','1','sys_oper_type','','info','N','0','admin','2026-03-31 17:46:33','',NULL,'新增操作'),(20,2,'修改','2','sys_oper_type','','info','N','0','admin','2026-03-31 17:46:33','',NULL,'修改操作'),(21,3,'删除','3','sys_oper_type','','danger','N','0','admin','2026-03-31 17:46:33','',NULL,'删除操作'),(22,4,'授权','4','sys_oper_type','','primary','N','0','admin','2026-03-31 17:46:33','',NULL,'授权操作'),(23,5,'导出','5','sys_oper_type','','warning','N','0','admin','2026-03-31 17:46:33','',NULL,'导出操作'),(24,6,'导入','6','sys_oper_type','','warning','N','0','admin','2026-03-31 17:46:33','',NULL,'导入操作'),(25,7,'强退','7','sys_oper_type','','danger','N','0','admin','2026-03-31 17:46:33','',NULL,'强退操作'),(26,8,'生成代码','8','sys_oper_type','','warning','N','0','admin','2026-03-31 17:46:33','',NULL,'生成操作'),(27,9,'清空数据','9','sys_oper_type','','danger','N','0','admin','2026-03-31 17:46:33','',NULL,'清空操作'),(28,1,'成功','0','sys_common_status','','primary','N','0','admin','2026-03-31 17:46:33','',NULL,'正常状态'),(29,2,'失败','1','sys_common_status','','danger','N','0','admin','2026-03-31 17:46:33','',NULL,'停用状态'),(111,1,'??','DRAFT','ndt_task_status',NULL,'info','Y','0','admin','2026-07-29 00:00:31','',NULL,NULL),(112,2,'???','IN_PROGRESS','ndt_task_status',NULL,'warning','N','0','admin','2026-07-29 00:00:31','',NULL,NULL),(113,3,'???','COMPLETED','ndt_task_status',NULL,'success','N','0','admin','2026-07-29 00:00:31','',NULL,NULL),(114,4,'???','CLOSED','ndt_task_status',NULL,'info','N','0','admin','2026-07-29 00:00:31','',NULL,NULL),(116,1,'创建者','CREATOR','ndt_task_role',NULL,'primary','N','0','admin','2026-05-29 23:34:02','',NULL,NULL),(117,2,'上传者','UPLOADER','ndt_task_role',NULL,'warning','N','0','admin','2026-05-29 23:34:02','',NULL,NULL),(118,3,'评定者','EVALUATOR','ndt_task_role',NULL,'success','N','0','admin','2026-05-29 23:34:02','',NULL,NULL),(119,4,'查看者','VIEWER','ndt_task_role',NULL,'info','Y','0','admin','2026-05-29 23:34:02','',NULL,NULL),(120,1,'未知','UNKNOWN','ndt_integrity_status',NULL,'info','Y','0','admin','2026-05-29 23:34:02','',NULL,NULL),(121,2,'通过','PASS','ndt_integrity_status',NULL,'success','N','0','admin','2026-05-29 23:34:02','',NULL,NULL),(122,3,'失败','FAIL','ndt_integrity_status',NULL,'danger','N','0','admin','2026-05-29 23:34:02','',NULL,NULL),(123,1,'Study','STUDY','ndt_uid_type',NULL,'primary','Y','0','admin','2026-05-29 23:34:02','',NULL,NULL),(124,2,'Series','SERIES','ndt_uid_type',NULL,'primary','N','0','admin','2026-05-29 23:34:02','',NULL,NULL),(125,3,'SOP Instance','SOP_INSTANCE','ndt_uid_type',NULL,'primary','N','0','admin','2026-05-29 23:34:02','',NULL,NULL),(126,1,'2.25.UUID','UUID_2_25','ndt_uid_root_type',NULL,'success','Y','0','admin','2026-05-29 23:34:02','',NULL,NULL),(127,2,'自定义Root','CUSTOM_ROOT','ndt_uid_root_type',NULL,'warning','N','0','admin','2026-05-29 23:34:02','',NULL,NULL),(128,1,'草稿','DRAFT','ndt_evaluation_status',NULL,'info','Y','0','admin','2026-05-29 23:34:02','',NULL,NULL),(129,2,'已提交','SUBMITTED','ndt_evaluation_status',NULL,'success','N','0','admin','2026-05-29 23:34:02','',NULL,NULL),(130,1,'???','PENDING','ndt_workpiece_status',NULL,'info','Y','0','admin','2026-07-29 00:00:31','',NULL,NULL),(131,2,'???','IN_PROGRESS','ndt_workpiece_status',NULL,'warning','N','0','admin','2026-07-29 00:00:31','',NULL,NULL),(132,3,'???','COMPLETED','ndt_workpiece_status',NULL,'success','N','0','admin','2026-07-29 00:00:31','',NULL,NULL),(133,1,'????','ORIGINAL_IMAGE','ndt_object_type',NULL,'primary','Y','0','admin','2026-07-29 00:00:31','',NULL,NULL),(134,2,'????','PROCESSED_IMAGE','ndt_object_type',NULL,'warning','N','0','admin','2026-07-29 00:00:31','',NULL,NULL),(135,3,'??','SCREENSHOT','ndt_object_type',NULL,'info','N','0','admin','2026-07-29 00:00:31','',NULL,NULL),(136,4,'????','ANNOTATION_IMAGE','ndt_object_type',NULL,'info','N','0','admin','2026-07-29 00:00:31','',NULL,NULL),(137,5,'????','PRESENTATION_STATE','ndt_object_type',NULL,'info','N','0','admin','2026-07-29 00:00:31','',NULL,NULL),(138,6,'?????','SR','ndt_object_type',NULL,'success','N','0','admin','2026-07-29 00:00:31','',NULL,NULL),(139,7,'??','OTHER','ndt_object_type',NULL,'info','N','0','admin','2026-07-29 00:00:31','',NULL,NULL),(140,1,'????','DEFECT','ndt_evaluation_type',NULL,'primary','Y','0','admin','2026-07-29 00:00:31','',NULL,NULL),(141,2,'????','WORKPIECE','ndt_evaluation_type',NULL,'primary','N','0','admin','2026-07-29 00:00:31','',NULL,NULL),(142,1,'??','DRAFT','ndt_report_status',NULL,'info','Y','0','admin','2026-07-29 00:00:31','',NULL,NULL),(143,2,'???','RELEASED','ndt_report_status',NULL,'success','N','0','admin','2026-07-29 00:00:31','',NULL,NULL),(144,1,'??','PASS','ndt_review_result',NULL,'success','Y','0','admin','2026-07-29 00:00:31','',NULL,NULL),(145,2,'??','REJECT','ndt_review_result',NULL,'danger','N','0','admin','2026-07-29 00:00:31','',NULL,NULL);
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE KEY `dict_type` (`dict_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'用户性别','sys_user_sex','0','admin','2026-03-31 17:46:33','',NULL,'用户性别列表'),(2,'菜单状态','sys_show_hide','0','admin','2026-03-31 17:46:33','',NULL,'菜单状态列表'),(3,'系统开关','sys_normal_disable','0','admin','2026-03-31 17:46:33','',NULL,'系统开关列表'),(4,'任务状态','sys_job_status','0','admin','2026-03-31 17:46:33','',NULL,'任务状态列表'),(5,'任务分组','sys_job_group','0','admin','2026-03-31 17:46:33','',NULL,'任务分组列表'),(6,'系统是否','sys_yes_no','0','admin','2026-03-31 17:46:33','',NULL,'系统是否列表'),(7,'通知类型','sys_notice_type','0','admin','2026-03-31 17:46:33','',NULL,'通知类型列表'),(8,'通知状态','sys_notice_status','0','admin','2026-03-31 17:46:33','',NULL,'通知状态列表'),(9,'操作类型','sys_oper_type','0','admin','2026-03-31 17:46:33','',NULL,'操作类型列表'),(10,'系统状态','sys_common_status','0','admin','2026-03-31 17:46:33','',NULL,'登录状态列表'),(104,'NDT????','ndt_task_status','0','admin','2026-05-29 23:34:02','admin','2026-07-29 00:00:31','???????'),(105,'NDT任务角色','ndt_task_role','0','admin','2026-05-29 23:34:02','',NULL,'NDT任务分配角色'),(106,'NDT完整性状态','ndt_integrity_status','0','admin','2026-05-29 23:34:02','',NULL,'NDT完整性校验状态'),(107,'NDT UID类型','ndt_uid_type','0','admin','2026-05-29 23:34:02','',NULL,'NDT UID类型'),(108,'NDT UID根类型','ndt_uid_root_type','0','admin','2026-05-29 23:34:02','',NULL,'NDT UID根类型'),(109,'NDT评定状态','ndt_evaluation_status','0','admin','2026-05-29 23:34:02','',NULL,'NDT评定状态'),(110,'NDT????','ndt_workpiece_status','0','admin','2026-07-29 00:00:31','',NULL,'???????'),(111,'NDT????','ndt_object_type','0','admin','2026-07-29 00:00:31','',NULL,'DICOM???????'),(112,'NDT????','ndt_evaluation_type','0','admin','2026-07-29 00:00:31','',NULL,'???????'),(113,'NDT????','ndt_report_status','0','admin','2026-07-29 00:00:31','',NULL,'??PDF????'),(114,'NDT????','ndt_review_result','0','admin','2026-07-29 00:00:31','',NULL,'??????');
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job`
--

DROP TABLE IF EXISTS `sys_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job` (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='定时任务调度表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job`
--

LOCK TABLES `sys_job` WRITE;
/*!40000 ALTER TABLE `sys_job` DISABLE KEYS */;
INSERT INTO `sys_job` VALUES (1,'系统默认（无参）','DEFAULT','ryTask.ryNoParams','0/10 * * * * ?','3','1','1','admin','2026-03-31 17:46:34','',NULL,''),(2,'系统默认（有参）','DEFAULT','ryTask.ryParams(\'ry\')','0/15 * * * * ?','3','1','1','admin','2026-03-31 17:46:34','',NULL,''),(3,'系统默认（多参）','DEFAULT','ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)','0/20 * * * * ?','3','1','1','admin','2026-03-31 17:46:34','',NULL,'');
/*!40000 ALTER TABLE `sys_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job_log`
--

DROP TABLE IF EXISTS `sys_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '异常信息',
  `start_time` datetime DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job_log`
--

LOCK TABLES `sys_job_log` WRITE;
/*!40000 ALTER TABLE `sys_job_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  KEY `idx_sys_logininfor_s` (`status`) USING BTREE,
  KEY `idx_sys_logininfor_lt` (`login_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2094 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,1,'system',NULL,'','',1,0,'M','0','0','','system','admin','2026-03-31 17:46:33','',NULL,'系统管理目录'),(2,'系统监控',0,2,'monitor',NULL,'','',1,0,'M','0','0','','monitor','admin','2026-03-31 17:46:33','',NULL,'系统监控目录'),(3,'系统工具',0,3,'tool',NULL,'','',1,0,'M','0','0','','tool','admin','2026-03-31 17:46:33','',NULL,'系统工具目录'),(4,'若依官网',0,4,'http://ruoyi.vip',NULL,'','',0,0,'M','0','1','','guide','admin','2026-03-31 17:46:33','admin','2026-06-02 16:27:09','若依官网地址'),(100,'用户管理',1,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2026-03-31 17:46:33','',NULL,'用户管理菜单'),(101,'角色管理',1,2,'role','system/role/index','','',1,0,'C','0','0','system:role:list','peoples','admin','2026-03-31 17:46:33','',NULL,'角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','','',1,0,'C','0','0','system:menu:list','tree-table','admin','2026-03-31 17:46:33','',NULL,'菜单管理菜单'),(103,'部门管理',1,4,'dept','system/dept/index','','',1,0,'C','0','0','system:dept:list','tree','admin','2026-03-31 17:46:33','',NULL,'部门管理菜单'),(104,'岗位管理',1,5,'post','system/post/index','','',1,0,'C','0','0','system:post:list','post','admin','2026-03-31 17:46:33','',NULL,'岗位管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','','',1,0,'C','0','0','system:dict:list','dict','admin','2026-03-31 17:46:33','',NULL,'字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','','',1,0,'C','0','0','system:config:list','edit','admin','2026-03-31 17:46:33','',NULL,'参数设置菜单'),(107,'通知公告',1,8,'notice','system/notice/index','','',1,0,'C','0','0','system:notice:list','message','admin','2026-03-31 17:46:33','',NULL,'通知公告菜单'),(108,'日志管理',1,9,'log','','','',1,0,'M','0','0','','log','admin','2026-03-31 17:46:33','',NULL,'日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','','',1,0,'C','0','0','monitor:online:list','online','admin','2026-03-31 17:46:33','',NULL,'在线用户菜单'),(110,'定时任务',2,2,'job','monitor/job/index','','',1,0,'C','0','0','monitor:job:list','job','admin','2026-03-31 17:46:33','',NULL,'定时任务菜单'),(111,'数据监控',2,3,'druid','monitor/druid/index','','',1,0,'C','0','0','monitor:druid:list','druid','admin','2026-03-31 17:46:33','',NULL,'数据监控菜单'),(112,'服务监控',2,4,'server','monitor/server/index','','',1,0,'C','0','0','monitor:server:list','server','admin','2026-03-31 17:46:33','',NULL,'服务监控菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','','',1,0,'C','0','0','monitor:cache:list','redis','admin','2026-03-31 17:46:33','',NULL,'缓存监控菜单'),(114,'缓存列表',2,6,'cacheList','monitor/cache/list','','',1,0,'C','0','0','monitor:cache:list','redis-list','admin','2026-03-31 17:46:33','',NULL,'缓存列表菜单'),(115,'表单构建',3,1,'build','tool/build/index','','',1,0,'C','0','0','tool:build:list','build','admin','2026-03-31 17:46:33','',NULL,'表单构建菜单'),(116,'代码生成',3,2,'gen','tool/gen/index','','',1,0,'C','0','0','tool:gen:list','code','admin','2026-03-31 17:46:33','',NULL,'代码生成菜单'),(117,'系统接口',3,3,'swagger','tool/swagger/index','','',1,0,'C','0','0','tool:swagger:list','swagger','admin','2026-03-31 17:46:33','',NULL,'系统接口菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2026-03-31 17:46:33','',NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2026-03-31 17:46:33','',NULL,'登录日志菜单'),(1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2026-03-31 17:46:33','',NULL,''),(1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2026-03-31 17:46:33','',NULL,''),(1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2026-03-31 17:46:33','',NULL,''),(1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2026-03-31 17:46:33','',NULL,''),(1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2026-03-31 17:46:33','',NULL,''),(1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2026-03-31 17:46:33','',NULL,''),(1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2026-03-31 17:46:33','',NULL,''),(1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2026-03-31 17:46:33','',NULL,''),(1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2026-03-31 17:46:33','',NULL,''),(1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2026-03-31 17:46:33','',NULL,''),(1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2026-03-31 17:46:33','',NULL,''),(1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2026-03-31 17:46:33','',NULL,''),(1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2026-03-31 17:46:33','',NULL,''),(1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2026-03-31 17:46:33','',NULL,''),(1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2026-03-31 17:46:33','',NULL,''),(1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2026-03-31 17:46:33','',NULL,''),(1016,'部门查询',103,1,'','','','',1,0,'F','0','0','system:dept:query','#','admin','2026-03-31 17:46:33','',NULL,''),(1017,'部门新增',103,2,'','','','',1,0,'F','0','0','system:dept:add','#','admin','2026-03-31 17:46:33','',NULL,''),(1018,'部门修改',103,3,'','','','',1,0,'F','0','0','system:dept:edit','#','admin','2026-03-31 17:46:33','',NULL,''),(1019,'部门删除',103,4,'','','','',1,0,'F','0','0','system:dept:remove','#','admin','2026-03-31 17:46:33','',NULL,''),(1020,'岗位查询',104,1,'','','','',1,0,'F','0','0','system:post:query','#','admin','2026-03-31 17:46:33','',NULL,''),(1021,'岗位新增',104,2,'','','','',1,0,'F','0','0','system:post:add','#','admin','2026-03-31 17:46:33','',NULL,''),(1022,'岗位修改',104,3,'','','','',1,0,'F','0','0','system:post:edit','#','admin','2026-03-31 17:46:33','',NULL,''),(1023,'岗位删除',104,4,'','','','',1,0,'F','0','0','system:post:remove','#','admin','2026-03-31 17:46:33','',NULL,''),(1024,'岗位导出',104,5,'','','','',1,0,'F','0','0','system:post:export','#','admin','2026-03-31 17:46:33','',NULL,''),(1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2026-03-31 17:46:33','',NULL,''),(1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2026-03-31 17:46:33','',NULL,''),(1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2026-03-31 17:46:33','',NULL,''),(1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2026-03-31 17:46:33','',NULL,''),(1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2026-03-31 17:46:33','',NULL,''),(1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2026-03-31 17:46:33','',NULL,''),(1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2026-03-31 17:46:33','',NULL,''),(1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2026-03-31 17:46:33','',NULL,''),(1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2026-03-31 17:46:33','',NULL,''),(1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2026-03-31 17:46:33','',NULL,''),(1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2026-03-31 17:46:33','',NULL,''),(1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2026-03-31 17:46:33','',NULL,''),(1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2026-03-31 17:46:33','',NULL,''),(1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2026-03-31 17:46:33','',NULL,''),(1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2026-03-31 17:46:33','',NULL,''),(1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2026-03-31 17:46:33','',NULL,''),(1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2026-03-31 17:46:33','',NULL,''),(1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2026-03-31 17:46:33','',NULL,''),(1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2026-03-31 17:46:33','',NULL,''),(1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2026-03-31 17:46:33','',NULL,''),(1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2026-03-31 17:46:33','',NULL,''),(1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2026-03-31 17:46:33','',NULL,''),(1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2026-03-31 17:46:33','',NULL,''),(1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2026-03-31 17:46:33','',NULL,''),(1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2026-03-31 17:46:33','',NULL,''),(1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2026-03-31 17:46:33','',NULL,''),(1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2026-03-31 17:46:33','',NULL,''),(1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2026-03-31 17:46:33','',NULL,''),(1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2026-03-31 17:46:33','',NULL,''),(1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2026-03-31 17:46:33','',NULL,''),(1055,'生成查询',116,1,'#','','','',1,0,'F','0','0','tool:gen:query','#','admin','2026-03-31 17:46:33','',NULL,''),(1056,'生成修改',116,2,'#','','','',1,0,'F','0','0','tool:gen:edit','#','admin','2026-03-31 17:46:33','',NULL,''),(1057,'生成删除',116,3,'#','','','',1,0,'F','0','0','tool:gen:remove','#','admin','2026-03-31 17:46:33','',NULL,''),(1058,'导入代码',116,4,'#','','','',1,0,'F','0','0','tool:gen:import','#','admin','2026-03-31 17:46:33','',NULL,''),(1059,'预览代码',116,5,'#','','','',1,0,'F','0','0','tool:gen:preview','#','admin','2026-03-31 17:46:33','',NULL,''),(1060,'生成代码',116,6,'#','','','',1,0,'F','0','0','tool:gen:code','#','admin','2026-03-31 17:46:33','',NULL,''),(2013,'无损检测管理',0,5,'ndt',NULL,'','',1,0,'M','0','0','','monitor','admin','2026-05-29 23:34:02','',NULL,'NDT DICOM业务管理目录'),(2014,'检测任务管理',2013,1,'task','ndt/task/index','','',1,0,'C','0','0','ndt:task:list','list','admin','2026-05-29 23:34:02','',NULL,'NDT检测任务管理'),(2015,'DCM文件管理',2013,2,'dicom','ndt/dicom/index','','',1,0,'C','0','0','ndt:dicom:list','upload','admin','2026-05-29 23:34:02','admin','2026-06-02 16:28:26','NDT DICOM文件管理'),(2016,'检测人员档案',2013,3,'inspector','ndt/inspector/index','','',1,0,'C','0','0','ndt:inspector:list','peoples','admin','2026-05-29 23:34:02','',NULL,'NDT检测人员档案'),(2017,'UID规则配置',2013,5,'uidRule','ndt/uidRule/index','','',1,0,'C','0','0','ndt:uidRule:list','system','admin','2026-05-29 23:34:02','',NULL,'NDT UID规则配置'),(2018,'DCM完整性校验',2013,7,'integrity','ndt/integrity/index','','',1,0,'C','0','0','ndt:integrity:list','validCode','admin','2026-05-29 23:34:02','admin','2026-06-02 16:27:46','NDT DICOM完整性校验'),(2019,'评定结果管理',2013,8,'evaluation','ndt/evaluation/index','','',1,0,'C','0','0','ndt:evaluation:list','form','admin','2026-05-29 23:34:02','',NULL,'NDT评定结果管理'),(2020,'任务查询',2014,1,'','','','',1,0,'F','0','0','ndt:task:query','#','admin','2026-05-29 23:34:02','',NULL,''),(2021,'任务新增',2014,2,'','','','',1,0,'F','0','0','ndt:task:add','#','admin','2026-05-29 23:34:02','',NULL,''),(2022,'任务修改',2014,3,'','','','',1,0,'F','0','0','ndt:task:edit','#','admin','2026-05-29 23:34:02','',NULL,''),(2023,'任务删除',2014,4,'','','','',1,0,'F','0','0','ndt:task:remove','#','admin','2026-05-29 23:34:02','',NULL,''),(2024,'任务分配',2014,5,'','','','',1,0,'F','0','0','ndt:task:assign','#','admin','2026-05-29 23:34:02','',NULL,''),(2025,'OHIF查看',2014,6,'','','','',1,0,'F','0','0','ndt:task:ohif','#','admin','2026-05-29 23:34:02','',NULL,''),(2026,'DICOM上传',2015,1,'','','','',1,0,'F','0','0','ndt:dicom:upload','#','admin','2026-05-29 23:34:02','',NULL,''),(2027,'DICOM下载',2015,2,'','','','',1,0,'F','0','0','ndt:dicom:download','#','admin','2026-05-29 23:34:02','',NULL,''),(2028,'档案新增',2016,1,'','','','',1,0,'F','0','0','ndt:inspector:add','#','admin','2026-05-29 23:34:02','',NULL,''),(2029,'档案修改',2016,2,'','','','',1,0,'F','0','0','ndt:inspector:edit','#','admin','2026-05-29 23:34:02','',NULL,''),(2030,'档案删除',2016,3,'','','','',1,0,'F','0','0','ndt:inspector:remove','#','admin','2026-05-29 23:34:02','',NULL,''),(2031,'UID新增',2017,1,'','','','',1,0,'F','0','0','ndt:uidRule:add','#','admin','2026-05-29 23:34:02','',NULL,''),(2032,'UID查询',2017,0,'','','','',1,0,'F','0','0','ndt:uidRule:query','#','admin','2026-05-29 23:34:02','',NULL,''),(2033,'UID修改',2017,2,'','','','',1,0,'F','0','0','ndt:uidRule:edit','#','admin','2026-05-29 23:34:02','',NULL,''),(2034,'UID删除',2017,3,'','','','',1,0,'F','0','0','ndt:uidRule:remove','#','admin','2026-05-29 23:34:02','',NULL,''),(2035,'UID生成',2017,4,'','','','',1,0,'F','0','0','ndt:uidRule:generate','#','admin','2026-05-29 23:34:02','',NULL,''),(2036,'完整性重检',2018,1,'','','','',1,0,'F','0','0','ndt:integrity:verify','#','admin','2026-05-29 23:34:02','',NULL,''),(2037,'评定查询',2019,1,'','','','',1,0,'F','0','0','ndt:evaluation:query','#','admin','2026-05-29 23:34:02','',NULL,''),(2038,'评定新增',2019,2,'','','','',1,0,'F','0','0','ndt:evaluation:add','#','admin','2026-05-29 23:34:02','',NULL,''),(2039,'评定修改',2019,3,'','','','',1,0,'F','0','0','ndt:evaluation:edit','#','admin','2026-05-29 23:34:02','',NULL,''),(2040,'评定删除',2019,4,'','','','',1,0,'F','0','0','ndt:evaluation:remove','#','admin','2026-05-29 23:34:02','',NULL,''),(2041,'OHIF入口配置',2013,9,'ohif','ndt/ohif/index','','',1,0,'C','0','0','ndt:ohif:list','link','admin','2026-06-02 18:05:10','',NULL,'NDT OHIF入口配置'),(2042,'Orthanc归档管理',2013,10,'orthanc','ndt/orthanc/index','','',1,0,'C','0','0','ndt:orthanc:list','tree','admin','2026-06-02 18:05:18','',NULL,'NDT Orthanc归档管理'),(2043,'报告管理',2013,11,'report','ndt/report/index','','',1,0,'C','0','0','ndt:report:list','document','admin','2026-06-02 18:05:23','',NULL,'NDT报告管理'),(2044,'DICOM标签查看',2015,1,'','','','',1,0,'F','0','0','ndt:dicom:tag:list','#','admin','2026-06-02 18:06:12','',NULL,'查看DICOM标签'),(2045,'DICOM标签新增',2015,2,'','','','',1,0,'F','0','0','ndt:dicom:tag:add','#','admin','2026-06-02 18:06:18','',NULL,'新增DICOM标签'),(2046,'DICOM标签修改',2015,3,'','','','',1,0,'F','0','0','ndt:dicom:tag:edit','#','admin','2026-06-02 18:06:27','',NULL,'修改DICOM标签'),(2047,'DICOM标签删除',2015,4,'','','','',1,0,'F','0','0','ndt:dicom:tag:remove','#','admin','2026-06-02 18:06:35','',NULL,'删除DICOM标签'),(2048,'Orthanc树查看',2042,1,'','','','',1,0,'F','0','0','ndt:orthanc:list','#','admin','2026-06-02 18:06:45','',NULL,'查看Orthanc树形结构'),(2049,'Orthanc标签查看',2042,2,'','','','',1,0,'F','0','0','ndt:orthanc:query','#','admin','2026-06-02 18:06:57','',NULL,'查看Orthanc实例标签'),(2050,'Orthanc标签修改',2042,3,'','','','',1,0,'F','0','0','ndt:orthanc:edit','#','admin','2026-06-02 18:07:04','',NULL,'修改Orthanc实例标签'),(2051,'OHIF配置查看',2041,1,'','','','',1,0,'F','0','0','ndt:ohif:list','#','admin','2026-06-02 18:07:11','',NULL,'查看OHIF配置'),(2052,'报告查询',2043,1,'','','','',1,0,'F','0','0','ndt:report:list','#','admin','2026-06-02 18:07:27','',NULL,'查看报告列表'),(2053,'DCM标签管理',2013,6,'dicomPrivateTag','ndt/dicomPrivateTag/index','','',1,0,'C','0','0','ndt:dicomPrivateTag:list','edit','admin','2026-06-04 17:50:16','',NULL,'NDT允许编辑的DICOM标签配置'),(2054,'私有标签查询',2053,1,'','','','',1,0,'F','0','0','ndt:dicomPrivateTag:query','#','admin','2026-06-04 17:50:23','',NULL,''),(2055,'私有标签新增',2053,2,'','','','',1,0,'F','0','0','ndt:dicomPrivateTag:add','#','admin','2026-06-04 17:50:29','',NULL,''),(2056,'私有标签修改',2053,3,'','','','',1,0,'F','0','0','ndt:dicomPrivateTag:edit','#','admin','2026-06-04 17:50:37','',NULL,''),(2057,'私有标签删除',2053,4,'','','','',1,0,'F','0','0','ndt:dicomPrivateTag:remove','#','admin','2026-06-04 17:50:43','',NULL,''),(2058,'????',2013,4,'customer','ndt/company/index','','',1,0,'C','0','0','ndt:customer:list','people','admin','2026-06-05 14:08:10','admin','2026-07-29 00:00:31','NDT客户信息静态展示菜单'),(2059,'自定义校验规则',2013,12,'validationRule','ndt/validationRule/index','','',1,0,'C','0','0','ndt:validationRule:list','validCode','admin','2026-06-13 23:54:32','',NULL,'DICOM上传自定义校验规则'),(2060,'规则查询',2059,1,'','','','',1,0,'F','0','0','ndt:validationRule:query','#','admin','2026-06-13 23:54:32','',NULL,''),(2061,'规则新增',2059,2,'','','','',1,0,'F','0','0','ndt:validationRule:add','#','admin','2026-06-13 23:54:32','',NULL,''),(2062,'规则修改',2059,3,'','','','',1,0,'F','0','0','ndt:validationRule:edit','#','admin','2026-06-13 23:54:32','',NULL,''),(2063,'规则删除',2059,4,'','','','',1,0,'F','0','0','ndt:validationRule:remove','#','admin','2026-06-13 23:54:32','',NULL,''),(2064,'规则导出',2059,5,'','','','',1,0,'F','0','0','ndt:validationRule:export','#','admin','2026-06-13 23:54:32','',NULL,''),(2065,'????',2058,1,'','',NULL,'',1,0,'F','0','0','ndt:customer:query','#','admin','2026-07-29 00:00:31','',NULL,''),(2066,'????',2058,2,'','',NULL,'',1,0,'F','0','0','ndt:customer:add','#','admin','2026-07-29 00:00:31','',NULL,''),(2067,'????',2058,3,'','',NULL,'',1,0,'F','0','0','ndt:customer:edit','#','admin','2026-07-29 00:00:31','',NULL,''),(2068,'????',2058,4,'','',NULL,'',1,0,'F','0','0','ndt:customer:remove','#','admin','2026-07-29 00:00:31','',NULL,''),(2069,'????',2014,10,'','',NULL,'',1,0,'F','0','0','ndt:workpiece:list','#','admin','2026-07-29 00:00:31','',NULL,''),(2070,'????',2014,11,'','',NULL,'',1,0,'F','0','0','ndt:workpiece:query','#','admin','2026-07-29 00:00:31','',NULL,''),(2071,'????',2014,12,'','',NULL,'',1,0,'F','0','0','ndt:workpiece:add','#','admin','2026-07-29 00:00:31','',NULL,''),(2072,'????',2014,13,'','',NULL,'',1,0,'F','0','0','ndt:workpiece:edit','#','admin','2026-07-29 00:00:31','',NULL,''),(2073,'????',2014,14,'','',NULL,'',1,0,'F','0','0','ndt:workpiece:remove','#','admin','2026-07-29 00:00:31','',NULL,''),(2074,'????',2014,15,'','',NULL,'',1,0,'F','0','0','ndt:position:list','#','admin','2026-07-29 00:00:31','',NULL,''),(2075,'????',2014,16,'','',NULL,'',1,0,'F','0','0','ndt:position:query','#','admin','2026-07-29 00:00:31','',NULL,''),(2076,'????',2014,17,'','',NULL,'',1,0,'F','0','0','ndt:position:add','#','admin','2026-07-29 00:00:31','',NULL,''),(2077,'????',2014,18,'','',NULL,'',1,0,'F','0','0','ndt:position:edit','#','admin','2026-07-29 00:00:31','',NULL,''),(2078,'????',2014,19,'','',NULL,'',1,0,'F','0','0','ndt:position:remove','#','admin','2026-07-29 00:00:31','',NULL,''),(2079,'????',2015,10,'','',NULL,'',1,0,'F','0','0','ndt:dicom:query','#','admin','2026-07-29 00:00:31','',NULL,''),(2080,'????',2015,11,'','',NULL,'',1,0,'F','0','0','ndt:dicom:remove','#','admin','2026-07-29 00:00:31','',NULL,''),(2081,'????',2019,10,'','',NULL,'',1,0,'F','0','0','ndt:defect:list','#','admin','2026-07-29 00:00:31','',NULL,''),(2082,'????',2019,11,'','',NULL,'',1,0,'F','0','0','ndt:defect:query','#','admin','2026-07-29 00:00:31','',NULL,''),(2083,'????',2019,12,'','',NULL,'',1,0,'F','0','0','ndt:defect:add','#','admin','2026-07-29 00:00:31','',NULL,''),(2084,'????',2019,13,'','',NULL,'',1,0,'F','0','0','ndt:defect:edit','#','admin','2026-07-29 00:00:31','',NULL,''),(2085,'????',2019,14,'','',NULL,'',1,0,'F','0','0','ndt:defect:remove','#','admin','2026-07-29 00:00:31','',NULL,''),(2086,'????',2019,15,'','',NULL,'',1,0,'F','0','0','ndt:evaluation:submit','#','admin','2026-07-29 00:00:31','',NULL,''),(2087,'????',2019,16,'','',NULL,'',1,0,'F','0','0','ndt:review:list','#','admin','2026-07-29 00:00:31','',NULL,''),(2088,'????',2019,17,'','',NULL,'',1,0,'F','0','0','ndt:review:add','#','admin','2026-07-29 00:00:31','',NULL,''),(2089,'????',2043,2,'','',NULL,'',1,0,'F','0','0','ndt:report:query','#','admin','2026-07-29 00:00:31','',NULL,''),(2090,'????',2043,3,'','',NULL,'',1,0,'F','0','0','ndt:report:add','#','admin','2026-07-29 00:00:31','',NULL,''),(2091,'????',2043,4,'','',NULL,'',1,0,'F','0','0','ndt:report:download','#','admin','2026-07-29 00:00:31','',NULL,''),(2092,'????',2043,5,'','',NULL,'',1,0,'F','0','0','ndt:report:edit','#','admin','2026-07-29 00:00:31','',NULL,''),(2093,'????',2043,6,'','',NULL,'',1,0,'F','0','0','ndt:report:remove','#','admin','2026-07-29 00:00:31','',NULL,'');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (1,'温馨提醒：2018-07-01 若依新版本发布啦','2',_binary '新版本内容','0','admin','2026-03-31 17:46:34','',NULL,'管理员'),(2,'维护通知：2018-07-01 若依系统凌晨维护','1',_binary '维护内容','0','admin','2026-03-31 17:46:34','',NULL,'管理员'),(3,'若依开源框架介绍','1',_binary '<p><span style=\"color: rgb(230, 0, 0);\">项目介绍</span></p><p><font color=\"#333333\">RuoYi开源项目是为企业用户定制的后台脚手架框架，为企业打造的一站式解决方案，降低企业开发成本，提升开发效率。主要包括用户管理、角色管理、部门管理、菜单管理、参数管理、字典管理、</font><span style=\"color: rgb(51, 51, 51);\">岗位管理</span><span style=\"color: rgb(51, 51, 51);\">、定时任务</span><span style=\"color: rgb(51, 51, 51);\">、</span><span style=\"color: rgb(51, 51, 51);\">服务监控、登录日志、操作日志、代码生成等功能。其中，还支持多数据源、数据权限、国际化、Redis缓存、Docker部署、滑动验证码、第三方认证登录、分布式事务、</span><font color=\"#333333\">分布式文件存储</font><span style=\"color: rgb(51, 51, 51);\">、分库分表处理等技术特点。</span></p><p><img src=\"https://foruda.gitee.com/images/1773931848342439032/a4d22313_1815095.png\" style=\"width: 64px;\"><br></p><p><span style=\"color: rgb(230, 0, 0);\">官网及演示</span></p><p><span style=\"color: rgb(51, 51, 51);\">若依官网地址：&nbsp;</span><a href=\"http://ruoyi.vip\" target=\"_blank\">http://ruoyi.vip</a><a href=\"http://ruoyi.vip\" target=\"_blank\"></a></p><p><span style=\"color: rgb(51, 51, 51);\">若依文档地址：&nbsp;</span><a href=\"http://doc.ruoyi.vip\" target=\"_blank\">http://doc.ruoyi.vip</a><br></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【不分离版】：&nbsp;</span><a href=\"http://demo.ruoyi.vip\" target=\"_blank\">http://demo.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【分离版本】：&nbsp;</span><a href=\"http://vue.ruoyi.vip\" target=\"_blank\">http://vue.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【微服务版】：&nbsp;</span><a href=\"http://cloud.ruoyi.vip\" target=\"_blank\">http://cloud.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【移动端版】：&nbsp;</span><a href=\"http://h5.ruoyi.vip\" target=\"_blank\">http://h5.ruoyi.vip</a></p><p><br style=\"color: rgb(48, 49, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px;\"></p>','0','admin','2026-03-31 17:46:34','',NULL,'管理员');
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice_read`
--

DROP TABLE IF EXISTS `sys_notice_read`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice_read` (
  `read_id` bigint NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int NOT NULL COMMENT '公告id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `read_time` datetime NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`) USING BTREE,
  UNIQUE KEY `uk_user_notice` (`user_id`,`notice_id`) USING BTREE COMMENT '同一用户同一公告只记录一次'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='公告已读记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice_read`
--

LOCK TABLES `sys_notice_read` WRITE;
/*!40000 ALTER TABLE `sys_notice_read` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_notice_read` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  KEY `idx_sys_oper_log_bt` (`business_type`) USING BTREE,
  KEY `idx_sys_oper_log_s` (`status`) USING BTREE,
  KEY `idx_sys_oper_log_ot` (`oper_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_post`
--

DROP TABLE IF EXISTS `sys_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_post` (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='岗位信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_post`
--

LOCK TABLES `sys_post` WRITE;
/*!40000 ALTER TABLE `sys_post` DISABLE KEYS */;
INSERT INTO `sys_post` VALUES (1,'ceo','董事长',1,'0','admin','2026-03-31 17:46:33','',NULL,''),(2,'se','项目经理',2,'0','admin','2026-03-31 17:46:33','',NULL,''),(3,'hr','人力资源',3,'0','admin','2026-03-31 17:46:33','',NULL,''),(4,'user','普通员工',4,'0','admin','2026-03-31 17:46:33','',NULL,'');
/*!40000 ALTER TABLE `sys_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','admin',1,'1',1,1,'0','0','admin','2026-03-31 17:46:33','',NULL,'超级管理员'),(2,'普通角色','common',2,'2',1,1,'0','0','admin','2026-03-31 17:46:33','',NULL,'普通角色'),(100,'测试角色','test',3,'1',1,1,'0','0','admin','2026-05-24 18:55:07','',NULL,NULL),(101,'公司管理员','ndt_company_admin',10,'1',1,1,'0','0','admin','2026-05-29 23:34:02','',NULL,'NDT公司管理员'),(102,'检测人员','ndt_inspector',11,'2',1,1,'0','0','admin','2026-05-29 23:34:02','',NULL,'NDT检测人员'),(103,'客户用户','ndt_customer',12,'2',1,1,'0','0','admin','2026-05-29 23:34:02','',NULL,'NDT客户只读用户');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_dept`
--

DROP TABLE IF EXISTS `sys_role_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='角色和部门关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_dept`
--

LOCK TABLES `sys_role_dept` WRITE;
/*!40000 ALTER TABLE `sys_role_dept` DISABLE KEYS */;
INSERT INTO `sys_role_dept` VALUES (2,100),(2,101),(2,105);
/*!40000 ALTER TABLE `sys_role_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (2,1),(2,2),(2,3),(2,4),(2,100),(2,101),(2,102),(2,103),(2,104),(2,105),(2,106),(2,107),(2,108),(2,109),(2,110),(2,111),(2,112),(2,113),(2,114),(2,115),(2,116),(2,117),(2,500),(2,501),(2,1000),(2,1001),(2,1002),(2,1003),(2,1004),(2,1005),(2,1006),(2,1007),(2,1008),(2,1009),(2,1010),(2,1011),(2,1012),(2,1013),(2,1014),(2,1015),(2,1016),(2,1017),(2,1018),(2,1019),(2,1020),(2,1021),(2,1022),(2,1023),(2,1024),(2,1025),(2,1026),(2,1027),(2,1028),(2,1029),(2,1030),(2,1031),(2,1032),(2,1033),(2,1034),(2,1035),(2,1036),(2,1037),(2,1038),(2,1039),(2,1040),(2,1041),(2,1042),(2,1043),(2,1044),(2,1045),(2,1046),(2,1047),(2,1048),(2,1049),(2,1050),(2,1051),(2,1052),(2,1053),(2,1054),(2,1055),(2,1056),(2,1057),(2,1058),(2,1059),(2,1060),(100,1),(100,2),(100,3),(100,4),(100,100),(100,101),(100,102),(100,103),(100,104),(100,105),(100,106),(100,107),(100,108),(100,109),(100,110),(100,111),(100,112),(100,113),(100,114),(100,115),(100,116),(100,117),(100,500),(100,501),(100,1000),(100,1001),(100,1002),(100,1003),(100,1004),(100,1005),(100,1006),(100,1007),(100,1008),(100,1009),(100,1010),(100,1011),(100,1012),(100,1013),(100,1014),(100,1015),(100,1016),(100,1017),(100,1018),(100,1019),(100,1020),(100,1021),(100,1022),(100,1023),(100,1024),(100,1025),(100,1026),(100,1027),(100,1028),(100,1029),(100,1030),(100,1031),(100,1032),(100,1033),(100,1034),(100,1035),(100,1036),(100,1037),(100,1038),(100,1039),(100,1040),(100,1041),(100,1042),(100,1043),(100,1044),(100,1045),(100,1046),(100,1047),(100,1048),(100,1049),(100,1050),(100,1051),(100,1052),(100,1053),(100,1054),(100,1055),(100,1056),(100,1057),(100,1058),(100,1059),(100,1060),(101,2013),(101,2014),(101,2015),(101,2016),(101,2017),(101,2018),(101,2019),(101,2020),(101,2021),(101,2022),(101,2023),(101,2024),(101,2025),(101,2026),(101,2027),(101,2028),(101,2029),(101,2030),(101,2031),(101,2032),(101,2033),(101,2034),(101,2035),(101,2036),(101,2037),(101,2038),(101,2039),(101,2040),(101,2041),(101,2042),(101,2043),(101,2044),(101,2045),(101,2046),(101,2047),(101,2048),(101,2049),(101,2050),(101,2051),(101,2052),(101,2053),(101,2054),(101,2055),(101,2056),(101,2057),(101,2058),(101,2059),(101,2060),(101,2061),(101,2062),(101,2063),(101,2064),(101,2065),(101,2066),(101,2067),(101,2068),(101,2069),(101,2070),(101,2071),(101,2072),(101,2073),(101,2074),(101,2075),(101,2076),(101,2077),(101,2078),(101,2079),(101,2080),(101,2081),(101,2082),(101,2083),(101,2084),(101,2085),(101,2086),(101,2087),(101,2088),(101,2089),(101,2090),(101,2091),(101,2092),(101,2093),(102,2013),(102,2014),(102,2015),(102,2018),(102,2019),(102,2020),(102,2025),(102,2026),(102,2027),(102,2036),(102,2037),(102,2038),(102,2039),(102,2041),(102,2042),(102,2043),(102,2044),(102,2045),(102,2046),(102,2048),(102,2049),(102,2051),(102,2052),(102,2069),(102,2070),(102,2071),(102,2072),(102,2073),(102,2074),(102,2075),(102,2076),(102,2077),(102,2078),(102,2079),(102,2081),(102,2082),(102,2083),(102,2084),(102,2085),(102,2086),(102,2087),(102,2088),(102,2089),(102,2090),(102,2091),(103,2013),(103,2014),(103,2015),(103,2018),(103,2019),(103,2020),(103,2025),(103,2027),(103,2037),(103,2041),(103,2042),(103,2043),(103,2044),(103,2048),(103,2049),(103,2051),(103,2052),(103,2069),(103,2070),(103,2074),(103,2075),(103,2079),(103,2081),(103,2082),(103,2087),(103,2089),(103,2091);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,103,'admin','若依','00','ry@163.com','15888888888','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','172.17.0.1','2026-07-28 23:55:53','2026-03-31 17:46:33','admin','2026-03-31 17:46:33','',NULL,'管理员'),(2,105,'ry','若依','00','ry@qq.com','15666666666','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-03-31 17:46:33','2026-03-31 17:46:33','admin','2026-03-31 17:46:33','','2026-03-31 18:21:54','测试员');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_post`
--

DROP TABLE IF EXISTS `sys_user_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_post` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户与岗位关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_post`
--

LOCK TABLES `sys_user_post` WRITE;
/*!40000 ALTER TABLE `sys_user_post` DISABLE KEYS */;
INSERT INTO `sys_user_post` VALUES (1,1),(2,2);
/*!40000 ALTER TABLE `sys_user_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(2,2);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'ry-vue'
--

--
-- Dumping routines for database 'ry-vue'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-29  0:04:28
