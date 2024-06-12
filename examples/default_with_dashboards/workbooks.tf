
resource "azurerm_resource_group" "amba_addons" {
  name     = "rg-amba-add-ons"
  location = var.default_location
}

resource "azurerm_application_insights" "appinsights" {
  name                = "AMBA-AppInsights"
  location            = azurerm_resource_group.amba_addons.location
  resource_group_name = azurerm_resource_group.amba_addons.name
  application_type    = "web"
}

data "http" "workbook_template" {
  url = "https://raw.githubusercontent.com/microsoft/AzureMonitorCommunity/master/Azure%20Services/Azure%20Monitor/Workbooks/Alerts%20Management.workbook"
}

resource "random_uuid" "amba_workbook" {
}

# this parameter does not have a parameter, just leave this here as an example how to do it
resource "azurerm_application_insights_workbook" "alert_management" {
  count = var.log_analytics_workspace_id != "" ? 1 : 0
  name                = random_uuid.amba_workbook.result
  location            = azurerm_resource_group.amba_addons.location
  resource_group_name = azurerm_resource_group.amba_addons.name
  display_name        = "AMBA-Alert-Management"
  source_id           = lower(var.log_analytics_workspace_id)
  category            = "workbook"
  data_json           = jsonencode(replace(data.http.workbook_template.response_body, "app_insights_name", azurerm_application_insights.appinsights.name))
}
