# ------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ------------------------------------------------------------------------------

output "group" {
  description = "All attributes of the created 'google_cloud_identity_group' resource."
  value       = try(google_cloud_identity_group.group[0], null)
}

output "membership" {
  description = "All attributes of the created 'google_cloud_identity_group_membership' resource."
  value       = try(google_cloud_identity_group_membership.membership, null)
}

# ------------------------------------------------------------------------------
# OUTPUT ALL INPUT VARIABLES
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether the module is enabled."
  value       = var.module_enabled
}
