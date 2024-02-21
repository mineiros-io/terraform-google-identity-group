[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![license][badge-license]][apache20]
[![Join Slack][badge-slack]][slack]

# Terraform Mock Tests

! Note: Test mocking is available in Terraform v1.7.0 and later. This feature is in beta. !

Each resource change may require you to run terraform init (you will get prompt when you run `terraform test`).

Unit tests are split into 3 categories:
 - unit_minial - minimal set of features, providing only required variables
 - unit_disabled - testing scenario when a module is disabled
 - unit_complete - testing all resources provding all optional variables
 
`tests/setup` contains shared, real resouces to be available for testing values.
Each tests contains a `mock_provider` for `google` and `google-beta`.
Inputs are supplied in the `variables` section.

In general, data for the mocks can from from different sources:

- as a value from the `mock_resource`

```hcl
  mock_resource "<resource name>" {
    defaults = {
      ...
    }
  }
```

- as an `override_data`, `override_resource`, or `override_module`

```hcl
  override_data {
    target = <target resource>
    values = { ... }
  }
```

- as a default mock value by using a `mock_provider`

```hcl
mock_provider "google" {
  alias = "fake"
} 
```

- from additional (real) resources created just for tests (`tests/setup`)


Links:  
[Terraform Mocking](https://developer.hashicorp.com/terraform/language/tests/mocking)  
[Terraform Testing](https://developer.hashicorp.com/terraform/tutorials/configuration-language/test)



## How to run the tests

This repository comes with a [Makefile], that helps you to run the tests in a convenient way.

Run `terraform test` from the root directory.

<!-- References -->

[makefile]: https://github.com/mineiros-io/terraform-google-identity-group/blob/main/Makefile
[testdirectory]: https://github.com/mineiros-io/terraform-google-identity-group/tree/main/test
[unit-disabled]: https://github.com/mineiros-io/terraform-google-identity-group/blob/main/test/unit-disabled/main.tf
[unit-minimal]: https://github.com/mineiros-io/terraform-google-identity-group/blob/main/test/unit-minimal/main.tf
[unit-complete]: https://github.com/mineiros-io/terraform-google-identity-group/blob/main/test/unit-complete/main.tf
[homepage]: https://mineiros.io/?ref=terraform-google-identity-group
[terratest]: https://github.com/gruntwork-io/terratest
[package testing]: https://golang.org/pkg/testing/
[docker]: https://docs.docker.com/get-started/
[go]: https://golang.org/
[terraform]: https://www.terraform.io/downloads.html
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
