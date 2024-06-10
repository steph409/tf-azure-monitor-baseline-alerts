
data "alz_archetype_keys" "connectivity" {
  base_archetype = "custom_connectivity"
}

data "azurerm_management_group" "connectivity" {
  name = "slcorp-connectivity"
}

data "alz_archetype" "connectivity" {
  id = "slcorp-connectivity"
  defaults = {
    location = var.default_location
  }
  base_archetype = "custom_connectivity"
  parent_id      = data.azurerm_management_group.this.name # root management group name
  policy_assignments_to_modify = {
    Deploy-AMBA-Connectivity = {
      parameters = jsonencode({
        ALZMonitorResourceGroupName = "rg-amba-monitoring-002",
        "ERCIRQoSDropBitsinPerSecAlertSeverity" : "3",
        "ALZMonitorResourceGroupLocation" : "westeurope"
      })
    }
  }
}


module "connectivity" {
  source              = "./module"
  alz_archetype       = data.alz_archetype.connectivity
  alz_archetype_keys  = data.alz_archetype_keys.connectivity
  management_group_id = data.alz_archetype.connectivity.id
}
