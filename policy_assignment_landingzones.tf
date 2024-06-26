
data "alz_archetype_keys" "landingzones" {
  base_archetype = "custom_landingzones"
}

data "azurerm_management_group" "landingzones" {
  name = "${var.root_name}-landing-zones" # Configure: name of the landing-zones management group. If you are following ALZ standard, it is `root_name`-landing-zones
}

data "alz_archetype" "landingzones" {
  # id = data.azurerm_management_group.landingzones.name
  id = "slcorp-landing-zones"
  defaults = {
    location = var.default_location
  }
  base_archetype = data.alz_archetype_keys.landingzones.base_archetype
  parent_id      = data.azurerm_management_group.platform.name

  policy_assignments_to_modify = {
    Deploy-AMBA-LandingZone = {
      parameters = jsonencode(var.parameters["Deploy-AMBA-LandingZone"])
    }
  }
}


module "landingzones" {
  source              = "./module"
  alz_archetype       = data.alz_archetype.landingzones
  alz_archetype_keys  = data.alz_archetype_keys.landingzones
  management_group_id = data.alz_archetype.landingzones.id
  template_file_vars  = local.template_file_vars
}
