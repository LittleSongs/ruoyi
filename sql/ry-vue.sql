/*
 Navicat Premium Dump SQL

 Source Server         : mysql
 Source Server Type    : MySQL
 Source Server Version : 80046 (8.0.46)
 Source Host           : localhost:3306
 Source Schema         : ry-vue

 Target Server Type    : MySQL
 Target Server Version : 80046 (8.0.46)
 File Encoding         : 65001

 Date: 05/08/2026 00:15:47
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for dcm_validation_record
-- ----------------------------
DROP TABLE IF EXISTS `dcm_validation_record`;
CREATE TABLE `dcm_validation_record`  (
  `record_id` bigint NOT NULL AUTO_INCREMENT,
  `batch_id` bigint NULL DEFAULT NULL,
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `file_size` bigint NULL DEFAULT NULL,
  `temp_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `sop_class_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `media_storage_sop_class_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `study_instance_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `series_instance_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `sop_instance_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `modality` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `official_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'validate_iods结果 PASS/FAIL',
  `custom_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '自定义规则结果 PASS/FAIL',
  `final_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最终结果 PASS/FAIL',
  `error_count` int NULL DEFAULT 0,
  `warning_count` int NULL DEFAULT 0,
  `official_result_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'validate_iods原始结果',
  `custom_result_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '自定义规则结果',
  `orthanc_instance_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '通过后才有',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `idx_dcm_validation_record_sop`(`sop_instance_uid` ASC) USING BTREE,
  INDEX `idx_dcm_validation_record_status`(`final_status` ASC) USING BTREE,
  INDEX `idx_dcm_validation_record_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'DICOM上传校验记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dcm_validation_record
-- ----------------------------
INSERT INTO `dcm_validation_record` VALUES (1, NULL, 'image-000001.dcm', 527650, 'C:\\Users\\china\\AppData\\Local\\Temp\\ruoyi-ndt-1469537421528751272.dcm', '1.2.840.10008.5.1.4.1.1.2', '1.2.840.10008.5.1.4.1.1.2', '1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932', '1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160', '1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765087', 'CT', 'PASS', 'PASS', 'PASS', 0, 0, '{\"exitCode\":0,\"status\":\"PASS\",\"stderr\":\"\",\"stdout\":\"Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-1469537421528751272.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.2\\\" (CT Image IOD)\\r\\n\"}', '{\"errors\":[],\"ruleType\":1,\"status\":\"PASS\",\"warnings\":[]}', 'ec80720f-b98f706a-94faa0b8-acd549b4-2d1cc21a', 'admin', '2026-08-02 20:18:56');
INSERT INTO `dcm_validation_record` VALUES (3, NULL, 'image-000001-P02-new-series.dcm', 527650, 'C:\\Users\\china\\AppData\\Local\\Temp\\ruoyi-ndt-3119078759540092425.dcm', '1.2.840.10008.5.1.4.1.1.2', '1.2.840.10008.5.1.4.1.1.2', '1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932', '1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027234284793743', '1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765554', 'CT', 'PASS', 'PASS', 'PASS', 0, 0, '{\"exitCode\":0,\"status\":\"PASS\",\"stderr\":\"\",\"stdout\":\"Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-3119078759540092425.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.2\\\" (CT Image IOD)\\r\\n\"}', '{\"errors\":[],\"ruleType\":1,\"status\":\"PASS\",\"warnings\":[]}', '31c517e3-6c708a3a-db8acaf9-a392b839-7f9e1a12', 'admin', '2026-08-02 20:23:54');
INSERT INTO `dcm_validation_record` VALUES (4, NULL, 'dicondeEnhancedCtExampleImageE2767-13Typical.dcm', 5204786, 'C:\\Users\\china\\AppData\\Local\\Temp\\ruoyi-ndt-3667232956667416422.dcm', '1.2.840.10008.5.1.4.1.1.2.1', '1.2.840.10008.5.1.4.1.1.2.1', '2.16.840.1.114229.80.20140203.160754.76312.1', '2.16.840.1.114229.80.20140203.160754.76312.1.1', '2.16.840.1.114229.80.20140203.160754.76312', 'CT', 'FAIL', 'PASS', 'FAIL', 1, 0, '{\"exitCode\":7,\"status\":\"FAIL\",\"stderr\":\"\",\"stdout\":\"Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-3667232956667416422.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.2.1\\\" (Enhanced CT Image IOD)\\r\\n\\r\\nErrors\\r\\n======\\r\\n\\r\\nModule \\\"CT Position\\\":\\r\\n(5200,9229) (Shared Functional Groups Sequence) / (0018,9326) (CT Position Sequence):\\r\\n  Tag (0018,9313) (Data Collection Center (Patient)) is missing\\r\\n  Tag (0018,9318) (Reconstruction Target Center (Patient)) is missing\\r\\n\\r\\nModule \\\"CT X-Ray Details\\\":\\r\\n(5200,9229) (Shared Functional Groups Sequence) / (0018,9325) (CT X-Ray Details Sequence):\\r\\n  Tag (0018,7050) (Filter Material) is missing\\r\\n\\r\\nModule \\\"General\\\":\\r\\nTag (0008,0032) (Acquisition Time) is unexpected\\r\\nTag (0010,2160) (Ethnic Group) is unexpected\\r\\nTag (0014,1020) (Expiry Date) is unexpected\\r\\nTag (0032,4000) (Study Comments) is unexpected\\r\\n\\r\\n======\\r\\n\"}', '{\"errors\":[],\"ruleType\":1,\"status\":\"PASS\",\"warnings\":[]}', NULL, 'admin', '2026-08-02 22:20:07');
INSERT INTO `dcm_validation_record` VALUES (5, NULL, 'dicondeUsExampleImageE2663-11Minimum.DCM', 3530, 'C:\\Users\\china\\AppData\\Local\\Temp\\ruoyi-ndt-2753450554026424549.dcm', '1.2.840.10008.5.1.4.1.1.6.1', '1.2.840.10008.5.1.4.1.1.6.1', '2.16.840.1.114229.13.1.5151312514.1389091060.2', '2.16.840.1.114229.13.1.5151312514.1389091060.2.4885', '1.2.528.1.1001.100.4.1269.841.86472596787.201401355436666', 'US', 'FAIL', 'PASS', 'FAIL', 1, 0, '{\"exitCode\":7,\"status\":\"FAIL\",\"stderr\":\"\",\"stdout\":\"Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-2753450554026424549.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.6.1\\\" (Ultrasound Image IOD)\\r\\n\\r\\nErrors\\r\\n======\\r\\n\\r\\nModule \\\"General\\\":\\r\\nTag (0010,2160) (Ethnic Group) is unexpected\\r\\nTag (0014,1020) (Expiry Date) is unexpected\\r\\nTag (0018,6024) (Physical Units X Direction) is unexpected\\r\\nTag (0018,6026) (Physical Units Y Direction) is unexpected\\r\\nTag (0018,602C) (Physical Delta X) is unexpected\\r\\nTag (0018,602E) (Physical Delta Y) is unexpected\\r\\nTag (0032,4000) (Study Comments) is unexpected\\r\\n\\r\\n======\\r\\n\"}', '{\"errors\":[],\"ruleType\":1,\"status\":\"PASS\",\"warnings\":[]}', NULL, 'admin', '2026-08-02 22:20:13');
INSERT INTO `dcm_validation_record` VALUES (6, NULL, 'dicondeCrExampleImageE2738-11Minimum.DCM', 3432330, 'C:\\Users\\china\\AppData\\Local\\Temp\\ruoyi-ndt-346717655782139094.dcm', '1.2.840.10008.5.1.4.1.1.1', '1.2.840.10008.5.1.4.1.1.1', '2.16.840.1.114229.17.7.20100406.164813.1', '2.16.840.1.114229.17.7.20100406.164813.1.1', '2.16.840.1.114229.17.7.20100406.164813.1.1.1', 'CR', 'FAIL', 'PASS', 'FAIL', 1, 0, '{\"exitCode\":3,\"status\":\"FAIL\",\"stderr\":\"\",\"stdout\":\"Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-346717655782139094.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.1\\\" (Computed Radiography Image IOD)\\r\\n\\r\\nErrors\\r\\n======\\r\\n\\r\\nModule \\\"General\\\":\\r\\nTag (0010,2160) (Ethnic Group) is unexpected\\r\\nTag (0014,1020) (Expiry Date) is unexpected\\r\\nTag (0032,4000) (Study Comments) is unexpected\\r\\n\\r\\n======\\r\\n\"}', '{\"errors\":[],\"ruleType\":1,\"status\":\"PASS\",\"warnings\":[]}', NULL, 'admin', '2026-08-02 22:20:17');
INSERT INTO `dcm_validation_record` VALUES (7, NULL, 'output.dcm', 6566, 'C:\\Users\\china\\AppData\\Local\\Temp\\ruoyi-ndt-6855650616250347539.dcm', '1.2.840.10008.5.1.4.1.1.7', '1.2.840.10008.5.1.4.1.1.7', '1.2.276.0.7230010.3.1.2.0.90719.1779900585.273440', '1.2.276.0.7230010.3.1.3.0.90719.1779900585.273439', '1.2.276.0.7230010.3.1.4.0.90719.1779900585.273441', NULL, 'FAIL', 'PASS', 'FAIL', 1, 0, '{\"exitCode\":1,\"status\":\"FAIL\",\"stderr\":\"\",\"stdout\":\"Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-6855650616250347539.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.7\\\" (Secondary Capture Image IOD)\\r\\n\\r\\nErrors\\r\\n======\\r\\n\\r\\nModule \\\"General Series\\\":\\r\\nTag (0008,0060) (Modality) is missing\\r\\n\\r\\n======\\r\\n\"}', '{\"errors\":[],\"ruleType\":1,\"status\":\"PASS\",\"warnings\":[]}', NULL, 'admin', '2026-08-02 22:20:25');
INSERT INTO `dcm_validation_record` VALUES (8, NULL, 'dicondeCrExampleImageE2738-11Typical.DCM', 5487882, 'C:\\Users\\china\\AppData\\Local\\Temp\\ruoyi-ndt-12546286564404310509.dcm', '1.2.840.10008.5.1.4.1.1.1', '1.2.840.10008.5.1.4.1.1.1', '2.16.840.1.114229.17.7.20100406.130434.1', '2.16.840.1.114229.17.7.20100406.130434.1.1', '2.16.840.1.114229.17.7.20100406.130434.1.1.1', 'CR', 'FAIL', 'PASS', 'FAIL', 1, 0, '{\"exitCode\":3,\"status\":\"FAIL\",\"stderr\":\"\",\"stdout\":\"Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-12546286564404310509.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.1\\\" (Computed Radiography Image IOD)\\r\\n\\r\\nErrors\\r\\n======\\r\\n\\r\\nModule \\\"General\\\":\\r\\nTag (0010,2160) (Ethnic Group) is unexpected\\r\\nTag (0014,1020) (Expiry Date) is unexpected\\r\\nTag (0032,4000) (Study Comments) is unexpected\\r\\n\\r\\n======\\r\\n\"}', '{\"errors\":[],\"ruleType\":1,\"status\":\"PASS\",\"warnings\":[]}', NULL, 'admin', '2026-08-02 22:20:36');
INSERT INTO `dcm_validation_record` VALUES (9, NULL, 'image-000195.dcm', 527696, 'C:\\Users\\china\\AppData\\Local\\Temp\\ruoyi-ndt-6677985347025649314.dcm', '1.2.840.10008.5.1.4.1.1.2', '1.2.840.10008.5.1.4.1.1.2', '1.3.6.1.4.1.44316.6.102.1.20250704114423696.33358672119535771932', '1.3.6.1.4.1.44316.6.102.2.20250704121912287.36535028333355733227', '1.3.6.1.4.1.44316.6.102.3.2025070412239125.151133372912858941086', 'CT', 'PASS', 'PASS', 'PASS', 0, 0, '{\"exitCode\":0,\"status\":\"PASS\",\"stderr\":\"\",\"stdout\":\"Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-6677985347025649314.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.2\\\" (CT Image IOD)\\r\\n\"}', '{\"errors\":[],\"ruleType\":1,\"status\":\"PASS\",\"warnings\":[]}', '4013a57c-613cd279-1e6e916a-3ad4ceef-83eef100', 'admin', '2026-08-02 22:23:40');

-- ----------------------------
-- Table structure for dcm_validation_rule
-- ----------------------------
DROP TABLE IF EXISTS `dcm_validation_rule`;
CREATE TABLE `dcm_validation_rule`  (
  `rule_id` bigint NOT NULL AUTO_INCREMENT,
  `rule_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '规则名称',
  `sop_class_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '适用SOPClassUID，*表示通用规则',
  `sop_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'SOP名称',
  `modality` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '可选，CT/DX/CR等',
  `rule_type` tinyint NOT NULL COMMENT '规则类型：1=必备Tag',
  `tag_code` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Tag编号，如00111010',
  `tag_display` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '显示格式，如(0011,1010)',
  `tag_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Tag名称',
  `vr` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'VR，如LO/SH/LT/UI',
  `private_creator` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '私有Tag创建者，如RuoYiNDT',
  `allow_blank` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '是否允许空值 Y/N',
  `severity` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'ERROR' COMMENT 'ERROR/WARNING',
  `enabled` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'Y' COMMENT '是否启用',
  `sort_order` int NULL DEFAULT 0,
  `fail_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '失败提示',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`rule_id`) USING BTREE,
  INDEX `idx_dcm_validation_rule_sop`(`sop_class_uid` ASC, `rule_type` ASC, `enabled` ASC) USING BTREE,
  INDEX `idx_dcm_validation_rule_tag`(`tag_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'DICOM自定义校验规则表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dcm_validation_rule
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `form_col_num` int NULL DEFAULT 1 COMMENT '表单布局（单列 双列 三列）',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------

-- ----------------------------
-- Table structure for ndt_customer
-- ----------------------------
DROP TABLE IF EXISTS `ndt_customer`;
CREATE TABLE `ndt_customer`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '客户主键',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '客户名称',
  `contact_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ndt_customer_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'NDT客户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_customer
-- ----------------------------
INSERT INTO `ndt_customer` VALUES (2, '宁波中科检测', '张三', '13586801014', '测试备注信息', 'admin', '2026-07-29 17:46:27', 'admin', '2026-07-29 18:05:46', '2');
INSERT INTO `ndt_customer` VALUES (3, '宁波中科检测', '宋明豫', '13586801014', '测试备注', 'admin', '2026-07-29 18:06:13', 'admin', '2026-07-29 18:06:13', '0');

-- ----------------------------
-- Table structure for ndt_defect
-- ----------------------------
DROP TABLE IF EXISTS `ndt_defect`;
CREATE TABLE `ndt_defect`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '缺陷主键',
  `original_object_id` bigint NOT NULL COMMENT '所属原始图对象主键',
  `defect_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '缺陷编号',
  `defect_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '缺陷类型',
  `roi_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'ROI类型',
  `roi_data_json` json NULL COMMENT 'ROI坐标和几何数据',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '缺陷描述',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ndt_defect_no`(`original_object_id` ASC, `defect_no` ASC) USING BTREE,
  INDEX `idx_ndt_defect_type`(`defect_type` ASC) USING BTREE,
  CONSTRAINT `fk_ndt_defect_original_object` FOREIGN KEY (`original_object_id`) REFERENCES `ndt_dicom_object` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'NDT缺陷表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_defect
-- ----------------------------

-- ----------------------------
-- Table structure for ndt_dicom_integrity_record
-- ----------------------------
DROP TABLE IF EXISTS `ndt_dicom_integrity_record`;
CREATE TABLE `ndt_dicom_integrity_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `study_instance_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'StudyInstanceUID',
  `series_instance_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'SeriesInstanceUID',
  `sop_instance_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'SOPInstanceUID',
  `orthanc_instance_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Orthanc Instance ID',
  `pixel_data_sha256` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'PixelData SHA-256',
  `metadata_sha256` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '元数据 SHA-256',
  `file_sha256` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '原始文件 SHA-256',
  `signed_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '签名内容',
  `signature_algorithm` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '签名算法',
  `signature_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '签名值',
  `public_key_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '公钥ID',
  `import_user_id` bigint NULL DEFAULT NULL COMMENT '导入用户ID',
  `import_time` datetime NULL DEFAULT NULL COMMENT '导入时间',
  `last_verify_time` datetime NULL DEFAULT NULL COMMENT '最后校验时间',
  `verify_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'UNKNOWN' COMMENT '校验状态',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ndt_integrity_sop`(`sop_instance_uid` ASC) USING BTREE,
  INDEX `idx_ndt_integrity_orthanc`(`orthanc_instance_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'NDT DICOM完整性校验表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_dicom_integrity_record
-- ----------------------------
INSERT INTO `ndt_dicom_integrity_record` VALUES (1, '1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932', '1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160', '1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765087', 'ec80720f-b98f706a-94faa0b8-acd549b4-2d1cc21a', NULL, NULL, 'c3ea9864816c08de3319a5900070d528ce36eeaa3d3812610456b1b254ab573b', NULL, NULL, NULL, NULL, 1, '2026-08-02 20:18:57', NULL, 'UNKNOWN', NULL, '2026-08-02 20:18:57', '2026-08-02 20:18:57');
INSERT INTO `ndt_dicom_integrity_record` VALUES (2, '1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932', '1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160', '1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036769999', '325d71fd-42454199-a2b5d1b9-ef6617e3-bac96b27', NULL, NULL, 'e769aef544d83600d882ff3089a5eda02063fe730918ad92477f7bb0833e725b', NULL, NULL, NULL, NULL, 1, '2026-08-02 20:19:27', NULL, 'UNKNOWN', NULL, '2026-08-02 20:19:26', '2026-08-02 20:19:26');
INSERT INTO `ndt_dicom_integrity_record` VALUES (3, '1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932', '1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027234284793743', '1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765554', '31c517e3-6c708a3a-db8acaf9-a392b839-7f9e1a12', NULL, NULL, 'a7e558e42b137eab16da6b1d8b57200a9be156dfee811a0a8a366c1fb7a41efa', NULL, NULL, NULL, NULL, 1, '2026-08-02 20:23:54', NULL, 'UNKNOWN', NULL, '2026-08-02 20:23:54', '2026-08-02 20:23:54');
INSERT INTO `ndt_dicom_integrity_record` VALUES (4, '1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932', '1.3.6.1.4.1.44316.6.102.2.20250704114429771.63133867861500115690', '1.3.6.1.4.1.44316.6.102.3.20250704114423666.30394198594456817768', 'fe446e0a-fb1fcfef-4c290fa9-b1ea9520-de8b1d92', NULL, NULL, '828128b708cac60340182cf9b57e822af288bfe630e2ce2e5fa422350fcffd36', NULL, NULL, NULL, NULL, 1, '2026-08-02 20:47:32', NULL, 'UNKNOWN', NULL, '2026-08-02 20:47:32', '2026-08-02 20:47:32');
INSERT INTO `ndt_dicom_integrity_record` VALUES (5, '1.3.6.1.4.1.44316.6.102.1.20250704114423696.33358672119535771932', '1.3.6.1.4.1.44316.6.102.2.20250704121912287.36535028333355733227', '1.3.6.1.4.1.44316.6.102.3.2025070412239125.151133372912858941086', '4013a57c-613cd279-1e6e916a-3ad4ceef-83eef100', NULL, NULL, '415266b9dd13bd76fab555bfefac6cc58a0deefa4240ac05662e621e9121dddd', NULL, NULL, NULL, NULL, 1, '2026-08-02 22:23:41', NULL, 'UNKNOWN', NULL, '2026-08-02 22:23:40', '2026-08-02 22:23:40');

-- ----------------------------
-- Table structure for ndt_dicom_object
-- ----------------------------
DROP TABLE IF EXISTS `ndt_dicom_object`;
CREATE TABLE `ndt_dicom_object`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'DICOM或派生对象主键',
  `series_id` bigint NOT NULL,
  `object_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '对象类型',
  `object_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '对象名称',
  `storage_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '存储类型',
  `orthanc_instance_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Orthanc Instance ID',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件系统路径',
  `object_key` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '对象存储Key',
  `mime_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'MIME类型',
  `sop_instance_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'SOP Instance UID',
  `sop_class_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'SOP Class UID',
  `parameters_json` json NULL COMMENT '显示参数或对象参数',
  `metadata_json` json NULL COMMENT '扩展元数据',
  `sha256` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件SHA-256摘要',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ndt_object_sop_uid`(`sop_instance_uid` ASC) USING BTREE,
  UNIQUE INDEX `uk_ndt_object_active_original_series`(((case when ((`object_type` = _utf8mb4\'ORIGINAL_IMAGE\') and (`del_flag` = _utf8mb4\'0\')) then `series_id` else NULL end)) ASC) USING BTREE,
  INDEX `idx_ndt_object_orthanc`(`orthanc_instance_id` ASC) USING BTREE,
  INDEX `idx_ndt_object_sha256`(`sha256` ASC) USING BTREE,
  INDEX `idx_ndt_object_series_type`(`series_id` ASC, `object_type` ASC) USING BTREE,
  CONSTRAINT `fk_ndt_object_series` FOREIGN KEY (`series_id`) REFERENCES `ndt_dicom_series` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_ndt_object_storage_type` CHECK (`storage_type` in (_utf8mb4'ORTHANC',_utf8mb4'FILE_SYSTEM',_utf8mb4'OBJECT_STORAGE',_utf8mb4'DATABASE_JSON')),
  CONSTRAINT `chk_ndt_object_type` CHECK (`object_type` in (_utf8mb4'ORIGINAL_IMAGE',_utf8mb4'PROCESSED_IMAGE',_utf8mb4'SCREENSHOT',_utf8mb4'ANNOTATION_IMAGE',_utf8mb4'PRESENTATION_STATE',_utf8mb4'SR',_utf8mb4'OTHER'))
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'NDT DICOM及派生对象表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_dicom_object
-- ----------------------------
INSERT INTO `ndt_dicom_object` VALUES (1, 1, 'ORIGINAL_IMAGE', 'image-000001.dcm', 'ORTHANC', 'ec80720f-b98f706a-94faa0b8-acd549b4-2d1cc21a', NULL, NULL, 'application/dicom', '1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765087', '1.2.840.10008.5.1.4.1.1.2', NULL, '{\"KVP\": \"120\", \"Rows\": \"512\", \"VmaMod\": \"0\", \"Columns\": \"512\", \"HighBit\": \"15\", \"StudyID\": \"1\", \"SuiteId\": \"LS16\", \"VmaClip\": \"0\", \"VmaMamp\": \"0\", \"Exposure\": \"41\", \"Modality\": \"CT\", \"ImageType\": \"ORIGINAL\\\\PRIMARY\\\\AXIAL\", \"PatientID\": \"0\", \"PlaneType\": \"2\", \"ProductId\": \"LightSpeed Pro\", \"ScoutType\": \"0\", \"StudyDate\": \"20151207\", \"StudyTime\": \"073153\", \"XrayChain\": \"99\\\\99\\\\99\", \"BitsStored\": \"16\", \"DASAdInput\": \"0\", \"DASCalMode\": \"0\", \"DASFpaGain\": \"0\", \"FilterType\": \"BODY FILTER\", \"FocalSpots\": \"1.200000\", \"PatientAge\": \"062Y\", \"PatientSex\": \"M\", \"SeriesDate\": \"20151207\", \"SeriesTime\": \"073458\", \"TableSpeed\": \"0.000000\", \"CellSpacing\": \"1.023900\", \"ContentDate\": \"20151207\", \"ContentTime\": \"073659\", \"LastScanRAS\": \"I\", \"MidScanFlag\": \"1\", \"MidScanTime\": \"136.928848\", \"PatientName\": \"Anonymized^^\", \"PatientSize\": \"1.75\", \"RescaleType\": \"HU\", \"SOPClassUID\": \"1.2.840.10008.5.1.4.1.1.2\", \"ScanFOVType\": \"16\", \"ScanOptions\": \"AXIAL MODE\", \"StationName\": \"\", \"TableHeight\": \"182.500000\", \"WindowValue\": \"350\", \"WindowWidth\": \"350\", \"EquipmentUID\": \"\", \"ExposureTime\": \"700\", \"FirstScanRAS\": \"I\", \"FullFidelity\": \"CT_LIGHTSPEED\", \"GantryPeriod\": \"0.700000\", \"Manufacturer\": \"GE MEDICAL SYSTEMS\", \"NormalACoord\": \"0\", \"NormalRCoord\": \"0\", \"NormalSCoord\": \"-1\", \"PixelSpacing\": \"0.902344\\\\0.902344\", \"ProtocolName\": \"5.8 KUNAS ONKOLOGIJA (dvi fazes)\", \"RescaleSlope\": \" 1\", \"SeriesNumber\": \"200\", \"WindowCenter\": \"40\", \"BitsAllocated\": \"16\", \"OperatorsName\": \"\", \"PatientWeight\": \"91.0\", \"SegmentNumber\": \"0\", \"SliceLocation\": \"-289.750\", \"BiopsyPosition\": \"0\", \"DeltaStartTime\": \"0.000000\", \"GeneratorPower\": \"7200\", \"InstanceNumber\": \"5\", \"PrivateCreator\": \"GEMS_HELIOS_01\", \"SOPInstanceUID\": \"1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765087\", \"ScanPitchRatio\": \"\", \"SeriesContrast\": \"1\", \"SliceThickness\": \"10.000000\", \"AccessionNumber\": \"\", \"AcquisitionDate\": \"20151207\", \"AcquisitionTime\": \"073657\", \"BiopsyTLocation\": \"0\", \"DASOutputSource\": \"0\", \"ImageActualDate\": \"1449473698\", \"InstitutionName\": \"\", \"PatientPosition\": \"FFS\", \"SamplesPerPixel\": \"1\", \"XRayTubeCurrent\": \"60\", \"AngleOfFirstView\": \"0.000000\", \"DASTriggerSource\": \"0\", \"DegreeOfRotation\": \"364.40817260742188\", \"DegreesOfAzimuth\": \"85\", \"DurationOfXrayOn\": \"0.69999998807907104\", \"NumberOfTriggers\": \"992\", \"PatientBirthDate\": \"\", \"RescaleIntercept\": \" -1024\", \"SoftwareVersions\": \"07MW11.10\", \"StudyDescription\": \"KUNAS\", \"StudyInstanceUID\": \"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\", \"TableEndLocation\": \"0\", \"TriggerFrequency\": \"1400.000000\", \"AcquisitionNumber\": \"5\", \"BiopsyRefLocation\": \"0\", \"CellNumberAtTheta\": \"389.750000\", \"ConvolutionKernel\": \"SOFT\", \"PixelPaddingValue\": \"-2000\", \"ReferenceChannels\": \"0\\\\0\\\\0\\\\0\\\\0\\\\0\", \"RotationDirection\": \"CW\", \"SeriesDescription\": \"Smart Prep Series\", \"SeriesInstanceUID\": \"1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160\", \"TriggerOnPosition\": \"316.86260986328125\", \"ContrastBolusAgent\": \"H2O+UROGRAFINAS & ULTRAVIST370-100\", \"ContrastBolusRoute\": \"Oral & IV\", \"GantryDetectorTilt\": \"0.000000\", \"NumberOfOverranges\": \"-1\", \"PrivateScanOptions\": \"2\\\\0\\\\0\\\\0\", \"SmartScanOnOffFlag\": \"0\", \"TableStartLocation\": \"0\", \"FrameOfReferenceUID\": \"1.2.840.113619.2.55.3.4271045733.996.1449464144.597.17720.5\", \"PixelRepresentation\": \"1\", \"ImagePositionPatient\": \"-223.100\\\\-206.400\\\\-289.750\", \"InstanceCreationDate\": \"20151207\", \"InstanceCreationTime\": \"073659\", \"MaxOverrangesInAView\": \"0\", \"SpecificCharacterSet\": \"ISO_IR 100\", \"ManufacturerModelName\": \"LightSpeed Pro 16\", \"ViewCompressionFactor\": \"1\", \"DataCollectionDiameter\": \"500.000000\", \"ReconstructionDiameter\": \"462.000000\", \"ReferringPhysicianName\": \"\", \"StartScanToXrayOnDelay\": \"0\", \"TotalSegmentsRequested\": \"0\", \"CorrectedAfterglowTerms\": \"0\", \"DistanceSourceToPatient\": \"541.000000\", \"ImageOrientationPatient\": \"1.000000\\\\0.000000\\\\0.000000\\\\0.000000\\\\1.000000\\\\0.000000\", \"NumberOfCellsInDetector\": \"912\", \"ReconPostProcessingFlag\": \"0\", \"ReferencedImageSequence\": [{\"ReferencedSOPClassUID\": \"1.2.840.10008.5.1.4.1.1.2\", \"ReferencedSOPInstanceUID\": \"1.3.6.1.4.1.44316.6.102.3.20250704114423666.30394198594456817768\"}], \"AdditionalPatientHistory\": \"\", \"CenterACoordOfPlaneImage\": \"-24.600000381469727\", \"CenterRCoordOfPlaneImage\": \"-7.9000000953674316\", \"CenterSCoordOfPlaneImage\": \"-289.75\", \"DistanceSourceToDetector\": \"949.075012\", \"ImageFromWhichPrescribed\": \"2\", \"PerformedProcedureStepID\": \"PPS ID  20527\", \"NoViewsRefChannelsBlocked\": \"0\\\\0\\\\0\\\\0\", \"PhotometricInterpretation\": \"MONOCHROME2\", \"SeriesFromWhichPrescribed\": \"1\", \"StartTimeSecsInFirstAxial\": \"1449473681.298032\", \"HorizontalFrameOfReference\": \"1772.000000\", \"PositionReferenceIndicator\": \"SN\", \"RACoordOfTargetReconCentre\": \"-7.900000\\\\-24.600000\", \"NameOfPhysiciansReadingStudy\": \"\", \"PerformedProcedureStepStartDate\": \"20151207\", \"PerformedProcedureStepStartTime\": \"073153\", \"DependantOnNumberOfViewsProcessed\": \"2\", \"PerformedProcedureStepDescription\": \"KUNAS\"}', 'c3ea9864816c08de3319a5900070d528ce36eeaa3d3812610456b1b254ab573b', 'admin', '2026-08-02 20:18:57', 'admin', '2026-08-02 20:18:57', '0');
INSERT INTO `ndt_dicom_object` VALUES (2, 1, 'PROCESSED_IMAGE', 'image-000001-sub-2.dcm', 'ORTHANC', '325d71fd-42454199-a2b5d1b9-ef6617e3-bac96b27', NULL, NULL, 'application/dicom', '1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036769999', '1.2.840.10008.5.1.4.1.1.2', NULL, '{\"KVP\": \"120\", \"Rows\": \"512\", \"VmaMod\": \"0\", \"Columns\": \"512\", \"HighBit\": \"15\", \"StudyID\": \"1\", \"SuiteId\": \"LS16\", \"VmaClip\": \"0\", \"VmaMamp\": \"0\", \"Exposure\": \"41\", \"Modality\": \"CT\", \"ImageType\": \"ORIGINAL\\\\PRIMARY\\\\AXIAL\", \"PatientID\": \"0\", \"PlaneType\": \"2\", \"ProductId\": \"LightSpeed Pro\", \"ScoutType\": \"0\", \"StudyDate\": \"20151207\", \"StudyTime\": \"073153\", \"XrayChain\": \"99\\\\99\\\\99\", \"BitsStored\": \"16\", \"DASAdInput\": \"0\", \"DASCalMode\": \"0\", \"DASFpaGain\": \"0\", \"FilterType\": \"BODY FILTER\", \"FocalSpots\": \"1.200000\", \"PatientAge\": \"062Y\", \"PatientSex\": \"M\", \"SeriesDate\": \"20151207\", \"SeriesTime\": \"073458\", \"TableSpeed\": \"0.000000\", \"CellSpacing\": \"1.023900\", \"ContentDate\": \"20151207\", \"ContentTime\": \"073659\", \"LastScanRAS\": \"I\", \"MidScanFlag\": \"1\", \"MidScanTime\": \"136.928848\", \"PatientName\": \"Anonymized^^\", \"PatientSize\": \"1.75\", \"RescaleType\": \"HU\", \"SOPClassUID\": \"1.2.840.10008.5.1.4.1.1.2\", \"ScanFOVType\": \"16\", \"ScanOptions\": \"AXIAL MODE\", \"StationName\": \"\", \"TableHeight\": \"182.500000\", \"WindowValue\": \"350\", \"WindowWidth\": \"350\", \"EquipmentUID\": \"\", \"ExposureTime\": \"700\", \"FirstScanRAS\": \"I\", \"FullFidelity\": \"CT_LIGHTSPEED\", \"GantryPeriod\": \"0.700000\", \"Manufacturer\": \"GE MEDICAL SYSTEMS\", \"NormalACoord\": \"0\", \"NormalRCoord\": \"0\", \"NormalSCoord\": \"-1\", \"PixelSpacing\": \"0.902344\\\\0.902344\", \"ProtocolName\": \"5.8 KUNAS ONKOLOGIJA (dvi fazes)\", \"RescaleSlope\": \" 1\", \"SeriesNumber\": \"200\", \"WindowCenter\": \"40\", \"BitsAllocated\": \"16\", \"OperatorsName\": \"²âÊÔÅÉÉúÍ¼-´¦ÀíÍ¼\", \"PatientWeight\": \"91.0\", \"SegmentNumber\": \"0\", \"SliceLocation\": \"-289.750\", \"BiopsyPosition\": \"0\", \"DeltaStartTime\": \"0.000000\", \"GeneratorPower\": \"7200\", \"InstanceNumber\": \"5\", \"PrivateCreator\": \"GEMS_HELIOS_01\", \"SOPInstanceUID\": \"1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036769999\", \"ScanPitchRatio\": \"\", \"SeriesContrast\": \"1\", \"SliceThickness\": \"10.000000\", \"AccessionNumber\": \"\", \"AcquisitionDate\": \"20151207\", \"AcquisitionTime\": \"073657\", \"BiopsyTLocation\": \"0\", \"DASOutputSource\": \"0\", \"ImageActualDate\": \"1449473698\", \"InstitutionName\": \"\", \"PatientPosition\": \"FFS\", \"SamplesPerPixel\": \"1\", \"XRayTubeCurrent\": \"60\", \"AngleOfFirstView\": \"0.000000\", \"DASTriggerSource\": \"0\", \"DegreeOfRotation\": \"364.40817260742188\", \"DegreesOfAzimuth\": \"85\", \"DurationOfXrayOn\": \"0.69999998807907104\", \"NumberOfTriggers\": \"992\", \"PatientBirthDate\": \"\", \"RescaleIntercept\": \" -1024\", \"SoftwareVersions\": \"07MW11.10\", \"StudyDescription\": \"KUNAS\", \"StudyInstanceUID\": \"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\", \"TableEndLocation\": \"0\", \"TriggerFrequency\": \"1400.000000\", \"AcquisitionNumber\": \"5\", \"BiopsyRefLocation\": \"0\", \"CellNumberAtTheta\": \"389.750000\", \"ConvolutionKernel\": \"SOFT\", \"PixelPaddingValue\": \"-2000\", \"ReferenceChannels\": \"0\\\\0\\\\0\\\\0\\\\0\\\\0\", \"RotationDirection\": \"CW\", \"SeriesDescription\": \"Smart Prep Series\", \"SeriesInstanceUID\": \"1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160\", \"TriggerOnPosition\": \"316.86260986328125\", \"ContrastBolusAgent\": \"H2O+UROGRAFINAS & ULTRAVIST370-100\", \"ContrastBolusRoute\": \"Oral & IV\", \"GantryDetectorTilt\": \"0.000000\", \"NumberOfOverranges\": \"-1\", \"PrivateScanOptions\": \"2\\\\0\\\\0\\\\0\", \"SmartScanOnOffFlag\": \"0\", \"TableStartLocation\": \"0\", \"FrameOfReferenceUID\": \"1.2.840.113619.2.55.3.4271045733.996.1449464144.597.17720.5\", \"PixelRepresentation\": \"1\", \"ImagePositionPatient\": \"-223.100\\\\-206.400\\\\-289.750\", \"InstanceCreationDate\": \"20151207\", \"InstanceCreationTime\": \"073659\", \"MaxOverrangesInAView\": \"0\", \"SpecificCharacterSet\": \"ISO_IR 100\", \"ManufacturerModelName\": \"LightSpeed Pro 16\", \"ViewCompressionFactor\": \"1\", \"DataCollectionDiameter\": \"500.000000\", \"ReconstructionDiameter\": \"462.000000\", \"ReferringPhysicianName\": \"\", \"StartScanToXrayOnDelay\": \"0\", \"TotalSegmentsRequested\": \"0\", \"CorrectedAfterglowTerms\": \"0\", \"DistanceSourceToPatient\": \"541.000000\", \"ImageOrientationPatient\": \"1.000000\\\\0.000000\\\\0.000000\\\\0.000000\\\\1.000000\\\\0.000000\", \"NumberOfCellsInDetector\": \"912\", \"ReconPostProcessingFlag\": \"0\", \"ReferencedImageSequence\": [{\"ReferencedSOPClassUID\": \"1.2.840.10008.5.1.4.1.1.2\", \"ReferencedSOPInstanceUID\": \"1.3.6.1.4.1.44316.6.102.3.20250704114423666.30394198594456817768\"}], \"AdditionalPatientHistory\": \"\", \"CenterACoordOfPlaneImage\": \"-24.600000381469727\", \"CenterRCoordOfPlaneImage\": \"-7.9000000953674316\", \"CenterSCoordOfPlaneImage\": \"-289.75\", \"DistanceSourceToDetector\": \"949.075012\", \"ImageFromWhichPrescribed\": \"2\", \"PerformedProcedureStepID\": \"PPS ID  20527\", \"NoViewsRefChannelsBlocked\": \"0\\\\0\\\\0\\\\0\", \"PhotometricInterpretation\": \"MONOCHROME2\", \"SeriesFromWhichPrescribed\": \"1\", \"StartTimeSecsInFirstAxial\": \"1449473681.298032\", \"HorizontalFrameOfReference\": \"1772.000000\", \"PositionReferenceIndicator\": \"SN\", \"RACoordOfTargetReconCentre\": \"-7.900000\\\\-24.600000\", \"NameOfPhysiciansReadingStudy\": \"\", \"PerformedProcedureStepStartDate\": \"20151207\", \"PerformedProcedureStepStartTime\": \"073153\", \"DependantOnNumberOfViewsProcessed\": \"2\", \"PerformedProcedureStepDescription\": \"KUNAS\"}', 'e769aef544d83600d882ff3089a5eda02063fe730918ad92477f7bb0833e725b', 'admin', '2026-08-02 20:19:26', 'admin', '2026-08-02 20:19:26', '0');
INSERT INTO `ndt_dicom_object` VALUES (3, 2, 'ORIGINAL_IMAGE', 'image-000001-P02-new-series.dcm', 'ORTHANC', '31c517e3-6c708a3a-db8acaf9-a392b839-7f9e1a12', NULL, NULL, 'application/dicom', '1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765554', '1.2.840.10008.5.1.4.1.1.2', NULL, '{\"KVP\": \"120\", \"Rows\": \"512\", \"VmaMod\": \"0\", \"Columns\": \"512\", \"HighBit\": \"15\", \"StudyID\": \"1\", \"SuiteId\": \"LS16\", \"VmaClip\": \"0\", \"VmaMamp\": \"0\", \"Exposure\": \"41\", \"Modality\": \"CT\", \"ImageType\": \"ORIGINAL\\\\PRIMARY\\\\AXIAL\", \"PatientID\": \"0\", \"PlaneType\": \"2\", \"ProductId\": \"LightSpeed Pro\", \"ScoutType\": \"0\", \"StudyDate\": \"20151207\", \"StudyTime\": \"073153\", \"XrayChain\": \"99\\\\99\\\\99\", \"BitsStored\": \"16\", \"DASAdInput\": \"0\", \"DASCalMode\": \"0\", \"DASFpaGain\": \"0\", \"FilterType\": \"BODY FILTER\", \"FocalSpots\": \"1.200000\", \"PatientAge\": \"062Y\", \"PatientSex\": \"M\", \"SeriesDate\": \"20151207\", \"SeriesTime\": \"073458\", \"TableSpeed\": \"0.000000\", \"CellSpacing\": \"1.023900\", \"ContentDate\": \"20151207\", \"ContentTime\": \"073659\", \"LastScanRAS\": \"I\", \"MidScanFlag\": \"1\", \"MidScanTime\": \"136.928848\", \"PatientName\": \"Anonymized^^\", \"PatientSize\": \"1.75\", \"RescaleType\": \"HU\", \"SOPClassUID\": \"1.2.840.10008.5.1.4.1.1.2\", \"ScanFOVType\": \"16\", \"ScanOptions\": \"AXIAL MODE\", \"StationName\": \"\", \"TableHeight\": \"182.500000\", \"WindowValue\": \"350\", \"WindowWidth\": \"350\", \"EquipmentUID\": \"\", \"ExposureTime\": \"700\", \"FirstScanRAS\": \"I\", \"FullFidelity\": \"CT_LIGHTSPEED\", \"GantryPeriod\": \"0.700000\", \"Manufacturer\": \"GE MEDICAL SYSTEMS\", \"NormalACoord\": \"0\", \"NormalRCoord\": \"0\", \"NormalSCoord\": \"-1\", \"PixelSpacing\": \"0.902344\\\\0.902344\", \"ProtocolName\": \"5.8 KUNAS ONKOLOGIJA (dvi fazes)\", \"RescaleSlope\": \" 1\", \"SeriesNumber\": \"200\", \"WindowCenter\": \"40\", \"BitsAllocated\": \"16\", \"OperatorsName\": \"\", \"PatientWeight\": \"91.0\", \"SegmentNumber\": \"0\", \"SliceLocation\": \"-289.750\", \"BiopsyPosition\": \"0\", \"DeltaStartTime\": \"0.000000\", \"GeneratorPower\": \"7200\", \"InstanceNumber\": \"5\", \"PrivateCreator\": \"GEMS_HELIOS_01\", \"SOPInstanceUID\": \"1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765554\", \"ScanPitchRatio\": \"\", \"SeriesContrast\": \"1\", \"SliceThickness\": \"10.000000\", \"AccessionNumber\": \"\", \"AcquisitionDate\": \"20151207\", \"AcquisitionTime\": \"073657\", \"BiopsyTLocation\": \"0\", \"DASOutputSource\": \"0\", \"ImageActualDate\": \"1449473698\", \"InstitutionName\": \"\", \"PatientPosition\": \"FFS\", \"SamplesPerPixel\": \"1\", \"XRayTubeCurrent\": \"60\", \"AngleOfFirstView\": \"0.000000\", \"DASTriggerSource\": \"0\", \"DegreeOfRotation\": \"364.40817260742188\", \"DegreesOfAzimuth\": \"85\", \"DurationOfXrayOn\": \"0.69999998807907104\", \"NumberOfTriggers\": \"992\", \"PatientBirthDate\": \"\", \"RescaleIntercept\": \" -1024\", \"SoftwareVersions\": \"07MW11.10\", \"StudyDescription\": \"KUNAS\", \"StudyInstanceUID\": \"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\", \"TableEndLocation\": \"0\", \"TriggerFrequency\": \"1400.000000\", \"AcquisitionNumber\": \"5\", \"BiopsyRefLocation\": \"0\", \"CellNumberAtTheta\": \"389.750000\", \"ConvolutionKernel\": \"SOFT\", \"PixelPaddingValue\": \"-2000\", \"ReferenceChannels\": \"0\\\\0\\\\0\\\\0\\\\0\\\\0\", \"RotationDirection\": \"CW\", \"SeriesDescription\": \"Smart Prep Series\", \"SeriesInstanceUID\": \"1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027234284793743\", \"TriggerOnPosition\": \"316.86260986328125\", \"ContrastBolusAgent\": \"H2O+UROGRAFINAS & ULTRAVIST370-100\", \"ContrastBolusRoute\": \"Oral & IV\", \"GantryDetectorTilt\": \"0.000000\", \"NumberOfOverranges\": \"-1\", \"PrivateScanOptions\": \"2\\\\0\\\\0\\\\0\", \"SmartScanOnOffFlag\": \"0\", \"TableStartLocation\": \"0\", \"FrameOfReferenceUID\": \"1.2.840.113619.2.55.3.4271045733.996.1449464144.597.17720.5\", \"PixelRepresentation\": \"1\", \"ImagePositionPatient\": \"-223.100\\\\-206.400\\\\-289.750\", \"InstanceCreationDate\": \"20151207\", \"InstanceCreationTime\": \"073659\", \"MaxOverrangesInAView\": \"0\", \"SpecificCharacterSet\": \"ISO_IR 100\", \"ManufacturerModelName\": \"LightSpeed Pro 16\", \"ViewCompressionFactor\": \"1\", \"DataCollectionDiameter\": \"500.000000\", \"ReconstructionDiameter\": \"462.000000\", \"ReferringPhysicianName\": \"\", \"StartScanToXrayOnDelay\": \"0\", \"TotalSegmentsRequested\": \"0\", \"CorrectedAfterglowTerms\": \"0\", \"DistanceSourceToPatient\": \"541.000000\", \"ImageOrientationPatient\": \"1.000000\\\\0.000000\\\\0.000000\\\\0.000000\\\\1.000000\\\\0.000000\", \"NumberOfCellsInDetector\": \"912\", \"ReconPostProcessingFlag\": \"0\", \"ReferencedImageSequence\": [{\"ReferencedSOPClassUID\": \"1.2.840.10008.5.1.4.1.1.2\", \"ReferencedSOPInstanceUID\": \"1.3.6.1.4.1.44316.6.102.3.20250704114423666.30394198594456817768\"}], \"AdditionalPatientHistory\": \"\", \"CenterACoordOfPlaneImage\": \"-24.600000381469727\", \"CenterRCoordOfPlaneImage\": \"-7.9000000953674316\", \"CenterSCoordOfPlaneImage\": \"-289.75\", \"DistanceSourceToDetector\": \"949.075012\", \"ImageFromWhichPrescribed\": \"2\", \"PerformedProcedureStepID\": \"PPS ID  20527\", \"NoViewsRefChannelsBlocked\": \"0\\\\0\\\\0\\\\0\", \"PhotometricInterpretation\": \"MONOCHROME2\", \"SeriesFromWhichPrescribed\": \"1\", \"StartTimeSecsInFirstAxial\": \"1449473681.298032\", \"HorizontalFrameOfReference\": \"1772.000000\", \"PositionReferenceIndicator\": \"SN\", \"RACoordOfTargetReconCentre\": \"-7.900000\\\\-24.600000\", \"NameOfPhysiciansReadingStudy\": \"\", \"PerformedProcedureStepStartDate\": \"20151207\", \"PerformedProcedureStepStartTime\": \"073153\", \"DependantOnNumberOfViewsProcessed\": \"2\", \"PerformedProcedureStepDescription\": \"KUNAS\"}', 'a7e558e42b137eab16da6b1d8b57200a9be156dfee811a0a8a366c1fb7a41efa', 'admin', '2026-08-02 20:23:54', 'admin', '2026-08-02 20:23:54', '0');
INSERT INTO `ndt_dicom_object` VALUES (4, 3, 'SR', 'image-000001.dcm', 'ORTHANC', 'fe446e0a-fb1fcfef-4c290fa9-b1ea9520-de8b1d92', NULL, NULL, 'application/dicom', '1.3.6.1.4.1.44316.6.102.3.20250704114423666.30394198594456817768', '1.2.840.10008.5.1.4.1.1.2', NULL, '{\"KVP\": \"120\", \"Rows\": \"1595\", \"VmaMod\": \"0\", \"Columns\": \"888\", \"HighBit\": \"15\", \"StudyID\": \"1\", \"SuiteId\": \"LS16\", \"VmaClip\": \"0\", \"VmaMamp\": \"0\", \"Exposure\": \"87\", \"Modality\": \"CT\", \"ImageType\": \"ORIGINAL\\\\PRIMARY\\\\LOCALIZER\", \"PatientID\": \"0\", \"PlaneType\": \"1\", \"ProductId\": \"LightSpeed Pro\", \"ScoutType\": \"2\", \"StudyDate\": \"20151207\", \"StudyTime\": \"073153\", \"XrayChain\": \"99\\\\99\\\\99\", \"BitsStored\": \"16\", \"DASAdInput\": \"0\", \"DASCalMode\": \"0\", \"DASFpaGain\": \"0\", \"FilterType\": \"BODY FILTER\", \"FocalSpots\": \"1.200000\", \"PatientAge\": \"062Y\", \"PatientSex\": \"M\", \"SeriesDate\": \"20151207\", \"SeriesTime\": \"073153\", \"TableSpeed\": \"0.000000\", \"CellSpacing\": \"1.023900\", \"ContentDate\": \"20151207\", \"ContentTime\": \"073300\", \"LastScanRAS\": \"I\", \"MidScanFlag\": \"0\", \"MidScanTime\": \"0.000000\", \"PatientName\": \"Anonymized^^\", \"PatientSize\": \"1.75\", \"RescaleType\": \"HU\", \"SOPClassUID\": \"1.2.840.10008.5.1.4.1.1.2\", \"ScanFOVType\": \"16\", \"ScanOptions\": \"SCOUT MODE\", \"StationName\": \"\", \"TableHeight\": \"182.500000\", \"WindowValue\": \"500\", \"WindowWidth\": \"500\", \"EquipmentUID\": \"\", \"ExposureTime\": \"8770\", \"FirstScanRAS\": \"S\", \"FullFidelity\": \"CT_LIGHTSPEED\", \"GantryPeriod\": \"0.000000\", \"Manufacturer\": \"GE MEDICAL SYSTEMS\", \"NormalACoord\": \"-6.1230317691118863e-17\", \"NormalRCoord\": \"-1\", \"NormalSCoord\": \"0\", \"PixelSpacing\": \"0.545455\\\\0.596847\", \"ProtocolName\": \"5.8 KUNAS ONKOLOGIJA (dvi fazes)\", \"RescaleSlope\": \" 1\", \"SeriesNumber\": \"1\", \"WindowCenter\": \"50\", \"BitsAllocated\": \"16\", \"OperatorsName\": \"\", \"PatientWeight\": \"91.0\", \"SegmentNumber\": \"0\", \"SliceLocation\": \"70.000\", \"BiopsyPosition\": \"0\", \"DeltaStartTime\": \"0.000000\", \"GeneratorPower\": \"1200\", \"InstanceNumber\": \"2\", \"PrivateCreator\": \"GEMS_HELIOS_01\", \"SOPInstanceUID\": \"1.3.6.1.4.1.44316.6.102.3.20250704114423666.30394198594456817768\", \"ScanPitchRatio\": \"\", \"SeriesContrast\": \"0\", \"SliceThickness\": \"870.000000\", \"AccessionNumber\": \"\", \"AcquisitionDate\": \"20151207\", \"AcquisitionTime\": \"073251\", \"BiopsyTLocation\": \"0\", \"DASOutputSource\": \"0\", \"ImageActualDate\": \"1449473513\", \"InstitutionName\": \"\", \"PatientPosition\": \"FFS\", \"SamplesPerPixel\": \"1\", \"XRayTubeCurrent\": \"10\", \"AngleOfFirstView\": \"0.000000\", \"DASTriggerSource\": \"0\", \"DegreeOfRotation\": \"0\", \"DegreesOfAzimuth\": \"90\", \"DurationOfXrayOn\": \"8.7781820297241211\", \"NumberOfTriggers\": \"4828\", \"PatientBirthDate\": \"\", \"RescaleIntercept\": \" -1024\", \"SoftwareVersions\": \"07MW11.10\", \"StudyDescription\": \"KUNAS\", \"StudyInstanceUID\": \"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\", \"TableEndLocation\": \"-800\", \"TriggerFrequency\": \"550.000000\", \"AcquisitionNumber\": \"2\", \"BiopsyRefLocation\": \"0\", \"CellNumberAtTheta\": \"389.750000\", \"ConvolutionKernel\": \"STANDARD\", \"ReferenceChannels\": \"0\\\\0\\\\0\\\\0\\\\0\\\\0\", \"RotationDirection\": \"CW\", \"SeriesDescription\": \"scout\", \"SeriesInstanceUID\": \"1.3.6.1.4.1.44316.6.102.2.20250704114429771.63133867861500115690\", \"TriggerOnPosition\": \"89.56390380859375\", \"GantryDetectorTilt\": \"0.000000\", \"NumberOfOverranges\": \"-1\", \"PrivateScanOptions\": \"8\\\\0\\\\0\\\\0\", \"SmartScanOnOffFlag\": \"0\", \"TableStartLocation\": \"70\", \"FrameOfReferenceUID\": \"1.2.840.113619.2.55.3.4271045733.996.1449464144.597.17720.5\", \"PixelRepresentation\": \"1\", \"ImagePositionPatient\": \"-0.000\\\\265.000\\\\70.000\", \"InstanceCreationDate\": \"20151207\", \"InstanceCreationTime\": \"073300\", \"MaxOverrangesInAView\": \"0\", \"SpecificCharacterSet\": \"ISO_IR 100\", \"ManufacturerModelName\": \"LightSpeed Pro 16\", \"ViewCompressionFactor\": \"3\", \"DataCollectionDiameter\": \"500.000000\", \"ReconstructionDiameter\": \"\", \"ReferringPhysicianName\": \"\", \"StartScanToXrayOnDelay\": \"0\", \"TotalSegmentsRequested\": \"0\", \"CorrectedAfterglowTerms\": \"0\", \"DistanceSourceToPatient\": \"541.000000\", \"ImageOrientationPatient\": \"0.000000\\\\-1.000000\\\\0.000000\\\\0.000000\\\\0.000000\\\\-1.000000\", \"NumberOfCellsInDetector\": \"912\", \"ReconPostProcessingFlag\": \"1\", \"AdditionalPatientHistory\": \"\", \"CenterACoordOfPlaneImage\": \"0\", \"CenterRCoordOfPlaneImage\": \"0\", \"CenterSCoordOfPlaneImage\": \"-365\", \"DistanceSourceToDetector\": \"949.075012\", \"ImageFromWhichPrescribed\": \"0\", \"PerformedProcedureStepID\": \"PPS ID  20527\", \"NoViewsRefChannelsBlocked\": \"0\\\\0\\\\0\\\\0\", \"PhotometricInterpretation\": \"MONOCHROME2\", \"SeriesFromWhichPrescribed\": \"0\", \"StartTimeSecsInFirstAxial\": \"0\", \"HorizontalFrameOfReference\": \"1772.000000\", \"PositionReferenceIndicator\": \"SN\", \"RACoordOfTargetReconCentre\": \"0.000000\\\\0.000000\", \"NameOfPhysiciansReadingStudy\": \"\", \"PerformedProcedureStepStartDate\": \"20151207\", \"PerformedProcedureStepStartTime\": \"073153\", \"DependantOnNumberOfViewsProcessed\": \"2\", \"PerformedProcedureStepDescription\": \"KUNAS\"}', '828128b708cac60340182cf9b57e822af288bfe630e2ce2e5fa422350fcffd36', 'admin', '2026-08-02 20:47:32', 'admin', '2026-08-02 20:47:32', '0');
INSERT INTO `ndt_dicom_object` VALUES (5, 4, 'ORIGINAL_IMAGE', 'image-000195.dcm', 'ORTHANC', '4013a57c-613cd279-1e6e916a-3ad4ceef-83eef100', NULL, NULL, 'application/dicom', '1.3.6.1.4.1.44316.6.102.3.2025070412239125.151133372912858941086', '1.2.840.10008.5.1.4.1.1.2', NULL, '{\"KVP\": \"120\", \"Rows\": \"512\", \"VmaMod\": \"0\", \"Columns\": \"512\", \"HighBit\": \"15\", \"StudyID\": \"1\", \"SuiteId\": \"LS16\", \"VmaClip\": \"163\", \"VmaMamp\": \"0\", \"Exposure\": \"13\", \"Modality\": \"CT\", \"ImageType\": \"ORIGINAL\\\\PRIMARY\\\\AXIAL\", \"PatientID\": \"0\", \"PlaneType\": \"2\", \"ProductId\": \"LightSpeed Pro\", \"ScoutType\": \"0\", \"StudyDate\": \"20151207\", \"StudyTime\": \"073153\", \"XrayChain\": \"99\\\\99\\\\99\", \"BitsStored\": \"16\", \"DASAdInput\": \"0\", \"DASCalMode\": \"0\", \"DASFpaGain\": \"0\", \"FilterType\": \"BODY FILTER\", \"FocalSpots\": \"1.200000\", \"PatientAge\": \"062Y\", \"PatientSex\": \"M\", \"SeriesDate\": \"20151207\", \"SeriesTime\": \"073419\", \"TableSpeed\": \"35.000000\", \"CellSpacing\": \"1.023900\", \"ContentDate\": \"20151207\", \"ContentTime\": \"073849\", \"LastScanRAS\": \"I\", \"MidScanFlag\": \"1\", \"MidScanTime\": \"1.990000\", \"PatientName\": \"Anonymized^^\", \"PatientSize\": \"1.75\", \"RescaleType\": \"HU\", \"SOPClassUID\": \"1.2.840.10008.5.1.4.1.1.2\", \"ScanFOVType\": \"16\", \"ScanOptions\": \"HELICAL MODE\", \"StationName\": \"\", \"TableHeight\": \"182.500000\", \"WindowValue\": \"1500\", \"WindowWidth\": \"1500\", \"EquipmentUID\": \"\", \"ExposureTime\": \"554\", \"FirstScanRAS\": \"S\", \"FullFidelity\": \"CT_LIGHTSPEED\", \"GantryPeriod\": \"0.700000\", \"Manufacturer\": \"GE MEDICAL SYSTEMS\", \"NormalACoord\": \"0\", \"NormalRCoord\": \"0\", \"NormalSCoord\": \"-1\", \"PixelSpacing\": \"0.703125\\\\0.703125\", \"ProtocolName\": \"5.8 KUNAS ONKOLOGIJA (dvi fazes)\", \"RescaleSlope\": \" 1\", \"SeriesNumber\": \"3\", \"WindowCenter\": \"-500\", \"BitsAllocated\": \"16\", \"OperatorsName\": \"\", \"PatientWeight\": \"91.0\", \"SegmentNumber\": \"0\", \"SliceLocation\": \"-41.250\", \"BiopsyPosition\": \"0\", \"DeltaStartTime\": \"1.712857\", \"GeneratorPower\": \"74400\", \"InstanceNumber\": \"53\", \"PrivateCreator\": \"GEMS_HELIOS_01\", \"RevolutionTime\": \"0.69999998807907104\", \"SOPInstanceUID\": \"1.3.6.1.4.1.44316.6.102.3.2025070412239125.151133372912858941086\", \"ScanPitchRatio\": \"1.75:1\", \"SeriesContrast\": \"0\", \"SliceThickness\": \"1.250000\", \"AccessionNumber\": \"\", \"AcquisitionDate\": \"20151207\", \"AcquisitionTime\": \"073441\", \"BiopsyTLocation\": \"0\", \"DASOutputSource\": \"0\", \"ImageActualDate\": \"1449473659\", \"InstitutionName\": \"\", \"PatientPosition\": \"FFS\", \"SamplesPerPixel\": \"1\", \"XRayTubeCurrent\": \"555\", \"AngleOfFirstView\": \"0.000000\", \"DASTriggerSource\": \"0\", \"DegreeOfRotation\": \"7168.775390625\", \"DegreesOfAzimuth\": \"355\", \"DurationOfXrayOn\": \"13.939285278320312\", \"NumberOfTriggers\": \"19515\", \"PatientBirthDate\": \"\", \"RescaleIntercept\": \" -1024\", \"SoftwareVersions\": \"07MW11.10\", \"StudyDescription\": \"KUNAS\", \"StudyInstanceUID\": \"1.3.6.1.4.1.44316.6.102.1.20250704114423696.33358672119535771932\", \"TableEndLocation\": \"0\", \"TriggerFrequency\": \"1400.000000\", \"AcquisitionNumber\": \"1\", \"BiopsyRefLocation\": \"0\", \"CellNumberAtTheta\": \"389.750000\", \"ConvolutionKernel\": \"LUNG\", \"PixelPaddingValue\": \"-2000\", \"ReferenceChannels\": \"0\\\\0\\\\0\\\\0\\\\0\\\\0\", \"RotationDirection\": \"CW\", \"SeriesDescription\": \"Recon 2: natyve\", \"SeriesInstanceUID\": \"1.3.6.1.4.1.44316.6.102.2.20250704121912287.36535028333355733227\", \"SpiralPitchFactor\": \"1.75\", \"TriggerOnPosition\": \"207.69230651855469\", \"GantryDetectorTilt\": \"0.000000\", \"NumberOfOverranges\": \"-1\", \"PrivateScanOptions\": \"4\\\\0\\\\0\\\\0\", \"SmartScanOnOffFlag\": \"2\", \"TableStartLocation\": \"0\", \"FrameOfReferenceUID\": \"1.2.840.113619.2.55.3.4271045733.996.1449464144.597.17720.5\", \"PixelRepresentation\": \"1\", \"ImagePositionPatient\": \"-163.700\\\\-118.200\\\\-41.250\", \"InstanceCreationDate\": \"20151207\", \"InstanceCreationTime\": \"073849\", \"MaxOverrangesInAView\": \"0\", \"SpecificCharacterSet\": \"ISO_IR 100\", \"TableFeedPerRotation\": \"35\", \"ManufacturerModelName\": \"LightSpeed Pro 16\", \"TotalCollimationWidth\": \"20\", \"ViewCompressionFactor\": \"1\", \"DataCollectionDiameter\": \"500.000000\", \"ReconstructionDiameter\": \"360.000000\", \"ReferringPhysicianName\": \"\", \"SingleCollimationWidth\": \"1.25\", \"StartScanToXrayOnDelay\": \"0\", \"TotalSegmentsRequested\": \"0\", \"CorrectedAfterglowTerms\": \"0\", \"DistanceSourceToPatient\": \"541.000000\", \"ImageOrientationPatient\": \"1.000000\\\\0.000000\\\\0.000000\\\\0.000000\\\\1.000000\\\\0.000000\", \"NumberOfCellsInDetector\": \"912\", \"ReconPostProcessingFlag\": \"1\", \"ReferencedImageSequence\": [{\"ReferencedSOPClassUID\": \"1.2.840.10008.5.1.4.1.1.2\", \"ReferencedSOPInstanceUID\": \"1.3.6.1.4.1.44316.6.102.3.20250704114423666.30394198594456817768\"}], \"AdditionalPatientHistory\": \"\", \"CenterACoordOfPlaneImage\": \"-61.799999237060547\", \"CenterRCoordOfPlaneImage\": \"-16.299999237060547\", \"CenterSCoordOfPlaneImage\": \"-41.25\", \"DistanceSourceToDetector\": \"949.075012\", \"ImageFromWhichPrescribed\": \"2\", \"PerformedProcedureStepID\": \"PPS ID  20527\", \"NoViewsRefChannelsBlocked\": \"0\\\\0\\\\0\\\\0\", \"PhotometricInterpretation\": \"MONOCHROME2\", \"SeriesFromWhichPrescribed\": \"1\", \"StartTimeSecsInFirstAxial\": \"1449473681.298032\", \"HorizontalFrameOfReference\": \"1772.000000\", \"PositionReferenceIndicator\": \"SN\", \"RACoordOfTargetReconCentre\": \"-16.299999\\\\-61.799999\", \"NameOfPhysiciansReadingStudy\": \"\", \"PerformedProcedureStepStartDate\": \"20151207\", \"PerformedProcedureStepStartTime\": \"073153\", \"DependantOnNumberOfViewsProcessed\": \"3\", \"PerformedProcedureStepDescription\": \"KUNAS\"}', '415266b9dd13bd76fab555bfefac6cc58a0deefa4240ac05662e621e9121dddd', 'admin', '2026-08-02 22:23:40', 'admin', '2026-08-02 22:23:40', '0');

-- ----------------------------
-- Table structure for ndt_dicom_object_relation
-- ----------------------------
DROP TABLE IF EXISTS `ndt_dicom_object_relation`;
CREATE TABLE `ndt_dicom_object_relation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '对象关系主键',
  `source_object_id` bigint NOT NULL COMMENT '来源对象主键',
  `target_object_id` bigint NOT NULL COMMENT '目标或衍生对象主键',
  `relation_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关系类型',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ndt_object_relation`(`source_object_id` ASC, `target_object_id` ASC, `relation_type` ASC) USING BTREE,
  INDEX `idx_ndt_relation_target`(`target_object_id` ASC) USING BTREE,
  CONSTRAINT `fk_ndt_relation_source` FOREIGN KEY (`source_object_id`) REFERENCES `ndt_dicom_object` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ndt_relation_target` FOREIGN KEY (`target_object_id`) REFERENCES `ndt_dicom_object` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_ndt_relation_distinct` CHECK (`source_object_id` <> `target_object_id`),
  CONSTRAINT `chk_ndt_relation_type` CHECK (`relation_type` in (_utf8mb4'DERIVED_FROM',_utf8mb4'REFERENCES',_utf8mb4'GENERATED_FROM'))
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'NDT DICOM对象关系表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_dicom_object_relation
-- ----------------------------
INSERT INTO `ndt_dicom_object_relation` VALUES (1, 1, 2, 'DERIVED_FROM', NULL, 'admin', '2026-08-02 20:19:26');
INSERT INTO `ndt_dicom_object_relation` VALUES (2, 1, 4, 'GENERATED_FROM', NULL, 'admin', '2026-08-02 20:47:32');

-- ----------------------------
-- Table structure for ndt_dicom_private_tag
-- ----------------------------
DROP TABLE IF EXISTS `ndt_dicom_private_tag`;
CREATE TABLE `ndt_dicom_private_tag`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tag_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Orthanc/DICOM标签名称或私有标签关键字',
  `tag_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '显示名称',
  `tag_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'DICOM标签号',
  `vr` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '值表示VR',
  `default_value` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '新增默认值',
  `enabled` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '1' COMMENT '是否启用',
  `builtin` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '是否内置',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ndt_private_tag_name`(`tag_name` ASC) USING BTREE,
  INDEX `idx_ndt_private_tag_enabled`(`enabled` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'NDT允许编辑的DICOM私有标签配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_dicom_private_tag
-- ----------------------------
INSERT INTO `ndt_dicom_private_tag` VALUES (1, 'Manufacturer', '制造商', '0008,0070', 'LO', '', '1', '1', 'DICOM标准制造商标签', 'admin', '2026-06-04 17:49:58', '', NULL, '0');
INSERT INTO `ndt_dicom_private_tag` VALUES (2, '0011,0010', 'NDT私有标签创建者', '0011,0010', 'LO', 'RuoYiNDT', '0', '1', 'NDT私有标签块创建者', 'admin', '2026-06-04 17:49:58', 'admin', '2026-06-04 19:22:22', '2');
INSERT INTO `ndt_dicom_private_tag` VALUES (3, 'NdtClientName', '委托方', '0011,1010', 'LO', '', '1', '1', 'NDT私有标签：委托方', 'admin', '2026-06-04 17:49:58', 'admin', '2026-06-04 19:22:01', '0');
INSERT INTO `ndt_dicom_private_tag` VALUES (4, 'NdtInspectorName', '检测人员', '0011,1011', 'LO', '', '1', '1', 'NDT私有标签：检测人员', 'admin', '2026-06-04 17:49:58', 'admin', '2026-06-04 19:22:11', '0');
INSERT INTO `ndt_dicom_private_tag` VALUES (5, 'NdtEvaluationConclusion', '评定结论', '0011,1012', 'LT', '', '1', '1', 'NDT私有标签：评定结论', 'admin', '2026-06-04 17:49:58', 'admin', '2026-06-04 19:22:17', '0');
INSERT INTO `ndt_dicom_private_tag` VALUES (6, 'PatientName', '工件名称', '0010,0010', 'PN', '', '1', '0', NULL, 'admin', '2026-06-04 18:55:04', 'admin', '2026-06-04 18:55:04', '0');

-- ----------------------------
-- Table structure for ndt_dicom_series
-- ----------------------------
DROP TABLE IF EXISTS `ndt_dicom_series`;
CREATE TABLE `ndt_dicom_series`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `study_id` bigint NOT NULL,
  `workpiece_id` bigint NOT NULL,
  `position_id` bigint NOT NULL,
  `series_instance_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `modality` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `series_number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `series_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `orthanc_series_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NULL DEFAULT NULL,
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ndt_series_uid`(`series_instance_uid` ASC) USING BTREE,
  INDEX `idx_ndt_series_study`(`study_id` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_ndt_series_position`(`position_id` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_ndt_series_study_workpiece`(`study_id` ASC, `workpiece_id` ASC) USING BTREE,
  INDEX `idx_ndt_series_position_workpiece`(`position_id` ASC, `workpiece_id` ASC) USING BTREE,
  CONSTRAINT `fk_ndt_series_position_workpiece` FOREIGN KEY (`position_id`, `workpiece_id`) REFERENCES `ndt_inspection_position` (`id`, `workpiece_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ndt_series_study_workpiece` FOREIGN KEY (`study_id`, `workpiece_id`) REFERENCES `ndt_inspection_study` (`id`, `workpiece_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_dicom_series
-- ----------------------------
INSERT INTO `ndt_dicom_series` VALUES (1, 1, 3, 7, '1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160', 'CT', '200', 'Smart Prep Series', 'c9562219-175ad9a2-47fcb4d0-2fd6b507-082a381b', 'admin', '2026-08-02 20:18:56', 'admin', '2026-08-02 20:18:56', '0');
INSERT INTO `ndt_dicom_series` VALUES (2, 1, 3, 8, '1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027234284793743', 'CT', '200', 'Smart Prep Series', 'bcbf7f4f-21306533-1203819c-bfa2af7e-1f51dca3', 'admin', '2026-08-02 20:23:54', 'admin', '2026-08-02 20:23:54', '0');
INSERT INTO `ndt_dicom_series` VALUES (3, 1, 3, 7, '1.3.6.1.4.1.44316.6.102.2.20250704114429771.63133867861500115690', 'CT', '1', 'scout', '445d7d9c-f8d82385-de251313-e6c40e5f-0643a602', 'admin', '2026-08-02 20:47:32', 'admin', '2026-08-02 20:47:32', '0');
INSERT INTO `ndt_dicom_series` VALUES (4, 2, 3, 7, '1.3.6.1.4.1.44316.6.102.2.20250704121912287.36535028333355733227', 'CT', '3', 'Recon 2: natyve', 'a2fc0a65-7cd438d2-daaac325-50a16bee-0a9c32fb', 'admin', '2026-08-02 22:23:40', 'admin', '2026-08-02 22:23:40', '0');

-- ----------------------------
-- Table structure for ndt_evaluation
-- ----------------------------
DROP TABLE IF EXISTS `ndt_evaluation`;
CREATE TABLE `ndt_evaluation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评定主键',
  `evaluation_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评定类型（DEFECT或WORKPIECE）',
  `defect_id` bigint NULL DEFAULT NULL COMMENT '缺陷主键',
  `workpiece_id` bigint NULL DEFAULT NULL COMMENT '工件主键',
  `level` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '评定等级',
  `conclusion` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '评定结论',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '评定说明',
  `evaluator_id` bigint NULL DEFAULT NULL COMMENT '评定人员用户ID',
  `evaluation_time` datetime NULL DEFAULT NULL COMMENT '评定时间',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DRAFT' COMMENT '评定状态',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ndt_evaluation_defect`(`defect_id` ASC) USING BTREE,
  INDEX `idx_ndt_evaluation_workpiece`(`workpiece_id` ASC) USING BTREE,
  INDEX `idx_ndt_evaluation_evaluator`(`evaluator_id` ASC) USING BTREE,
  INDEX `idx_ndt_evaluation_status`(`status` ASC) USING BTREE,
  CONSTRAINT `fk_ndt_evaluation_defect` FOREIGN KEY (`defect_id`) REFERENCES `ndt_defect` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ndt_evaluation_workpiece` FOREIGN KEY (`workpiece_id`) REFERENCES `ndt_workpiece` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_ndt_evaluation_target` CHECK (((`evaluation_type` = _utf8mb4'DEFECT') and (`defect_id` is not null) and (`workpiece_id` is null)) or ((`evaluation_type` = _utf8mb4'WORKPIECE') and (`workpiece_id` is not null) and (`defect_id` is null)))
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'NDT评定表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_evaluation
-- ----------------------------
INSERT INTO `ndt_evaluation` VALUES (1, 'WORKPIECE', NULL, 3, '1', '工件测试评定', '111111', 1, '2026-08-02 20:47:31', 'SUBMITTED', 'admin', '2026-08-02 20:40:05', 'admin', '2026-08-02 20:47:31', '0');

-- ----------------------------
-- Table structure for ndt_evaluation_review
-- ----------------------------
DROP TABLE IF EXISTS `ndt_evaluation_review`;
CREATE TABLE `ndt_evaluation_review`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '复核主键',
  `evaluation_id` bigint NOT NULL COMMENT '被复核的评定主键',
  `review_result` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '复核结果（PASS或REJECT）',
  `review_comment` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '复核意见',
  `reviewer_id` bigint NOT NULL COMMENT '复核人员用户ID',
  `review_time` datetime NOT NULL COMMENT '复核时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ndt_review_evaluation`(`evaluation_id` ASC) USING BTREE,
  INDEX `idx_ndt_review_reviewer`(`reviewer_id` ASC) USING BTREE,
  INDEX `idx_ndt_review_time`(`review_time` ASC) USING BTREE,
  CONSTRAINT `fk_ndt_review_evaluation` FOREIGN KEY (`evaluation_id`) REFERENCES `ndt_evaluation` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_ndt_review_result` CHECK (`review_result` in (_utf8mb4'PASS',_utf8mb4'REJECT'))
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'NDT评定复核记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_evaluation_review
-- ----------------------------

-- ----------------------------
-- Table structure for ndt_inspection_position
-- ----------------------------
DROP TABLE IF EXISTS `ndt_inspection_position`;
CREATE TABLE `ndt_inspection_position`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '检测部位主键',
  `workpiece_id` bigint NOT NULL COMMENT '所属工件主键',
  `position_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部位名称',
  `position_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部位编码',
  `sort_no` int NOT NULL DEFAULT 0 COMMENT '排序号',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ndt_position_code`(`workpiece_id` ASC, `position_code` ASC) USING BTREE,
  UNIQUE INDEX `uk_ndt_position_id_workpiece`(`id` ASC, `workpiece_id` ASC) USING BTREE,
  INDEX `idx_ndt_position_workpiece_sort`(`workpiece_id` ASC, `sort_no` ASC) USING BTREE,
  CONSTRAINT `fk_ndt_position_workpiece` FOREIGN KEY (`workpiece_id`) REFERENCES `ndt_workpiece` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'NDT检测部位表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_inspection_position
-- ----------------------------
INSERT INTO `ndt_inspection_position` VALUES (1, 1, '螺纹', '1', 1, '螺纹备注', 'admin', '2026-07-29 19:21:47', 'admin', '2026-07-29 19:21:47', '0');
INSERT INTO `ndt_inspection_position` VALUES (2, 1, '螺丝头', '2', 0, '螺丝头备注', 'admin', '2026-07-29 19:36:41', 'admin', '2026-07-29 19:36:41', '0');
INSERT INTO `ndt_inspection_position` VALUES (3, 1, '螺母', '3', 0, '螺母备注', 'admin', '2026-07-29 19:38:08', 'admin', '2026-07-29 19:41:08', '0');
INSERT INTO `ndt_inspection_position` VALUES (4, 1, '螺柱', '4', 1, 'test', 'admin', '2026-07-29 19:38:30', 'admin', '2026-07-29 19:38:30', '0');
INSERT INTO `ndt_inspection_position` VALUES (5, 1, 'test', '5', 0, 'test2', 'admin', '2026-07-29 19:40:45', 'admin', '2026-07-29 19:40:45', '0');
INSERT INTO `ndt_inspection_position` VALUES (6, 2, '工件正面', '1', 0, '', 'admin', '2026-07-29 19:50:22', 'admin', '2026-07-29 19:50:22', '0');
INSERT INTO `ndt_inspection_position` VALUES (7, 3, '1号焊缝', 'P01', 0, '', 'admin', '2026-08-02 19:17:03', 'admin', '2026-08-02 19:17:03', '0');
INSERT INTO `ndt_inspection_position` VALUES (8, 3, '2号焊缝', 'P02', 0, '', 'admin', '2026-08-02 19:17:18', 'admin', '2026-08-02 19:17:18', '0');

-- ----------------------------
-- Table structure for ndt_inspection_study
-- ----------------------------
DROP TABLE IF EXISTS `ndt_inspection_study`;
CREATE TABLE `ndt_inspection_study`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `workpiece_id` bigint NOT NULL,
  `study_instance_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `inspection_method_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `study_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `study_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `study_date` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `study_time` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `orthanc_study_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NULL DEFAULT NULL,
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ndt_study_uid`(`study_instance_uid` ASC) USING BTREE,
  UNIQUE INDEX `uk_ndt_study_id_workpiece`(`id` ASC, `workpiece_id` ASC) USING BTREE,
  INDEX `idx_ndt_study_workpiece`(`workpiece_id` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_ndt_study_method`(`inspection_method_code` ASC) USING BTREE,
  CONSTRAINT `fk_ndt_study_workpiece` FOREIGN KEY (`workpiece_id`) REFERENCES `ndt_workpiece` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_inspection_study
-- ----------------------------
INSERT INTO `ndt_inspection_study` VALUES (1, 3, '1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932', 'CT', '1', 'KUNAS', '20151207', '073153', 'a2390fab-3be3e31b-268f6c22-4eb2e70f-6e5d1726', 'ACTIVE', 'admin', '2026-08-02 20:18:56', 'admin', '2026-08-02 20:18:56', '0');
INSERT INTO `ndt_inspection_study` VALUES (2, 3, '1.3.6.1.4.1.44316.6.102.1.20250704114423696.33358672119535771932', 'CT', '1', 'KUNAS', '20151207', '073153', '33571643-081a1e28-d97f9dd1-f6d43eb7-1a3a664a', 'ACTIVE', 'admin', '2026-08-02 22:23:40', 'admin', '2026-08-02 22:23:40', '0');

-- ----------------------------
-- Table structure for ndt_inspection_task
-- ----------------------------
DROP TABLE IF EXISTS `ndt_inspection_task`;
CREATE TABLE `ndt_inspection_task`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '检测任务主键',
  `customer_id` bigint NOT NULL COMMENT '所属客户主键',
  `task_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `task_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务编号',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DRAFT' COMMENT '任务状态',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `finish_time` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '任务说明',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ndt_task_no`(`task_no` ASC) USING BTREE,
  INDEX `idx_ndt_task_customer`(`customer_id` ASC) USING BTREE,
  INDEX `idx_ndt_task_status`(`status` ASC) USING BTREE,
  INDEX `idx_ndt_task_start_time`(`start_time` ASC) USING BTREE,
  CONSTRAINT `fk_ndt_task_customer` FOREIGN KEY (`customer_id`) REFERENCES `ndt_customer` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'NDT检测任务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_inspection_task
-- ----------------------------
INSERT INTO `ndt_inspection_task` VALUES (1, 3, '螺丝螺纹检测', 'NDT20260729181318b4f834', 'DRAFT', '2026-07-29 00:00:00', '2026-07-30 00:00:00', '螺丝螺纹检测任务说明', 'admin', '2026-07-29 18:13:18', 'admin', '2026-07-29 18:13:18', '0');
INSERT INTO `ndt_inspection_task` VALUES (2, 3, 'test', 'NDT2026080212411396ea58', 'DRAFT', NULL, NULL, '', 'admin', '2026-08-02 12:41:13', 'admin', '2026-08-02 12:41:13', '0');
INSERT INTO `ndt_inspection_task` VALUES (3, 3, '测试任务A', 'NDT20260802191631a4e0b1', 'DRAFT', NULL, NULL, '', 'admin', '2026-08-02 19:16:31', 'admin', '2026-08-02 19:16:31', '0');

-- ----------------------------
-- Table structure for ndt_inspector_profile
-- ----------------------------
DROP TABLE IF EXISTS `ndt_inspector_profile`;
CREATE TABLE `ndt_inspector_profile`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `inspector_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '检测人员编号',
  `certificate_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '证书编号',
  `certificate_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '证书名称',
  `qualification_level` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '资质等级',
  `issue_date` date NULL DEFAULT NULL COMMENT '发证日期',
  `expire_date` date NULL DEFAULT NULL COMMENT '有效期至',
  `certificate_file` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '证书附件地址',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ndt_inspector_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_ndt_inspector_no`(`inspector_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'NDT检测人员扩展档案表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_inspector_profile
-- ----------------------------

-- ----------------------------
-- Table structure for ndt_task_report
-- ----------------------------
DROP TABLE IF EXISTS `ndt_task_report`;
CREATE TABLE `ndt_task_report`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务报告主键',
  `task_id` bigint NOT NULL COMMENT '所属检测任务主键',
  `report_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '报告名称',
  `version` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '报告版本',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件系统路径',
  `object_key` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '对象存储Key',
  `sha256` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '报告文件SHA-256摘要',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DRAFT' COMMENT '报告状态',
  `generate_by` bigint NULL DEFAULT NULL COMMENT '生成人员用户ID',
  `generate_time` datetime NULL DEFAULT NULL COMMENT '生成时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ndt_report_version`(`task_id` ASC, `version` ASC) USING BTREE,
  INDEX `idx_ndt_report_status`(`status` ASC) USING BTREE,
  INDEX `idx_ndt_report_generate_time`(`generate_time` ASC) USING BTREE,
  CONSTRAINT `fk_ndt_report_task` FOREIGN KEY (`task_id`) REFERENCES `ndt_inspection_task` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'NDT任务级PDF报告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_task_report
-- ----------------------------
INSERT INTO `ndt_task_report` VALUES (1, 3, '房屋租赁合同FWZL2026060337723420260801121852.pdf', '1', 'C:\\Users\\china\\Code\\RuoYi-profile\\ndt-reports\\3\\v1-房屋租赁合同FWZL2026060337723420260801121852.pdf', NULL, 'be41c42136318ce361e5f02cd90fc171b249678a5fbe95942b01edf1033a293c', 'DRAFT', 1, '2026-08-02 21:00:01', 'admin', '2026-08-02 21:00:00', 'admin', '2026-08-02 21:00:00');

-- ----------------------------
-- Table structure for ndt_task_user
-- ----------------------------
DROP TABLE IF EXISTS `ndt_task_user`;
CREATE TABLE `ndt_task_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `task_id` bigint NOT NULL COMMENT '任务ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `task_role` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务角色：CREATOR/UPLOADER/EVALUATOR/VIEWER',
  `can_evaluate` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '是否可评定',
  `can_upload` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '是否可上传',
  `can_view` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '1' COMMENT '是否可查看',
  `assigned_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '分配人',
  `assigned_time` datetime NULL DEFAULT NULL COMMENT '分配时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ndt_task_user_role`(`task_id` ASC, `user_id` ASC, `task_role` ASC) USING BTREE,
  INDEX `idx_ndt_task_user_task`(`task_id` ASC) USING BTREE,
  INDEX `idx_ndt_task_user_user`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'NDT检测任务用户分配表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_task_user
-- ----------------------------
INSERT INTO `ndt_task_user` VALUES (38, 1, 100, 'CREATOR', '1', '1', '1', 'admin', '2026-07-29 20:00:25');
INSERT INTO `ndt_task_user` VALUES (39, 1, 101, 'EVALUATOR', '1', '0', '1', 'admin', '2026-07-29 20:00:25');
INSERT INTO `ndt_task_user` VALUES (40, 2, 1, 'CREATOR', '1', '1', '1', 'admin', '2026-08-02 12:41:13');
INSERT INTO `ndt_task_user` VALUES (41, 3, 1, 'CREATOR', '1', '1', '1', 'admin', '2026-08-02 19:16:31');

-- ----------------------------
-- Table structure for ndt_uid_rule
-- ----------------------------
DROP TABLE IF EXISTS `ndt_uid_rule`;
CREATE TABLE `ndt_uid_rule`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `rule_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '规则名称',
  `uid_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'UID类型',
  `root_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '根类型',
  `uid_root` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'UID根',
  `suffix_pattern` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '后缀模式',
  `enabled` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '1' COMMENT '是否启用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ndt_uid_rule_type`(`uid_type` ASC, `enabled` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'NDT UID规则配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_uid_rule
-- ----------------------------
INSERT INTO `ndt_uid_rule` VALUES (1, '默认2.25 Study UID', 'STUDY', 'UUID_2_25', NULL, NULL, '0', '第一阶段默认Study UID规则', 'admin', '2026-05-29 23:34:02', 'admin', '2026-06-02 14:50:39', '0');
INSERT INTO `ndt_uid_rule` VALUES (2, '默认2.25 Series UID', 'SERIES', 'CUSTOM_ROOT', '123', 'study.124123123123.11111', '1', '第一阶段默认Series UID规则', 'admin', '2026-05-29 23:34:02', 'admin', '2026-06-02 15:07:28', '0');
INSERT INTO `ndt_uid_rule` VALUES (3, '默认2.25 SOP UID', 'SOP_INSTANCE', 'UUID_2_25', NULL, NULL, '1', '第一阶段默认SOPInstance UID规则', 'admin', '2026-05-29 23:34:02', '', NULL, '0');
INSERT INTO `ndt_uid_rule` VALUES (4, 'test', 'STUDY', 'CUSTOM_ROOT', '111.233.45.5', '12123', '1', NULL, 'admin', '2026-06-02 15:39:05', 'admin', '2026-06-02 15:39:26', '2');
INSERT INTO `ndt_uid_rule` VALUES (5, 'test444', 'STUDY', 'CUSTOM_ROOT', '111.222', '33333.{random}', '1', NULL, 'admin', '2026-06-02 15:40:00', 'admin', '2026-06-02 15:40:00', '0');

-- ----------------------------
-- Table structure for ndt_workpiece
-- ----------------------------
DROP TABLE IF EXISTS `ndt_workpiece`;
CREATE TABLE `ndt_workpiece`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '工件主键',
  `task_id` bigint NOT NULL COMMENT '所属检测任务主键',
  `workpiece_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工件名称',
  `sort_no` int NOT NULL DEFAULT 0 COMMENT '排序号',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PENDING' COMMENT '工件状态',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ndt_workpiece_task`(`task_id` ASC) USING BTREE,
  INDEX `idx_ndt_workpiece_task_sort`(`task_id` ASC, `sort_no` ASC) USING BTREE,
  CONSTRAINT `fk_ndt_workpiece_task` FOREIGN KEY (`task_id`) REFERENCES `ndt_inspection_task` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'NDT工件表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ndt_workpiece
-- ----------------------------
INSERT INTO `ndt_workpiece` VALUES (1, 1, '一号螺丝', 0, 'PENDING', '一号螺丝备注', 'admin', '2026-07-29 19:20:20', 'admin', '2026-07-29 19:20:20', '0');
INSERT INTO `ndt_workpiece` VALUES (2, 1, '二号工件', 1, 'PENDING', '二号螺丝备注', 'admin', '2026-07-29 19:20:54', 'admin', '2026-07-29 19:20:54', '0');
INSERT INTO `ndt_workpiece` VALUES (3, 3, '工件A', 0, 'PENDING', '', 'admin', '2026-08-02 19:16:42', 'admin', '2026-08-02 19:16:42', '0');

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '日历信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '已触发的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '任务详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '暂停的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '调度器状态表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '触发器详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2026-03-31 17:46:33', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2026-03-31 17:46:33', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2026-03-31 17:46:33', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2026-03-31 17:46:33', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2026-03-31 17:46:33', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2026-03-31 17:46:33', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2026-03-31 17:46:33', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2026-03-31 17:46:33', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 201 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '宁波中科检测', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 17:46:33', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '宁波总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 17:46:33', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '杭州分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2026-03-31 17:46:33', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 17:46:33', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 17:46:33', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 17:46:33', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 17:46:33', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-03-31 17:46:33', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2026-03-31 17:46:33', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2026-03-31 17:46:33', '', NULL);
INSERT INTO `sys_dept` VALUES (200, 101, '0,100,101', '客户部门', 6, '张三', NULL, NULL, '0', '0', 'admin', '2026-06-05 13:23:04', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 146 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (111, 1, '草稿', 'DRAFT', 'ndt_task_status', NULL, 'info', 'Y', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (112, 2, '进行中', 'IN_PROGRESS', 'ndt_task_status', NULL, 'warning', 'N', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (113, 3, '已完成', 'COMPLETED', 'ndt_task_status', NULL, 'success', 'N', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (114, 4, '已关闭', 'CLOSED', 'ndt_task_status', NULL, 'info', 'N', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (116, 1, '创建者', 'CREATOR', 'ndt_task_role', NULL, 'primary', 'N', '0', 'admin', '2026-05-29 23:34:02', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (117, 2, '上传者', 'UPLOADER', 'ndt_task_role', NULL, 'warning', 'N', '0', 'admin', '2026-05-29 23:34:02', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (118, 3, '评定者', 'EVALUATOR', 'ndt_task_role', NULL, 'success', 'N', '0', 'admin', '2026-05-29 23:34:02', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (119, 4, '查看者', 'VIEWER', 'ndt_task_role', NULL, 'info', 'Y', '0', 'admin', '2026-05-29 23:34:02', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (120, 1, '未知', 'UNKNOWN', 'ndt_integrity_status', NULL, 'info', 'Y', '0', 'admin', '2026-05-29 23:34:02', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (121, 2, '通过', 'PASS', 'ndt_integrity_status', NULL, 'success', 'N', '0', 'admin', '2026-05-29 23:34:02', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (122, 3, '失败', 'FAIL', 'ndt_integrity_status', NULL, 'danger', 'N', '0', 'admin', '2026-05-29 23:34:02', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (123, 1, 'Study', 'STUDY', 'ndt_uid_type', NULL, 'primary', 'Y', '0', 'admin', '2026-05-29 23:34:02', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (124, 2, 'Series', 'SERIES', 'ndt_uid_type', NULL, 'primary', 'N', '0', 'admin', '2026-05-29 23:34:02', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (125, 3, 'SOP Instance', 'SOP_INSTANCE', 'ndt_uid_type', NULL, 'primary', 'N', '0', 'admin', '2026-05-29 23:34:02', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (126, 1, '2.25.UUID', 'UUID_2_25', 'ndt_uid_root_type', NULL, 'success', 'Y', '0', 'admin', '2026-05-29 23:34:02', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (127, 2, '自定义Root', 'CUSTOM_ROOT', 'ndt_uid_root_type', NULL, 'warning', 'N', '0', 'admin', '2026-05-29 23:34:02', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (128, 1, '草稿', 'DRAFT', 'ndt_evaluation_status', NULL, 'info', 'Y', '0', 'admin', '2026-05-29 23:34:02', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (129, 2, '已提交', 'SUBMITTED', 'ndt_evaluation_status', NULL, 'success', 'N', '0', 'admin', '2026-05-29 23:34:02', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (130, 1, '待处理', 'PENDING', 'ndt_workpiece_status', NULL, 'info', 'Y', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (131, 2, '进行中', 'IN_PROGRESS', 'ndt_workpiece_status', NULL, 'warning', 'N', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (132, 3, '已完成', 'COMPLETED', 'ndt_workpiece_status', NULL, 'success', 'N', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (133, 1, '原始图像', 'ORIGINAL_IMAGE', 'ndt_object_type', NULL, 'primary', 'Y', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (134, 2, '处理图像', 'PROCESSED_IMAGE', 'ndt_object_type', NULL, 'warning', 'N', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (135, 3, '截图', 'SCREENSHOT', 'ndt_object_type', NULL, 'info', 'N', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (136, 4, '标注图像', 'ANNOTATION_IMAGE', 'ndt_object_type', NULL, 'info', 'N', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (137, 5, '显示状态', 'PRESENTATION_STATE', 'ndt_object_type', NULL, 'info', 'N', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (138, 6, '结构化报告', 'SR', 'ndt_object_type', NULL, 'success', 'N', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (139, 7, '其他', 'OTHER', 'ndt_object_type', NULL, 'info', 'N', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (140, 1, '缺陷评定', 'DEFECT', 'ndt_evaluation_type', NULL, 'primary', 'Y', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (141, 2, '工件评定', 'WORKPIECE', 'ndt_evaluation_type', NULL, 'primary', 'N', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (142, 1, '草稿', 'DRAFT', 'ndt_report_status', NULL, 'info', 'Y', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (143, 2, '已发布', 'RELEASED', 'ndt_report_status', NULL, 'success', 'N', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (144, 1, '通过', 'PASS', 'ndt_review_result', NULL, 'success', 'Y', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (145, 2, '驳回', 'REJECT', 'ndt_review_result', NULL, 'danger', 'N', '0', 'admin', '2026-07-29 00:00:31', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 115 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (104, 'NDT任务状态', 'ndt_task_status', '0', 'admin', '2026-05-29 23:34:02', 'admin', '2026-07-29 00:00:31', '新任务模型状态');
INSERT INTO `sys_dict_type` VALUES (105, 'NDT任务角色', 'ndt_task_role', '0', 'admin', '2026-05-29 23:34:02', '', NULL, 'NDT任务分配角色');
INSERT INTO `sys_dict_type` VALUES (106, 'NDT完整性状态', 'ndt_integrity_status', '0', 'admin', '2026-05-29 23:34:02', '', NULL, 'NDT完整性校验状态');
INSERT INTO `sys_dict_type` VALUES (107, 'NDT UID类型', 'ndt_uid_type', '0', 'admin', '2026-05-29 23:34:02', '', NULL, 'NDT UID类型');
INSERT INTO `sys_dict_type` VALUES (108, 'NDT UID根类型', 'ndt_uid_root_type', '0', 'admin', '2026-05-29 23:34:02', '', NULL, 'NDT UID根类型');
INSERT INTO `sys_dict_type` VALUES (109, 'NDT评定状态', 'ndt_evaluation_status', '0', 'admin', '2026-05-29 23:34:02', '', NULL, 'NDT评定状态');
INSERT INTO `sys_dict_type` VALUES (110, 'NDT工件状态', 'ndt_workpiece_status', '0', 'admin', '2026-07-29 00:00:31', '', NULL, '新工件模型状态');
INSERT INTO `sys_dict_type` VALUES (111, 'NDT对象类型', 'ndt_object_type', '0', 'admin', '2026-07-29 00:00:31', '', NULL, 'DICOM及派生对象类型');
INSERT INTO `sys_dict_type` VALUES (112, 'NDT评定类型', 'ndt_evaluation_type', '0', 'admin', '2026-07-29 00:00:31', '', NULL, '缺陷或工件评定');
INSERT INTO `sys_dict_type` VALUES (113, 'NDT报告状态', 'ndt_report_status', '0', 'admin', '2026-07-29 00:00:31', '', NULL, '任务PDF报告状态');
INSERT INTO `sys_dict_type` VALUES (114, 'NDT复核结果', 'ndt_review_result', '0', 'admin', '2026-07-29 00:00:31', '', NULL, '评定复核结果');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2026-03-31 17:46:34', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2026-03-31 17:46:34', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2026-03-31 17:46:34', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '异常信息',
  `start_time` datetime NULL DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (1, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-29 16:49:42');
INSERT INTO `sys_logininfor` VALUES (2, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-29 17:43:42');
INSERT INTO `sys_logininfor` VALUES (3, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-29 19:19:09');
INSERT INTO `sys_logininfor` VALUES (4, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-29 23:15:53');
INSERT INTO `sys_logininfor` VALUES (5, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-08-01 17:32:58');
INSERT INTO `sys_logininfor` VALUES (6, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '1', '验证码错误', '2026-08-01 18:35:09');
INSERT INTO `sys_logininfor` VALUES (7, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-08-01 18:35:13');
INSERT INTO `sys_logininfor` VALUES (8, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-08-01 19:34:26');
INSERT INTO `sys_logininfor` VALUES (9, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-08-02 08:34:46');
INSERT INTO `sys_logininfor` VALUES (10, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-08-04 14:54:09');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2094 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2026-03-31 17:46:33', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2026-03-31 17:46:33', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2026-03-31 17:46:33', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'M', '0', '1', '', 'guide', 'admin', '2026-03-31 17:46:33', 'admin', '2026-06-02 16:27:09', '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2026-03-31 17:46:33', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2026-03-31 17:46:33', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2026-03-31 17:46:33', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2026-03-31 17:46:33', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2026-03-31 17:46:33', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2026-03-31 17:46:33', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2026-03-31 17:46:33', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2026-03-31 17:46:33', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2026-03-31 17:46:33', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2026-03-31 17:46:33', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2026-03-31 17:46:33', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2026-03-31 17:46:33', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2026-03-31 17:46:33', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2026-03-31 17:46:33', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2026-03-31 17:46:33', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2026-03-31 17:46:33', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2026-03-31 17:46:33', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2026-03-31 17:46:33', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2026-03-31 17:46:33', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2026-03-31 17:46:33', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2013, '无损检测管理', 0, 5, 'ndt', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2026-05-29 23:34:02', '', NULL, 'NDT DICOM业务管理目录');
INSERT INTO `sys_menu` VALUES (2014, '检测任务管理', 2013, 1, 'task', 'ndt/task/index', '', '', 1, 0, 'C', '0', '0', 'ndt:task:list', 'list', 'admin', '2026-05-29 23:34:02', '', NULL, 'NDT检测任务管理');
INSERT INTO `sys_menu` VALUES (2015, 'DCM文件管理', 2013, 2, 'dicom', 'ndt/dicom/index', '', '', 1, 0, 'C', '0', '0', 'ndt:dicom:list', 'upload', 'admin', '2026-05-29 23:34:02', 'admin', '2026-06-02 16:28:26', 'NDT DICOM文件管理');
INSERT INTO `sys_menu` VALUES (2016, '检测人员档案', 2013, 3, 'inspector', 'ndt/inspector/index', '', '', 1, 0, 'C', '0', '0', 'ndt:inspector:list', 'peoples', 'admin', '2026-05-29 23:34:02', '', NULL, 'NDT检测人员档案');
INSERT INTO `sys_menu` VALUES (2017, 'UID规则配置', 2013, 5, 'uidRule', 'ndt/uidRule/index', '', '', 1, 0, 'C', '0', '0', 'ndt:uidRule:list', 'system', 'admin', '2026-05-29 23:34:02', '', NULL, 'NDT UID规则配置');
INSERT INTO `sys_menu` VALUES (2018, 'DCM完整性校验', 2013, 7, 'integrity', 'ndt/integrity/index', '', '', 1, 0, 'C', '0', '0', 'ndt:integrity:list', 'validCode', 'admin', '2026-05-29 23:34:02', 'admin', '2026-06-02 16:27:46', 'NDT DICOM完整性校验');
INSERT INTO `sys_menu` VALUES (2019, '评定结果管理', 2013, 8, 'evaluation', 'ndt/evaluation/index', '', '', 1, 0, 'C', '0', '0', 'ndt:evaluation:list', 'form', 'admin', '2026-05-29 23:34:02', '', NULL, 'NDT评定结果管理');
INSERT INTO `sys_menu` VALUES (2020, '任务查询', 2014, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:task:query', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2021, '任务新增', 2014, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:task:add', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2022, '任务修改', 2014, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:task:edit', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2023, '任务删除', 2014, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:task:remove', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2024, '任务分配', 2014, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:task:assign', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2025, 'OHIF查看', 2014, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:task:ohif', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2026, 'DICOM上传', 2015, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicom:upload', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2027, 'DICOM下载', 2015, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicom:download', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2028, '档案新增', 2016, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:inspector:add', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2029, '档案修改', 2016, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:inspector:edit', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2030, '档案删除', 2016, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:inspector:remove', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2031, 'UID新增', 2017, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:uidRule:add', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2032, 'UID查询', 2017, 0, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:uidRule:query', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2033, 'UID修改', 2017, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:uidRule:edit', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2034, 'UID删除', 2017, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:uidRule:remove', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2035, 'UID生成', 2017, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:uidRule:generate', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2036, '完整性重检', 2018, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:integrity:verify', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2037, '评定查询', 2019, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:evaluation:query', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2038, '评定新增', 2019, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:evaluation:add', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2039, '评定修改', 2019, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:evaluation:edit', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2040, '评定删除', 2019, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:evaluation:remove', '#', 'admin', '2026-05-29 23:34:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2041, 'OHIF入口配置', 2013, 9, 'ohif', 'ndt/ohif/index', '', '', 1, 0, 'C', '0', '0', 'ndt:ohif:list', 'link', 'admin', '2026-06-02 18:05:10', '', NULL, 'NDT OHIF入口配置');
INSERT INTO `sys_menu` VALUES (2042, 'Orthanc归档管理', 2013, 10, 'orthanc', 'ndt/orthanc/index', '', '', 1, 0, 'C', '0', '0', 'ndt:orthanc:list', 'tree', 'admin', '2026-06-02 18:05:18', '', NULL, 'NDT Orthanc归档管理');
INSERT INTO `sys_menu` VALUES (2043, '报告管理', 2013, 11, 'report', 'ndt/report/index', '', '', 1, 0, 'C', '0', '0', 'ndt:report:list', 'document', 'admin', '2026-06-02 18:05:23', '', NULL, 'NDT报告管理');
INSERT INTO `sys_menu` VALUES (2044, 'DICOM标签查看', 2015, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicom:tag:list', '#', 'admin', '2026-06-02 18:06:12', '', NULL, '查看DICOM标签');
INSERT INTO `sys_menu` VALUES (2045, 'DICOM标签新增', 2015, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicom:tag:add', '#', 'admin', '2026-06-02 18:06:18', '', NULL, '新增DICOM标签');
INSERT INTO `sys_menu` VALUES (2046, 'DICOM标签修改', 2015, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicom:tag:edit', '#', 'admin', '2026-06-02 18:06:27', '', NULL, '修改DICOM标签');
INSERT INTO `sys_menu` VALUES (2047, 'DICOM标签删除', 2015, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicom:tag:remove', '#', 'admin', '2026-06-02 18:06:35', '', NULL, '删除DICOM标签');
INSERT INTO `sys_menu` VALUES (2048, 'Orthanc树查看', 2042, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:orthanc:list', '#', 'admin', '2026-06-02 18:06:45', '', NULL, '查看Orthanc树形结构');
INSERT INTO `sys_menu` VALUES (2049, 'Orthanc标签查看', 2042, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:orthanc:query', '#', 'admin', '2026-06-02 18:06:57', '', NULL, '查看Orthanc实例标签');
INSERT INTO `sys_menu` VALUES (2050, 'Orthanc标签修改', 2042, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:orthanc:edit', '#', 'admin', '2026-06-02 18:07:04', '', NULL, '修改Orthanc实例标签');
INSERT INTO `sys_menu` VALUES (2051, 'OHIF配置查看', 2041, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:ohif:list', '#', 'admin', '2026-06-02 18:07:11', '', NULL, '查看OHIF配置');
INSERT INTO `sys_menu` VALUES (2052, '报告查询', 2043, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:report:list', '#', 'admin', '2026-06-02 18:07:27', '', NULL, '查看报告列表');
INSERT INTO `sys_menu` VALUES (2053, 'DCM标签管理', 2013, 6, 'dicomPrivateTag', 'ndt/dicomPrivateTag/index', '', '', 1, 0, 'C', '0', '0', 'ndt:dicomPrivateTag:list', 'edit', 'admin', '2026-06-04 17:50:16', '', NULL, 'NDT允许编辑的DICOM标签配置');
INSERT INTO `sys_menu` VALUES (2054, '私有标签查询', 2053, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicomPrivateTag:query', '#', 'admin', '2026-06-04 17:50:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2055, '私有标签新增', 2053, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicomPrivateTag:add', '#', 'admin', '2026-06-04 17:50:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2056, '私有标签修改', 2053, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicomPrivateTag:edit', '#', 'admin', '2026-06-04 17:50:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2057, '私有标签删除', 2053, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicomPrivateTag:remove', '#', 'admin', '2026-06-04 17:50:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2058, '客户管理', 2013, 4, 'customer', 'ndt/company/index', '', '', 1, 0, 'C', '0', '0', 'ndt:customer:list', 'people', 'admin', '2026-06-05 14:08:10', 'admin', '2026-07-29 17:11:48', 'NDT客户信息静态展示菜单');
INSERT INTO `sys_menu` VALUES (2059, '自定义校验规则', 2013, 12, 'validationRule', 'ndt/validationRule/index', '', '', 1, 0, 'C', '0', '0', 'ndt:validationRule:list', 'validCode', 'admin', '2026-06-13 23:54:32', '', NULL, 'DICOM上传自定义校验规则');
INSERT INTO `sys_menu` VALUES (2060, '规则查询', 2059, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:validationRule:query', '#', 'admin', '2026-06-13 23:54:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2061, '规则新增', 2059, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:validationRule:add', '#', 'admin', '2026-06-13 23:54:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2062, '规则修改', 2059, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:validationRule:edit', '#', 'admin', '2026-06-13 23:54:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2063, '规则删除', 2059, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:validationRule:remove', '#', 'admin', '2026-06-13 23:54:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2064, '规则导出', 2059, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:validationRule:export', '#', 'admin', '2026-06-13 23:54:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2065, '客户查询', 2058, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:customer:query', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2066, '客户新增', 2058, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:customer:add', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2067, '客户修改', 2058, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:customer:edit', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2068, '客户删除', 2058, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:customer:remove', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2069, '工件列表', 2014, 10, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:workpiece:list', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2070, '工件查询', 2014, 11, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:workpiece:query', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2071, '工件新增', 2014, 12, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:workpiece:add', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2072, '工件修改', 2014, 13, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:workpiece:edit', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2073, '工件删除', 2014, 14, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:workpiece:remove', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2074, '部位列表', 2014, 15, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:position:list', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2075, '部位查询', 2014, 16, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:position:query', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2076, '部位新增', 2014, 17, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:position:add', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2077, '部位修改', 2014, 18, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:position:edit', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2078, '部位删除', 2014, 19, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:position:remove', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2079, '对象查询', 2015, 10, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:dicom:query', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2080, '对象删除', 2015, 11, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:dicom:remove', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2081, '缺陷列表', 2019, 10, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:defect:list', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2082, '缺陷查询', 2019, 11, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:defect:query', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2083, '缺陷新增', 2019, 12, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:defect:add', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2084, '缺陷修改', 2019, 13, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:defect:edit', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2085, '缺陷删除', 2019, 14, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:defect:remove', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2086, '评定提交', 2019, 15, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:evaluation:submit', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2087, '复核查询', 2019, 16, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:review:list', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2088, '复核追加', 2019, 17, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:review:add', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2089, '报告查询', 2043, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:report:query', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2090, '报告上传', 2043, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:report:add', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2091, '报告下载', 2043, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:report:download', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2092, '报告状态', 2043, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:report:edit', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');
INSERT INTO `sys_menu` VALUES (2093, '报告删除', 2043, 6, '', '', NULL, '', 1, 0, 'F', '0', '0', 'ndt:report:remove', '#', 'admin', '2026-07-29 00:00:31', 'admin', '2026-07-29 17:11:48', '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2026-03-31 17:46:34', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2026-03-31 17:46:34', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (3, '若依开源框架介绍', '1', 0x3C703E3C7370616E207374796C653D22636F6C6F723A20726762283233302C20302C2030293B223EE9A1B9E79BAEE4BB8BE7BB8D3C2F7370616E3E3C2F703E3C703E3C666F6E7420636F6C6F723D2223333333333333223E52756F5969E5BC80E6BA90E9A1B9E79BAEE698AFE4B8BAE4BC81E4B89AE794A8E688B7E5AE9AE588B6E79A84E5908EE58FB0E8849AE6898BE69EB6E6A186E69EB6EFBC8CE4B8BAE4BC81E4B89AE68993E980A0E79A84E4B880E7AB99E5BC8FE8A7A3E586B3E696B9E6A188EFBC8CE9998DE4BD8EE4BC81E4B89AE5BC80E58F91E68890E69CACEFBC8CE68F90E58D87E5BC80E58F91E69588E78E87E38082E4B8BBE8A681E58C85E68BACE794A8E688B7E7AEA1E79086E38081E8A792E889B2E7AEA1E79086E38081E983A8E997A8E7AEA1E79086E38081E88F9CE58D95E7AEA1E79086E38081E58F82E695B0E7AEA1E79086E38081E5AD97E585B8E7AEA1E79086E380813C2F666F6E743E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE5B297E4BD8DE7AEA1E790863C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE38081E5AE9AE697B6E4BBBBE58AA13C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE380813C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE69C8DE58AA1E79B91E68EA7E38081E799BBE5BD95E697A5E5BF97E38081E6938DE4BD9CE697A5E5BF97E38081E4BBA3E7A081E7949FE68890E7AD89E58A9FE883BDE38082E585B6E4B8ADEFBC8CE8BF98E694AFE68C81E5A49AE695B0E68DAEE6BA90E38081E695B0E68DAEE69D83E99990E38081E59BBDE99985E58C96E380815265646973E7BC93E5AD98E38081446F636B6572E983A8E7BDB2E38081E6BB91E58AA8E9AA8CE8AF81E7A081E38081E7ACACE4B889E696B9E8AEA4E8AF81E799BBE5BD95E38081E58886E5B883E5BC8FE4BA8BE58AA1E380813C2F7370616E3E3C666F6E7420636F6C6F723D2223333333333333223EE58886E5B883E5BC8FE69687E4BBB6E5AD98E582A83C2F666F6E743E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE38081E58886E5BA93E58886E8A1A8E5A484E79086E7AD89E68A80E69CAFE789B9E782B9E380823C2F7370616E3E3C2F703E3C703E3C696D67207372633D2268747470733A2F2F666F727564612E67697465652E636F6D2F696D616765732F313737333933313834383334323433393033322F61346432323331335F313831353039352E706E6722207374796C653D2277696474683A20363470783B223E3C62723E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A20726762283233302C20302C2030293B223EE5AE98E7BD91E58F8AE6BC94E7A4BA3C2F7370616E3E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE88BA5E4BE9DE5AE98E7BD91E59CB0E59D80EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F72756F79692E7669703C2F613E3C6120687265663D22687474703A2F2F72756F79692E76697022207461726765743D225F626C616E6B223E3C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE88BA5E4BE9DE69687E6A1A3E59CB0E59D80EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F646F632E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F646F632E72756F79692E7669703C2F613E3C62723E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E4B88DE58886E7A6BBE78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F64656D6F2E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F64656D6F2E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E58886E7A6BBE78988E69CACE38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F7675652E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F7675652E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E5BEAEE69C8DE58AA1E78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F636C6F75642E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F636C6F75642E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E7A7BBE58AA8E7ABAFE78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F68352E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F68352E72756F79692E7669703C2F613E3C2F703E3C703E3C6272207374796C653D22636F6C6F723A207267622834382C2034392C203531293B20666F6E742D66616D696C793A202671756F743B48656C766574696361204E6575652671756F743B2C2048656C7665746963612C20417269616C2C2073616E732D73657269663B20666F6E742D73697A653A20313270783B223E3C2F703E, '0', 'admin', '2026-03-31 17:46:34', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_notice_read
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice_read`;
CREATE TABLE `sys_notice_read`  (
  `read_id` bigint NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int NOT NULL COMMENT '公告id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `read_time` datetime NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`) USING BTREE,
  UNIQUE INDEX `uk_user_notice`(`user_id` ASC, `notice_id` ASC) USING BTREE COMMENT '同一用户同一公告只记录一次'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告已读记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice_read
-- ----------------------------

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 352 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (288, 'NDT客户', 1, 'com.ruoyi.ndt.customer.controller.NdtCustomerController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/customer', '127.0.0.1', '内网IP', '{\"contactName\":\"张三\",\"contactPhone\":\"13586801014\",\"createBy\":\"admin\",\"id\":2,\"name\":\"宁波中科检测\",\"params\":{},\"remark\":\"测试备注信息\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 17:46:27', 22);
INSERT INTO `sys_oper_log` VALUES (289, 'NDT客户', 2, 'com.ruoyi.ndt.customer.controller.NdtCustomerController.edit()', 'PUT', 1, 'admin', '研发部门', '/ndt/customer', '127.0.0.1', '内网IP', '{\"contactName\":\"张三1\",\"contactPhone\":\"135868010141\",\"createBy\":\"admin\",\"createTime\":\"2026-07-29 17:46:27\",\"delFlag\":\"0\",\"id\":2,\"name\":\"宁波中科检测1\",\"params\":{},\"remark\":\"测试备注信息1\",\"updateBy\":\"admin\",\"updateTime\":\"2026-07-29 17:46:27\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 17:46:36', 6);
INSERT INTO `sys_oper_log` VALUES (290, 'NDT客户', 2, 'com.ruoyi.ndt.customer.controller.NdtCustomerController.edit()', 'PUT', 1, 'admin', '研发部门', '/ndt/customer', '127.0.0.1', '内网IP', '{\"contactName\":\"张三\",\"contactPhone\":\"13586801014\",\"createBy\":\"admin\",\"createTime\":\"2026-07-29 17:46:27\",\"delFlag\":\"0\",\"id\":2,\"name\":\"宁波中科检测\",\"params\":{},\"remark\":\"测试备注信息\",\"updateBy\":\"admin\",\"updateTime\":\"2026-07-29 17:46:36\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 17:46:41', 7);
INSERT INTO `sys_oper_log` VALUES (291, 'NDT客户', 3, 'com.ruoyi.ndt.customer.controller.NdtCustomerController.remove()', 'DELETE', 1, 'admin', '研发部门', '/ndt/customer/2', '127.0.0.1', '内网IP', '[2] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 18:05:46', 20);
INSERT INTO `sys_oper_log` VALUES (292, 'NDT客户', 1, 'com.ruoyi.ndt.customer.controller.NdtCustomerController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/customer', '127.0.0.1', '内网IP', '{\"contactName\":\"宋明豫\",\"contactPhone\":\"13586801014\",\"createBy\":\"admin\",\"createTime\":\"2026-07-29 17:46:27\",\"delFlag\":\"0\",\"id\":3,\"name\":\"宁波中科检测\",\"params\":{},\"remark\":\"测试备注\",\"updateBy\":\"admin\",\"updateTime\":\"2026-07-29 17:46:36\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 18:06:13', 6);
INSERT INTO `sys_oper_log` VALUES (293, 'NDT检测任务', 1, 'com.ruoyi.ndt.task.controller.NdtInspectionTaskController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/task', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"customerId\":3,\"description\":\"螺丝螺纹检测任务说明\",\"finishTime\":\"2026-07-30 00:00:00\",\"id\":1,\"params\":{},\"startTime\":\"2026-07-29 00:00:00\",\"status\":\"DRAFT\",\"taskName\":\"螺丝螺纹检测\",\"taskNo\":\"NDT20260729181318b4f834\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 18:13:18', 34);
INSERT INTO `sys_oper_log` VALUES (294, 'NDT工件', 1, 'com.ruoyi.ndt.workpiece.controller.NdtWorkpieceController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/workpiece', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"id\":1,\"params\":{},\"remark\":\"一号螺丝备注\",\"sortNo\":0,\"status\":\"PENDING\",\"taskId\":1,\"updateBy\":\"admin\",\"workpieceName\":\"一号螺丝\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 19:20:20', 9);
INSERT INTO `sys_oper_log` VALUES (295, 'NDT工件', 1, 'com.ruoyi.ndt.workpiece.controller.NdtWorkpieceController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/workpiece', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"id\":2,\"params\":{},\"remark\":\"二号螺丝备注\",\"sortNo\":1,\"status\":\"PENDING\",\"taskId\":1,\"updateBy\":\"admin\",\"workpieceName\":\"二号工件\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 19:20:54', 8);
INSERT INTO `sys_oper_log` VALUES (296, 'NDT检测部位', 1, 'com.ruoyi.ndt.position.controller.NdtInspectionPositionController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/position', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"id\":1,\"params\":{},\"positionCode\":\"1\",\"positionName\":\"螺纹\",\"remark\":\"螺纹备注\",\"sortNo\":1,\"updateBy\":\"admin\",\"workpieceId\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 19:21:47', 12);
INSERT INTO `sys_oper_log` VALUES (297, 'NDT检测部位', 1, 'com.ruoyi.ndt.position.controller.NdtInspectionPositionController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/position', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-07-29 19:21:47\",\"delFlag\":\"0\",\"id\":2,\"params\":{},\"positionCode\":\"2\",\"positionName\":\"螺丝头\",\"remark\":\"螺丝头备注\",\"sortNo\":0,\"taskId\":1,\"updateBy\":\"admin\",\"updateTime\":\"2026-07-29 19:21:47\",\"workpieceId\":1,\"workpieceName\":\"一号螺丝\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 19:36:41', 8);
INSERT INTO `sys_oper_log` VALUES (298, 'NDT检测部位', 1, 'com.ruoyi.ndt.position.controller.NdtInspectionPositionController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/position', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-07-29 19:21:47\",\"delFlag\":\"0\",\"id\":3,\"params\":{},\"positionCode\":\"3\",\"positionName\":\"螺母\",\"remark\":\"螺母备注\",\"sortNo\":2,\"taskId\":1,\"updateBy\":\"admin\",\"updateTime\":\"2026-07-29 19:21:47\",\"workpieceId\":1,\"workpieceName\":\"一号螺丝\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 19:38:08', 8);
INSERT INTO `sys_oper_log` VALUES (299, 'NDT检测部位', 1, 'com.ruoyi.ndt.position.controller.NdtInspectionPositionController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/position', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-07-29 19:21:47\",\"delFlag\":\"0\",\"id\":4,\"params\":{},\"positionCode\":\"4\",\"positionName\":\"螺柱\",\"remark\":\"test\",\"sortNo\":1,\"taskId\":1,\"updateBy\":\"admin\",\"updateTime\":\"2026-07-29 19:21:47\",\"workpieceId\":1,\"workpieceName\":\"一号螺丝\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 19:38:30', 8);
INSERT INTO `sys_oper_log` VALUES (300, 'NDT检测部位', 1, 'com.ruoyi.ndt.position.controller.NdtInspectionPositionController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/position', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-07-29 19:21:47\",\"delFlag\":\"0\",\"id\":5,\"params\":{},\"positionCode\":\"5\",\"positionName\":\"test\",\"remark\":\"test2\",\"sortNo\":0,\"taskId\":1,\"updateBy\":\"admin\",\"updateTime\":\"2026-07-29 19:21:47\",\"workpieceId\":1,\"workpieceName\":\"一号螺丝\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 19:40:45', 10);
INSERT INTO `sys_oper_log` VALUES (301, 'NDT检测部位', 2, 'com.ruoyi.ndt.position.controller.NdtInspectionPositionController.edit()', 'PUT', 1, 'admin', '研发部门', '/ndt/position', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-07-29 19:38:08\",\"delFlag\":\"0\",\"id\":3,\"params\":{},\"positionCode\":\"3\",\"positionName\":\"螺母\",\"remark\":\"螺母备注\",\"sortNo\":0,\"taskId\":1,\"updateBy\":\"admin\",\"updateTime\":\"2026-07-29 19:38:08\",\"workpieceId\":1,\"workpieceName\":\"一号螺丝\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 19:41:08', 9);
INSERT INTO `sys_oper_log` VALUES (302, 'NDT检测部位', 1, 'com.ruoyi.ndt.position.controller.NdtInspectionPositionController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/position', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"id\":6,\"params\":{},\"positionCode\":\"1\",\"positionName\":\"工件正面\",\"remark\":\"\",\"sortNo\":0,\"updateBy\":\"admin\",\"workpieceId\":2} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 19:50:22', 7);
INSERT INTO `sys_oper_log` VALUES (303, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptId\":103,\"nickName\":\"宋明豫\",\"params\":{},\"phonenumber\":\"13586801014\",\"postIds\":[],\"roleIds\":[101],\"status\":\"0\",\"userId\":100,\"userName\":\"宋明豫\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 19:52:56', 69);
INSERT INTO `sys_oper_log` VALUES (304, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptId\":100,\"nickName\":\"张三\",\"params\":{},\"phonenumber\":\"\",\"postIds\":[4],\"roleIds\":[2],\"status\":\"0\",\"userId\":101,\"userName\":\"张三\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 19:53:27', 62);
INSERT INTO `sys_oper_log` VALUES (305, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[\"validate_iods 官方校验失败：\"],\"fileName\":\"image-000001.dcm\",\"fileSha256\":\"c3ea9864816c08de3319a5900070d528ce36eeaa3d3812610456b1b254ab573b\",\"finalStatus\":\"FAIL\",\"officialStatus\":\"FAIL\",\"positionId\":1,\"seriesUid\":\"1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765087\",\"studyUid\":\"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\",\"validationRecordId\":21}}', 0, NULL, '2026-07-29 23:25:03', 76);
INSERT INTO `sys_oper_log` VALUES (306, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[\"validate_iods 官方校验失败：\"],\"fileName\":\"image-000001.dcm\",\"fileSha256\":\"c3ea9864816c08de3319a5900070d528ce36eeaa3d3812610456b1b254ab573b\",\"finalStatus\":\"FAIL\",\"officialStatus\":\"FAIL\",\"positionId\":1,\"seriesUid\":\"1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765087\",\"studyUid\":\"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\",\"validationRecordId\":22}}', 0, NULL, '2026-08-01 17:48:07', 68);
INSERT INTO `sys_oper_log` VALUES (307, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[\"validate_iods 官方校验失败：\"],\"fileName\":\"image-000001.dcm\",\"fileSha256\":\"c3ea9864816c08de3319a5900070d528ce36eeaa3d3812610456b1b254ab573b\",\"finalStatus\":\"FAIL\",\"officialStatus\":\"FAIL\",\"positionId\":1,\"seriesUid\":\"1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765087\",\"studyUid\":\"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\",\"validationRecordId\":23}}', 0, NULL, '2026-08-01 17:48:28', 34);
INSERT INTO `sys_oper_log` VALUES (308, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[\"validate_iods 官方校验失败：\"],\"fileName\":\"image-000001.dcm\",\"fileSha256\":\"c3ea9864816c08de3319a5900070d528ce36eeaa3d3812610456b1b254ab573b\",\"finalStatus\":\"FAIL\",\"officialStatus\":\"FAIL\",\"positionId\":1,\"seriesUid\":\"1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765087\",\"studyUid\":\"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\",\"validationRecordId\":24}}', 0, NULL, '2026-08-01 17:48:47', 29);
INSERT INTO `sys_oper_log` VALUES (309, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[\"validate_iods 官方校验失败：\"],\"fileName\":\"image-000001.dcm\",\"fileSha256\":\"c3ea9864816c08de3319a5900070d528ce36eeaa3d3812610456b1b254ab573b\",\"finalStatus\":\"FAIL\",\"officialStatus\":\"FAIL\",\"positionId\":1,\"seriesUid\":\"1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765087\",\"studyUid\":\"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\",\"validationRecordId\":25}}', 0, NULL, '2026-08-01 17:50:56', 33);
INSERT INTO `sys_oper_log` VALUES (310, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[],\"fileName\":\"image-000001.dcm\",\"fileSha256\":\"c3ea9864816c08de3319a5900070d528ce36eeaa3d3812610456b1b254ab573b\",\"finalStatus\":\"PASS\",\"objectId\":1,\"officialStatus\":\"PASS\",\"orthancInstanceId\":\"ec80720f-b98f706a-94faa0b8-acd549b4-2d1cc21a\",\"positionId\":1,\"seriesUid\":\"1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765087\",\"studyUid\":\"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\",\"validationRecordId\":26}}', 0, NULL, '2026-08-01 18:36:13', 41988);
INSERT INTO `sys_oper_log` VALUES (311, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"1\"}', NULL, 1, 'SOPInstanceUID已存在，不能重复上传', '2026-08-01 18:36:24', 256);
INSERT INTO `sys_oper_log` VALUES (312, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"2\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[],\"fileName\":\"image-000002.dcm\",\"fileSha256\":\"38b29a49201ec3cc59c598daafd6890355117397d75075f426c55864a204e66b\",\"finalStatus\":\"PASS\",\"objectId\":2,\"officialStatus\":\"PASS\",\"orthancInstanceId\":\"31b02d85-5d02d762-934e2a0d-f741b6a9-48e69a67\",\"positionId\":2,\"seriesUid\":\"1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"1.3.6.1.4.1.44316.6.102.3.20250704114424902.24404038532358178500\",\"studyUid\":\"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\",\"validationRecordId\":28}}', 0, NULL, '2026-08-01 19:34:59', 425);
INSERT INTO `sys_oper_log` VALUES (313, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"3\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[],\"fileName\":\"image-000003.dcm\",\"fileSha256\":\"2cfabfeef76a249e949aff036738d79a54b77cbf0524c77d5728b4249f463627\",\"finalStatus\":\"PASS\",\"objectId\":3,\"officialStatus\":\"PASS\",\"orthancInstanceId\":\"b8304522-ec2550db-6e988818-3ae62d34-b5237e04\",\"positionId\":3,\"seriesUid\":\"1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"1.3.6.1.4.1.44316.6.102.3.2025070411442695.351556929324256748767\",\"studyUid\":\"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\",\"validationRecordId\":29}}', 0, NULL, '2026-08-01 19:35:12', 325);
INSERT INTO `sys_oper_log` VALUES (314, 'NDT检测任务', 1, 'com.ruoyi.ndt.task.controller.NdtInspectionTaskController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/task', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"customerId\":3,\"description\":\"\",\"id\":2,\"params\":{},\"status\":\"DRAFT\",\"taskName\":\"test\",\"taskNo\":\"NDT2026080212411396ea58\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-02 12:41:13', 158);
INSERT INTO `sys_oper_log` VALUES (315, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"6\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[],\"fileName\":\"image-000001.dcm\",\"fileSha256\":\"828128b708cac60340182cf9b57e822af288bfe630e2ce2e5fa422350fcffd36\",\"finalStatus\":\"PASS\",\"objectId\":4,\"officialStatus\":\"PASS\",\"orthancInstanceId\":\"fe446e0a-fb1fcfef-4c290fa9-b1ea9520-de8b1d92\",\"positionId\":6,\"seriesUid\":\"1.3.6.1.4.1.44316.6.102.2.20250704114429771.63133867861500115690\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"1.3.6.1.4.1.44316.6.102.3.20250704114423666.30394198594456817768\",\"studyUid\":\"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\",\"validationRecordId\":30}}', 0, NULL, '2026-08-02 12:46:33', 995);
INSERT INTO `sys_oper_log` VALUES (316, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[],\"fileName\":\"image-000001.dcm\",\"fileSha256\":\"c3ea9864816c08de3319a5900070d528ce36eeaa3d3812610456b1b254ab573b\",\"finalStatus\":\"PASS\",\"objectId\":1,\"officialStatus\":\"PASS\",\"orthancInstanceId\":\"ec80720f-b98f706a-94faa0b8-acd549b4-2d1cc21a\",\"positionId\":1,\"seriesUid\":\"1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765087\",\"studyUid\":\"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\",\"validationRecordId\":1}}', 0, NULL, '2026-08-02 16:00:43', 1001);
INSERT INTO `sys_oper_log` VALUES (317, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[],\"fileName\":\"image-000002.dcm\",\"fileSha256\":\"38b29a49201ec3cc59c598daafd6890355117397d75075f426c55864a204e66b\",\"finalStatus\":\"PASS\",\"objectId\":2,\"officialStatus\":\"PASS\",\"orthancInstanceId\":\"31b02d85-5d02d762-934e2a0d-f741b6a9-48e69a67\",\"positionId\":1,\"seriesUid\":\"1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"1.3.6.1.4.1.44316.6.102.3.20250704114424902.24404038532358178500\",\"studyUid\":\"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\",\"validationRecordId\":2}}', 0, NULL, '2026-08-02 16:01:22', 324);
INSERT INTO `sys_oper_log` VALUES (318, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[],\"fileName\":\"image-000001.dcm\",\"fileSha256\":\"828128b708cac60340182cf9b57e822af288bfe630e2ce2e5fa422350fcffd36\",\"finalStatus\":\"PASS\",\"objectId\":3,\"officialStatus\":\"PASS\",\"orthancInstanceId\":\"fe446e0a-fb1fcfef-4c290fa9-b1ea9520-de8b1d92\",\"positionId\":1,\"seriesUid\":\"1.3.6.1.4.1.44316.6.102.2.20250704114429771.63133867861500115690\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"1.3.6.1.4.1.44316.6.102.3.20250704114423666.30394198594456817768\",\"studyUid\":\"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\",\"validationRecordId\":3}}', 0, NULL, '2026-08-02 16:01:42', 486);
INSERT INTO `sys_oper_log` VALUES (319, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"2\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[\"validate_iods 官方校验失败：Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-13479798934757007034.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.2\\\" (CT Image IOD)\\r\\n\\r\\nErrors\\r\\n======\\r\\n\\r\\nModule \\\"General Series\\\":\\r\\nTag (0018,5100) (Patient Position) is missing\\r\\n\\r\\nModule \\\"General\\\":\\r\\nTag (0010,2160) (Ethnic Group) is unexpected\\r\\nTag (0014,1020) (Expiry Date) is unexpected\\r\\nTag (0032,4000) (Study Comments) is unexpected\\r\\n\\r\\n======\"],\"fileName\":\"dicondeCtExampleImageE2767-13Minimum.DCM\",\"fileSha256\":\"44eda97dd1cededb55a84d5440badecee9b2e49cfce18bc2fdffe05e71060dbc\",\"finalStatus\":\"FAIL\",\"officialStatus\":\"FAIL\",\"positionId\":2,\"seriesUid\":\"2.16.840.1.114229.17.43.20100505142628.1.1\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"2.16.840.1.114229.17.43.20100505142628.1.1.1\",\"studyUid\":\"2.16.840.1.114229.17.43.20100505142628.1\",\"validationRecordId\":4}}', 0, NULL, '2026-08-02 16:11:52', 264);
INSERT INTO `sys_oper_log` VALUES (320, 'NDT检测任务', 1, 'com.ruoyi.ndt.task.controller.NdtInspectionTaskController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/task', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"customerId\":3,\"description\":\"\",\"id\":3,\"params\":{},\"status\":\"DRAFT\",\"taskName\":\"测试任务A\",\"taskNo\":\"NDT20260802191631a4e0b1\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-02 19:16:31', 118);
INSERT INTO `sys_oper_log` VALUES (321, 'NDT工件', 1, 'com.ruoyi.ndt.workpiece.controller.NdtWorkpieceController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/workpiece', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"id\":3,\"params\":{},\"remark\":\"\",\"sortNo\":0,\"status\":\"PENDING\",\"taskId\":3,\"updateBy\":\"admin\",\"workpieceName\":\"工件A\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-02 19:16:42', 9);
INSERT INTO `sys_oper_log` VALUES (322, 'NDT检测部位', 1, 'com.ruoyi.ndt.position.controller.NdtInspectionPositionController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/position', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"id\":7,\"params\":{},\"positionCode\":\"P01\",\"positionName\":\"1号焊缝\",\"remark\":\"\",\"sortNo\":0,\"updateBy\":\"admin\",\"workpieceId\":3} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-02 19:17:03', 9);
INSERT INTO `sys_oper_log` VALUES (323, 'NDT检测部位', 1, 'com.ruoyi.ndt.position.controller.NdtInspectionPositionController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/position', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"id\":8,\"params\":{},\"positionCode\":\"P02\",\"positionName\":\"2号焊缝\",\"remark\":\"\",\"sortNo\":0,\"updateBy\":\"admin\",\"workpieceId\":3} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-02 19:17:18', 8);
INSERT INTO `sys_oper_log` VALUES (324, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"7\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[\"validate_iods 官方校验失败：Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-10190262544881893855.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.4\\\" (MR Image IOD)\\r\\n\\r\\nErrors\\r\\n======\\r\\n\\r\\nModule \\\"Frame of Reference\\\":\\r\\nTag (0020,1040) (Position Reference Indicator) is missing\\r\\n\\r\\nModule \\\"General Equipment\\\":\\r\\nTag (0008,0070) (Manufacturer) is missing\\r\\n\\r\\nModule \\\"General Study\\\":\\r\\nTag (0008,0050) (Accession Number) is missing\\r\\nTag (0008,0090) (Referring Physician\'s Name) is missing\\r\\nTag (0020,0010) (Study ID) is missing\\r\\n\\r\\nModule \\\"Patient\\\":\\r\\nTag (0010,0030) (Patient\'s Birth Date) is missing\\r\\nTag (0010,0040) (Patient\'s Sex) is missing\\r\\n\\r\\n======\"],\"fileName\":\"image-000021.dcm\",\"fileSha256\":\"072f97a5573714ba53760b454de4dabb77cc7fb0014434d013b1204d54c17c54\",\"finalStatus\":\"FAIL\",\"officialStatus\":\"FAIL\",\"positionId\":7,\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.4\",\"sopInstanceUid\":\"1.2.826.0.1.3680043.8.1055.1.20111103111213003.62992974.26670569\",\"validationRecordId\":1}}', 0, NULL, '2026-08-02 19:17:58', 281);
INSERT INTO `sys_oper_log` VALUES (325, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"7\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[\"validate_iods 官方校验失败：Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-14634400884941001118.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.4\\\" (MR Image IOD)\\r\\n\\r\\nErrors\\r\\n======\\r\\n\\r\\nModule \\\"Frame of Reference\\\":\\r\\nTag (0020,1040) (Position Reference Indicator) is missing\\r\\n\\r\\nModule \\\"General Equipment\\\":\\r\\nTag (0008,0070) (Manufacturer) is missing\\r\\n\\r\\nModule \\\"General Study\\\":\\r\\nTag (0008,0050) (Accession Number) is missing\\r\\nTag (0008,0090) (Referring Physician\'s Name) is missing\\r\\nTag (0020,0010) (Study ID) is missing\\r\\n\\r\\nModule \\\"Patient\\\":\\r\\nTag (0010,0030) (Patient\'s Birth Date) is missing\\r\\nTag (0010,0040) (Patient\'s Sex) is missing\\r\\n\\r\\n======\"],\"fileName\":\"image-000011.dcm\",\"fileSha256\":\"aed6f1db23af99989c9b0ffa4aaada13d0eeace228d52eb04536b06e3539dca1\",\"finalStatus\":\"FAIL\",\"officialStatus\":\"FAIL\",\"positionId\":7,\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.4\",\"sopInstanceUid\":\"1.2.826.0.1.3680043.8.1055.1.20111103111150650.27301014.60114609\",\"validationRecordId\":2}}', 0, NULL, '2026-08-02 19:18:21', 247);
INSERT INTO `sys_oper_log` VALUES (326, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"7\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[\"validate_iods 官方校验失败：Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-8075653996210065650.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.4\\\" (MR Image IOD)\\r\\n\\r\\nErrors\\r\\n======\\r\\n\\r\\nModule \\\"Frame of Reference\\\":\\r\\nTag (0020,1040) (Position Reference Indicator) is missing\\r\\n\\r\\nModule \\\"General Equipment\\\":\\r\\nTag (0008,0070) (Manufacturer) is missing\\r\\n\\r\\nModule \\\"General Study\\\":\\r\\nTag (0008,0050) (Accession Number) is missing\\r\\nTag (0008,0090) (Referring Physician\'s Name) is missing\\r\\nTag (0020,0010) (Study ID) is missing\\r\\n\\r\\nModule \\\"Patient\\\":\\r\\nTag (0010,0030) (Patient\'s Birth Date) is missing\\r\\nTag (0010,0040) (Patient\'s Sex) is missing\\r\\n\\r\\n======\"],\"fileName\":\"image-000001.dcm\",\"fileSha256\":\"7db442021fe1c2eec3524579f916238d9249f88a6e6221828479861c4fdbcf8e\",\"finalStatus\":\"FAIL\",\"officialStatus\":\"FAIL\",\"positionId\":7,\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.4\",\"sopInstanceUid\":\"1.2.826.0.1.3680043.8.1055.1.20111103111148288.81713267.86905863\",\"validationRecordId\":3}}', 0, NULL, '2026-08-02 19:18:53', 249);
INSERT INTO `sys_oper_log` VALUES (327, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"7\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[\"validate_iods 官方校验失败：Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-18021764458029730430.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.4\\\" (MR Image IOD)\\r\\n\\r\\nErrors\\r\\n======\\r\\n\\r\\nModule \\\"Frame of Reference\\\":\\r\\nTag (0020,1040) (Position Reference Indicator) is missing\\r\\n\\r\\nModule \\\"General Equipment\\\":\\r\\nTag (0008,0070) (Manufacturer) is missing\\r\\n\\r\\nModule \\\"General Study\\\":\\r\\nTag (0008,0050) (Accession Number) is missing\\r\\nTag (0008,0090) (Referring Physician\'s Name) is missing\\r\\nTag (0020,0010) (Study ID) is missing\\r\\n\\r\\nModule \\\"Patient\\\":\\r\\nTag (0010,0030) (Patient\'s Birth Date) is missing\\r\\nTag (0010,0040) (Patient\'s Sex) is missing\\r\\n\\r\\n======\"],\"fileName\":\"image-000001.dcm\",\"fileSha256\":\"7db442021fe1c2eec3524579f916238d9249f88a6e6221828479861c4fdbcf8e\",\"finalStatus\":\"FAIL\",\"officialStatus\":\"FAIL\",\"positionId\":7,\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.4\",\"sopInstanceUid\":\"1.2.826.0.1.3680043.8.1055.1.20111103111148288.81713267.86905863\",\"validationRecordId\":4}}', 0, NULL, '2026-08-02 19:19:17', 250);
INSERT INTO `sys_oper_log` VALUES (328, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"7\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[],\"fileName\":\"image-000001.dcm\",\"fileSha256\":\"c3ea9864816c08de3319a5900070d528ce36eeaa3d3812610456b1b254ab573b\",\"finalStatus\":\"PASS\",\"objectId\":1,\"officialStatus\":\"PASS\",\"orthancInstanceId\":\"ec80720f-b98f706a-94faa0b8-acd549b4-2d1cc21a\",\"positionId\":7,\"seriesUid\":\"1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765087\",\"studyUid\":\"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\",\"validationRecordId\":5}}', 0, NULL, '2026-08-02 19:23:04', 423);
INSERT INTO `sys_oper_log` VALUES (329, 'NDT影像派生对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.uploadDerived()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/derived/upload', '127.0.0.1', '内网IP', '{\"sourceObjectId\":\"1\",\"objectType\":\"PROCESSED_IMAGE\"}', NULL, 1, 'SOPInstanceUID已存在，不能重复上传', '2026-08-02 19:28:00', 110);
INSERT INTO `sys_oper_log` VALUES (330, 'NDT影像派生对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.uploadDerived()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/derived/upload', '127.0.0.1', '内网IP', '{\"sourceObjectId\":\"1\",\"objectType\":\"PROCESSED_IMAGE\"}', NULL, 1, 'SOPInstanceUID已存在，不能重复上传', '2026-08-02 19:30:19', 87);
INSERT INTO `sys_oper_log` VALUES (331, 'NDT影像派生对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.uploadDerived()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/derived/upload', '127.0.0.1', '内网IP', '{\"sourceObjectId\":\"1\",\"objectType\":\"PROCESSED_IMAGE\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"createBy\":\"admin\",\"createTime\":\"2026-08-02 19:30:46\",\"delFlag\":\"0\",\"id\":2,\"metadataJson\":\"{\\\"KVP\\\": \\\"120\\\", \\\"Rows\\\": \\\"512\\\", \\\"VmaMod\\\": \\\"0\\\", \\\"Columns\\\": \\\"512\\\", \\\"HighBit\\\": \\\"15\\\", \\\"StudyID\\\": \\\"1\\\", \\\"SuiteId\\\": \\\"LS16\\\", \\\"VmaClip\\\": \\\"0\\\", \\\"VmaMamp\\\": \\\"0\\\", \\\"Exposure\\\": \\\"41\\\", \\\"Modality\\\": \\\"CT\\\", \\\"ImageType\\\": \\\"ORIGINAL\\\\\\\\PRIMARY\\\\\\\\AXIAL\\\", \\\"PatientID\\\": \\\"0\\\", \\\"PlaneType\\\": \\\"2\\\", \\\"ProductId\\\": \\\"LightSpeed Pro\\\", \\\"ScoutType\\\": \\\"0\\\", \\\"StudyDate\\\": \\\"20151207\\\", \\\"StudyTime\\\": \\\"073153\\\", \\\"XrayChain\\\": \\\"99\\\\\\\\99\\\\\\\\99\\\", \\\"BitsStored\\\": \\\"16\\\", \\\"DASAdInput\\\": \\\"0\\\", \\\"DASCalMode\\\": \\\"0\\\", \\\"DASFpaGain\\\": \\\"0\\\", \\\"FilterType\\\": \\\"BODY FILTER\\\", \\\"FocalSpots\\\": \\\"1.200000\\\", \\\"PatientAge\\\": \\\"062Y\\\", \\\"PatientSex\\\": \\\"M\\\", \\\"SeriesDate\\\": \\\"20151207\\\", \\\"SeriesTime\\\": \\\"073458\\\", \\\"TableSpeed\\\": \\\"0.000000\\\", \\\"CellSpacing\\\": \\\"1.023900\\\", \\\"ContentDate\\\": \\\"20151207\\\", \\\"ContentTime\\\": \\\"073659\\\", \\\"LastScanRAS\\\": \\\"I\\\", \\\"MidScanFlag\\\": \\\"1\\\", \\\"MidScanTime\\\": \\\"136.928848\\\", \\\"PatientName\\\": \\\"Anonymized^^\\\", \\\"PatientSize\\\": \\\"1.75\\\", \\\"RescaleType\\\": \\\"HU\\\", \\\"SOPClassUID\\\": \\\"1.2.840.10008.5.1.4.1.1.2\\\", \\\"ScanFOVType\\\": \\\"16\\\", \\\"ScanOptions\\\": \\\"AXIAL MODE\\\", \\\"StationName\\\": \\\"\\\", \\\"TableHeight\\\": \\\"182.500000\\\", \\\"WindowValue\\\": \\\"350\\\", \\\"WindowWidth\\\": \\\"350\\\", \\\"EquipmentUID\\\": \\\"\\\", \\\"ExposureTime\\\": \\\"700\\\", \\\"FirstScanRAS\\\": \\\"I\\\", \\\"FullFidelity\\\": \\\"CT_LIGHTSPEED\\\", \\\"GantryPeriod\\\": \\\"0.700000\\\", \\\"Manufacturer\\\": \\\"GE MEDICAL SYSTEMS\\\", \\\"NormalACoord\\\": \\\"0\\\", \\\"NormalRCoord\\\": \\\"0\\\", \\\"NormalSCoord\\\": \\\"-1\\\", \\\"PixelSpacing\\\": \\\"0.902344\\\\\\\\0.902344\\\", \\\"ProtocolName\\\": \\\"5.8 KUNAS ONKOLOGIJA (dvi fazes)\\\", \\\"RescaleSlope\\\": \\\" 1\\\", \\\"SeriesNumber\\\": \\\"200\\\", \\\"WindowCenter\\\": \\\"40\\\", \\\"BitsAllocated\\\": \\\"16\\\", \\\"OperatorsName\\\": \\\"²âÊÔÅÉÉúÍ¼-´¦ÀíÍ¼\\\", \\\"PatientWeight\\\": \\\"91.0\\\", \\\"SegmentNumber\\\": \\\"0\\\", \\\"SliceLocation\\\": \\\"-289.750\\\", \\\"BiopsyPosition\\\": \\\"0\\\", \\\"DeltaStartTime', 0, NULL, '2026-08-02 19:30:46', 92);
INSERT INTO `sys_oper_log` VALUES (332, 'NDT影像派生对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.uploadDerived()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/derived/upload', '127.0.0.1', '内网IP', '{\"sourceObjectId\":\"1\",\"objectType\":\"PROCESSED_IMAGE\"}', NULL, 1, 'SOPInstanceUID已存在，不能重复上传', '2026-08-02 20:07:39', 90);
INSERT INTO `sys_oper_log` VALUES (333, 'NDT影像派生对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.uploadDerived()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/derived/upload', '127.0.0.1', '内网IP', '{\"sourceObjectId\":\"1\",\"objectType\":\"PROCESSED_IMAGE\"}', NULL, 1, '处理图、截图和标注图必须与来源原图属于同一个Series', '2026-08-02 20:09:21', 100);
INSERT INTO `sys_oper_log` VALUES (334, 'NDT影像派生对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.uploadDerived()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/derived/upload', '127.0.0.1', '内网IP', '{\"sourceObjectId\":\"1\",\"objectType\":\"PROCESSED_IMAGE\"}', NULL, 1, '派生图必须与来源原图属于同一个Study', '2026-08-02 20:13:30', 168);
INSERT INTO `sys_oper_log` VALUES (335, 'NDT影像派生对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.uploadDerived()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/derived/upload', '127.0.0.1', '内网IP', '{\"sourceObjectId\":\"1\",\"objectType\":\"PROCESSED_IMAGE\"}', NULL, 1, '派生图必须与来源原图属于同一个Study Instance UID', '2026-08-02 20:14:10', 143);
INSERT INTO `sys_oper_log` VALUES (336, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"7\"}', NULL, 1, '一个Series只能包含一张原始图', '2026-08-02 20:14:59', 330);
INSERT INTO `sys_oper_log` VALUES (337, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"7\"}', NULL, 1, '一个Series只能包含一张原始图', '2026-08-02 20:15:06', 316);
INSERT INTO `sys_oper_log` VALUES (338, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"7\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[],\"fileName\":\"image-000001.dcm\",\"fileSha256\":\"c3ea9864816c08de3319a5900070d528ce36eeaa3d3812610456b1b254ab573b\",\"finalStatus\":\"PASS\",\"objectId\":1,\"officialStatus\":\"PASS\",\"orthancInstanceId\":\"ec80720f-b98f706a-94faa0b8-acd549b4-2d1cc21a\",\"positionId\":7,\"seriesUid\":\"1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027493311337160\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765087\",\"studyUid\":\"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\",\"validationRecordId\":1}}', 0, NULL, '2026-08-02 20:18:57', 348);
INSERT INTO `sys_oper_log` VALUES (339, 'NDT影像派生对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.uploadDerived()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/derived/upload', '127.0.0.1', '内网IP', '{\"sourceObjectId\":\"1\",\"objectType\":\"PROCESSED_IMAGE\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"createBy\":\"admin\",\"createTime\":\"2026-08-02 20:19:26\",\"delFlag\":\"0\",\"id\":2,\"metadataJson\":\"{\\\"KVP\\\": \\\"120\\\", \\\"Rows\\\": \\\"512\\\", \\\"VmaMod\\\": \\\"0\\\", \\\"Columns\\\": \\\"512\\\", \\\"HighBit\\\": \\\"15\\\", \\\"StudyID\\\": \\\"1\\\", \\\"SuiteId\\\": \\\"LS16\\\", \\\"VmaClip\\\": \\\"0\\\", \\\"VmaMamp\\\": \\\"0\\\", \\\"Exposure\\\": \\\"41\\\", \\\"Modality\\\": \\\"CT\\\", \\\"ImageType\\\": \\\"ORIGINAL\\\\\\\\PRIMARY\\\\\\\\AXIAL\\\", \\\"PatientID\\\": \\\"0\\\", \\\"PlaneType\\\": \\\"2\\\", \\\"ProductId\\\": \\\"LightSpeed Pro\\\", \\\"ScoutType\\\": \\\"0\\\", \\\"StudyDate\\\": \\\"20151207\\\", \\\"StudyTime\\\": \\\"073153\\\", \\\"XrayChain\\\": \\\"99\\\\\\\\99\\\\\\\\99\\\", \\\"BitsStored\\\": \\\"16\\\", \\\"DASAdInput\\\": \\\"0\\\", \\\"DASCalMode\\\": \\\"0\\\", \\\"DASFpaGain\\\": \\\"0\\\", \\\"FilterType\\\": \\\"BODY FILTER\\\", \\\"FocalSpots\\\": \\\"1.200000\\\", \\\"PatientAge\\\": \\\"062Y\\\", \\\"PatientSex\\\": \\\"M\\\", \\\"SeriesDate\\\": \\\"20151207\\\", \\\"SeriesTime\\\": \\\"073458\\\", \\\"TableSpeed\\\": \\\"0.000000\\\", \\\"CellSpacing\\\": \\\"1.023900\\\", \\\"ContentDate\\\": \\\"20151207\\\", \\\"ContentTime\\\": \\\"073659\\\", \\\"LastScanRAS\\\": \\\"I\\\", \\\"MidScanFlag\\\": \\\"1\\\", \\\"MidScanTime\\\": \\\"136.928848\\\", \\\"PatientName\\\": \\\"Anonymized^^\\\", \\\"PatientSize\\\": \\\"1.75\\\", \\\"RescaleType\\\": \\\"HU\\\", \\\"SOPClassUID\\\": \\\"1.2.840.10008.5.1.4.1.1.2\\\", \\\"ScanFOVType\\\": \\\"16\\\", \\\"ScanOptions\\\": \\\"AXIAL MODE\\\", \\\"StationName\\\": \\\"\\\", \\\"TableHeight\\\": \\\"182.500000\\\", \\\"WindowValue\\\": \\\"350\\\", \\\"WindowWidth\\\": \\\"350\\\", \\\"EquipmentUID\\\": \\\"\\\", \\\"ExposureTime\\\": \\\"700\\\", \\\"FirstScanRAS\\\": \\\"I\\\", \\\"FullFidelity\\\": \\\"CT_LIGHTSPEED\\\", \\\"GantryPeriod\\\": \\\"0.700000\\\", \\\"Manufacturer\\\": \\\"GE MEDICAL SYSTEMS\\\", \\\"NormalACoord\\\": \\\"0\\\", \\\"NormalRCoord\\\": \\\"0\\\", \\\"NormalSCoord\\\": \\\"-1\\\", \\\"PixelSpacing\\\": \\\"0.902344\\\\\\\\0.902344\\\", \\\"ProtocolName\\\": \\\"5.8 KUNAS ONKOLOGIJA (dvi fazes)\\\", \\\"RescaleSlope\\\": \\\" 1\\\", \\\"SeriesNumber\\\": \\\"200\\\", \\\"WindowCenter\\\": \\\"40\\\", \\\"BitsAllocated\\\": \\\"16\\\", \\\"OperatorsName\\\": \\\"²âÊÔÅÉÉúÍ¼-´¦ÀíÍ¼\\\", \\\"PatientWeight\\\": \\\"91.0\\\", \\\"SegmentNumber\\\": \\\"0\\\", \\\"SliceLocation\\\": \\\"-289.750\\\", \\\"BiopsyPosition\\\": \\\"0\\\", \\\"DeltaStartTime', 0, NULL, '2026-08-02 20:19:26', 94);
INSERT INTO `sys_oper_log` VALUES (340, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"7\"}', NULL, 1, '同一Study中的一个检测部位只能对应一个影像Series', '2026-08-02 20:20:52', 338);
INSERT INTO `sys_oper_log` VALUES (341, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"8\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[],\"fileName\":\"image-000001-P02-new-series.dcm\",\"fileSha256\":\"a7e558e42b137eab16da6b1d8b57200a9be156dfee811a0a8a366c1fb7a41efa\",\"finalStatus\":\"PASS\",\"objectId\":3,\"officialStatus\":\"PASS\",\"orthancInstanceId\":\"31c517e3-6c708a3a-db8acaf9-a392b839-7f9e1a12\",\"positionId\":8,\"seriesUid\":\"1.3.6.1.4.1.44316.6.102.2.20250704114423696.32099027234284793743\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"1.3.6.1.4.1.44316.6.102.3.20250704114423665.39432108326036765554\",\"studyUid\":\"1.3.6.1.4.1.44316.6.102.1.20250704114423696.61158672119535771932\",\"validationRecordId\":3}}', 0, NULL, '2026-08-02 20:23:54', 322);
INSERT INTO `sys_oper_log` VALUES (342, 'NDT评定', 1, 'com.ruoyi.ndt.evaluation.controller.NdtEvaluationController.add()', 'POST', 1, 'admin', '研发部门', '/ndt/evaluation', '127.0.0.1', '内网IP', '{\"conclusion\":\"工件测试评定\",\"createBy\":\"admin\",\"description\":\"111111\",\"evaluationType\":\"WORKPIECE\",\"evaluatorId\":1,\"id\":1,\"level\":\"1\",\"params\":{},\"status\":\"DRAFT\",\"updateBy\":\"admin\",\"workpieceId\":3} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"conclusion\":\"工件测试评定\",\"createBy\":\"admin\",\"description\":\"111111\",\"evaluationType\":\"WORKPIECE\",\"evaluatorId\":1,\"id\":1,\"level\":\"1\",\"params\":{},\"status\":\"DRAFT\",\"updateBy\":\"admin\",\"workpieceId\":3}}', 0, NULL, '2026-08-02 20:40:06', 97);
INSERT INTO `sys_oper_log` VALUES (343, 'NDT任务报告', 1, 'com.ruoyi.ndt.report.controller.NdtTaskReportController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/report/upload', '127.0.0.1', '内网IP', '{\"taskId\":\"3\"}', NULL, 1, '保存报告文件失败', '2026-08-02 20:52:43', 24);
INSERT INTO `sys_oper_log` VALUES (344, 'NDT任务报告', 1, 'com.ruoyi.ndt.report.controller.NdtTaskReportController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/report/upload', '127.0.0.1', '内网IP', '{\"taskId\":\"3\"}', NULL, 1, '保存报告文件失败', '2026-08-02 20:59:30', 19);
INSERT INTO `sys_oper_log` VALUES (345, 'NDT任务报告', 1, 'com.ruoyi.ndt.report.controller.NdtTaskReportController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/report/upload', '127.0.0.1', '内网IP', '{\"taskId\":\"3\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"createBy\":\"admin\",\"createTime\":\"2026-08-02 21:00:00\",\"filePath\":\"C:\\\\Users\\\\china\\\\Code\\\\RuoYi-profile\\\\ndt-reports\\\\3\\\\v1-房屋租赁合同FWZL2026060337723420260801121852.pdf\",\"generateBy\":1,\"generateName\":\"若依\",\"generateTime\":\"2026-08-02 21:00:01\",\"id\":1,\"params\":{},\"reportName\":\"房屋租赁合同FWZL2026060337723420260801121852.pdf\",\"sha256\":\"be41c42136318ce361e5f02cd90fc171b249678a5fbe95942b01edf1033a293c\",\"status\":\"DRAFT\",\"taskId\":3,\"taskName\":\"测试任务A\",\"updateBy\":\"admin\",\"updateTime\":\"2026-08-02 21:00:00\",\"version\":\"1\"}}', 0, NULL, '2026-08-02 21:00:00', 123);
INSERT INTO `sys_oper_log` VALUES (346, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"7\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[\"validate_iods 官方校验失败：Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-3667232956667416422.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.2.1\\\" (Enhanced CT Image IOD)\\r\\n\\r\\nErrors\\r\\n======\\r\\n\\r\\nModule \\\"CT Position\\\":\\r\\n(5200,9229) (Shared Functional Groups Sequence) / (0018,9326) (CT Position Sequence):\\r\\n  Tag (0018,9313) (Data Collection Center (Patient)) is missing\\r\\n  Tag (0018,9318) (Reconstruction Target Center (Patient)) is missing\\r\\n\\r\\nModule \\\"CT X-Ray Details\\\":\\r\\n(5200,9229) (Shared Functional Groups Sequence) / (0018,9325) (CT X-Ray Details Sequence):\\r\\n  Tag (0018,7050) (Filter Material) is missing\\r\\n\\r\\nModule \\\"General\\\":\\r\\nTag (0008,0032) (Acquisition Time) is unexpected\\r\\nTag (0010,2160) (Ethnic Group) is unexpected\\r\\nTag (0014,1020) (Expiry Date) is unexpected\\r\\nTag (0032,4000) (Study Comments) is unexpected\\r\\n\\r\\n======\"],\"fileName\":\"dicondeEnhancedCtExampleImageE2767-13Typical.dcm\",\"fileSha256\":\"49c1e0ecf5aa8f6344db1a663e48783ca1328dcda5557b28f78ce5c760869e6f\",\"finalStatus\":\"FAIL\",\"officialStatus\":\"FAIL\",\"positionId\":7,\"seriesUid\":\"2.16.840.1.114229.80.20140203.160754.76312.1.1\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2.1\",\"sopInstanceUid\":\"2.16.840.1.114229.80.20140203.160754.76312\",\"studyUid\":\"2.16.840.1.114229.80.20140203.160754.76312.1\",\"validationRecordId\":4}}', 0, NULL, '2026-08-02 22:20:07', 799);
INSERT INTO `sys_oper_log` VALUES (347, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"7\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[\"validate_iods 官方校验失败：Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-2753450554026424549.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.6.1\\\" (Ultrasound Image IOD)\\r\\n\\r\\nErrors\\r\\n======\\r\\n\\r\\nModule \\\"General\\\":\\r\\nTag (0010,2160) (Ethnic Group) is unexpected\\r\\nTag (0014,1020) (Expiry Date) is unexpected\\r\\nTag (0018,6024) (Physical Units X Direction) is unexpected\\r\\nTag (0018,6026) (Physical Units Y Direction) is unexpected\\r\\nTag (0018,602C) (Physical Delta X) is unexpected\\r\\nTag (0018,602E) (Physical Delta Y) is unexpected\\r\\nTag (0032,4000) (Study Comments) is unexpected\\r\\n\\r\\n======\"],\"fileName\":\"dicondeUsExampleImageE2663-11Minimum.DCM\",\"fileSha256\":\"843b4e7ffcb840ac38671b5ffdc532c87d8eba599a88f530b4fea63611b4b1b8\",\"finalStatus\":\"FAIL\",\"officialStatus\":\"FAIL\",\"positionId\":7,\"seriesUid\":\"2.16.840.1.114229.13.1.5151312514.1389091060.2.4885\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.6.1\",\"sopInstanceUid\":\"1.2.528.1.1001.100.4.1269.841.86472596787.201401355436666\",\"studyUid\":\"2.16.840.1.114229.13.1.5151312514.1389091060.2\",\"validationRecordId\":5}}', 0, NULL, '2026-08-02 22:20:13', 242);
INSERT INTO `sys_oper_log` VALUES (348, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"7\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[\"validate_iods 官方校验失败：Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-346717655782139094.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.1\\\" (Computed Radiography Image IOD)\\r\\n\\r\\nErrors\\r\\n======\\r\\n\\r\\nModule \\\"General\\\":\\r\\nTag (0010,2160) (Ethnic Group) is unexpected\\r\\nTag (0014,1020) (Expiry Date) is unexpected\\r\\nTag (0032,4000) (Study Comments) is unexpected\\r\\n\\r\\n======\"],\"fileName\":\"dicondeCrExampleImageE2738-11Minimum.DCM\",\"fileSha256\":\"e272badd2fbbb274a84107eea256f152b8c5b6e1e6838f4ffd1aa36df49481d1\",\"finalStatus\":\"FAIL\",\"officialStatus\":\"FAIL\",\"positionId\":7,\"seriesUid\":\"2.16.840.1.114229.17.7.20100406.164813.1.1\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.1\",\"sopInstanceUid\":\"2.16.840.1.114229.17.7.20100406.164813.1.1.1\",\"studyUid\":\"2.16.840.1.114229.17.7.20100406.164813.1\",\"validationRecordId\":6}}', 0, NULL, '2026-08-02 22:20:17', 265);
INSERT INTO `sys_oper_log` VALUES (349, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"7\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[\"validate_iods 官方校验失败：Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-6855650616250347539.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.7\\\" (Secondary Capture Image IOD)\\r\\n\\r\\nErrors\\r\\n======\\r\\n\\r\\nModule \\\"General Series\\\":\\r\\nTag (0008,0060) (Modality) is missing\\r\\n\\r\\n======\"],\"fileName\":\"output.dcm\",\"fileSha256\":\"089283a008713a49f7654d4696f7a31bc8975a8651d6f0a7030bfad0b206ced4\",\"finalStatus\":\"FAIL\",\"officialStatus\":\"FAIL\",\"positionId\":7,\"seriesUid\":\"1.2.276.0.7230010.3.1.3.0.90719.1779900585.273439\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.7\",\"sopInstanceUid\":\"1.2.276.0.7230010.3.1.4.0.90719.1779900585.273441\",\"studyUid\":\"1.2.276.0.7230010.3.1.2.0.90719.1779900585.273440\",\"validationRecordId\":7}}', 0, NULL, '2026-08-02 22:20:25', 239);
INSERT INTO `sys_oper_log` VALUES (350, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"7\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[\"validate_iods 官方校验失败：Using DICOM edition 2026c\\r\\nValidating DICOM file C:\\\\Users\\\\china\\\\AppData\\\\Local\\\\Temp\\\\ruoyi-ndt-12546286564404310509.dcm\\r\\nSOP class is \\\"1.2.840.10008.5.1.4.1.1.1\\\" (Computed Radiography Image IOD)\\r\\n\\r\\nErrors\\r\\n======\\r\\n\\r\\nModule \\\"General\\\":\\r\\nTag (0010,2160) (Ethnic Group) is unexpected\\r\\nTag (0014,1020) (Expiry Date) is unexpected\\r\\nTag (0032,4000) (Study Comments) is unexpected\\r\\n\\r\\n======\"],\"fileName\":\"dicondeCrExampleImageE2738-11Typical.DCM\",\"fileSha256\":\"e516dea77310b9f163b527e1b6347afdab802b643fda8beb00433119384ba17b\",\"finalStatus\":\"FAIL\",\"officialStatus\":\"FAIL\",\"positionId\":7,\"seriesUid\":\"2.16.840.1.114229.17.7.20100406.130434.1.1\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.1\",\"sopInstanceUid\":\"2.16.840.1.114229.17.7.20100406.130434.1.1.1\",\"studyUid\":\"2.16.840.1.114229.17.7.20100406.130434.1\",\"validationRecordId\":8}}', 0, NULL, '2026-08-02 22:20:36', 288);
INSERT INTO `sys_oper_log` VALUES (351, 'NDT DICOM对象', 1, 'com.ruoyi.ndt.dicom.controller.NdtDicomObjectController.upload()', 'POST', 1, 'admin', '研发部门', '/ndt/dicom/object/upload', '127.0.0.1', '内网IP', '{\"positionId\":\"7\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"customStatus\":\"PASS\",\"errors\":[],\"fileName\":\"image-000195.dcm\",\"fileSha256\":\"415266b9dd13bd76fab555bfefac6cc58a0deefa4240ac05662e621e9121dddd\",\"finalStatus\":\"PASS\",\"objectId\":5,\"officialStatus\":\"PASS\",\"orthancInstanceId\":\"4013a57c-613cd279-1e6e916a-3ad4ceef-83eef100\",\"positionId\":7,\"seriesUid\":\"1.3.6.1.4.1.44316.6.102.2.20250704121912287.36535028333355733227\",\"sopClassUid\":\"1.2.840.10008.5.1.4.1.1.2\",\"sopInstanceUid\":\"1.3.6.1.4.1.44316.6.102.3.2025070412239125.151133372912858941086\",\"studyUid\":\"1.3.6.1.4.1.44316.6.102.1.20250704114423696.33358672119535771932\",\"validationRecordId\":9}}', 0, NULL, '2026-08-02 22:23:40', 447);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '岗位信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2026-03-31 17:46:33', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2026-03-31 17:46:33', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2026-03-31 17:46:33', '', NULL, '普通角色');
INSERT INTO `sys_role` VALUES (100, '测试角色', 'test', 3, '1', 1, 1, '0', '0', 'admin', '2026-05-24 18:55:07', '', NULL, NULL);
INSERT INTO `sys_role` VALUES (101, '公司管理员', 'ndt_company_admin', 10, '1', 1, 1, '0', '0', 'admin', '2026-05-29 23:34:02', '', NULL, 'NDT公司管理员');
INSERT INTO `sys_role` VALUES (102, '检测人员', 'ndt_inspector', 11, '2', 1, 1, '0', '0', 'admin', '2026-05-29 23:34:02', '', NULL, 'NDT检测人员');
INSERT INTO `sys_role` VALUES (103, '客户用户', 'ndt_customer', 12, '2', 1, 1, '0', '0', 'admin', '2026-05-29 23:34:02', '', NULL, 'NDT客户只读用户');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);
INSERT INTO `sys_role_menu` VALUES (100, 1);
INSERT INTO `sys_role_menu` VALUES (100, 2);
INSERT INTO `sys_role_menu` VALUES (100, 3);
INSERT INTO `sys_role_menu` VALUES (100, 4);
INSERT INTO `sys_role_menu` VALUES (100, 100);
INSERT INTO `sys_role_menu` VALUES (100, 101);
INSERT INTO `sys_role_menu` VALUES (100, 102);
INSERT INTO `sys_role_menu` VALUES (100, 103);
INSERT INTO `sys_role_menu` VALUES (100, 104);
INSERT INTO `sys_role_menu` VALUES (100, 105);
INSERT INTO `sys_role_menu` VALUES (100, 106);
INSERT INTO `sys_role_menu` VALUES (100, 107);
INSERT INTO `sys_role_menu` VALUES (100, 108);
INSERT INTO `sys_role_menu` VALUES (100, 109);
INSERT INTO `sys_role_menu` VALUES (100, 110);
INSERT INTO `sys_role_menu` VALUES (100, 111);
INSERT INTO `sys_role_menu` VALUES (100, 112);
INSERT INTO `sys_role_menu` VALUES (100, 113);
INSERT INTO `sys_role_menu` VALUES (100, 114);
INSERT INTO `sys_role_menu` VALUES (100, 115);
INSERT INTO `sys_role_menu` VALUES (100, 116);
INSERT INTO `sys_role_menu` VALUES (100, 117);
INSERT INTO `sys_role_menu` VALUES (100, 500);
INSERT INTO `sys_role_menu` VALUES (100, 501);
INSERT INTO `sys_role_menu` VALUES (100, 1000);
INSERT INTO `sys_role_menu` VALUES (100, 1001);
INSERT INTO `sys_role_menu` VALUES (100, 1002);
INSERT INTO `sys_role_menu` VALUES (100, 1003);
INSERT INTO `sys_role_menu` VALUES (100, 1004);
INSERT INTO `sys_role_menu` VALUES (100, 1005);
INSERT INTO `sys_role_menu` VALUES (100, 1006);
INSERT INTO `sys_role_menu` VALUES (100, 1007);
INSERT INTO `sys_role_menu` VALUES (100, 1008);
INSERT INTO `sys_role_menu` VALUES (100, 1009);
INSERT INTO `sys_role_menu` VALUES (100, 1010);
INSERT INTO `sys_role_menu` VALUES (100, 1011);
INSERT INTO `sys_role_menu` VALUES (100, 1012);
INSERT INTO `sys_role_menu` VALUES (100, 1013);
INSERT INTO `sys_role_menu` VALUES (100, 1014);
INSERT INTO `sys_role_menu` VALUES (100, 1015);
INSERT INTO `sys_role_menu` VALUES (100, 1016);
INSERT INTO `sys_role_menu` VALUES (100, 1017);
INSERT INTO `sys_role_menu` VALUES (100, 1018);
INSERT INTO `sys_role_menu` VALUES (100, 1019);
INSERT INTO `sys_role_menu` VALUES (100, 1020);
INSERT INTO `sys_role_menu` VALUES (100, 1021);
INSERT INTO `sys_role_menu` VALUES (100, 1022);
INSERT INTO `sys_role_menu` VALUES (100, 1023);
INSERT INTO `sys_role_menu` VALUES (100, 1024);
INSERT INTO `sys_role_menu` VALUES (100, 1025);
INSERT INTO `sys_role_menu` VALUES (100, 1026);
INSERT INTO `sys_role_menu` VALUES (100, 1027);
INSERT INTO `sys_role_menu` VALUES (100, 1028);
INSERT INTO `sys_role_menu` VALUES (100, 1029);
INSERT INTO `sys_role_menu` VALUES (100, 1030);
INSERT INTO `sys_role_menu` VALUES (100, 1031);
INSERT INTO `sys_role_menu` VALUES (100, 1032);
INSERT INTO `sys_role_menu` VALUES (100, 1033);
INSERT INTO `sys_role_menu` VALUES (100, 1034);
INSERT INTO `sys_role_menu` VALUES (100, 1035);
INSERT INTO `sys_role_menu` VALUES (100, 1036);
INSERT INTO `sys_role_menu` VALUES (100, 1037);
INSERT INTO `sys_role_menu` VALUES (100, 1038);
INSERT INTO `sys_role_menu` VALUES (100, 1039);
INSERT INTO `sys_role_menu` VALUES (100, 1040);
INSERT INTO `sys_role_menu` VALUES (100, 1041);
INSERT INTO `sys_role_menu` VALUES (100, 1042);
INSERT INTO `sys_role_menu` VALUES (100, 1043);
INSERT INTO `sys_role_menu` VALUES (100, 1044);
INSERT INTO `sys_role_menu` VALUES (100, 1045);
INSERT INTO `sys_role_menu` VALUES (100, 1046);
INSERT INTO `sys_role_menu` VALUES (100, 1047);
INSERT INTO `sys_role_menu` VALUES (100, 1048);
INSERT INTO `sys_role_menu` VALUES (100, 1049);
INSERT INTO `sys_role_menu` VALUES (100, 1050);
INSERT INTO `sys_role_menu` VALUES (100, 1051);
INSERT INTO `sys_role_menu` VALUES (100, 1052);
INSERT INTO `sys_role_menu` VALUES (100, 1053);
INSERT INTO `sys_role_menu` VALUES (100, 1054);
INSERT INTO `sys_role_menu` VALUES (100, 1055);
INSERT INTO `sys_role_menu` VALUES (100, 1056);
INSERT INTO `sys_role_menu` VALUES (100, 1057);
INSERT INTO `sys_role_menu` VALUES (100, 1058);
INSERT INTO `sys_role_menu` VALUES (100, 1059);
INSERT INTO `sys_role_menu` VALUES (100, 1060);
INSERT INTO `sys_role_menu` VALUES (101, 2013);
INSERT INTO `sys_role_menu` VALUES (101, 2014);
INSERT INTO `sys_role_menu` VALUES (101, 2015);
INSERT INTO `sys_role_menu` VALUES (101, 2016);
INSERT INTO `sys_role_menu` VALUES (101, 2017);
INSERT INTO `sys_role_menu` VALUES (101, 2018);
INSERT INTO `sys_role_menu` VALUES (101, 2019);
INSERT INTO `sys_role_menu` VALUES (101, 2020);
INSERT INTO `sys_role_menu` VALUES (101, 2021);
INSERT INTO `sys_role_menu` VALUES (101, 2022);
INSERT INTO `sys_role_menu` VALUES (101, 2023);
INSERT INTO `sys_role_menu` VALUES (101, 2024);
INSERT INTO `sys_role_menu` VALUES (101, 2025);
INSERT INTO `sys_role_menu` VALUES (101, 2026);
INSERT INTO `sys_role_menu` VALUES (101, 2027);
INSERT INTO `sys_role_menu` VALUES (101, 2028);
INSERT INTO `sys_role_menu` VALUES (101, 2029);
INSERT INTO `sys_role_menu` VALUES (101, 2030);
INSERT INTO `sys_role_menu` VALUES (101, 2031);
INSERT INTO `sys_role_menu` VALUES (101, 2032);
INSERT INTO `sys_role_menu` VALUES (101, 2033);
INSERT INTO `sys_role_menu` VALUES (101, 2034);
INSERT INTO `sys_role_menu` VALUES (101, 2035);
INSERT INTO `sys_role_menu` VALUES (101, 2036);
INSERT INTO `sys_role_menu` VALUES (101, 2037);
INSERT INTO `sys_role_menu` VALUES (101, 2038);
INSERT INTO `sys_role_menu` VALUES (101, 2039);
INSERT INTO `sys_role_menu` VALUES (101, 2040);
INSERT INTO `sys_role_menu` VALUES (101, 2041);
INSERT INTO `sys_role_menu` VALUES (101, 2042);
INSERT INTO `sys_role_menu` VALUES (101, 2043);
INSERT INTO `sys_role_menu` VALUES (101, 2044);
INSERT INTO `sys_role_menu` VALUES (101, 2045);
INSERT INTO `sys_role_menu` VALUES (101, 2046);
INSERT INTO `sys_role_menu` VALUES (101, 2047);
INSERT INTO `sys_role_menu` VALUES (101, 2048);
INSERT INTO `sys_role_menu` VALUES (101, 2049);
INSERT INTO `sys_role_menu` VALUES (101, 2050);
INSERT INTO `sys_role_menu` VALUES (101, 2051);
INSERT INTO `sys_role_menu` VALUES (101, 2052);
INSERT INTO `sys_role_menu` VALUES (101, 2053);
INSERT INTO `sys_role_menu` VALUES (101, 2054);
INSERT INTO `sys_role_menu` VALUES (101, 2055);
INSERT INTO `sys_role_menu` VALUES (101, 2056);
INSERT INTO `sys_role_menu` VALUES (101, 2057);
INSERT INTO `sys_role_menu` VALUES (101, 2058);
INSERT INTO `sys_role_menu` VALUES (101, 2059);
INSERT INTO `sys_role_menu` VALUES (101, 2060);
INSERT INTO `sys_role_menu` VALUES (101, 2061);
INSERT INTO `sys_role_menu` VALUES (101, 2062);
INSERT INTO `sys_role_menu` VALUES (101, 2063);
INSERT INTO `sys_role_menu` VALUES (101, 2064);
INSERT INTO `sys_role_menu` VALUES (101, 2065);
INSERT INTO `sys_role_menu` VALUES (101, 2066);
INSERT INTO `sys_role_menu` VALUES (101, 2067);
INSERT INTO `sys_role_menu` VALUES (101, 2068);
INSERT INTO `sys_role_menu` VALUES (101, 2069);
INSERT INTO `sys_role_menu` VALUES (101, 2070);
INSERT INTO `sys_role_menu` VALUES (101, 2071);
INSERT INTO `sys_role_menu` VALUES (101, 2072);
INSERT INTO `sys_role_menu` VALUES (101, 2073);
INSERT INTO `sys_role_menu` VALUES (101, 2074);
INSERT INTO `sys_role_menu` VALUES (101, 2075);
INSERT INTO `sys_role_menu` VALUES (101, 2076);
INSERT INTO `sys_role_menu` VALUES (101, 2077);
INSERT INTO `sys_role_menu` VALUES (101, 2078);
INSERT INTO `sys_role_menu` VALUES (101, 2079);
INSERT INTO `sys_role_menu` VALUES (101, 2080);
INSERT INTO `sys_role_menu` VALUES (101, 2081);
INSERT INTO `sys_role_menu` VALUES (101, 2082);
INSERT INTO `sys_role_menu` VALUES (101, 2083);
INSERT INTO `sys_role_menu` VALUES (101, 2084);
INSERT INTO `sys_role_menu` VALUES (101, 2085);
INSERT INTO `sys_role_menu` VALUES (101, 2086);
INSERT INTO `sys_role_menu` VALUES (101, 2087);
INSERT INTO `sys_role_menu` VALUES (101, 2088);
INSERT INTO `sys_role_menu` VALUES (101, 2089);
INSERT INTO `sys_role_menu` VALUES (101, 2090);
INSERT INTO `sys_role_menu` VALUES (101, 2091);
INSERT INTO `sys_role_menu` VALUES (101, 2092);
INSERT INTO `sys_role_menu` VALUES (101, 2093);
INSERT INTO `sys_role_menu` VALUES (102, 2013);
INSERT INTO `sys_role_menu` VALUES (102, 2014);
INSERT INTO `sys_role_menu` VALUES (102, 2015);
INSERT INTO `sys_role_menu` VALUES (102, 2018);
INSERT INTO `sys_role_menu` VALUES (102, 2019);
INSERT INTO `sys_role_menu` VALUES (102, 2020);
INSERT INTO `sys_role_menu` VALUES (102, 2025);
INSERT INTO `sys_role_menu` VALUES (102, 2026);
INSERT INTO `sys_role_menu` VALUES (102, 2027);
INSERT INTO `sys_role_menu` VALUES (102, 2036);
INSERT INTO `sys_role_menu` VALUES (102, 2037);
INSERT INTO `sys_role_menu` VALUES (102, 2038);
INSERT INTO `sys_role_menu` VALUES (102, 2039);
INSERT INTO `sys_role_menu` VALUES (102, 2041);
INSERT INTO `sys_role_menu` VALUES (102, 2042);
INSERT INTO `sys_role_menu` VALUES (102, 2043);
INSERT INTO `sys_role_menu` VALUES (102, 2044);
INSERT INTO `sys_role_menu` VALUES (102, 2045);
INSERT INTO `sys_role_menu` VALUES (102, 2046);
INSERT INTO `sys_role_menu` VALUES (102, 2048);
INSERT INTO `sys_role_menu` VALUES (102, 2049);
INSERT INTO `sys_role_menu` VALUES (102, 2051);
INSERT INTO `sys_role_menu` VALUES (102, 2052);
INSERT INTO `sys_role_menu` VALUES (102, 2069);
INSERT INTO `sys_role_menu` VALUES (102, 2070);
INSERT INTO `sys_role_menu` VALUES (102, 2071);
INSERT INTO `sys_role_menu` VALUES (102, 2072);
INSERT INTO `sys_role_menu` VALUES (102, 2073);
INSERT INTO `sys_role_menu` VALUES (102, 2074);
INSERT INTO `sys_role_menu` VALUES (102, 2075);
INSERT INTO `sys_role_menu` VALUES (102, 2076);
INSERT INTO `sys_role_menu` VALUES (102, 2077);
INSERT INTO `sys_role_menu` VALUES (102, 2078);
INSERT INTO `sys_role_menu` VALUES (102, 2079);
INSERT INTO `sys_role_menu` VALUES (102, 2081);
INSERT INTO `sys_role_menu` VALUES (102, 2082);
INSERT INTO `sys_role_menu` VALUES (102, 2083);
INSERT INTO `sys_role_menu` VALUES (102, 2084);
INSERT INTO `sys_role_menu` VALUES (102, 2085);
INSERT INTO `sys_role_menu` VALUES (102, 2086);
INSERT INTO `sys_role_menu` VALUES (102, 2087);
INSERT INTO `sys_role_menu` VALUES (102, 2088);
INSERT INTO `sys_role_menu` VALUES (102, 2089);
INSERT INTO `sys_role_menu` VALUES (102, 2090);
INSERT INTO `sys_role_menu` VALUES (102, 2091);
INSERT INTO `sys_role_menu` VALUES (103, 2013);
INSERT INTO `sys_role_menu` VALUES (103, 2014);
INSERT INTO `sys_role_menu` VALUES (103, 2015);
INSERT INTO `sys_role_menu` VALUES (103, 2018);
INSERT INTO `sys_role_menu` VALUES (103, 2019);
INSERT INTO `sys_role_menu` VALUES (103, 2020);
INSERT INTO `sys_role_menu` VALUES (103, 2025);
INSERT INTO `sys_role_menu` VALUES (103, 2027);
INSERT INTO `sys_role_menu` VALUES (103, 2037);
INSERT INTO `sys_role_menu` VALUES (103, 2041);
INSERT INTO `sys_role_menu` VALUES (103, 2042);
INSERT INTO `sys_role_menu` VALUES (103, 2043);
INSERT INTO `sys_role_menu` VALUES (103, 2044);
INSERT INTO `sys_role_menu` VALUES (103, 2048);
INSERT INTO `sys_role_menu` VALUES (103, 2049);
INSERT INTO `sys_role_menu` VALUES (103, 2051);
INSERT INTO `sys_role_menu` VALUES (103, 2052);
INSERT INTO `sys_role_menu` VALUES (103, 2069);
INSERT INTO `sys_role_menu` VALUES (103, 2070);
INSERT INTO `sys_role_menu` VALUES (103, 2074);
INSERT INTO `sys_role_menu` VALUES (103, 2075);
INSERT INTO `sys_role_menu` VALUES (103, 2079);
INSERT INTO `sys_role_menu` VALUES (103, 2081);
INSERT INTO `sys_role_menu` VALUES (103, 2082);
INSERT INTO `sys_role_menu` VALUES (103, 2087);
INSERT INTO `sys_role_menu` VALUES (103, 2089);
INSERT INTO `sys_role_menu` VALUES (103, 2091);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-08-04 14:54:08', '2026-03-31 17:46:33', 'admin', '2026-03-31 17:46:33', '', NULL, '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-03-31 17:46:33', '2026-03-31 17:46:33', 'admin', '2026-03-31 17:46:33', '', '2026-03-31 18:21:54', '测试员');
INSERT INTO `sys_user` VALUES (100, 103, '宋明豫', '宋明豫', '00', '', '13586801014', '0', '', '$2a$10$.vF8K99SA2SeTBQ3.hvd6evunjwh.BK7emn8REzWfQ7/V36rru5Ly', '0', '0', '', NULL, NULL, 'admin', '2026-07-29 19:52:56', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (101, 100, '张三', '张三', '00', '', '', '0', '', '$2a$10$98q9i/hCCErFEboeNcNohuhK7.xanQwpCDr66EbWXa4P.VaB6wzHS', '0', '0', '', NULL, NULL, 'admin', '2026-07-29 19:53:27', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);
INSERT INTO `sys_user_post` VALUES (101, 4);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (100, 101);
INSERT INTO `sys_user_role` VALUES (101, 2);

SET FOREIGN_KEY_CHECKS = 1;
