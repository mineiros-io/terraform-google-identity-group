# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# EMPTY FEATURES (DISABLED) UNIT TEST
# This module tests an empty set of features.
# The purpose is to verify no resources are created when the module is disabled.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

variable "domain" {
  type        = string
  description = "(Required) The domain of the organization to create the identity group in."
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
}

data "google_organization" "organization" {
  domain = var.domain
}

# DO NOT RENAME MODULE NAME
module "test" {
  source = "../.."

  module_enabled = false

  # add all required arguments
  parent       = "customers/${data.google_organization.organization.directory_customer_id}"
  group_key_id = "unit-disabled@${var.domain}"

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
}

# outputs generate non-idempotent terraform plans so we disable them for now unless we need them.
# output "all" {
#   description = "All outputs of the module."
#   value       = module.test
# }
