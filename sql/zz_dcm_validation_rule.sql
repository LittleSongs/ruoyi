-- DICOM upload validation: custom rules, validation records and NDT menu entry.

create table if not exists dcm_validation_rule (
    rule_id bigint primary key auto_increment,
    rule_name varchar(100) not null comment '规则名称',
    sop_class_uid varchar(128) not null comment '适用SOPClassUID，*表示通用规则',
    sop_name varchar(200) null comment 'SOP名称',
    modality varchar(32) null comment '可选，CT/DX/CR等',
    rule_type tinyint not null comment '规则类型：1=必备Tag',
    tag_code varchar(16) not null comment 'Tag编号，如00111010',
    tag_display varchar(32) not null comment '显示格式，如(0011,1010)',
    tag_name varchar(100) null comment 'Tag名称',
    vr varchar(8) null comment 'VR，如LO/SH/LT/UI',
    private_creator varchar(100) null comment '私有Tag创建者，如RuoYiNDT',
    allow_blank char(1) default 'N' comment '是否允许空值 Y/N',
    severity varchar(20) default 'ERROR' comment 'ERROR/WARNING',
    enabled char(1) default 'Y' comment '是否启用',
    sort_order int default 0,
    fail_message varchar(500) null comment '失败提示',
    remark varchar(500) null,
    create_by varchar(64),
    create_time datetime,
    update_by varchar(64),
    update_time datetime,
    key idx_dcm_validation_rule_sop (sop_class_uid, rule_type, enabled),
    key idx_dcm_validation_rule_tag (tag_code)
) engine=InnoDB default charset=utf8mb4 comment='DICOM自定义校验规则表';

create table if not exists dcm_validation_record (
    record_id bigint primary key auto_increment,
    batch_id bigint null,
    file_name varchar(255),
    file_size bigint,
    temp_path varchar(500),
    sop_class_uid varchar(128),
    media_storage_sop_class_uid varchar(128),
    study_instance_uid varchar(128),
    series_instance_uid varchar(128),
    sop_instance_uid varchar(128),
    modality varchar(32),
    official_status varchar(20) comment 'validate_iods结果 PASS/FAIL',
    custom_status varchar(20) comment '自定义规则结果 PASS/FAIL',
    final_status varchar(20) comment '最终结果 PASS/FAIL',
    error_count int default 0,
    warning_count int default 0,
    official_result_json longtext comment 'validate_iods原始结果',
    custom_result_json longtext comment '自定义规则结果',
    orthanc_instance_id varchar(128) null comment '通过后才有',
    create_by varchar(64),
    create_time datetime,
    key idx_dcm_validation_record_sop (sop_instance_uid),
    key idx_dcm_validation_record_status (final_status),
    key idx_dcm_validation_record_create_time (create_time)
) engine=InnoDB default charset=utf8mb4 comment='DICOM上传校验记录表';

set @ndt_parent_id = (select menu_id from sys_menu where parent_id = 0 and path = 'ndt' order by menu_id limit 1);
set @validation_rule_id = null;

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '自定义校验规则', @ndt_parent_id, 11, 'validationRule', 'ndt/validationRule/index', '', '', 1, 0, 'C', '0', '0', 'ndt:validationRule:list', 'validCode', 'admin', sysdate(), 'DICOM上传自定义校验规则'
where @ndt_parent_id is not null
  and not exists (select 1 from sys_menu where parent_id = @ndt_parent_id and path = 'validationRule');

set @validation_rule_id = (select menu_id from sys_menu where parent_id = @ndt_parent_id and path = 'validationRule' order by menu_id limit 1);

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '规则查询', @validation_rule_id, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:validationRule:query', '#', 'admin', sysdate(), ''
where @validation_rule_id is not null and not exists (select 1 from sys_menu where perms = 'ndt:validationRule:query' and menu_type = 'F');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '规则新增', @validation_rule_id, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:validationRule:add', '#', 'admin', sysdate(), ''
where @validation_rule_id is not null and not exists (select 1 from sys_menu where perms = 'ndt:validationRule:add' and menu_type = 'F');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '规则修改', @validation_rule_id, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:validationRule:edit', '#', 'admin', sysdate(), ''
where @validation_rule_id is not null and not exists (select 1 from sys_menu where perms = 'ndt:validationRule:edit' and menu_type = 'F');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '规则删除', @validation_rule_id, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:validationRule:remove', '#', 'admin', sysdate(), ''
where @validation_rule_id is not null and not exists (select 1 from sys_menu where perms = 'ndt:validationRule:remove' and menu_type = 'F');

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '规则导出', @validation_rule_id, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'ndt:validationRule:export', '#', 'admin', sysdate(), ''
where @validation_rule_id is not null and not exists (select 1 from sys_menu where perms = 'ndt:validationRule:export' and menu_type = 'F');
