
data "alz_archetype_keys" "identity" {
  base_archetype = "custom_identity"
}

data "azurerm_management_group" "identity" {
  name = "slcorp-identity"
}

data "alz_archetype" "identity" {
  id = data.azurerm_management_group.identity.name
  defaults = {
    location = var.default_location
  }
  base_archetype = data.alz_archetype_keys.identity.base_archetype
  parent_id      = data.azurerm_management_group.root.name # root management group name
  policy_assignments_to_modify = {
    Deploy-AMBA-Identity = {
      parameters = jsonencode({
        ALZMonitorResourceGroupName = "rg-amba-monitoring-001"
      })
    }
  }
}

module "identity" {
  source              = "./module"
  alz_archetype       = data.alz_archetype.identity
  alz_archetype_keys  = data.alz_archetype_keys.identity
  management_group_id = data.alz_archetype.identity.id
}
