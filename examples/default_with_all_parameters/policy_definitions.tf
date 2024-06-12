provider "alz" {
  lib_urls    = ["../../${path.root}/lib"] # TODO add version similar to alz_lib_ref = "platform/alz@v2024.03.00"
  use_alz_lib = false
}

locals {
  template_file_vars = {
    root_scope_resource_id      = "/providers/Microsoft.Management/managementGroups/${data.azurerm_management_group.root.name}"
    current_scope_resource_id   = "/providers/Microsoft.Management/managementGroups/${data.azurerm_management_group.root.name}"
    default_location            = var.default_location
    connectivityManagementGroup = data.azurerm_management_group.connectivity.name
    managementManagementGroup   = data.azurerm_management_group.management.name
    IdentityManagementGroup     = data.azurerm_management_group.identity.name
    LandingZoneManagementGroup  = data.azurerm_management_group.landingzones.name
    contoso                     = data.azurerm_management_group.root.name
  }
}


module "root_policy_definitions" {
  source = "../../module/policy_definition"

  alz_archetype_keys  = data.alz_archetype_keys.root
  template_file_vars  = local.template_file_vars
  management_group_id = data.azurerm_management_group.root.id
}
