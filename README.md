## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.0.0 |

## Providers

| Name                                                                              | Version |
| --------------------------------------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws)                                  | 4.2.0   |
| <a name="provider_tenstad_remote"></a> [tenstad_remote](#provider_tenstad_remote) | 0.0.23  |

## Modules

No modules.

## Resources

| Name                                                                                                                  | Type        |
| --------------------------------------------------------------------------------------------------------------------- | ----------- |
| [hashicups_coffees.all](https://registry.terraform.io/providers/hashicorp/hashicups/latest/docs/data-sources/coffees) | data source |

## Inputs

| Name                                                          | Description            | Type     | Default     | Required |
| ------------------------------------------------------------- | ---------------------- | -------- | ----------- | :------: |
| <a name="input_name"></a> [name](#input_name)                 | Tag name for resources | `string` | demo        |   yes    |
| <a name="input_cidr_block"></a> [name](#input_cidr_block)     | CIDR block for vpc     | `string` | 10.0.0.0/16 |   yes    |
| <a name="input_worker_nodes"></a> [name](#input_worker_nodes) | Now many worker nodes  | `number` | 2           |   yes    |

## Outputs

| Name                                                                                       | Description           |
| ------------------------------------------------------------------------------------------ | --------------------- |
| <a name="output_public_ip"></a> [public_ip](#output_public_ip)                             | Master public ip      |
| <a name="output_public_ip_worker"></a> [public_ip_worker](#output_public_ip_worker)        | Worker public ip      |
| <a name="output_elastic_password"></a> [public_elastic_password](#output_elastic_password) | elastic user password |
