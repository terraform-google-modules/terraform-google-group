# terraform-google-group

This module manages Cloud Identity Groups and Memberships using the
[Cloud Identity Group API](https://cloud.google.com/identity/docs/groups).

## Usage

Basic usage of this module is as follows:

```hcl
# Required if using User ADCs (Application Default Credentials) for Cloud Identity API.
provider "google-beta" {
  user_project_override = true
  billing_project       = "<PROJECT_ID>"
}

module "group" {
  source  = "terraform-google-modules/group/google"
  version = "~> 0.1"

  id           = "example-group@example.com"
  display_name = "example-group"
  description  = "Example group"
  domain       = "example.com"
  owners       = ["foo@example.com"]
  managers     = ["example-sa@my-project.iam.gserviceaccount.com"]
  members      = ["another-group@example.com"]
}
```

Functional examples are included in the [examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| customer\_id | Customer ID of the organization to create the group in. One of domain or customer_id must be specified | string | `""` | no |
| description | Description of the group | string | `""` | no |
| display\_name | Display name of the group | string | `""` | no |
| domain | Domain of the organization to create the group in. One of domain or customer_id must be specified | string | `""` | no |
| id | ID of the group. For Google-managed entities, the ID must be the email address the group | string | n/a | yes |
| managers | Managers of the group. Each entry is the ID of an entity. For Google-managed entities, the ID must be the email address of an existing group, user or service account | list | `<list>` | no |
| members | Members of the group. Each entry is the ID of an entity. For Google-managed entities, the ID must be the email address of an existing group, user or service account | list | `<list>` | no |
| owners | Owners of the group. Each entry is the ID of an entity. For Google-managed entities, the ID must be the email address of an existing group, user or service account | list | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the group. For Google-managed entities, the ID is the email address the group |
| resource\_name | Resource name of the group in the format: groups/{group_id}, where group_id is the unique ID assigned to the group. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Limitations

The provider is still under development, the following are known issues or
limitations:

* Updating a `google_cloud_identity_group_membership` to remove a role fails
    with an error
    ([link](https://github.com/hashicorp/terraform-provider-google/issues/7616)).

* [InitialGroupConfig](https://cloud.google.com/identity/docs/reference/rest/v1beta1/groups/create#initialgroupconfig)
    is not supported in the `google_cloud_identity_group` resource, which
    prevents non-admins from creating groups in an organization, even when the
    organization is configured to allow anyone to create groups.

* Only
    [Google Groups](https://cloud.google.com/identity/docs/groups#group_properties)
    are supported.

* Last `OWNER` cannot be removed from a Google Group.

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

* [Terraform][terraform] v0.12
* [Terraform Provider for GCP][terraform-provider-gcp] plugin v2.0

### Permissions

A service account or user account needs the following roles to provision the
resources of this module:

#### Google Cloud IAM roles

* Service Usage Consumer: `roles/serviceusage.serviceUsageConsumer` on the
    billing project
* Organization Viewer: `roles/resourcemanager.organizationViewer` if using
    `domain` instead of `customer_id`

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a service
account with the necessary roles applied.

#### Google Workspace (formerly known as G Suite) roles

* [Group Admin role](https://support.google.com/a/answer/2405986?hl=en)

To make the service account a Group Admin, you must have Google Workspace Super
Admin access for your domain. Follow
[Assigning an admin role to the service account](https://cloud.google.com/identity/docs/how-to/setup#assigning_an_admin_role_to_the_service_account)
for instructions.

To create groups as an end user, the caller is required to authenticate as a
member of the domain, i.e. you cannot use this module to create a group under
`bar.com` with a `foo.com` user identity.

After the groups have been created, the organization’s Super Admin, Group Admin
or any custom role with Groups privilege can always modify and delete the groups
and their memberships. In addition, the group’s OWNER and MANAGER can edit
membership, and OWNER can delete the group. Documentation around the three group
default roles (OWNER, MANAGER and MEMBER) can be found
[here](https://support.google.com/a/answer/167094?hl=en).

### APIs

A project with the following APIs enabled must be used to host the resources of
this module:

* Cloud Identity API: `cloudidentity.googleapis.com`

The [Project Factory module][project-factory-module] can be used to provision a
project with the necessary APIs enabled.

To use the Cloud Identity Groups API, you must have Google Groups for Business
enabled for your domain and allow end users to create groups.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for information on
contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html
