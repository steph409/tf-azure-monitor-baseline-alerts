# The policies contain some values which need to be replaced.
# This will eventually move either into the provider or be implemented natively
# with terraform 1.9 which has the templatestring experiment currently in alpha.
# Until then, we load the files again, and use templatefile to replace the values
# Typically, those values should not be changed here.
locals {
  template_file_vars = {
    root_scope_resource_id      = "/providers/Microsoft.Management/managementGroups/${data.azurerm_management_group.root.name}"
    current_scope_resource_id   = "/providers/Microsoft.Management/managementGroups/${data.azurerm_management_group.root.name}"
    default_location            = var.default_location
    connectivityManagementGroup = data.azurerm_management_group.platform.name
    managementManagementGroup   = data.azurerm_management_group.platform.name
    IdentityManagementGroup     = data.azurerm_management_group.platform.name
    LandingZoneManagementGroup  = data.azurerm_management_group.landingzones.name
    contoso                     = data.azurerm_management_group.root.name
  }
}

# call the module which does all policy and initiative definitions
module "root_policy_definitions" {
  source = "../../module/policy_definition"

  alz_archetype_keys  = data.alz_archetype_keys.root
  template_file_vars  = local.template_file_vars
  management_group_id = data.azurerm_management_group.root.id
}
