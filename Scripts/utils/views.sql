-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

create view tenant_user.v_tenant_user as
  select tu.id_tenant,
         tu.id_user,
         t.name as tenant_name,
         u.email as email
    from tenant_user.tenant_user tu
    join tenant_user.tenant t on (t.id = tu.id_tenant)
    join tenant_user.user u on (u.id = tu.id_user);