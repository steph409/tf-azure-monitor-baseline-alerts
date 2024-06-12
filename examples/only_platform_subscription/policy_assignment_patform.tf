# this is the reference to the existing management group
# in this management group, the initiatives Deploy-AMBA-Identity, Deploy-AMBA-Conectivity, Deploy-AMBA-Management will be assigned
# if you want to assign it to a different management group, modify the name here
data "azurerm_management_group" "platform" {
  name = "${var.root_name}-platform" # Configure: name of the platform management group. If you are following ALZ standard, it is `root_name`-platform
}

# this reference the configuration of the archetype. The archetypes are defined in /lib/archetye_definition
# typically, this should not be modified
data "alz_archetype_keys" "platform" {
  base_archetype = "amba_platform" # in this archetype, three policy assigments are made: Deploy-AMBA-Identity, Deploy-AMBA-Conectivity, Deploy-AMBA-Management
}

# this is the definition of the archetype. Typically, this should not be modified
data "alz_archetype" "platform" {
  id = data.azurerm_management_group.platform.name

  defaults = {
    location = var.default_location
  }
  base_archetype = data.alz_archetype_keys.platform.base_archetype
  parent_id      = data.azurerm_management_group.root.name
  policy_assignments_to_modify = {
    Deploy-AMBA-Identity = {
      parameters = jsonencode(var.parameters["Deploy-AMBA-Identity"])
    }
    Deploy-AMBA-Management = {
      parameters = jsonencode(var.parameters["Deploy-AMBA-Management"])
    }
    Deploy-AMBA-Connectivity = {
      parameters = jsonencode(var.parameters["Deploy-AMBA-Connectivity"])
    }
  }
}


module "platform" {
  source              = "../../module/policy_assignment"
  alz_archetype       = data.alz_archetype.platform
  alz_archetype_keys  = data.alz_archetype_keys.platform
  management_group_id = data.alz_archetype.platform.id
  template_file_vars  = local.template_file_vars
}
