provider "alz" {
  lib_urls    = ["${path.root}/lib"] # TODO add version similar to alz_lib_ref = "platform/alz@v2024.03.00"
  use_alz_lib = false
}


data "azurerm_client_config" "current" {}


locals {

  template_file_vars = {
    root_scope_resource_id      = "/providers/Microsoft.Management/managementGroups/slcorp"
    current_scope_resource_id   = "/providers/Microsoft.Management/managementGroups/slcorp"
    default_location            = "germanywestcentral"
    connectivityManagementGroup = "slcorp-connectivity"
    managementManagementGroup   = "slcorp-management"
    IdentityManagementGroup     = "slcorp-identity"
    LandingZoneManagementGroup  = "slcorp-landing-zones"
    contoso                     = "slcorp"
  }

  # TODO - this is not working as expected, e.g. the default location is not picked up correctly
  # alz_policy_definitions_decoded = { for k in data.alz_archetype_keys.this.alz_policy_definition_keys : k => jsondecode(data.alz_archetype.this.alz_policy_definitions[k]) }
  # there is a new experiment templatestring in terraform v1.9 alpha which might be a solution for this
  # workaround until this is GA:
  # alz_policy_definitions_decoded     = { for k in data.alz_archetype_keys.root.alz_policy_definition_keys : k => jsondecode(data.alz_archetype.root.alz_policy_definitions[k]) }

  alz_policy_definitions_decoded = { for k in data.alz_archetype_keys.root.alz_policy_definition_keys :
    k => jsondecode(
      templatefile("lib/policy_definitions/policy_definition_${lower(k)}.json", local.template_file_vars)
    )
  }

  alz_policy_set_definitions_decoded = { for k in data.alz_archetype_keys.root.alz_policy_set_definition_keys : k => jsondecode(data.alz_archetype.root.alz_policy_set_definitions[k]) }
}


resource "azurerm_policy_definition" "this" {
  for_each = local.alz_policy_definitions_decoded

  display_name        = try(each.value.properties.displayName, "")
  mode                = each.value.properties.mode
  name                = each.key
  policy_type         = try(each.value.properties.policyType, "Custom")
  description         = try(each.value.properties.description, "")
  management_group_id = data.azurerm_management_group.root.id
  metadata            = jsonencode(try(each.value.properties.metadata, {}))
  parameters          = try(each.value.properties.parameters, null) != null && try(each.value.properties.parameters, {}) != {} ? jsonencode(each.value.properties.parameters) : null
  policy_rule         = jsonencode(try(each.value.properties.policyRule, {}))
}


resource "azurerm_policy_set_definition" "this" {
  for_each = local.alz_policy_set_definitions_decoded

  display_name        = try(each.value.properties.displayName, "")
  name                = each.key
  policy_type         = try(each.value.properties.policyType, "Custom")
  management_group_id = data.azurerm_management_group.root.id
  metadata            = jsonencode(try(each.value.properties.metadata, {}))
  parameters          = try(each.value.properties.parameters, null) != null && try(each.value.properties.parameters, {}) != {} ? jsonencode(each.value.properties.parameters) : null

  # TODO - this line is missing in matt's module --> opened pr
  description = try(each.value.properties.description, "")

  dynamic "policy_definition_reference" {
    for_each = try(each.value.properties.policyDefinitions, [])

    content {
      policy_definition_id = policy_definition_reference.value.policyDefinitionId
      parameter_values     = try(jsonencode(policy_definition_reference.value.parameters), jsonencode({}))
      policy_group_names   = try(policy_definition_reference.value.groupNames, [])
      reference_id         = try(policy_definition_reference.value.policyDefinitionReferenceId, "")
    }
  }
  dynamic "policy_definition_group" {
    # needed to change this line, as is seems that policyDefinitionGroups are set to null in json which is invalid for terraform
    for_each = try(each.value.properties.policyDefinitionGroups, null) != null ? each.value.properties.policyDefinitionGroups : []
    # for_each = try(each.value.properties.policyDefinitionGroups, [])
    content {
      name                            = policy_definition_group.value.name
      additional_metadata_resource_id = try(policy_definition_group.value.additionalMetadataId, "")
      category                        = try(policy_definition_group.value.category, "")
      description                     = try(policy_definition_group.value.description, "")
      display_name                    = try(policy_definition_group.value.displayName, "")
    }
  }
  depends_on = [azurerm_policy_definition.this]
}
