header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-google-identity-group"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-google-identity-group/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-google-identity-group/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-identity-group.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-google-identity-group/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gcp-provider" {
    image = "https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-identity-group"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) module to create and manage a [Google Cloud Identity Group](https://cloud.google.com/identity/).

    **_This module supports Terraform version 1
    and is compatible with the Terraform Google Provider version 4._** and 5._**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      This module implements the following Terraform resources

      - `google_cloud_identity_group`
      - `google_cloud_identity_group_membership`
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most common usage of the module:

      ```hcl
      module "terraform-google-identity-group" {
        source = "git@github.com:mineiros-io/terraform-google-identity-group.git?ref=v0.1.0"

        group_key_id = "id-of-entity"
        parent       = "resource-name-of-entity"

        memberships = [
          {
            id    = "member@mineiros.io"
            roles = ["MEMBER"]
          },
          {
            id    = "manager@mineiros.io"
            roles = ["MEMBER", "MANAGER"]
          },
          {
            id    = "owner@mineiros.io"
            roles = ["MEMBER", "OWNER"]
          }
        ]
      }
      ```
      **NOTE:** Google Groups are an organization level resource and can only be created and managed
      with Service Accounts or with a Principal that impersonates a single service account.
      The Service Account will require to be a Google Groups Admin to be able to create the Google
      Groups and manage the addition, removal of users/service accounts to and from the group.
      There are two different ways of enabaling a service account to work with the Google Groups API:
        - [Authenticating as a service account without domain-wide delegation (recommended)](https://cloud.google.com/identity/docs/how-to/setup#assigning_an_admin_role_to_the_service_account)
        - [Authenticating as a service account with domain-wide delegation](https://cloud.google.com/identity/docs/how-to/setup#assigning_an_admin_role_to_the_service_account)
      Granting a service account access to your organisation's data via domain-wide delegation should be used with caution.
      It can be reversed by disabling or deleting the service account or by removing access through the Google Workspace admin console.
    END
  }
  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Main Resource Configuration"

      variable "group_key_id" {
        required    = true
        type        = string
        description = <<-END
          The ID of the entity. For Google-managed entities, the id must be the email address of an existing group or user. For external-identity-mapped entities, the id must be a string conforming to the Identity Source's requirements. Must be unique within a namespace.
        END

      }

      variable "parent" {
        required    = true
        type        = string
        description = <<-END
          The resource name of the entity under which this Group resides in the Cloud Identity resource hierarchy. Must be of the form `identitysources/{identity_source_id}` for external-identity-mapped groups or `customers/{customer_id}` for Google Groups.
        END
      }

      variable "labels" {
        type        = map(string)
        default     = { "cloudidentity.googleapis.com/groups.discussion_forum" : "" }
        description = <<-END
          The labels that apply to the Group.Must not contain more than one entry.Must contain the entry `cloudidentity.googleapis.com/groups.discussion_forum`: '' if the Group is a Google Group or `system/groups/external`: '' if the Group is an external-identity-mapped group.
        END
      }

      variable "display_name" {
        type        = string
        description = <<-END
          The display name of the Group.
        END
      }

      variable "description" {
        type        = string
        description = <<-END
          An extended description to help users determine the purpose of a Group. Must not be longer than 4,096 characters.
        END
      }

      variable "initial_group_config" {
        type        = string
        default     = "EMPTY"
        description = <<-END
          The initial configuration options for creating a Group. Default value is `EMPTY`. Possible values are `INITIAL_GROUP_CONFIG_UNSPECIFIED`, `WITH_INITIAL_OWNER`, and `EMPTY`.
        END
      }

      variable "group_key_namespace" {
        type        = string
        description = <<-END
          The namespace in which the entity exists. If not specified, the EntityKey represents a Google-managed entity such as a Google user or a Google Group. If specified, the EntityKey represents an external-identity-mapped group. The namespace must correspond to an identity source created in Admin Console and must be in the form of `identitysources/{identity_source_id}`.
        END
      }

      variable "memberships" {
        type           = list(membership)
        description    = <<-END
          A list of memberships (id, roles) to get attached to the group resource created.
        END
        readme_example = <<-END
          memberships = [
            {
              id = "user@example.com"
              roles = ["MEMBER", "MANAGER"]
            }
          ]
        END
        default        = []

        attribute "id" {
          required    = true
          type        = string
          description = <<-END
            The id of the entity. For Google-managed entities, the id must be
            the email address of an existing group or user. For external-identity-mapped
            entities, the id must be a string conforming to the identity source's requirements.
          END
        }

        attribute "roles" {
          type        = list(string)
          default     = ["MEMBER"]
          description = <<-END
            A list of roles to bind to this Membership. Possible values are `OWNER`, `MANAGER`, and `MEMBER`.
            **Note:** The `OWNER` and `MANAGER` roles are supplementary roles that require the `MEMBER` role to be assigned.
          END
        }
      }
    }

    section {
      title = "Module Configuration"

      variable "module_enabled" {
        type        = bool
        default     = true
        description = <<-END
          Specifies whether resources in the module will be created.
        END
      }

      variable "module_timeouts" {
        type           = map(timeout)
        description    = <<-END
          A map of timeout objects that is keyed by Terraform resource name
          defining timeouts for `create`, `update` and `delete` Terraform operations.
          Supported resources are:
          - `google_cloud_identity_group`
          - `google_cloud_identity_group_membership`
        END
        readme_example = <<-END
          module_timeouts = {
            google_cloud_identity_group = {
              create = "4m"
              update = "4m"
              delete = "4m"
            }
            google_cloud_identity_group_membership = {
              create = "4m"
              update = "4m"
              delete = "4m"
            }
          }
        END

        attribute "create" {
          type        = string
          description = <<-END
            Timeout for create operations.
          END
        }

        attribute "update" {
          type        = string
          description = <<-END
            Timeout for update operations.
          END
        }

        attribute "delete" {
          type        = string
          description = <<-END
            Timeout for delete operations.
          END
        }
      }

      variable "module_depends_on" {
        type           = list(dependency)
        description    = <<-END
          A list of dependencies.
          Any object can be _assigned_ to this list to define a hidden external dependency.
        END
        default        = []
        readme_example = <<-END
          module_depends_on = [
            null_resource.name
          ]
        END
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported in the outputs of the module:
    END

    output "group" {
      type        = object(group)
      description = <<-END
        All attributes of the created `google_cloud_identity_group` resource.
      END
    }

    output "membership" {
      type        = object(membership)
      description = <<-END
        All attributes of the created `google_cloud_identity_group_membership` resource.
      END
    }

    output "module_enabled" {
      type        = bool
      description = <<-END
        Whether this module is enabled.
      END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "Google Documentation"
      content = <<-END
        - Identity Overview - https://cloud.google.com/identity/
        - Groups API Overview - https://cloud.google.com/identity/docs/groups
      END
    }

    section {
      title   = "Terraform GCP Provider Documentation"
      content = <<-END
        - Identity Group - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_identity_group
        - Identity Group Membership - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_identity_group_membership
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-google-identity-group"
  }
  ref "hello@mineiros.io" {
    value = " mailto:hello@mineiros.io"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "aws" {
    value = "https://aws.amazon.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-identity-group/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-identity-group/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-identity-group/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-identity-group/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-identity-group/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-identity-group/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-identity-group/blob/main/CONTRIBUTING.md"
  }
}
