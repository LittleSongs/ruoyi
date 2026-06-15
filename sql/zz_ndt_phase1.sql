-- NDT DICOM phase 1 MVP: independent business tables, dictionaries, roles and menus.

create table if not exists ndt_inspector_profile (
  id                    bigint        not null auto_increment comment '主键',
  user_id               bigint        not null comment '用户ID',
  inspector_no          varchar(64)   default null comment '检测人员编号',
  certificate_no        varchar(128)  default null comment '证书编号',
  certificate_name      varchar(128)  default null comment '证书名称',
  qualification_level   varchar(64)   default null comment '资质等级',
  issue_date            date          default null comment '发证日期',
  expire_date           date          default null comment '有效期至',
  certificate_file      varchar(500)  default null comment '证书附件地址',
  remark                varchar(500)  default null comment '备注',
  create_by             varchar(64)   default '' comment '创建者',
  create_time           datetime      default null comment '创建时间',
  update_by             varchar(64)   default '' comment '更新者',
  update_time           datetime      default null comment '更新时间',
  del_flag              char(1)       not null default '0' comment '删除标志（0存在 2删除）',
  primary key (id),
  unique key uk_ndt_inspector_user (user_id),
  key idx_ndt_inspector_no (inspector_no)
) engine=InnoDB default charset=utf8mb4 comment='NDT检测人员扩展档案表';

create table if not exists ndt_inspection_task (
  id                    bigint        not null auto_increment comment '主键',
  task_no               varchar(64)   not null comment '检测任务编号',
  task_name             varchar(200)  not null comment '检测任务名称',
  workpiece_name        varchar(200)  default null comment '工件名称',
  customer_dept_id      bigint        not null comment '客户部门ID',
  study_instance_uid    varchar(128)  default null comment 'DICOM StudyInstanceUID',
  orthanc_study_id      varchar(100)  default null comment 'Orthanc Study ID',
  status                varchar(32)   not null default 'DRAFT' comment '任务状态',
  is_public_sample      char(1)       not null default '0' comment '是否公开示例（1是 0否）',
  remark                varchar(500)  default null comment '备注',
  create_by             varchar(64)   default '' comment '创建者',
  create_time           datetime      default null comment '创建时间',
  update_by             varchar(64)   default '' comment '更新者',
  update_time           datetime      default null comment '更新时间',
  del_flag              char(1)       not null default '0' comment '删除标志（0存在 2删除）',
  primary key (id),
  unique key uk_ndt_task_no (task_no),
  key idx_ndt_task_customer (customer_dept_id),
  key idx_ndt_task_study_uid (study_instance_uid),
  key idx_ndt_task_orthanc (orthanc_study_id)
) engine=InnoDB default charset=utf8mb4 comment='NDT检测任务表';

create table if not exists ndt_task_user (
  id                    bigint        not null auto_increment comment '主键',
  task_id               bigint        not null comment '任务ID',
  user_id               bigint        not null comment '用户ID',
  task_role             varchar(32)   not null comment '任务角色：CREATOR/UPLOADER/EVALUATOR/VIEWER',
  can_evaluate          char(1)       not null default '0' comment '是否可评定',
  can_upload            char(1)       not null default '0' comment '是否可上传',
  can_view              char(1)       not null default '1' comment '是否可查看',
  assigned_by           varchar(64)   default '' comment '分配人',
  assigned_time         datetime      default null comment '分配时间',
  primary key (id),
  unique key uk_ndt_task_user_role (task_id, user_id, task_role),
  key idx_ndt_task_user_task (task_id),
  key idx_ndt_task_user_user (user_id)
) engine=InnoDB default charset=utf8mb4 comment='NDT检测任务用户分配表';

create table if not exists ndt_dicom_instance (
  id                    bigint        not null auto_increment comment '主键',
  task_id               bigint        not null comment '任务ID',
  workpiece_name        varchar(200)  default null comment '工件名称',
  customer_dept_id      bigint        not null comment '客户部门ID',
  study_instance_uid    varchar(128)  not null comment 'StudyInstanceUID',
  series_instance_uid   varchar(128)  not null comment 'SeriesInstanceUID',
  sop_instance_uid      varchar(128)  not null comment 'SOPInstanceUID',
  orthanc_study_id      varchar(100)  default null comment 'Orthanc Study ID',
  orthanc_series_id     varchar(100)  default null comment 'Orthanc Series ID',
  orthanc_instance_id   varchar(100)  not null comment 'Orthanc Instance ID',
  modality              varchar(64)   default null comment '模态',
  series_number         varchar(64)   default null comment 'Series编号',
  instance_number       varchar(64)   default null comment 'Instance编号',
  series_description    varchar(255)  default null comment 'Series描述',
  sop_class_uid         varchar(128)  default null comment 'SOPClassUID',
  is_original           char(1)       not null default '1' comment '是否原始图像',
  file_name             varchar(255)  default null comment '原始文件名',
  file_size             bigint        default null comment '文件大小',
  upload_user_id        bigint        default null comment '上传用户ID',
  upload_time           datetime      default null comment '上传时间',
  integrity_status      varchar(32)   not null default 'UNKNOWN' comment '完整性状态',
  remark                varchar(500)  default null comment '备注',
  create_by             varchar(64)   default '' comment '创建者',
  create_time           datetime      default null comment '创建时间',
  update_by             varchar(64)   default '' comment '更新者',
  update_time           datetime      default null comment '更新时间',
  del_flag              char(1)       not null default '0' comment '删除标志（0存在 2删除）',
  primary key (id),
  unique key uk_ndt_dicom_sop (sop_instance_uid),
  key idx_ndt_dicom_task (task_id),
  key idx_ndt_dicom_customer (customer_dept_id),
  key idx_ndt_dicom_study (study_instance_uid),
  key idx_ndt_dicom_orthanc (orthanc_instance_id)
) engine=InnoDB default charset=utf8mb4 comment='NDT DICOM实例索引表';

create table if not exists ndt_dicom_integrity_record (
  id                    bigint        not null auto_increment comment '主键',
  study_instance_uid    varchar(128)  not null comment 'StudyInstanceUID',
  series_instance_uid   varchar(128)  not null comment 'SeriesInstanceUID',
  sop_instance_uid      varchar(128)  not null comment 'SOPInstanceUID',
  orthanc_instance_id   varchar(100)  not null comment 'Orthanc Instance ID',
  pixel_data_sha256     varchar(64)   default null comment 'PixelData SHA-256',
  metadata_sha256       varchar(64)   default null comment '元数据 SHA-256',
  file_sha256           varchar(64)   not null comment '原始文件 SHA-256',
  signed_content        text          default null comment '签名内容',
  signature_algorithm   varchar(64)   default null comment '签名算法',
  signature_value       text          default null comment '签名值',
  public_key_id         varchar(128)  default null comment '公钥ID',
  import_user_id        bigint        default null comment '导入用户ID',
  import_time           datetime      default null comment '导入时间',
  last_verify_time      datetime      default null comment '最后校验时间',
  verify_status         varchar(32)   not null default 'UNKNOWN' comment '校验状态',
  remark                varchar(500)  default null comment '备注',
  create_time           datetime      default null comment '创建时间',
  update_time           datetime      default null comment '更新时间',
  primary key (id),
  unique key uk_ndt_integrity_sop (sop_instance_uid),
  key idx_ndt_integrity_orthanc (orthanc_instance_id)
) engine=InnoDB default charset=utf8mb4 comment='NDT DICOM完整性校验表';

create table if not exists ndt_evaluation (
  id                    bigint         not null auto_increment comment '主键',
  task_id               bigint         not null comment '任务ID',
  study_instance_uid    varchar(128)   default null comment 'StudyInstanceUID',
  series_instance_uid   varchar(128)   default null comment 'SeriesInstanceUID',
  sop_instance_uid      varchar(128)   default null comment 'SOPInstanceUID',
  evaluator_user_id     bigint         default null comment '评定人用户ID',
  defect_type           varchar(128)   default null comment '缺陷类型',
  defect_level          varchar(64)    default null comment '缺陷等级',
  conclusion            varchar(1000)  default null comment '评定结论',
  annotation_json       text           default null comment '标注JSON',
  evaluate_time         datetime       default null comment '评定时间',
  status                varchar(32)    not null default 'DRAFT' comment '评定状态',
  remark                varchar(500)   default null comment '备注',
  create_by             varchar(64)    default '' comment '创建者',
  create_time           datetime       default null comment '创建时间',
  update_by             varchar(64)    default '' comment '更新者',
  update_time           datetime       default null comment '更新时间',
  del_flag              char(1)        not null default '0' comment '删除标志（0存在 2删除）',
  primary key (id),
  key idx_ndt_eval_task (task_id),
  key idx_ndt_eval_sop (sop_instance_uid),
  key idx_ndt_eval_user (evaluator_user_id)
) engine=InnoDB default charset=utf8mb4 comment='NDT评定结果表';

create table if not exists ndt_dicom_object_relation (
  id                    bigint        not null auto_increment comment '主键',
  task_id               bigint        not null comment '任务ID',
  source_sop_instance_uid varchar(128) not null comment '源SOPInstanceUID',
  related_sop_instance_uid varchar(128) default null comment '关联SOPInstanceUID',
  related_type          varchar(32)   not null comment '关联类型',
  related_series_instance_uid varchar(128) default null comment '关联SeriesInstanceUID',
  orthanc_instance_id   varchar(100)  default null comment 'Orthanc Instance ID',
  evaluation_id         bigint        default null comment '评定记录ID',
  create_time           datetime      default null comment '创建时间',
  primary key (id),
  key idx_ndt_relation_task (task_id),
  key idx_ndt_relation_source (source_sop_instance_uid),
  key idx_ndt_relation_eval (evaluation_id)
) engine=InnoDB default charset=utf8mb4 comment='NDT DICOM对象关系表';

create table if not exists ndt_uid_rule (
  id                    bigint        not null auto_increment comment '主键',
  rule_name             varchar(128)  not null comment '规则名称',
  uid_type              varchar(32)   not null comment 'UID类型',
  root_type             varchar(32)   not null comment '根类型',
  uid_root              varchar(128)  default null comment 'UID根',
  suffix_pattern        varchar(255)  default null comment '后缀模式',
  enabled               char(1)       not null default '1' comment '是否启用',
  remark                varchar(500)  default null comment '备注',
  create_by             varchar(64)   default '' comment '创建者',
  create_time           datetime      default null comment '创建时间',
  update_by             varchar(64)   default '' comment '更新者',
  update_time           datetime      default null comment '更新时间',
  del_flag              char(1)       not null default '0' comment '删除标志（0存在 2删除）',
  primary key (id),
  key idx_ndt_uid_rule_type (uid_type, enabled)
) engine=InnoDB default charset=utf8mb4 comment='NDT UID规则配置表';

create table if not exists ndt_dicom_private_tag (
  id                    bigint        not null auto_increment comment '主键',
  tag_name              varchar(128)  not null comment 'Orthanc/DICOM标签名称或私有标签关键字',
  tag_label             varchar(100)  not null comment '显示名称',
  tag_code              varchar(32)   default null comment 'DICOM标签号',
  vr                    varchar(16)   default null comment '值表示VR',
  default_value         varchar(1000) default null comment '新增默认值',
  enabled               char(1)       not null default '1' comment '是否启用',
  builtin               char(1)       not null default '0' comment '是否内置',
  remark                varchar(500)  default null comment '备注',
  create_by             varchar(64)   default '' comment '创建者',
  create_time           datetime      default null comment '创建时间',
  update_by             varchar(64)   default '' comment '更新者',
  update_time           datetime      default null comment '更新时间',
  del_flag              char(1)       not null default '0' comment '删除标志',
  primary key (id),
  unique key uk_ndt_private_tag_name (tag_name),
  key idx_ndt_private_tag_enabled (enabled)
) engine=InnoDB default charset=utf8mb4 comment='NDT允许编辑的DICOM私有标签配置表';

insert into ndt_uid_rule (rule_name, uid_type, root_type, enabled, remark, create_by, create_time)
select '默认2.25 Study UID', 'STUDY', 'UUID_2_25', '1', '第一阶段默认Study UID规则', 'admin', sysdate()
where not exists (select 1 from ndt_uid_rule where uid_type = 'STUDY' and del_flag = '0');
insert into ndt_uid_rule (rule_name, uid_type, root_type, enabled, remark, create_by, create_time)
select '默认2.25 Series UID', 'SERIES', 'UUID_2_25', '1', '第一阶段默认Series UID规则', 'admin', sysdate()
where not exists (select 1 from ndt_uid_rule where uid_type = 'SERIES' and del_flag = '0');
insert into ndt_uid_rule (rule_name, uid_type, root_type, enabled, remark, create_by, create_time)
select '默认2.25 SOP UID', 'SOP_INSTANCE', 'UUID_2_25', '1', '第一阶段默认SOPInstance UID规则', 'admin', sysdate()
where not exists (select 1 from ndt_uid_rule where uid_type = 'SOP_INSTANCE' and del_flag = '0');

insert into ndt_dicom_private_tag (tag_name, tag_label, tag_code, vr, default_value, enabled, builtin, remark, create_by, create_time)
select 'Manufacturer', '制造商', '0008,0070', 'LO', '', '1', '1', 'DICOM标准制造商标签', 'admin', sysdate()
where not exists (select 1 from ndt_dicom_private_tag where tag_name = 'Manufacturer' and del_flag = '0');
insert into ndt_dicom_private_tag (tag_name, tag_label, tag_code, vr, default_value, enabled, builtin, remark, create_by, create_time)
select 'NdtClientName', '委托方', '0011,1010', 'LO', '', '1', '1', 'NDT私有标签：委托方', 'admin', sysdate()
where not exists (select 1 from ndt_dicom_private_tag where tag_name = 'NdtClientName' and del_flag = '0');
insert into ndt_dicom_private_tag (tag_name, tag_label, tag_code, vr, default_value, enabled, builtin, remark, create_by, create_time)
select 'NdtInspectorName', '检测人员', '0011,1011', 'LO', '', '1', '1', 'NDT私有标签：检测人员', 'admin', sysdate()
where not exists (select 1 from ndt_dicom_private_tag where tag_name = 'NdtInspectorName' and del_flag = '0');
insert into ndt_dicom_private_tag (tag_name, tag_label, tag_code, vr, default_value, enabled, builtin, remark, create_by, create_time)
select 'NdtEvaluationConclusion', '评定结论', '0011,1012', 'LT', '', '1', '1', 'NDT私有标签：评定结论', 'admin', sysdate()
where not exists (select 1 from ndt_dicom_private_tag where tag_name = 'NdtEvaluationConclusion' and del_flag = '0');

insert into sys_role (role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, remark)
select '公司管理员', 'ndt_company_admin', 10, '1', 1, 1, '0', '0', 'admin', sysdate(), 'NDT公司管理员'
where not exists (select 1 from sys_role where role_key = 'ndt_company_admin' and del_flag = '0');
insert into sys_role (role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, remark)
select '检测人员', 'ndt_inspector', 11, '2', 1, 1, '0', '0', 'admin', sysdate(), 'NDT检测人员'
where not exists (select 1 from sys_role where role_key = 'ndt_inspector' and del_flag = '0');
insert into sys_role (role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, remark)
select '客户用户', 'ndt_customer', 12, '2', 1, 1, '0', '0', 'admin', sysdate(), 'NDT客户只读用户'
where not exists (select 1 from sys_role where role_key = 'ndt_customer' and del_flag = '0');

insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
select 'NDT任务状态', 'ndt_task_status', '0', 'admin', sysdate(), 'NDT检测任务状态'
where not exists (select 1 from sys_dict_type where dict_type = 'ndt_task_status');
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
select 'NDT任务角色', 'ndt_task_role', '0', 'admin', sysdate(), 'NDT任务分配角色'
where not exists (select 1 from sys_dict_type where dict_type = 'ndt_task_role');
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
select 'NDT完整性状态', 'ndt_integrity_status', '0', 'admin', sysdate(), 'NDT完整性校验状态'
where not exists (select 1 from sys_dict_type where dict_type = 'ndt_integrity_status');
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
select 'NDT UID类型', 'ndt_uid_type', '0', 'admin', sysdate(), 'NDT UID类型'
where not exists (select 1 from sys_dict_type where dict_type = 'ndt_uid_type');
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
select 'NDT UID根类型', 'ndt_uid_root_type', '0', 'admin', sysdate(), 'NDT UID根类型'
where not exists (select 1 from sys_dict_type where dict_type = 'ndt_uid_root_type');
insert into sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
select 'NDT评定状态', 'ndt_evaluation_status', '0', 'admin', sysdate(), 'NDT评定状态'
where not exists (select 1 from sys_dict_type where dict_type = 'ndt_evaluation_status');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 1, '草稿', 'DRAFT', 'ndt_task_status', 'info', 'Y', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_task_status' and dict_value = 'DRAFT');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 2, '已分配', 'ASSIGNED', 'ndt_task_status', 'primary', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_task_status' and dict_value = 'ASSIGNED');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 3, '已上传', 'UPLOADED', 'ndt_task_status', 'warning', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_task_status' and dict_value = 'UPLOADED');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 4, '评定中', 'EVALUATING', 'ndt_task_status', 'warning', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_task_status' and dict_value = 'EVALUATING');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 5, '已评定', 'EVALUATED', 'ndt_task_status', 'success', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_task_status' and dict_value = 'EVALUATED');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 1, '创建者', 'CREATOR', 'ndt_task_role', 'primary', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_task_role' and dict_value = 'CREATOR');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 2, '上传者', 'UPLOADER', 'ndt_task_role', 'warning', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_task_role' and dict_value = 'UPLOADER');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 3, '评定者', 'EVALUATOR', 'ndt_task_role', 'success', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_task_role' and dict_value = 'EVALUATOR');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 4, '查看者', 'VIEWER', 'ndt_task_role', 'info', 'Y', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_task_role' and dict_value = 'VIEWER');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 1, '未知', 'UNKNOWN', 'ndt_integrity_status', 'info', 'Y', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_integrity_status' and dict_value = 'UNKNOWN');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 2, '通过', 'PASS', 'ndt_integrity_status', 'success', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_integrity_status' and dict_value = 'PASS');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 3, '失败', 'FAIL', 'ndt_integrity_status', 'danger', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_integrity_status' and dict_value = 'FAIL');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 1, 'Study', 'STUDY', 'ndt_uid_type', 'primary', 'Y', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_uid_type' and dict_value = 'STUDY');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 2, 'Series', 'SERIES', 'ndt_uid_type', 'primary', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_uid_type' and dict_value = 'SERIES');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 3, 'SOP Instance', 'SOP_INSTANCE', 'ndt_uid_type', 'primary', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_uid_type' and dict_value = 'SOP_INSTANCE');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 1, '2.25.UUID', 'UUID_2_25', 'ndt_uid_root_type', 'success', 'Y', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_uid_root_type' and dict_value = 'UUID_2_25');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 2, '自定义Root', 'CUSTOM_ROOT', 'ndt_uid_root_type', 'warning', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_uid_root_type' and dict_value = 'CUSTOM_ROOT');

insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 1, '草稿', 'DRAFT', 'ndt_evaluation_status', 'info', 'Y', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_evaluation_status' and dict_value = 'DRAFT');
insert into sys_dict_data (dict_sort, dict_label, dict_value, dict_type, list_class, is_default, status, create_by, create_time)
select 2, '已提交', 'SUBMITTED', 'ndt_evaluation_status', 'success', 'N', '0', 'admin', sysdate()
where not exists (select 1 from sys_dict_data where dict_type = 'ndt_evaluation_status' and dict_value = 'SUBMITTED');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '无损检测管理', 0, 5, 'ndt', null, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', sysdate(), 'NDT DICOM业务管理目录'
where not exists (select 1 from sys_menu where parent_id = 0 and path = 'ndt');
set @ndt_parent_id = (select menu_id from sys_menu where parent_id = 0 and path = 'ndt' order by menu_id limit 1);

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '检测任务管理', @ndt_parent_id, 1, 'task', 'ndt/task/index', '', '', 1, 0, 'C', '0', '0', 'ndt:task:list', 'list', 'admin', sysdate(), 'NDT检测任务管理'
where not exists (select 1 from sys_menu where parent_id = @ndt_parent_id and path = 'task');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'DICOM文件管理', @ndt_parent_id, 2, 'dicom', 'ndt/dicom/index', '', '', 1, 0, 'C', '0', '0', 'ndt:dicom:list', 'upload', 'admin', sysdate(), 'NDT DICOM文件管理'
where not exists (select 1 from sys_menu where parent_id = @ndt_parent_id and path = 'dicom');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '检测人员档案', @ndt_parent_id, 3, 'inspector', 'ndt/inspector/index', '', '', 1, 0, 'C', '0', '0', 'ndt:inspector:list', 'peoples', 'admin', sysdate(), 'NDT检测人员档案'
where not exists (select 1 from sys_menu where parent_id = @ndt_parent_id and path = 'inspector');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '客户公司管理', @ndt_parent_id, 4, 'company', 'ndt/company/index', '', '', 1, 0, 'C', '0', '0', 'ndt:company:list', 'people', 'admin', sysdate(), 'NDT客户公司信息静态展示'
where not exists (select 1 from sys_menu where parent_id = @ndt_parent_id and path = 'company');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'UID规则配置', @ndt_parent_id, 5, 'uidRule', 'ndt/uidRule/index', '', '', 1, 0, 'C', '0', '0', 'ndt:uidRule:list', 'system', 'admin', sysdate(), 'NDT UID规则配置'
where not exists (select 1 from sys_menu where parent_id = @ndt_parent_id and path = 'uidRule');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'DICOM私有标签', @ndt_parent_id, 6, 'dicomPrivateTag', 'ndt/dicomPrivateTag/index', '', '', 1, 0, 'C', '0', '0', 'ndt:dicomPrivateTag:list', 'edit', 'admin', sysdate(), 'NDT允许编辑的DICOM标签配置'
where not exists (select 1 from sys_menu where parent_id = @ndt_parent_id and path = 'dicomPrivateTag');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'DICOM完整性校验', @ndt_parent_id, 7, 'integrity', 'ndt/integrity/index', '', '', 1, 0, 'C', '0', '0', 'ndt:integrity:list', 'validCode', 'admin', sysdate(), 'NDT DICOM完整性校验'
where not exists (select 1 from sys_menu where parent_id = @ndt_parent_id and path = 'integrity');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '评定结果管理', @ndt_parent_id, 8, 'evaluation', 'ndt/evaluation/index', '', '', 1, 0, 'C', '0', '0', 'ndt:evaluation:list', 'form', 'admin', sysdate(), 'NDT评定结果管理'
where not exists (select 1 from sys_menu where parent_id = @ndt_parent_id and path = 'evaluation');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'OHIF入口配置', @ndt_parent_id, 9, 'ohif', 'ndt/ohif/index', '', '', 1, 0, 'C', '0', '0', 'ndt:ohif:list', 'link', 'admin', sysdate(), 'NDT OHIF入口配置'
where not exists (select 1 from sys_menu where parent_id = @ndt_parent_id and path = 'ohif');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'Orthanc归档管理', @ndt_parent_id, 10, 'orthanc', 'ndt/orthanc/index', '', '', 1, 0, 'C', '0', '0', 'ndt:orthanc:list', 'tree', 'admin', sysdate(), 'NDT Orthanc归档管理'
where not exists (select 1 from sys_menu where parent_id = @ndt_parent_id and path = 'orthanc');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '报告管理', @ndt_parent_id, 11, 'report', 'ndt/report/index', '', '', 1, 0, 'C', '0', '0', 'ndt:report:list', 'document', 'admin', sysdate(), 'NDT报告管理'
where not exists (select 1 from sys_menu where parent_id = @ndt_parent_id and path = 'report');
set @ndt_task_id = (select menu_id from sys_menu where parent_id = @ndt_parent_id and path = 'task' order by menu_id limit 1);
set @ndt_dicom_id = (select menu_id from sys_menu where parent_id = @ndt_parent_id and path = 'dicom' order by menu_id limit 1);
set @ndt_inspector_id = (select menu_id from sys_menu where parent_id = @ndt_parent_id and path = 'inspector' order by menu_id limit 1);
set @ndt_company_id = (select menu_id from sys_menu where parent_id = @ndt_parent_id and path = 'company' order by menu_id limit 1);
set @ndt_uid_id = (select menu_id from sys_menu where parent_id = @ndt_parent_id and path = 'uidRule' order by menu_id limit 1);
set @ndt_private_tag_id = (select menu_id from sys_menu where parent_id = @ndt_parent_id and path = 'dicomPrivateTag' order by menu_id limit 1);
set @ndt_integrity_id = (select menu_id from sys_menu where parent_id = @ndt_parent_id and path = 'integrity' order by menu_id limit 1);
set @ndt_evaluation_id = (select menu_id from sys_menu where parent_id = @ndt_parent_id and path = 'evaluation' order by menu_id limit 1);

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'DICOM标签管理', @ndt_dicom_id, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicom:tag:list', '#', 'admin', sysdate(), 'NDT DICOM标签查看'
where @ndt_dicom_id is not null
  and not exists (select 1 from sys_menu where perms = 'ndt:dicom:tag:list' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'DICOM标签新增', @ndt_dicom_id, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicom:tag:add', '#', 'admin', sysdate(), ''
where @ndt_dicom_id is not null
  and not exists (select 1 from sys_menu where perms = 'ndt:dicom:tag:add' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'DICOM标签修改', @ndt_dicom_id, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicom:tag:edit', '#', 'admin', sysdate(), ''
where @ndt_dicom_id is not null
  and not exists (select 1 from sys_menu where perms = 'ndt:dicom:tag:edit' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'DICOM标签删除', @ndt_dicom_id, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicom:tag:remove', '#', 'admin', sysdate(), ''
where @ndt_dicom_id is not null
  and not exists (select 1 from sys_menu where perms = 'ndt:dicom:tag:remove' and menu_type = 'F');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '任务查询', @ndt_task_id, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:task:query', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:task:query' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '任务新增', @ndt_task_id, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:task:add', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:task:add' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '任务修改', @ndt_task_id, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:task:edit', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:task:edit' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '任务删除', @ndt_task_id, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:task:remove', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:task:remove' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '任务分配', @ndt_task_id, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:task:assign', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:task:assign' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'OHIF查看', @ndt_task_id, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:task:ohif', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:task:ohif' and menu_type = 'F');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'DICOM上传', @ndt_dicom_id, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicom:upload', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:dicom:upload' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'DICOM下载', @ndt_dicom_id, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicom:download', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:dicom:download' and menu_type = 'F');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '档案新增', @ndt_inspector_id, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:inspector:add', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:inspector:add' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '档案修改', @ndt_inspector_id, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:inspector:edit', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:inspector:edit' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '档案删除', @ndt_inspector_id, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:inspector:remove', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:inspector:remove' and menu_type = 'F');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'UID新增', @ndt_uid_id, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:uidRule:add', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:uidRule:add' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'UID查询', @ndt_uid_id, 0, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:uidRule:query', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:uidRule:query' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'UID修改', @ndt_uid_id, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:uidRule:edit', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:uidRule:edit' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'UID删除', @ndt_uid_id, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:uidRule:remove', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:uidRule:remove' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 'UID生成', @ndt_uid_id, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:uidRule:generate', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:uidRule:generate' and menu_type = 'F');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '私有标签查询', @ndt_private_tag_id, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicomPrivateTag:query', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:dicomPrivateTag:query' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '私有标签新增', @ndt_private_tag_id, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicomPrivateTag:add', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:dicomPrivateTag:add' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '私有标签修改', @ndt_private_tag_id, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicomPrivateTag:edit', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:dicomPrivateTag:edit' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '私有标签删除', @ndt_private_tag_id, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:dicomPrivateTag:remove', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:dicomPrivateTag:remove' and menu_type = 'F');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '完整性重检', @ndt_integrity_id, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:integrity:verify', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:integrity:verify' and menu_type = 'F');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '评定查询', @ndt_evaluation_id, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:evaluation:query', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:evaluation:query' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '评定新增', @ndt_evaluation_id, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:evaluation:add', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:evaluation:add' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '评定修改', @ndt_evaluation_id, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:evaluation:edit', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:evaluation:edit' and menu_type = 'F');
insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '评定删除', @ndt_evaluation_id, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:evaluation:remove', '#', 'admin', sysdate(), ''
where not exists (select 1 from sys_menu where perms = 'ndt:evaluation:remove' and menu_type = 'F');

set @ndt_company_admin_role_id = (select role_id from sys_role where role_key = 'ndt_company_admin' and del_flag = '0' order by role_id limit 1);
set @ndt_inspector_role_id = (select role_id from sys_role where role_key = 'ndt_inspector' and del_flag = '0' order by role_id limit 1);
set @ndt_customer_role_id = (select role_id from sys_role where role_key = 'ndt_customer' and del_flag = '0' order by role_id limit 1);

insert into sys_role_menu (role_id, menu_id)
select @ndt_company_admin_role_id, m.menu_id
 from sys_menu m
 where @ndt_company_admin_role_id is not null
   and (m.menu_id in (@ndt_parent_id, @ndt_task_id, @ndt_dicom_id, @ndt_inspector_id, @ndt_company_id, @ndt_private_tag_id, @ndt_integrity_id, @ndt_evaluation_id)
        or m.perms in ('ndt:task:query','ndt:task:add','ndt:task:edit','ndt:task:remove','ndt:task:assign','ndt:task:ohif',
                       'ndt:dicom:upload','ndt:dicom:download','ndt:dicom:tag:list','ndt:dicom:tag:add','ndt:dicom:tag:edit','ndt:dicom:tag:remove',
                       'ndt:company:list',
                       'ndt:inspector:add','ndt:inspector:edit','ndt:inspector:remove',
                       'ndt:dicomPrivateTag:query','ndt:dicomPrivateTag:add','ndt:dicomPrivateTag:edit','ndt:dicomPrivateTag:remove',
                       'ndt:integrity:verify','ndt:evaluation:query'))
   and not exists (select 1 from sys_role_menu rm where rm.role_id = @ndt_company_admin_role_id and rm.menu_id = m.menu_id);

insert into sys_role_menu (role_id, menu_id)
select @ndt_inspector_role_id, m.menu_id
  from sys_menu m
 where @ndt_inspector_role_id is not null
   and (m.menu_id in (@ndt_parent_id, @ndt_task_id, @ndt_dicom_id, @ndt_integrity_id, @ndt_evaluation_id)
        or m.perms in ('ndt:task:query','ndt:task:ohif','ndt:dicom:upload','ndt:dicom:download',
                       'ndt:dicom:tag:list','ndt:dicom:tag:add','ndt:dicom:tag:edit',
                       'ndt:integrity:verify','ndt:evaluation:query','ndt:evaluation:add','ndt:evaluation:edit'))
   and not exists (select 1 from sys_role_menu rm where rm.role_id = @ndt_inspector_role_id and rm.menu_id = m.menu_id);

insert into sys_role_menu (role_id, menu_id)
select @ndt_customer_role_id, m.menu_id
  from sys_menu m
 where @ndt_customer_role_id is not null
   and (m.menu_id in (@ndt_parent_id, @ndt_task_id, @ndt_dicom_id, @ndt_integrity_id, @ndt_evaluation_id)
        or m.perms in ('ndt:task:query','ndt:task:ohif','ndt:dicom:download','ndt:dicom:tag:list','ndt:evaluation:query'))
   and not exists (select 1 from sys_role_menu rm where rm.role_id = @ndt_customer_role_id and rm.menu_id = m.menu_id);

-- Hide the older prototype DICOM menu if it exists; the first-stage MVP uses the independent /ndt/** business line.
update sys_menu set visible = '1'
 where parent_id = 0 and path = 'dcm';
