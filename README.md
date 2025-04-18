# terraform-aws-organizations-ous-by-path

A Terraform module to expose AWS Organizations Organizational Units with their relative paths from the Organization root.

OUs can be accessed via a list or through indexed Maps, see <a name="Outputs"></a> [Outputs](#Outputs) for more information.

Each OU is represented as a Map with attributes

- `arn` - ARN of the OU.
- `child_accounts` - List of AWS accounts that are direct children of the OU. Dependant upon the `include_child_accounts` variable.
  - `arn` - ARN of the account.
  - `email` - Email of the account.
  - `id` - Identifier of the account.
  - `name` - Name of the account.
  - `status` - Status of the account.
- `descendant_accounts` - List of AWS accounts that are direct children or descendants of the OU. Dependant upon the `include_descendant_accounts` variable.
  - `arn` - ARN of the account.
  - `email` - Email of the account.
  - `id` - Identifier of the account.
  - `name` - Name of the account.
  - `status` - Status of the account.
- `id` - ID of the OU.
- `id_path` - Path to the OU from the Organization ID, to be used with the `aws:PrincipalOrgPaths` and `aws:ResourceOrgPaths` conditions.
- `name` - Name of the OU.
- `name_path` - Path to the OU using OU names, delimited by the `name_path_delimiter` variable.
- `parent_id` - ID of the OU's direct parent.

## Usage

```hcl
module "ous" {
  source = "kurtismash/organizations-ous-by-path/aws"
}

# Create a bucket and allow access from accounts within a specified OU.
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*",
    ]
    condition {
      test     = "ForAllValues:StringEquals"
      variable = "aws:PrincipalOrgPaths"
      values   = [module.ous.by_name_path["Level 1 OU/Level 2 OU"].id_path]
    }
  }
}
resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "bucket-"
}
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.43.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_include_child_accounts"></a> [include\_child\_accounts](#input\_include\_child\_accounts) | Include direct child AWS accounts in the output, increases the number of API calls when enabled. | `bool` | `false` | no |
| <a name="input_include_descendant_accounts"></a> [include\_descendant\_accounts](#input\_include\_descendant\_accounts) | Include descendant AWS accounts in the output, increases complexity when enabled. | `bool` | `false` | no |
| <a name="input_name_path_delimiter"></a> [name\_path\_delimiter](#input\_name\_path\_delimiter) | Delimiter used to join names in the name\_path attribute of each OU. | `string` | `"/"` | no |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_by_id"></a> [by\_id](#output\_by\_id) | Map of all OUs indexed by id. |
| <a name="output_by_name_path"></a> [by\_name\_path](#output\_by\_name\_path) | Map of all OUs indexed by name\_path. |
| <a name="output_list"></a> [list](#output\_list) | List of all OUs with added attributes id\_path and name\_path. |
