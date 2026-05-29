-- DICOM/DCM phase 1: business index, evaluation, dictionaries and menus.

create table if not exists dcm_study (
  id                    bigint        not null auto_increment comment '主键',
  orthanc_study_id      varchar(100)  not null comment 'Orthanc Study ID',
  study_instance_uid    varchar(128)  not null comment 'DICOM StudyInstanceUID',
  study_description     varchar(255)  default null comment 'Study描述',
  study_date            varchar(32)   default null comment 'Study日期',
  accession_number      varchar(100)  default null comment '检查号',
  patient_id            varchar(100)  default null comment '对象编号',
  patient_name          varchar(255)  default null comment '对象名称',
  patient_sex           varchar(32)   default null comment '对象性别',
  patient_birth_date    varchar(32)   default null comment '对象出生日期',
  modality              varchar(64)   default null comment '模态',
  series_count          int           default 0 comment 'Series数量',
  instance_count        int           default 0 comment 'Instance数量',
  upload_user_id        bigint        default null comment '上传用户ID',
  upload_user_name      varchar(100)  default null comment '上传用户',
  status                varchar(32)   not null default 'UPLOADED' comment '业务状态',
  remark                varchar(500)  default null comment '备注',
  create_by             varchar(64)   default '' comment '创建者',
  create_time           datetime      default null comment '创建时间',
  update_by             varchar(64)   default '' comment '更新者',
  update_time           datetime      default null comment '更新时间',
  del_flag              char(1)       not null default '0' comment '删除标志（0存在 2删除）',
  primary key (id),
  unique key uk_dcm_study_uid (study_instance_uid),
  key idx_dcm_study_orthanc (orthanc_study_id)
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci comment='DCM Study索引表';

create table if not exists dcm_series (
  id                    bigint        not null auto_increment comment '主键',
  study_id              bigint        not null comment 'Study主键',
  orthanc_series_id     varchar(100)  not null comment 'Orthanc Series ID',
  series_instance_uid   varchar(128)  not null comment 'DICOM SeriesInstanceUID',
  series_number         varchar(64)   default null comment 'Series编号',
  series_description    varchar(255)  default null comment 'Series描述',
  modality              varchar(64)   default null comment '模态',
  body_part_examined    varchar(128)  default null comment '检查部位',
  instance_count        int           default 0 comment 'Instance数量',
  remark                varchar(500)  default null comment '备注',
  create_by             varchar(64)   default '' comment '创建者',
  create_time           datetime      default null comment '创建时间',
  update_by             varchar(64)   default '' comment '更新者',
  update_time           datetime      default null comment '更新时间',
  del_flag              char(1)       not null default '0' comment '删除标志（0存在 2删除）',
  primary key (id),
  unique key uk_dcm_series_uid (series_instance_uid),
  key idx_dcm_series_study (study_id),
  key idx_dcm_series_orthanc (orthanc_series_id)
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci comment='DCM Series索引表';

create table if not exists dcm_instance (
  id                    bigint        not null auto_increment comment '主键',
  study_id              bigint        not null comment 'Study主键',
  series_id             bigint        not null comment 'Series主键',
  orthanc_instance_id   varchar(100)  not null comment 'Orthanc Instance ID',
  sop_instance_uid      varchar(128)  not null comment 'DICOM SOPInstanceUID',
  instance_number       varchar(64)   default null comment 'Instance编号',
  sop_class_uid         varchar(128)  default null comment 'SOPClassUID',
  image_type            varchar(255)  default null comment '图像类型',
  `rows`                int           default null comment '图像行数',
  `columns`             int           default null comment '图像列数',
  pixel_spacing         varchar(100)  default null comment '像素间距',
  slice_location        varchar(100)  default null comment '切片位置',
  remark                varchar(500)  default null comment '备注',
  create_by             varchar(64)   default '' comment '创建者',
  create_time           datetime      default null comment '创建时间',
  update_by             varchar(64)   default '' comment '更新者',
  update_time           datetime      default null comment '更新时间',
  del_flag              char(1)       not null default '0' comment '删除标志（0存在 2删除）',
  primary key (id),
  unique key uk_dcm_instance_uid (sop_instance_uid),
  key idx_dcm_instance_study (study_id),
  key idx_dcm_instance_series (series_id),
  key idx_dcm_instance_orthanc (orthanc_instance_id)
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci comment='DCM Instance索引表';

create table if not exists dcm_evaluation (
  id                    bigint         not null auto_increment comment '主键',
  study_id              bigint         not null comment 'Study主键',
  series_id             bigint         default null comment 'Series主键',
  instance_id           bigint         default null comment 'Instance主键',
  evaluator_id          bigint         default null comment '评定人ID',
  evaluator_name        varchar(100)   default null comment '评定人',
  image_quality_result  varchar(32)    default 'UNKNOWN' comment '图像质量结果',
  defect_result         varchar(32)    default 'UNKNOWN' comment '缺陷结果',
  defect_level          varchar(64)    default null comment '缺陷等级',
  defect_description    varchar(1000)  default null comment '缺陷描述',
  evaluation_conclusion varchar(1000)  default null comment '评定结论',
  evaluation_status     varchar(32)    not null default 'DRAFT' comment '评定状态',
  evaluation_time       datetime       default null comment '提交时间',
  remark                varchar(500)   default null comment '备注',
  create_by             varchar(64)    default '' comment '创建者',
  create_time           datetime       default null comment '创建时间',
  update_by             varchar(64)    default '' comment '更新者',
  update_time           datetime       default null comment '更新时间',
  del_flag              char(1)        not null default '0' comment '删除标志（0存在 2删除）',
  primary key (id),
  unique key uk_dcm_evaluation_study (study_id)
) engine=InnoDB default charset=utf8mb4 collate=utf8mb4_0900_ai_ci comment='DCM当前评定表';

insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
select 'DCM Study状态', 'dcm_study_status', '0', 'admin', sysdate(), 'DCM Study业务状态'
where not exists (select 1 from sys_dict_type where dict_type = 'dcm_study_status');
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
select 'DCM评定状态', 'dcm_evaluation_status', '0', 'admin', sysdate(), 'DCM评定保存状态'
where not exists (select 1 from sys_dict_type where dict_type = 'dcm_evaluation_status');
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
select 'DCM图像质量结果', 'dcm_quality_result', '0', 'admin', sysdate(), 'DCM图像质量结果'
where not exists (select 1 from sys_dict_type where dict_type = 'dcm_quality_result');
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
select 'DCM缺陷结果', 'dcm_defect_result', '0', 'admin', sysdate(), 'DCM缺陷结果'
where not exists (select 1 from sys_dict_type where dict_type = 'dcm_defect_result');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 1, '已上传', 'UPLOADED', 'dcm_study_status', 'info', 'Y', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'dcm_study_status' and dict_value = 'UPLOADED');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 2, '评定中', 'EVALUATING', 'dcm_study_status', 'warning', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'dcm_study_status' and dict_value = 'EVALUATING');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 3, '已评定', 'EVALUATED', 'dcm_study_status', 'success', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'dcm_study_status' and dict_value = 'EVALUATED');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 1, '草稿', 'DRAFT', 'dcm_evaluation_status', 'info', 'Y', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'dcm_evaluation_status' and dict_value = 'DRAFT');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 2, '已提交', 'SUBMITTED', 'dcm_evaluation_status', 'success', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'dcm_evaluation_status' and dict_value = 'SUBMITTED');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 1, '合格', 'PASS', 'dcm_quality_result', 'success', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'dcm_quality_result' and dict_value = 'PASS');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 2, '不合格', 'FAIL', 'dcm_quality_result', 'danger', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'dcm_quality_result' and dict_value = 'FAIL');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 3, '未知', 'UNKNOWN', 'dcm_quality_result', 'info', 'Y', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'dcm_quality_result' and dict_value = 'UNKNOWN');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 1, '合格', 'PASS', 'dcm_defect_result', 'success', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'dcm_defect_result' and dict_value = 'PASS');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 2, '不合格', 'FAIL', 'dcm_defect_result', 'danger', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'dcm_defect_result' and dict_value = 'FAIL');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 3, '未知', 'UNKNOWN', 'dcm_defect_result', 'info', 'Y', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'dcm_defect_result' and dict_value = 'UNKNOWN');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'DICOM 管理', 0, 4, 'dcm', null, '', '', 1, 0, 'M', '0', '0', '', 'picture', 'admin', sysdate(), 'DICOM业务管理目录'
where not exists (select 1 from sys_menu where parent_id = 0 and path = 'dcm');
set @dcm_parent_id = (select menu_id from sys_menu where parent_id = 0 and path = 'dcm' order by menu_id limit 1);

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'DCM 上传', @dcm_parent_id, 1, 'upload', 'dcm/upload/index', '', '', 1, 0, 'C', '0', '0', 'dcm:upload:add', 'upload', 'admin', sysdate(), '单个DCM上传'
where not exists (select 1 from sys_menu where parent_id = @dcm_parent_id and path = 'upload');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'Study 列表', @dcm_parent_id, 2, 'study', 'dcm/study/index', '', '', 1, 0, 'C', '0', '0', 'dcm:study:list', 'list', 'admin', sysdate(), 'DCM Study管理'
where not exists (select 1 from sys_menu where parent_id = @dcm_parent_id and path = 'study');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '评定记录', @dcm_parent_id, 3, 'evaluation', 'dcm/evaluation/index', '', '', 1, 0, 'C', '0', '0', 'dcm:evaluation:list', 'form', 'admin', sysdate(), 'DCM评定记录'
where not exists (select 1 from sys_menu where parent_id = @dcm_parent_id and path = 'evaluation');

set @dcm_upload_id = (select menu_id from sys_menu where parent_id = @dcm_parent_id and path = 'upload' order by menu_id limit 1);
set @dcm_study_id = (select menu_id from sys_menu where parent_id = @dcm_parent_id and path = 'study' order by menu_id limit 1);
set @dcm_evaluation_id = (select menu_id from sys_menu where parent_id = @dcm_parent_id and path = 'evaluation' order by menu_id limit 1);

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'DCM上传', @dcm_upload_id, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'dcm:upload:add', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'dcm:upload:add' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'Study查询', @dcm_study_id, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'dcm:study:query', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'dcm:study:query' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'Study删除', @dcm_study_id, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'dcm:study:remove', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'dcm:study:remove' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'Series查询', @dcm_study_id, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'dcm:series:list', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'dcm:series:list' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'Instance查询', @dcm_study_id, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'dcm:instance:list', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'dcm:instance:list' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '评定查询', @dcm_evaluation_id, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'dcm:evaluation:query', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'dcm:evaluation:query' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '评定新增', @dcm_evaluation_id, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'dcm:evaluation:add', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'dcm:evaluation:add' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '评定修改', @dcm_evaluation_id, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'dcm:evaluation:edit', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'dcm:evaluation:edit' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '评定删除', @dcm_evaluation_id, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'dcm:evaluation:remove', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'dcm:evaluation:remove' and menu_type = 'F');
