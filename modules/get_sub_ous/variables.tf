variable "include_aws_accounts" {
  description = "Include AWS accounts in the output, increases the number of API calls when enabled."
  type        = bool
}

variable "parent_level_ou_list" {
  description = "output.list from the previous level of OUs."
  type = list(object({
    id        = string
    id_path   = string
    name_path = string
  }))
}

variable "name_path_delimiter" {
  description = "Delimiter used to join names in the name_path attribute of each OU."
  type        = string
}
