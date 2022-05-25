# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MINIMAL FEATURES UNIT TEST
# This module tests a minimal set of features.
# The purpose is to test all defaults for optional arguments and just provide the required arguments.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

variable "domain" {
  type        = string
  description = "(Required) The domain of the organization to create the identity group in."
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.75"
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

  # add all required arguments
  parent       = "customers/${data.google_organization.organization.directory_customer_id}"
  display_name = "unit-minimal"
  group_key_id = "unit-minimal@${var.domain}"

  # add all optional arguments that create additional resources
  memberships = [
    {
      id = "testuser@${var.domain}"
    }
  ]
}

# outputs generate non-idempotent terraform plans so we disable them for now unless we need them.
# output "all" {
#   description = "All outputs of the module."
#   value       = module.test
# }
