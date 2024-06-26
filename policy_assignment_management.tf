
data "alz_archetype_keys" "management" {
  base_archetype = "custom_management"
}

data "azurerm_management_group" "management" {
  name = "${var.root_name}-management" # Configure: name of the management management group. If you are following ALZ standard, it is `root_name`-management
}

data "alz_archetype" "management" {
  # id = data.azurerm_management_group.management.name
  id = "slcorp-management"
  defaults = {
    location = var.default_location
  }
  base_archetype = data.alz_archetype_keys.management.base_archetype
  parent_id      = data.azurerm_management_group.platform.name

  policy_assignments_to_modify = {
    Deploy-AMBA-Management = {
      parameters = jsonencode(var.parameters["Deploy-AMBA-Management"])
    }
  }
}


module "management" {
  source              = "./module"
  alz_archetype       = data.alz_archetype.management
  alz_archetype_keys  = data.alz_archetype_keys.management
  management_group_id = data.alz_archetype.management.id
  template_file_vars  = local.template_file_vars
}

