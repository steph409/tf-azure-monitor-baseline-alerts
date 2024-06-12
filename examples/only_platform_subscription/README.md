## One platform management group instead of separate management groups for Identity, Connectivity and Management

If you deployed one management group for your core infrastructure resources, you can assign all three initiatives to that management group. 

So, instead of doing the default policy assignment which is as following:

- root: Deploy-AMBA-SvcHealth, Deploy-AMBA-Notification
- landing-zones: Deploy-AMBA-LandingZone
- identity: Deploy-AMBA-Identity
- connectivity: Deploy-AMBA-Connectivity
- management: Deploy-AMBA-Management

We will do the following:

- root: Deploy-AMBA-SvcHealth, Deploy-AMBA-Notification
- landing-zones: Deploy-AMBA-LandingZone
- platform: Deploy-AMBA-Identity, Deploy-AMBA-Connectivity, Deploy-AMBA-Management

The variables are exactly the same as in the default configuration, but the policy_assignment files are different. Also note that we are using the `amba_platform` archetype which is defined in lib/archetype_definitions/ which is a combination of the `amba_identity`, `amba_connectivity` and `amba_management` archetypes.