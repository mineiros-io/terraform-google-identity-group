resource "google_cloud_identity_group" "group" {
  count = var.module_enabled ? 1 : 0

  depends_on = [var.module_depends_on]

  display_name         = var.display_name
  description          = var.description
  initial_group_config = var.initial_group_config

  parent = var.parent

  group_key {
    id        = var.group_key_id
    namespace = try(var.group_key_namespace, null)
  }

  labels = var.labels

  lifecycle {
    ignore_changes = [
      # Initial group config can only be configured when creating a group initially
      initial_group_config,
    ]
  }

  timeouts {
    create = try(var.group_timeouts.create, "6m")
    update = try(var.group_timeouts.update, "4m")
    delete = try(var.group_timeouts.delete, "4m")
  }
}

locals {
  memberships = { for b in var.memberships : b.id => b }
}

resource "google_cloud_identity_group_membership" "membership" {
  for_each = var.module_enabled ? local.memberships : tomap({})

  group = google_cloud_identity_group.group[0].id

  dynamic "roles" {
    for_each = try(each.value.roles, ["MEMBER"])

    content {
      name = roles.value
    }
  }

  preferred_member_key {
    id = each.value.id
  }

  timeouts {
    create = try(var.membership_timeouts.create, "4m")
    update = try(var.membership_timeouts.update, "4m")
    delete = try(var.membership_timeouts.delete, "4m")
  }
}
