
locals {
  alz_policy_assignments_decoded= { for k in var.alz_archetype_keys.alz_policy_assignment_keys : k => jsondecode(var.alz_archetype.alz_policy_assignments[k]) }
}

resource "azurerm_management_group_policy_assignment" "this" {
  for_each = local.alz_policy_assignments_decoded

  management_group_id  = try(each.value.properties.scope, var.management_group_id)
  name                 = each.value.name
  policy_definition_id = each.value.properties.policyDefinitionId
  description          = try(each.value.properties.description, "")
  display_name         = try(each.value.properties.displayName, "")

  enforce    = try(each.value.properties.enforce, "Default") == "Default" ? true : false
  location   = try(each.value.location, null)
  metadata   = jsonencode(try(each.value.properties.metadata, {}))
  not_scopes = try(each.value.properties.notScopes, [])
  parameters = try(each.value.properties.parameters, null) != null && try(each.value.properties.parameters, {}) != {} ? jsonencode(each.value.properties.parameters) : null

  dynamic "identity" {
    for_each = try(each.value.identity.type, "None") != "None" ? [each.value.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.type == "SystemAssigned" ? [] : toset(keys(identity.value.userAssignedIdentities))
    }
  }
  dynamic "non_compliance_message" {
    for_each = try(each.value.properties.nonComplianceMessages, [])

    content {
      # replace the word "enforcement mode" either with should or must
      content = replace(non_compliance_message.value.message, "{enforcementMode}",
      try(each.value.properties.enforcementMode) == "DoNotEnforce" ? "should" : "must")
      policy_definition_reference_id = try(non_compliance_message.value.policyDefinitionReferenceId, null)
    }
  }
  #   dynamic "non_compliance_message" {
  #   for_each = try(each.value.properties.nonComplianceMessages, [])

  #   content {
  #     content                        = replace(non_compliance_message.value.message, "{enforcementMode}", 
  #     non_compliance_message.value[try(each.value.properties.enforcementMode, "Default")])
  #     policy_definition_reference_id = try(non_compliance_message.value.policyDefinitionReferenceId, null)
  #   }
  # }
  dynamic "overrides" {
    for_each = try(each.value.properties.overrides, [])

    content {
      value = overrides.value.value

      dynamic "selectors" {
        for_each = try(overrides.value.selectors, [])

        content {
          in     = try(selectors.value.in, null)
          not_in = try(selectors.value.notIn, null)
        }
      }
    }
  }
  dynamic "resource_selectors" {
    for_each = try(each.value.properties.resourceSelectors, [])

    content {
      name = resource_selectors.value.name

      dynamic "selectors" {
        for_each = try(resource_selectors.value.selectors, [])

        content {
          kind   = selectors.value.kind
          in     = try(selectors.value.in, null)
          not_in = try(selectors.value.notIn, null)
        }
      }
    }
  }
  # depends_on = [time_sleep.before_policy_assignments]
#   depends_on = [azurerm_policy_set_definition.this]
}



locals {
  policy_role_assignments = var.alz_archetype.alz_policy_role_assignments != null ? {
    for pra_key, pra_val in var.alz_archetype.alz_policy_role_assignments : pra_key => {
      scope              = pra_val.scope
      role_definition_id = pra_val.role_definition_id
      principal_id       = one(azurerm_management_group_policy_assignment.this[pra_val.assignment_name].identity).principal_id
    }
  } : {}
}

resource "alz_policy_role_assignments" "this" {
  id          = var.alz_archetype.id
  assignments = local.policy_role_assignments
  # depends_on  = [time_sleep.before_policy_role_assignments]
}
