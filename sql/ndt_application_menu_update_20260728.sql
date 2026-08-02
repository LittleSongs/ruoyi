-- NDT application menu/permission/dictionary replacement.
-- This changes sys_* DATA only. It does not change any sys_* table structure.

SET NAMES utf8mb4;
START TRANSACTION;

DELETE FROM sys_role_menu WHERE menu_id BETWEEN 2000 AND 2012;
DELETE FROM sys_menu WHERE menu_id BETWEEN 2000 AND 2012;

UPDATE sys_menu
SET menu_name='客户管理', path='customer', component='ndt/company/index',
    perms='ndt:customer:list', update_by='admin', update_time=NOW()
WHERE menu_id=2058;

UPDATE sys_menu SET order_num=12 WHERE menu_id=2059;

DELETE FROM sys_role_menu WHERE menu_id BETWEEN 2065 AND 2093;
DELETE FROM sys_menu WHERE menu_id BETWEEN 2065 AND 2093;

INSERT INTO sys_menu
(menu_id,menu_name,parent_id,order_num,path,component,query,route_name,is_frame,is_cache,menu_type,visible,status,perms,icon,create_by,create_time,update_by,remark)
VALUES
(2065,'客户查询',2058,1,'','',NULL,'',1,0,'F','0','0','ndt:customer:query','#','admin',NOW(),'',''),
(2066,'客户新增',2058,2,'','',NULL,'',1,0,'F','0','0','ndt:customer:add','#','admin',NOW(),'',''),
(2067,'客户修改',2058,3,'','',NULL,'',1,0,'F','0','0','ndt:customer:edit','#','admin',NOW(),'',''),
(2068,'客户删除',2058,4,'','',NULL,'',1,0,'F','0','0','ndt:customer:remove','#','admin',NOW(),'',''),
(2069,'工件列表',2014,10,'','',NULL,'',1,0,'F','0','0','ndt:workpiece:list','#','admin',NOW(),'',''),
(2070,'工件查询',2014,11,'','',NULL,'',1,0,'F','0','0','ndt:workpiece:query','#','admin',NOW(),'',''),
(2071,'工件新增',2014,12,'','',NULL,'',1,0,'F','0','0','ndt:workpiece:add','#','admin',NOW(),'',''),
(2072,'工件修改',2014,13,'','',NULL,'',1,0,'F','0','0','ndt:workpiece:edit','#','admin',NOW(),'',''),
(2073,'工件删除',2014,14,'','',NULL,'',1,0,'F','0','0','ndt:workpiece:remove','#','admin',NOW(),'',''),
(2074,'部位列表',2014,15,'','',NULL,'',1,0,'F','0','0','ndt:position:list','#','admin',NOW(),'',''),
(2075,'部位查询',2014,16,'','',NULL,'',1,0,'F','0','0','ndt:position:query','#','admin',NOW(),'',''),
(2076,'部位新增',2014,17,'','',NULL,'',1,0,'F','0','0','ndt:position:add','#','admin',NOW(),'',''),
(2077,'部位修改',2014,18,'','',NULL,'',1,0,'F','0','0','ndt:position:edit','#','admin',NOW(),'',''),
(2078,'部位删除',2014,19,'','',NULL,'',1,0,'F','0','0','ndt:position:remove','#','admin',NOW(),'',''),
(2079,'对象查询',2015,10,'','',NULL,'',1,0,'F','0','0','ndt:dicom:query','#','admin',NOW(),'',''),
(2080,'对象删除',2015,11,'','',NULL,'',1,0,'F','0','0','ndt:dicom:remove','#','admin',NOW(),'',''),
(2081,'缺陷列表',2019,10,'','',NULL,'',1,0,'F','0','0','ndt:defect:list','#','admin',NOW(),'',''),
(2082,'缺陷查询',2019,11,'','',NULL,'',1,0,'F','0','0','ndt:defect:query','#','admin',NOW(),'',''),
(2083,'缺陷新增',2019,12,'','',NULL,'',1,0,'F','0','0','ndt:defect:add','#','admin',NOW(),'',''),
(2084,'缺陷修改',2019,13,'','',NULL,'',1,0,'F','0','0','ndt:defect:edit','#','admin',NOW(),'',''),
(2085,'缺陷删除',2019,14,'','',NULL,'',1,0,'F','0','0','ndt:defect:remove','#','admin',NOW(),'',''),
(2086,'评定提交',2019,15,'','',NULL,'',1,0,'F','0','0','ndt:evaluation:submit','#','admin',NOW(),'',''),
(2087,'复核查询',2019,16,'','',NULL,'',1,0,'F','0','0','ndt:review:list','#','admin',NOW(),'',''),
(2088,'复核追加',2019,17,'','',NULL,'',1,0,'F','0','0','ndt:review:add','#','admin',NOW(),'',''),
(2089,'报告查询',2043,2,'','',NULL,'',1,0,'F','0','0','ndt:report:query','#','admin',NOW(),'',''),
(2090,'报告上传',2043,3,'','',NULL,'',1,0,'F','0','0','ndt:report:add','#','admin',NOW(),'',''),
(2091,'报告下载',2043,4,'','',NULL,'',1,0,'F','0','0','ndt:report:download','#','admin',NOW(),'',''),
(2092,'报告状态',2043,5,'','',NULL,'',1,0,'F','0','0','ndt:report:edit','#','admin',NOW(),'',''),
(2093,'报告删除',2043,6,'','',NULL,'',1,0,'F','0','0','ndt:report:remove','#','admin',NOW(),'','');

-- Company administrator: all NDT menus and actions.
INSERT IGNORE INTO sys_role_menu(role_id,menu_id)
SELECT 101,menu_id FROM sys_menu WHERE menu_id BETWEEN 2013 AND 2093;

-- Inspector: task hierarchy, DICOM, defects/evaluations/reviews, report upload/download.
INSERT IGNORE INTO sys_role_menu(role_id,menu_id)
SELECT 102,menu_id FROM sys_menu WHERE menu_id IN
(2069,2070,2071,2072,2073,2074,2075,2076,2077,2078,2079,2081,2082,2083,2084,2085,2086,2087,2088,2089,2090,2091);
INSERT IGNORE INTO sys_role_menu(role_id,menu_id)
SELECT 102,menu_id FROM sys_menu WHERE menu_id IN (2041,2042,2043,2048,2049,2051,2052);

-- Customer/viewer: read-only hierarchy, objects, evaluations, reviews and reports.
INSERT IGNORE INTO sys_role_menu(role_id,menu_id)
SELECT 103,menu_id FROM sys_menu WHERE menu_id IN
(2069,2070,2074,2075,2079,2081,2082,2087,2089,2091);
INSERT IGNORE INTO sys_role_menu(role_id,menu_id)
SELECT 103,menu_id FROM sys_menu WHERE menu_id IN (2041,2042,2043,2048,2049,2051,2052);

-- Remove dictionaries that belonged to the dropped dcm_study/dcm_evaluation model.
DELETE FROM sys_dict_data
WHERE dict_type IN ('dcm_study_status','dcm_evaluation_status','dcm_quality_result','dcm_defect_result');
DELETE FROM sys_dict_type
WHERE dict_type IN ('dcm_study_status','dcm_evaluation_status','dcm_quality_result','dcm_defect_result');

-- Replace business dictionaries with the exact codes used by the new model.
DELETE FROM sys_dict_data
WHERE dict_type IN (
  'ndt_task_status','ndt_workpiece_status','ndt_object_type',
  'ndt_evaluation_type','ndt_report_status','ndt_review_result'
);
DELETE FROM sys_dict_type
WHERE dict_type IN (
  'ndt_workpiece_status','ndt_object_type',
  'ndt_evaluation_type','ndt_report_status','ndt_review_result'
);

UPDATE sys_dict_type
SET dict_name='NDT任务状态', status='0', update_by='admin', update_time=NOW(),
    remark='新任务模型状态'
WHERE dict_type='ndt_task_status';

INSERT INTO sys_dict_type
(dict_id,dict_name,dict_type,status,create_by,create_time,update_by,update_time,remark)
VALUES
(110,'NDT工件状态','ndt_workpiece_status','0','admin',NOW(),'',NULL,'新工件模型状态'),
(111,'NDT对象类型','ndt_object_type','0','admin',NOW(),'',NULL,'DICOM及派生对象类型'),
(112,'NDT评定类型','ndt_evaluation_type','0','admin',NOW(),'',NULL,'缺陷或工件评定'),
(113,'NDT报告状态','ndt_report_status','0','admin',NOW(),'',NULL,'任务PDF报告状态'),
(114,'NDT复核结果','ndt_review_result','0','admin',NOW(),'',NULL,'评定复核结果');

INSERT INTO sys_dict_data
(dict_code,dict_sort,dict_label,dict_value,dict_type,css_class,list_class,is_default,status,create_by,create_time,update_by,update_time,remark)
VALUES
(111,1,'草稿','DRAFT','ndt_task_status',NULL,'info','Y','0','admin',NOW(),'',NULL,NULL),
(112,2,'进行中','IN_PROGRESS','ndt_task_status',NULL,'warning','N','0','admin',NOW(),'',NULL,NULL),
(113,3,'已完成','COMPLETED','ndt_task_status',NULL,'success','N','0','admin',NOW(),'',NULL,NULL),
(114,4,'已关闭','CLOSED','ndt_task_status',NULL,'info','N','0','admin',NOW(),'',NULL,NULL),
(130,1,'待处理','PENDING','ndt_workpiece_status',NULL,'info','Y','0','admin',NOW(),'',NULL,NULL),
(131,2,'进行中','IN_PROGRESS','ndt_workpiece_status',NULL,'warning','N','0','admin',NOW(),'',NULL,NULL),
(132,3,'已完成','COMPLETED','ndt_workpiece_status',NULL,'success','N','0','admin',NOW(),'',NULL,NULL),
(133,1,'原始图像','ORIGINAL_IMAGE','ndt_object_type',NULL,'primary','Y','0','admin',NOW(),'',NULL,NULL),
(134,2,'处理图像','PROCESSED_IMAGE','ndt_object_type',NULL,'warning','N','0','admin',NOW(),'',NULL,NULL),
(135,3,'截图','SCREENSHOT','ndt_object_type',NULL,'info','N','0','admin',NOW(),'',NULL,NULL),
(136,4,'标注图像','ANNOTATION_IMAGE','ndt_object_type',NULL,'info','N','0','admin',NOW(),'',NULL,NULL),
(137,5,'显示状态','PRESENTATION_STATE','ndt_object_type',NULL,'info','N','0','admin',NOW(),'',NULL,NULL),
(138,6,'结构化报告','SR','ndt_object_type',NULL,'success','N','0','admin',NOW(),'',NULL,NULL),
(139,7,'其他','OTHER','ndt_object_type',NULL,'info','N','0','admin',NOW(),'',NULL,NULL),
(140,1,'缺陷评定','DEFECT','ndt_evaluation_type',NULL,'primary','Y','0','admin',NOW(),'',NULL,NULL),
(141,2,'工件评定','WORKPIECE','ndt_evaluation_type',NULL,'primary','N','0','admin',NOW(),'',NULL,NULL),
(142,1,'草稿','DRAFT','ndt_report_status',NULL,'info','Y','0','admin',NOW(),'',NULL,NULL),
(143,2,'已发布','RELEASED','ndt_report_status',NULL,'success','N','0','admin',NOW(),'',NULL,NULL),
(144,1,'通过','PASS','ndt_review_result',NULL,'success','Y','0','admin',NOW(),'',NULL,NULL),
(145,2,'驳回','REJECT','ndt_review_result',NULL,'danger','N','0','admin',NOW(),'',NULL,NULL);

COMMIT;
