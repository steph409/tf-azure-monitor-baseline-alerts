## Default configuration

If you rolled out the Azure Landing Zones with the [enterprise-scale terraform module](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale), you already have manangement groups.

To apply the baseline alerting configuration, we will assign the policies [as described in the documentation](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/deploy/Introduction-to-deploying-the-ALZ-Pattern/).

The following policy assignments are made:

- root: Deploy-AMBA-SvcHealth, Deploy-AMBA-Notification
- landing-zones: Deploy-AMBA-LandingZone
- identity: Deploy-AMBA-Identity
- connectivity: Deploy-AMBA-Connectivity
- management: Deploy-AMBA-Management

There are currently 5 variables that you need to set:

- subscription_id: Used in the provider, typically the management subscription ID
- default_location: The default location for the resources, defaults to germanywestcentral
- root_name: The name of you root management group, the same root_name you used when deploying the management groups. In the samples, it is often contoso. Usually, it is an abbreviation of your company name.
- tenant_id: The tenant ID of your Azure AD tenant in which the management groups are deployed.
- parameters: A map of all the policy parameters you want to modify. You can see all the available parameters in the documentation and in the [examples/default_with_all_parameters/](../examples/default_with_all_parameters/README.md). For readability, we only set a minimal set here in the variables.tf file: ALZMonitorResourceGroupName, ALZMonitorResourceGroupLocation and ALZMonitorResourceGroupTags. If you do not set a value, the default is used. If you want to set an additional parameter, you can add it to the variables.
