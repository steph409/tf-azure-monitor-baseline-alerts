
data "alz_archetype_keys" "landingzones" {
  base_archetype = "custom_landingzones"
}

data "azurerm_management_group" "landingzones" {
  name = "slcorp-landing-zones"
}

data "alz_archetype" "landingzones" {
  id = "slcorp-landing-zones"
  defaults = {
    location = var.default_location
  }
  base_archetype = "custom_landingzones"
  parent_id      = data.azurerm_management_group.this.name # root management group name

  policy_assignments_to_modify = {
    Deploy-AMBA-LandingZone = {
      parameters = jsonencode({
        ALZMonitorResourceGroupName = "rg-amba-monitoring-001"
      })
    }
  }
}


module "landingzones" {
  source              = "./module"
  alz_archetype       = data.alz_archetype.landingzones
  alz_archetype_keys  = data.alz_archetype_keys.landingzones
  management_group_id = data.alz_archetype.landingzones.id
}
