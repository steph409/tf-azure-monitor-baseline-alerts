
locals {
  # this is not working
  # alz_policy_definitions_decoded = { for k in data.alz_archetype_keys.this.alz_policy_definition_keys : k => jsondecode(data.alz_archetype.this.alz_policy_definitions[k]) }
  # alz_policy_set_definitions_decoded = { for k in data.alz_archetype_keys.root.alz_policy_set_definition_keys : k => jsondecode(data.alz_archetype.root.alz_policy_set_definitions[k]) }

  # there is a new experiment templatestring in terraform v1.9 alpha which might be a solution for this
  # workaround until this is GA:
  alz_policy_definitions_decoded = { for k in var.alz_archetype_keys.alz_policy_definition_keys :
    k => jsondecode(
      templatefile("${var.rel_path}/lib/policy_definitions/policy_definition_${lower(k)}.json", var.template_file_vars)
    )
  }

  alz_policy_set_definitions_decoded = { for k in var.alz_archetype_keys.alz_policy_set_definition_keys :
    k => jsondecode(
      templatefile("${var.rel_path}/lib/policy_set_definitions/policy_set_definition_${lower(replace(k, "-", "_"))}.json", var.template_file_vars)
    )
  }
}

resource "azurerm_policy_definition" "this" {
  for_each = local.alz_policy_definitions_decoded

  display_name        = try(each.value.properties.displayName, "")
  mode                = each.value.properties.mode
  name                = each.key
  policy_type         = try(each.value.properties.policyType, "Custom")
  description         = try(each.value.properties.description, "")
  management_group_id = var.management_group_id
  metadata            = jsonencode(try(each.value.properties.metadata, {}))
  parameters          = try(each.value.properties.parameters, null) != null && try(each.value.properties.parameters, {}) != {} ? jsonencode(each.value.properties.parameters) : null
  policy_rule         = jsonencode(try(each.value.properties.policyRule, {}))
}


resource "azurerm_policy_set_definition" "this" {
  for_each = local.alz_policy_set_definitions_decoded

  display_name        = try(each.value.properties.displayName, "")
  name                = each.key
  policy_type         = try(each.value.properties.policyType, "Custom")
  management_group_id = var.management_group_id
  metadata            = jsonencode(try(each.value.properties.metadata, {}))
  parameters          = try(each.value.properties.parameters, null) != null && try(each.value.properties.parameters, {}) != {} ? jsonencode(each.value.properties.parameters) : null

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
    for_each = try(each.value.properties.policyDefinitionGroups, null) != null ? each.value.properties.policyDefinitionGroups : []
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
