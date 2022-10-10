module "test" {
  source = "../.."

  module_enabled = true

  # add all required arguments

  parent       = "customers/${local.directory_customer_id}"
  group_key_id = "unit-complete@${local.org_domain}"

  # add most/all other optional arguments
  display_name         = "UnitComplete"
  description          = "A google identity group created by an automated unit test."
  labels               = { "cloudidentity.googleapis.com/groups.discussion_forum" : "" }
  initial_group_config = "INITIAL_GROUP_CONFIG_UNSPECIFIED"
  group_key_namespace  = "identitysources/identity_source_id"

  # add all optional arguments that create additional resources
  memberships = [
    {
      id    = "testuser@${local.org_domain}"
      roles = ["MEMBER", "MANAGER"]
    }
  ]

  # add most/all other optional arguments
  module_timeouts = {
    google_cloud_identity_group = {
      create = "10m"
      update = "11m"
      delete = "12m"
    }
    google_cloud_identity_group_membership = {
      create = "13m"
      update = "14m"
      delete = "15m"
    }
  }

  module_depends_on = ["nothing"]
}
