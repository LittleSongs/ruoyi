-- NDT Series 对象归档规则迁移
-- 规则：一个图像 Series 仅有一张有效原始图；图像派生对象与原图同 Series；SR 使用独立 Series。
-- 执行前应确认不存在同一 Series 下多张有效 ORIGINAL_IMAGE。

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;

ALTER TABLE `ndt_dicom_series`
  DROP COLUMN `series_role`;

CREATE UNIQUE INDEX `uk_ndt_object_active_original_series`
  ON `ndt_dicom_object`
  ((CASE WHEN `object_type` = 'ORIGINAL_IMAGE' AND `del_flag` = '0' THEN `series_id` ELSE NULL END));
