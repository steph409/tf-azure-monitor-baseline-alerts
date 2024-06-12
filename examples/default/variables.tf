variable "subscription_id" {
  type = string

}

variable "default_location" {
  default = "germanywestcentral"
  type    = string
}

variable "root_name" {
  default     = "contoso"
  description = "value of the root management group name"
  type        = string
}

variable "tenant_id" {
  type = string
}

variable "parameters" {
  description = "values for the parameters for the policy assignments. The default are the default for each policy."
  default = {
    "Deploy-AMBA-HybridVM" : {
      "ALZMonitorResourceGroupName" : "rg-amba-monitoring-001",
      "ALZMonitorResourceGroupTags" : {
        "_deployed_by_alz_monitor" : true,
        "_deployed_by_terraform" : true
      },
      "ALZMonitorResourceGroupLocation" : "germanywestcentral",
    },
    "Deploy-AMBA-Management" : {
      "ALZMonitorResourceGroupName" : "rg-amba-monitoring-001",
      "ALZMonitorResourceGroupTags" : {
        "_deployed_by_alz_monitor" : true,
        "_deployed_by_terraform" : true
      },
      "ALZMonitorResourceGroupLocation" : "germanywestcentral",
    },
    "Deploy-AMBA-SvcHealth" : {
      "ALZMonitorResourceGroupName" : "rg-amba-monitoring-001",
      "ALZMonitorResourceGroupTags" : {
        "_deployed_by_alz_monitor" : true,
        "_deployed_by_terraform" : true
      },
      "ALZMonitorResourceGroupLocation" : "germanywestcentral",
    },
    "Deploy-AMBA-Connectivity" : {
      "ALZMonitorResourceGroupName" : "rg-amba-monitoring-001",
      "ALZMonitorResourceGroupTags" : {
        "_deployed_by_alz_monitor" : true,
        "_deployed_by_terraform" : true
      },
      "ALZMonitorResourceGroupLocation" : "germanywestcentral",
    },
    "Deploy-AMBA-LandingZone" : {
      "ALZMonitorResourceGroupName" : "rg-amba-monitoring-001",
      "ALZMonitorResourceGroupTags" : {
        "_deployed_by_alz_monitor" : true,
        "_deployed_by_terraform" : true
      },
      "ALZMonitorResourceGroupLocation" : "germanywestcentral",
    },
    "Deploy-AMBA-Notification" : {
      "ALZMonitorResourceGroupName" : "rg-amba-monitoring-001",
      "ALZMonitorResourceGroupTags" : {
        "_deployed_by_alz_monitor" : true,
        "_deployed_by_terraform" : true
      },
      "ALZMonitorResourceGroupLocation" : "germanywestcentral",
    },
    "Deploy-AMBA-Identity" : {
      "ALZMonitorResourceGroupName" : "rg-amba-monitoring-001",
      "ALZMonitorResourceGroupTags" : {
        "_deployed_by_alz_monitor" : true,
        "_deployed_by_terraform" : true
      },
      "ALZMonitorResourceGroupLocation" : "germanywestcentral",
    }
  }
}
