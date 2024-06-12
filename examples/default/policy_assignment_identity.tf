
# this is the reference to the existing management group
# in this management group, the initiative Deploy-AMBA-Identity will be assigned
# if you want to assign it to a different management group, modify the name here
data "azurerm_management_group" "identity" {
  name = "${var.root_name}-identity" # Configure: name of the identity management group. If you are following ALZ standard, it is `root_name`-identity
}



# this reference the configuration of the archetype. The archetypes are defined in /lib/archetye_definition
# typically, this should not be modified
data "alz_archetype_keys" "identity" {
  base_archetype = "amba_identity"
}

# this is the definition of the archetype. Typically, this should not be modified
data "alz_archetype" "identity" {
  id = data.azurerm_management_group.identity.name

  defaults = {
    location = var.default_location
  }
  base_archetype = data.alz_archetype_keys.identity.base_archetype
  parent_id      = data.azurerm_management_group.root.name
  policy_assignments_to_modify = {
    Deploy-AMBA-Identity = {
      parameters = jsonencode(var.parameters["Deploy-AMBA-Identity"])
    }
  }
}

module "identity" {
  source              = "../../module/policy_assignment"
  alz_archetype       = data.alz_archetype.identity
  alz_archetype_keys  = data.alz_archetype_keys.identity
  management_group_id = data.alz_archetype.identity.id
  template_file_vars  = local.template_file_vars
}
