# this is the reference to the existing management group
# in this management group, the initiative Deploy-AMBA-Conectivity will be assigned
# if you want to assign it to a different management group, modify the name here
data "azurerm_management_group" "connectivity" {
  name = "${var.root_name}-connectivity" # Configure: name of the connectivity management group. If you are following ALZ standard, it is `root_name`-connectivity
}


# this reference the configuration of the archetype. The archetypes are defined in /lib/archetye_definition
# typically, this should not be modified
data "alz_archetype_keys" "connectivity" {
  base_archetype = "amba_connectivity"
}

# this is the definition of the archetype. Typically, this should not be modified
data "alz_archetype" "connectivity" {
  id = data.azurerm_management_group.connectivity.name

  defaults = {
    location = var.default_location
  }
  base_archetype = data.alz_archetype_keys.connectivity.base_archetype
  parent_id      = data.azurerm_management_group.root.name

  policy_assignments_to_modify = {
    Deploy-AMBA-Connectivity = {
      parameters = jsonencode(var.parameters["Deploy-AMBA-Connectivity"])
    }
  }
}


module "connectivity" {
  source              = "../../module/policy_assignment"
  alz_archetype       = data.alz_archetype.connectivity
  alz_archetype_keys  = data.alz_archetype_keys.connectivity
  management_group_id = data.alz_archetype.connectivity.id
  template_file_vars  = local.template_file_vars
}
