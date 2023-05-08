# Simple Example

This example illustrates how to use the `group` module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domain | Domain of the organization to create the group in | `string` | n/a | yes |
| project\_id | The ID of the project in which to provision resources and used for billing | `string` | n/a | yes |
| suffix | Suffix of the groups to create | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| group\_id | n/a |
| group\_name | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
