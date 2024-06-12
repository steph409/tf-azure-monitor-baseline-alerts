

# this is the reference to the existing management group
# in this management group, the initiative Deploy-AMBA-Management will be assigned
# if you want to assign it to a different management group, modify the name here
data "azurerm_management_group" "management" {
  name = "${var.root_name}-management" # Configure: name of the management management group. If you are following ALZ standard, it is `root_name`-management
}


# this reference the configuration of the archetype. The archetypes are defined in /lib/archetye_definition
# typically, this should not be modified
data "alz_archetype_keys" "management" {
  base_archetype = "amba_management"
}

# this is the definition of the archetype. Typically, this should not be modified
data "alz_archetype" "management" {
  id = data.azurerm_management_group.management.name

  defaults = {
    location = var.default_location
  }
  base_archetype = data.alz_archetype_keys.management.base_archetype
  parent_id      = data.azurerm_management_group.root.name

  policy_assignments_to_modify = {
    Deploy-AMBA-Management = {
      parameters = jsonencode(var.parameters["Deploy-AMBA-Management"])
    }
  }
}


module "management" {
  source              = "../../module/policy_assignment"
  alz_archetype       = data.alz_archetype.management
  alz_archetype_keys  = data.alz_archetype_keys.management
  management_group_id = data.alz_archetype.management.id
  template_file_vars  = local.template_file_vars
}

