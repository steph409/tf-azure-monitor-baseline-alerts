## Default configuration with all parameters in variables

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
- parameters: A map of all the policy parameters you want to modify. In the variables.tf file, you can see all the parameters that you can set with their defaults. You can overwrite them to fit the policies to your requirements.
