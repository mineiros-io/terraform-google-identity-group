module "test" {
  source = "../.."

  module_enabled = false

  # add all required arguments
  parent       = "customers/${local.org_directory_customer_id}"
  group_key_id = "unit-disabled@${local.org_domain}"

  # add all optional arguments that create additional resources
  memberships = [
    {
      id    = "unit-disabled@mineiros.io"
      roles = ["MEMBER"]
    },
    {
      id    = "unit-disabled2@mineiros.io"
      roles = ["MEMBER", "MANAGER"]
    }
  ]
  # add only required arguments and no optional arguments
}
