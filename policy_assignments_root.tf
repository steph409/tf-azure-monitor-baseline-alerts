
data "azurerm_management_group" "this" {
  name = "slcorp"
}

data "alz_archetype_keys" "this" {
  base_archetype = "custom_root"
}

data "alz_archetype" "this" {
  id = "slcorp"
  defaults = {
    location = var.default_location
  }
  base_archetype = "custom_root"
  parent_id      = data.azurerm_client_config.current.tenant_id
  policy_assignments_to_modify = {
    Deploy-AMBA-SvcHealth = {
      parameters = jsonencode({
        ALZMonitorResourceGroupName = "rg-amba-monitoring-001"
        # ALZMonitorResourceGroupTags = { "test" : "me" }
      })
    }
  }
}


module "root" {
  source              = "./module"
  alz_archetype       = data.alz_archetype.this
  alz_archetype_keys  = data.alz_archetype_keys.this
  management_group_id = data.alz_archetype.this.id
}
