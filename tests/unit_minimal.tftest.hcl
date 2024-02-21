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

run "unit_minimal" {
  providers = {
    google      = google.fake
    google-beta = google-beta.fake-beta
  }

  command = apply

  variables {
    module_enabled = true
    labels         = { "cloudidentity.googleapis.com/groups.discussion_forum" : "" }
    parent         = "customers/${run.setup_tests.project}"
    group_key_id   = "unit-minimal@${run.setup_tests.domain}"
  }

  ### Validate outputs
  assert {
    condition     = output.module_enabled == true
    error_message = "[Output] `module` should be enabled"
  }

  assert {
    condition     = output.group.name == google_cloud_identity_group.group[0].name
    error_message = "[Output] `group` name matches the resource name"
  }

  assert {
    condition     = length(keys(output.group)) == 11
    error_message = "[Output] group object should have 11 attributes"
  }

  assert {
    condition     = length(keys(output.membership)) == 0
    error_message = "[Output] membership object should have 0 attributes"
  }

  ### Validate google_cloud_identity_group

  assert {
    condition     = google_cloud_identity_group.group[0].parent == "customers/${run.setup_tests.project}"
    error_message = "wrong parent"
  }

  assert {
    condition     = google_cloud_identity_group.group[0].group_key[0].id == "unit-minimal@${run.setup_tests.domain}"
    error_message = "wrong group_key_id"
  }

  assert {
    condition     = length(keys(google_cloud_identity_group.group[0].labels)) == 1
    error_message = "there should be only 1 label key"
  }

  assert {
    condition     = google_cloud_identity_group.group[0].display_name == null
    error_message = "display_name should be null"
  }
}
