resource "azurerm_resource_group" "grafana" {
  name     = "rg-amba-dashboard-grafana"
  location = "germanywestcentral"
}

resource "azurerm_dashboard_grafana" "amba" {
  name                              = "amba-alz"
  resource_group_name               = azurerm_resource_group.grafana.name
  location                          = azurerm_resource_group.grafana.location
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = false

  identity {
    type = "SystemAssigned"
  }

  tags = {
    key = "value"
  }
}



# resource provider needs to be registered: Microsoft.Dashboard
# az provider register --namespace "Microsoft.Dashboard"
# resource "grafana_folder" "amba" {
#   title = "Azure Monitor Baseline Alerts"
# }

data "local_file" "grafana_dashboard" {
  filename = "${path.module}/infra-monitoring-amba-thresholds.json"
}

# resource "grafana_dashboard" "demo" {
#   folder      = grafana_folder.amba.uid
#   config_json = jsonencode(data.local_file.grafana_dashboard.content)
# }
