-- NDT business object grouping v2.
-- This migration never changes Study/Series/SOP Instance UIDs and is safe to run repeatedly.

create table if not exists ndt_dicom_series (
  id                    bigint        not null auto_increment,
  task_id               bigint        not null,
  study_instance_uid    varchar(128)  not null,
  series_instance_uid   varchar(128)  not null,
  orthanc_series_id     varchar(100)  default null,
  modality              varchar(64)   default null,
  series_number         varchar(64)   default null,
  series_description    varchar(255)  default null,
  series_role           varchar(32)   not null default 'OTHER_DERIVED',
  create_time           datetime      default null,
  update_time           datetime      default null,
  primary key (id),
  unique key uk_ndt_dicom_series_uid (series_instance_uid),
  key idx_ndt_dicom_series_task (task_id),
  key idx_ndt_dicom_series_study (study_instance_uid)
) engine=InnoDB default charset=utf8mb4 comment='NDT physical DICOM Series index';

create table if not exists ndt_inspection_part (
  id                       bigint        not null auto_increment,
  task_id                  bigint        not null,
  part_no                  varchar(32)   not null,
  part_name                varchar(255)  default null,
  source_dicom_instance_id bigint        not null,
  source_sop_instance_uid  varchar(128)  not null,
  sort_order               int           not null default 0,
  create_time              datetime      default null,
  update_time              datetime      default null,
  primary key (id),
  unique key uk_ndt_part_source_instance (source_dicom_instance_id),
  unique key uk_ndt_part_task_source_sop (task_id, source_sop_instance_uid),
  key idx_ndt_part_task_sort (task_id, sort_order)
) engine=InnoDB default charset=utf8mb4 comment='NDT inspection part anchored by one original SOP';

create table if not exists ndt_part_dicom_object (
  id                  bigint       not null auto_increment,
  task_id             bigint       not null,
  part_id             bigint       not null,
  dicom_instance_id   bigint       not null,
  object_role         varchar(32)  not null,
  sort_order          int          not null default 0,
  primary_flag        char(1)      not null default '0',
  create_time         datetime     default null,
  primary key (id),
  unique key uk_ndt_part_object (part_id, dicom_instance_id),
  key idx_ndt_part_object_task (task_id),
  key idx_ndt_part_object_instance (dicom_instance_id)
) engine=InnoDB default charset=utf8mb4 comment='NDT part to DICOM instance membership';

-- MySQL versions before ADD COLUMN IF NOT EXISTS are supported through information_schema guards.
set @ndt_schema = database();
set @ndt_sql = if(
  exists(select 1 from information_schema.columns
          where table_schema = @ndt_schema and table_name = 'ndt_dicom_instance'
            and column_name = 'dicom_series_id'),
  'select 1',
  'alter table ndt_dicom_instance add column dicom_series_id bigint default null after sop_class_uid');
prepare ndt_stmt from @ndt_sql;
execute ndt_stmt;
deallocate prepare ndt_stmt;

set @ndt_sql = if(
  exists(select 1 from information_schema.statistics
          where table_schema = @ndt_schema and table_name = 'ndt_dicom_instance'
            and index_name = 'idx_ndt_dicom_series_id'),
  'select 1',
  'alter table ndt_dicom_instance add key idx_ndt_dicom_series_id (dicom_series_id)');
prepare ndt_stmt from @ndt_sql;
execute ndt_stmt;
deallocate prepare ndt_stmt;

set @ndt_sql = if(
  exists(select 1 from information_schema.columns
          where table_schema = @ndt_schema and table_name = 'ndt_dicom_instance'
            and column_name = 'object_type'),
  'select 1',
  'alter table ndt_dicom_instance add column object_type varchar(32) default null after dicom_series_id');
prepare ndt_stmt from @ndt_sql;
execute ndt_stmt;
deallocate prepare ndt_stmt;

-- 1. Index every real physical Series. The aggregate classifier also detects legacy mixed Series.
insert into ndt_dicom_series
  (task_id, study_instance_uid, series_instance_uid, orthanc_series_id, modality,
   series_number, series_description, series_role, create_time, update_time)
select min(classified.task_id), max(classified.study_instance_uid), classified.series_instance_uid,
       max(classified.orthanc_series_id), max(classified.modality), max(classified.series_number),
       max(classified.series_description),
       if(count(distinct classified.inferred_object_type) > 1,
          'LEGACY_MIXED',
          max(classified.inferred_object_type)),
       now(), now()
  from (
    select i.*,
           case
             when i.modality = 'SR' or i.sop_class_uid like '1.2.840.10008.5.1.4.1.1.88.%' then 'SR'
             when i.modality = 'PR' or i.sop_class_uid like '1.2.840.10008.5.1.4.1.1.11.%' then 'PRESENTATION_STATE'
             when exists (select 1 from ndt_dicom_object_relation r
                           where r.task_id = i.task_id and r.related_sop_instance_uid = i.sop_instance_uid
                             and r.related_type = 'SR') then 'SR'
             when exists (select 1 from ndt_dicom_object_relation r
                           where r.task_id = i.task_id and r.related_sop_instance_uid = i.sop_instance_uid
                             and r.related_type = 'SNAPSHOT') then 'SNAPSHOT'
             when exists (select 1 from ndt_dicom_object_relation r
                           where r.task_id = i.task_id and r.related_sop_instance_uid = i.sop_instance_uid
                             and r.related_type = 'PROCESSED_IMAGE') then 'PROCESSED_IMAGE'
             when i.is_original = '1' then 'ORIGINAL'
             else 'OTHER_DERIVED'
           end as inferred_object_type
      from ndt_dicom_instance i
     where i.del_flag = '0'
  ) classified
 group by classified.series_instance_uid
on duplicate key update
  orthanc_series_id = coalesce(values(orthanc_series_id), orthanc_series_id),
  modality = coalesce(values(modality), modality),
  series_number = coalesce(values(series_number), series_number),
  series_description = coalesce(values(series_description), series_description),
  series_role = values(series_role), update_time = now();

-- 2. Classify instances. SR/PR semantics take priority over relations and is_original.
update ndt_dicom_instance i
left join ndt_dicom_series s on s.series_instance_uid = i.series_instance_uid
   set i.dicom_series_id = s.id,
       i.object_type = case
         when i.modality = 'SR' or i.sop_class_uid like '1.2.840.10008.5.1.4.1.1.88.%' then 'SR'
         when i.modality = 'PR' or i.sop_class_uid like '1.2.840.10008.5.1.4.1.1.11.%' then 'PRESENTATION_STATE'
         when exists (select 1 from ndt_dicom_object_relation r
                       where r.task_id = i.task_id and r.related_sop_instance_uid = i.sop_instance_uid
                         and r.related_type = 'SR') then 'SR'
         when exists (select 1 from ndt_dicom_object_relation r
                       where r.task_id = i.task_id and r.related_sop_instance_uid = i.sop_instance_uid
                         and r.related_type = 'SNAPSHOT') then 'SNAPSHOT'
         when exists (select 1 from ndt_dicom_object_relation r
                       where r.task_id = i.task_id and r.related_sop_instance_uid = i.sop_instance_uid
                         and r.related_type = 'PROCESSED_IMAGE') then 'PROCESSED_IMAGE'
         when i.is_original = '1' then 'ORIGINAL'
         else 'OTHER_DERIVED'
       end
 where i.del_flag = '0';

-- 3. One business Part per original SOP.
insert into ndt_inspection_part
  (task_id, part_no, part_name, source_dicom_instance_id, source_sop_instance_uid,
   sort_order, create_time, update_time)
select i.task_id, concat('P-', lpad(i.id, 6, '0')),
       coalesce(nullif(i.series_description, ''), nullif(i.file_name, ''), concat('P-', lpad(i.id, 6, '0'))),
       i.id, i.sop_instance_uid, least(i.id, 2147483647), now(), now()
  from ndt_dicom_instance i
 where i.del_flag = '0' and i.object_type = 'ORIGINAL'
on duplicate key update part_name = values(part_name), sort_order = values(sort_order), update_time = now();

-- 4. Attach every original to its own Part.
insert into ndt_part_dicom_object
  (task_id, part_id, dicom_instance_id, object_role, sort_order, primary_flag, create_time)
select p.task_id, p.id, p.source_dicom_instance_id, 'ORIGINAL',
       least(p.source_dicom_instance_id, 2147483647), '1', now()
  from ndt_inspection_part p
on duplicate key update object_role = values(object_role), sort_order = values(sort_order), primary_flag = '1';

-- 5. Attach related targets to every source Part. Unreliable objects deliberately remain unassigned.
insert into ndt_part_dicom_object
  (task_id, part_id, dicom_instance_id, object_role, sort_order, primary_flag, create_time)
select p.task_id, p.id, target.id, target.object_type,
       least(target.id, 2147483647), '0', now()
  from ndt_dicom_object_relation r
  join ndt_inspection_part p
    on p.task_id = r.task_id and p.source_sop_instance_uid = r.source_sop_instance_uid
  join ndt_dicom_instance target
    on target.task_id = r.task_id and target.sop_instance_uid = r.related_sop_instance_uid
   and target.del_flag = '0'
 where r.related_sop_instance_uid is not null
on duplicate key update object_role = values(object_role), sort_order = values(sort_order);

-- Relations may also point at a derived source object; inherit every Part containing that source.
insert into ndt_part_dicom_object
  (task_id, part_id, dicom_instance_id, object_role, sort_order, primary_flag, create_time)
select p.task_id, p.id, target.id, target.object_type,
       least(target.id, 2147483647), '0', now()
  from ndt_dicom_object_relation r
  join ndt_dicom_instance source
    on source.task_id = r.task_id and source.sop_instance_uid = r.source_sop_instance_uid
   and source.del_flag = '0'
  join ndt_part_dicom_object source_member
    on source_member.task_id = source.task_id and source_member.dicom_instance_id = source.id
  join ndt_inspection_part p on p.id = source_member.part_id
  join ndt_dicom_instance target
    on target.task_id = r.task_id and target.sop_instance_uid = r.related_sop_instance_uid
   and target.del_flag = '0'
 where r.related_sop_instance_uid is not null
on duplicate key update object_role = values(object_role), sort_order = values(sort_order);
