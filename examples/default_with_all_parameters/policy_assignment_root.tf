
# this is the reference to the existing management group
# in this management group, the initiatives Deploy-AMBA-Identity, Deploy-AMBA-SvcHealth, Deploy-AMBA-Notification will be assigned
# if you want to assign it to a different management group, modify the name here
data "azurerm_management_group" "root" {
  name = var.root_name # Configure: name of the top management group. If you are following ALZ standard, it is `root_name`
}

data "alz_archetype_keys" "root" {
  base_archetype = "amba_root"
}

# this is the definition of the archetype. Typically, this should not be modified
data "alz_archetype" "root" {
  id = var.root_name # Configure: name of the top management group. If you are following ALZ standard, it is `root_name`

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
  source              = "../../module/policy_assignment"
  alz_archetype       = data.alz_archetype.root
  alz_archetype_keys  = data.alz_archetype_keys.root
  management_group_id = data.alz_archetype.root.id
  template_file_vars  = local.template_file_vars
}
