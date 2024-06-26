
data "alz_archetype_keys" "connectivity" {
  base_archetype = "custom_connectivity"
}

data "azurerm_management_group" "connectivity" {
  name = "${var.root_name}-connectivity" # Configure: name of the connectivity management group. If you are following ALZ standard, it is `root_name`-connectivity
}

data "alz_archetype" "connectivity" {
  id = data.azurerm_management_group.connectivity.name
  # id = "slcorp-connectivity"
  defaults = {
    location = var.default_location
  }
  base_archetype = data.alz_archetype_keys.connectivity.base_archetype
  parent_id      = data.azurerm_management_group.platform.name

  policy_assignments_to_modify = {
    Deploy-AMBA-Connectivity = {
      parameters = jsonencode(var.parameters["Deploy-AMBA-Connectivity"])
    }
  }
}


module "connectivity" {
  source              = "./module"
  alz_archetype       = data.alz_archetype.connectivity
  alz_archetype_keys  = data.alz_archetype_keys.connectivity
  management_group_id = data.alz_archetype.connectivity.id
  template_file_vars  = local.template_file_vars
}
