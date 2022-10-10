module "test" {
  source = "../.."

  # add all required arguments
  parent       = "customers/${local.directory_customer_id}"
  display_name = "unit-minimal"
  group_key_id = "unit-minimal@${local.org_domain}"

  # add all optional arguments that create additional resources
  memberships = [
    {
      id = "testuser@${local.org_domain}"
    }
  ]
}
