
data "alz_archetype_keys" "management" {
  base_archetype = "custom_management"
}

data "azurerm_management_group" "management" {
  name = "slcorp-management"
}

data "alz_archetype" "management" {
  id = data.azurerm_management_group.management.name
  defaults = {
    location = var.default_location
  }
  base_archetype = data.alz_archetype_keys.management.base_archetype
  parent_id      = data.azurerm_management_group.root.name # root management group name

  policy_assignments_to_modify = {
    Deploy-AMBA-Management = {
      parameters = jsonencode({
        ALZMonitorResourceGroupName = "rg-amba-monitoring-002"
      })
    }
  }
}


module "management" {
  source              = "./module"
  alz_archetype       = data.alz_archetype.management
  alz_archetype_keys  = data.alz_archetype_keys.management
  management_group_id = data.alz_archetype.management.id
}

