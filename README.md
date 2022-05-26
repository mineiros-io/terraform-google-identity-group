[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-google-identity-group)

[![Build Status](https://github.com/mineiros-io/terraform-google-identity-group/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-google-identity-group/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-google-identity-group.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-google-identity-group/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version](https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-google/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-google-identity-group

A [Terraform](https://www.terraform.io) module to create and manage a [Google Cloud Identity Group](https://cloud.google.com/identity/).

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 4._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Main Resource Configuration](#main-resource-configuration)
  - [Module Configuration](#module-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [Google Documentation](#google-documentation)
  - [Terraform GCP Provider Documentation](#terraform-gcp-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This module implements the following Terraform resources

- `google_cloud_identity_group`
- `google_cloud_identity_group_membership`

## Getting Started

Most common usage of the module:

```hcl
module "terraform-google-identity-group" {
  source = "git@github.com:mineiros-io/terraform-google-identity-group.git?ref=v0.0.4"

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

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Main Resource Configuration

- [**`group_key_id`**](#var-group_key_id): *(**Required** `string`)*<a name="var-group_key_id"></a>

  The ID of the entity. For Google-managed entities, the id must be the email address of an existing group or user. For external-identity-mapped entities, the id must be a string conforming to the Identity Source's requirements. Must be unique within a namespace.

- [**`parent`**](#var-parent): *(**Required** `string`)*<a name="var-parent"></a>

  The resource name of the entity under which this Group resides in the Cloud Identity resource hierarchy. Must be of the form `identitysources/{identity_source_id}` for external-identity-mapped groups or `customers/{customer_id}` for Google Groups.

- [**`labels`**](#var-labels): *(Optional `map(string)`)*<a name="var-labels"></a>

  The labels that apply to the Group.Must not contain more than one entry.Must contain the entry `cloudidentity.googleapis.com/groups.discussion_forum`: '' if the Group is a Google Group or `system/groups/external`: '' if the Group is an external-identity-mapped group.

  Default is `{"cloudidentity.googleapis.com/groups.discussion_forum":""}`.

- [**`display_name`**](#var-display_name): *(Optional `string`)*<a name="var-display_name"></a>

  The display name of the Group.

- [**`description`**](#var-description): *(Optional `string`)*<a name="var-description"></a>

  An extended description to help users determine the purpose of a Group. Must not be longer than 4,096 characters.

- [**`initial_group_config`**](#var-initial_group_config): *(Optional `string`)*<a name="var-initial_group_config"></a>

  The initial configuration options for creating a Group. Default value is `EMPTY`. Possible values are `INITIAL_GROUP_CONFIG_UNSPECIFIED`, `WITH_INITIAL_OWNER`, and `EMPTY`.

  Default is `"EMPTY"`.

- [**`group_key_namespace`**](#var-group_key_namespace): *(Optional `string`)*<a name="var-group_key_namespace"></a>

  The namespace in which the entity exists. If not specified, the EntityKey represents a Google-managed entity such as a Google user or a Google Group. If specified, the EntityKey represents an external-identity-mapped group. The namespace must correspond to an identity source created in Admin Console and must be in the form of `identitysources/{identity_source_id}`.

- [**`memberships`**](#var-memberships): *(Optional `list(membership)`)*<a name="var-memberships"></a>

  A list of memberships (id, roles) to get attached to the group resource created.

  Default is `[]`.

  Each `membership` object in the list accepts the following attributes:

  - [**`roles`**](#attr-memberships-roles): *(Optional `list(string)`)*<a name="attr-memberships-roles"></a>

    A list of roles to bind to this Membership. Possible values are `OWNER`, `MANAGER`, and `MEMBER`.
    **Note:** The `OWNER` and `MANAGER` roles are supplementary roles that require the `MEMBER` role to be assigned.

    Default is `["MEMBER"]`.

    Example:

    ```hcl
    roles = ["MEMBER", "MANAGER"]
    ```

### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_timeouts`**](#var-module_timeouts): *(Optional `map(timeout)`)*<a name="var-module_timeouts"></a>

  A map of timeout objects that is keyed by Terraform resource name
  defining timeouts for `create`, `update` and `delete` Terraform operations.
  Supported resources are:
  - `google_cloud_identity_group`
  - `google_cloud_identity_group_membership`

  Example:

  ```hcl
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
  ```

  Each `timeout` object in the map accepts the following attributes:

  - [**`create`**](#attr-module_timeouts-create): *(Optional `string`)*<a name="attr-module_timeouts-create"></a>

    Timeout for create operations.

  - [**`update`**](#attr-module_timeouts-update): *(Optional `string`)*<a name="attr-module_timeouts-update"></a>

    Timeout for update operations.

  - [**`delete`**](#attr-module_timeouts-delete): *(Optional `string`)*<a name="attr-module_timeouts-delete"></a>

    Timeout for delete operations.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependency)`)*<a name="var-module_depends_on"></a>

  A list of dependencies.
  Any object can be _assigned_ to this list to define a hidden external dependency.

  Default is `[]`.

  Example:

  ```hcl
  module_depends_on = [
    null_resource.name
  ]
  ```

## Module Outputs

The following attributes are exported in the outputs of the module:

- [**`group`**](#output-group): *(`object(group)`)*<a name="output-group"></a>

  All attributes of the created `google_cloud_identity_group` resource.

- [**`membership`**](#output-membership): *(`object(membership)`)*<a name="output-membership"></a>

  All attributes of the created `google_cloud_identity_group_membership` resource.

- [**`module_enabled`**](#output-module_enabled): *(`bool`)*<a name="output-module_enabled"></a>

  Whether this module is enabled.

## External Documentation

### Google Documentation

- Identity Overview - https://cloud.google.com/identity/
- Groups API Overview - https://cloud.google.com/identity/docs/groups

### Terraform GCP Provider Documentation

- Identity Group - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_identity_group
- Identity Group Membership - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_identity_group_membership

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-identity-group
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[aws]: https://aws.amazon.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-google-identity-group/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-identity-group/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-identity-group/issues
[license]: https://github.com/mineiros-io/terraform-google-identity-group/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-identity-group/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-identity-group/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-identity-group/blob/main/CONTRIBUTING.md
