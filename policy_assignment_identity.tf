
data "alz_archetype_keys" "identity" {
  base_archetype = "custom_identity"
}

data "azurerm_management_group" "identity" {
  name = "${var.root_name}-identity" # Configure: name of the identity management group. If you are following ALZ standard, it is `root_name`-identity
}

data "alz_archetype" "identity" {
  # id = data.azurerm_management_group.identity.name
  id = "slcorp-identity"
  defaults = {
    location = var.default_location
  }
  base_archetype = data.alz_archetype_keys.identity.base_archetype
  parent_id      = data.azurerm_management_group.platform.name
  policy_assignments_to_modify = {
    Deploy-AMBA-Identity = {
      parameters = jsonencode(var.parameters["Deploy-AMBA-Identity"])
    }
  }
}

module "identity" {
  source              = "./module"
  alz_archetype       = data.alz_archetype.identity
  alz_archetype_keys  = data.alz_archetype_keys.identity
  management_group_id = data.alz_archetype.identity.id
  template_file_vars  = local.template_file_vars
}
