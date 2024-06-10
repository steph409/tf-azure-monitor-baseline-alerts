
data "azurerm_management_group" "root" {
  name = "slcorp"
}

data "alz_archetype_keys" "root" {
  base_archetype = "custom_root"
}

data "alz_archetype" "root" {
  id = data.azurerm_management_group.root.name
  defaults = {
    location = var.default_location
  }
  base_archetype = data.alz_archetype_keys.root.base_archetype
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
  alz_archetype       = data.alz_archetype.root
  alz_archetype_keys  = data.alz_archetype_keys.root
  management_group_id = data.alz_archetype.root.id
}
