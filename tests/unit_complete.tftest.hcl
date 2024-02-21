mock_provider "google" {
  alias = "fake"

  override_resource {
    target = google_cloud_identity_group.group
    values = {
      id = "unit-minimal"
    }
  }
}

mock_provider "google-beta" {
  alias = "fake-beta"
}

run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "unit_complete" {
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

    # add most/all other optional arguments
    display_name         = "UnitComplete"
    description          = run.setup_tests.description
    initial_group_config = "INITIAL_GROUP_CONFIG_UNSPECIFIED"
    group_key_namespace  = "identitysources/identity_source_id"

    # add all optional arguments that create additional resources
    memberships = [
      {
        id    = "testuser@${run.setup_tests.domain}"
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
    condition     = output.membership["testuser@my_domain"].name == google_cloud_identity_group_membership.membership["testuser@my_domain"].name
    error_message = "[Output] `membership` name matches the resource name"
  }

  assert {
    condition     = length(keys(output.group)) == 11
    error_message = "[Output] group object should have 11 attributes"
  }

  assert {
    condition     = length(keys(output.membership)) == 1
    error_message = "[Output] membership object should have 1 attribute"
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
    condition     = google_cloud_identity_group.group[0].display_name == "UnitComplete"
    error_message = "display_name should be UnitComplete"
  }

  assert {
    condition     = google_cloud_identity_group.group[0].description == run.setup_tests.description
    error_message = "description should be 'A google identity group created by an automated unit test.'"
  }

  assert {
    condition     = google_cloud_identity_group.group[0].initial_group_config == "INITIAL_GROUP_CONFIG_UNSPECIFIED"
    error_message = "initial_group_config should be 'INITIAL_GROUP_CONFIG_UNSPECIFIED'"
  }

  assert {
    condition     = google_cloud_identity_group.group[0].group_key[0].namespace == "identitysources/identity_source_id"
    error_message = "group_key: namespace should be 'identitysources/identity_source_id'"
  }

  assert {
    condition     = google_cloud_identity_group.group[0].timeouts.create == "10m"
    error_message = "group: timeouts.create should be '10m"
  }

  assert {
    condition     = google_cloud_identity_group.group[0].timeouts.update == "11m"
    error_message = "group: timeouts.update should be '11m"
  }

  assert {
    condition     = google_cloud_identity_group.group[0].timeouts.delete == "12m"
    error_message = "group: timeouts.delete should be '12m"
  }

  ### Validate google_cloud_identity_group_membership

  assert {
    condition     = google_cloud_identity_group_membership.membership != null
    error_message = "membership should exist"
  }

  assert {
    condition     = google_cloud_identity_group_membership.membership["testuser@my_domain"].timeouts.create == "13m"
    error_message = "membership: timeouts.delete should be '13m"
  }

  assert {
    condition     = google_cloud_identity_group_membership.membership["testuser@my_domain"].timeouts.update == "14m"
    error_message = "membership: timeouts.delete should be '14m"
  }

  assert {
    condition     = google_cloud_identity_group_membership.membership["testuser@my_domain"].timeouts.delete == "15m"
    error_message = "membership: timeouts.delete should be '15m"
  }

  assert {
    condition     = length(google_cloud_identity_group_membership.membership["testuser@my_domain"].roles) == 2
    error_message = "membership: user should have 2 roles"
  }

  assert {
    condition     = google_cloud_identity_group_membership.membership["testuser@my_domain"].preferred_member_key[0].id == "testuser@my_domain"
    error_message = "membership: user should have preferred_member_key equal to testuser@my_domain"
  }

  assert {
    condition     = google_cloud_identity_group_membership.membership["testuser@my_domain"].group == "unit-minimal"
    error_message = "membership: incorrect group name, expected: 'unit-minimal'"
  }
}
