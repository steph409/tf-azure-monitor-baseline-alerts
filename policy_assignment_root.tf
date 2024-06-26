
data "azurerm_management_group" "root" {
  name = var.root_name # Configure: name of the top management group. If you are following ALZ standard, it is `root_name`
}

data "alz_archetype_keys" "root" {
  base_archetype = "custom_root"
}

data "alz_archetype" "root" {
  # id = data.azurerm_management_group.root.name
  id = "slcorp"
  defaults = {
    location = var.default_location
  }
  base_archetype = data.alz_archetype_keys.root.base_archetype
  parent_id      = var.tenant_id
  policy_assignments_to_modify = {
    Deploy-AMBA-SvcHealth = {
      parameters = jsonencode(var.parameters["Deploy-AMBA-SvcHealth"])
    }
    Deploy-AMBA-Notification = {
      parameters = jsonencode(var.parameters["Deploy-AMBA-Notification"])
    }
  }
}


module "root" {
  source              = "./module"
  alz_archetype       = data.alz_archetype.root
  alz_archetype_keys  = data.alz_archetype_keys.root
  management_group_id = data.alz_archetype.root.id
  template_file_vars  = local.template_file_vars
}
