# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# COMPLETE FEATURES UNIT TEST
# This module tests a complete set of most/all non-exclusive features
# The purpose is to activate everything the module offers, but trying to keep execution time and costs minimal.
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

  module_enabled = true

  # add all required arguments

  parent       = "customers/${data.google_organization.organization.directory_customer_id}"
  group_key_id = "unit-complete@${var.domain}"

  # add most/all other optional arguments
  display_name = "UnitComplete"
  description  = "A google identity group created by an automated unit test."

  # add all optional arguments that create additional resources
  memberships = [
    {
      id   = "testuser@${var.domain}"
      role = "MAINTAINER"
    }
  ]

  # add most/all other optional arguments
  # module_timeouts = {
  #   group_timeouts = {
  #     create = "10m"
  #     update = "10m"
  #     delete = "10m"
  #   }
  # }

  module_depends_on = ["nothing"]
}

# outputs generate non-idempotent terraform plans so we disable them for now unless we need them.
# output "all" {
#   description = "All outputs of the module."
#   value       = module.test
# }
