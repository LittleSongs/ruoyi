-- NDT customer company static demo menu.
-- Run this script on an existing database if zz_ndt_phase1.sql has already been applied.

set @ndt_parent_id = (select menu_id from sys_menu where parent_id = 0 and path = 'ndt' order by menu_id limit 1);

insert into sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select '客户公司管理', @ndt_parent_id, 4, 'company', 'ndt/company/index', '', '', 1, 0, 'C', '0', '0', 'ndt:company:list', 'people', 'admin', sysdate(), 'NDT客户公司信息静态展示'
where @ndt_parent_id is not null
  and not exists (select 1 from sys_menu where parent_id = @ndt_parent_id and path = 'company');

update sys_menu
   set order_num = case path
       when 'uidRule' then 5
       when 'dicomPrivateTag' then 6
       when 'integrity' then 7
       when 'evaluation' then 8
       when 'ohif' then 9
       when 'orthanc' then 10
       when 'report' then 11
       else order_num
     end
 where parent_id = @ndt_parent_id
   and path in ('uidRule','dicomPrivateTag','integrity','evaluation','ohif','orthanc','report');

set @ndt_company_id = (select menu_id from sys_menu where parent_id = @ndt_parent_id and path = 'company' order by menu_id limit 1);
set @ndt_company_admin_role_id = (select role_id from sys_role where role_key = 'ndt_company_admin' and del_flag = '0' order by role_id limit 1);

insert into sys_role_menu (role_id, menu_id)
select @ndt_company_admin_role_id, @ndt_company_id
where @ndt_company_admin_role_id is not null
  and @ndt_company_id is not null
  and not exists (select 1 from sys_role_menu where role_id = @ndt_company_admin_role_id and menu_id = @ndt_company_id);
