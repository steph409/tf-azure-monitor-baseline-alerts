# Terraform Azure Monitor Baseline Alerts

## Official documentation

The official documentation for azure monitor baseline alerts is here: https://azure.github.io/azure-monitor-baseline-alerts/welcome/

This module implements [version 2024-06-05](https://github.com/Azure/azure-monitor-baseline-alerts/releases/tag/2024-06-05) of the azure monitor baseline alerts for azure landing zones. Future versions will also be available.

# Standard deployment

If you have deployed the azure landing zones according to the enterprise scale network, you will have the following management groups:

- root: typically top management group, called "root_name"
- landing_zones: typically the management group for the landing zones, called "root_name"-landing-zones, this management group is typically directly under the root management group
- platform: typically the management group for the platform, called "root_name"-platform, this management group is typically directly under the root management group
- identity: typically the management group for the identity, called "root_name"-identity, this management group is typically directly under the platform management group
- connectivity: typically the management group for the connectivity, called "root_name"-connectivity, this management group is typically directly under the platform management group
- management: typically the management group for the management, called "root_name"-management, this management group is typically directly under the platform management group

There are many policy definitions and policy set definitions. They are all defined on the root management group. The list can be seen in lib/archetype_definitions/archetype_definitions_amba_root.tf

The following policy assignments are made:

- root: Deploy-AMBA-SvcHealth, Deploy-AMBA-Notification
- landing-zones: Deploy-AMBA-LandingZone
- platform: None
- identity: Deploy-AMBA-Identity
- connectivity: Deploy-AMBA-Connectivity
- management: Deploy-AMBA-Management

There is one additional policy set definition `Deploy-AMBA-HybridVM` which is currently not assigned.



## Migrate from previous deployment to terraform

It is recommended to follow [the guide to cleanup the deployment](https://azure.github.io/azure-monitor-baseline-alerts/patterns/alz/Cleaning-up-a-Deployment/) and make a fresh deployment with terraform.

## Modify parameters

Look at the examples/default_with_all_parameters to see the full list of parameters. You can overwrite the default values for each parameter by setting the parameter in the variable `parameters`.

The parameters variable is set as following:

```hcl
  parameters {
    InitiativeAssignmentName : {
      ParameterName = ParameterValue
    }
  }
```

So for example, if you want to parameter `StorageAccountAvailabilityAlertState` in the initative `Deploy-AMBA-Management` from default `true` to `false`, your variable would look similar to this:

```hcl
parameters = {
  Deploy-AMBA-Management = {
    StorageAccountAvailabilityAlertState = false
  }
}
```

## Deployment Guide

To deploy the default configuration, set the variables in the examples/default/variables.tf or write them into a `.tfvars` file. Then run terraform init and apply:

```bash
cd examples/default
terraform init
terraform plan
terraform apply
```
