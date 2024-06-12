# this is the reference to the existing management group
# in this management group, the initiative Deploy-AMBA-LandingZone will be assigned
# if you want to assign it to a different management group, modify the name here
data "azurerm_management_group" "landingzones" {
  name = "${var.root_name}-landing-zones" # Configure: name of the landing-zones management group. If you are following ALZ standard, it is `root_name`-landing-zones
}


# this reference the configuration of the archetype. The archetypes are defined in /lib/archetye_definition
# typically, this should not be modified
data "alz_archetype_keys" "landingzones" {
  base_archetype = "amba_landingzones"
}

# this is the definition of the archetype. Typically, this should not be modified
data "alz_archetype" "landingzones" {
  id = data.azurerm_management_group.landingzones.name

  defaults = {
    location = var.default_location
  }
  base_archetype = data.alz_archetype_keys.landingzones.base_archetype
  parent_id      = data.azurerm_management_group.root.name

  policy_assignments_to_modify = {
    Deploy-AMBA-LandingZone = {
      parameters = jsonencode(var.parameters["Deploy-AMBA-LandingZone"])
    }
  }
}

# here the module is called which does the initiative assignments. Typically, this should not be modified
module "landingzones" {
  source              = "../../module/policy_assignment"
  alz_archetype       = data.alz_archetype.landingzones
  alz_archetype_keys  = data.alz_archetype_keys.landingzones
  management_group_id = data.alz_archetype.landingzones.id
  template_file_vars  = local.template_file_vars
}
