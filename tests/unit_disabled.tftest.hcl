mock_provider "google" {
  alias = "fake"
}

mock_provider "google-beta" {
  alias = "fake-beta"
}

run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "unit_disabled" {
  providers = {
    google      = google.fake
    google-beta = google-beta.fake-beta
  }

  command = apply

  variables {
    module_enabled = false
    labels         = { "cloudidentity.googleapis.com/groups.discussion_forum" : "" }
    parent         = "customers/${run.setup_tests.project}"
    group_key_id   = "unit-minimal@${run.setup_tests.domain}"
  }

  ### Validate outputs
  assert {
    condition     = output.module_enabled == false
    error_message = "[Output] `module` should not be enabled"
  }

  assert {
    condition     = output.group == null
    error_message = "[Output] group object should be null"
  }

  assert {
    condition     = length(keys(output.membership)) == 0
    error_message = "[Output] membership object should have 0 attributes"
  }

  ### Validate google_cloud_identity_group

  assert {
    condition     = google_cloud_identity_group.group != null
    error_message = "group should not exist"
  }

  ### Validate google_cloud_identity_group_membership

  assert {
    condition     = google_cloud_identity_group_membership.membership != null
    error_message = "membership should not exist"
  }
}
