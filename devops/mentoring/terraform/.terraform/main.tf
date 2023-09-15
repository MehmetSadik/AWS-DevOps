# DATADOG

resource "datadog_integration_aws" "production" {
  account_id                       = "1234"
  role_name                        = "DatadogAWSIntegrationRole"
  account_specific_namespace_rules = local.namespace_rules
}

resource "datadog_integration_aws" "development" {
  account_id                       = "1234"
  role_name                        = "DatadogAWSIntegrationRole"
  account_specific_namespace_rules = local.namespace_rules
}

resource "datadog_integration_aws" "test" {
  account_id                       = "1234"
  role_name                        = "DatadogAWSIntegrationRole"
  account_specific_namespace_rules = local.namespace_rules
}



output "production_external_id" {
  description = "production aws integration external-id."
  value       = datadog_integration_aws.production.external_id
}

output "development_external_id" {
  description = "development aws integration external-id."
  value       = datadog_integration_aws.development.external_id
}

output "test_external_id" {
  description = "test aws integration external-id."
  value       = datadog_integration_aws.test.external_id
}


#AWS


locals {
  environment  = terraform.workspace
  cluster-name = "${terraform.workspace}-cluster"
  external_id = {
    "prod"  = "production_external_id"
    "dev" = "development_external_id"
    "test"        = "test_external_id"
    }
}

data "terraform_remote_state" "datadog_config" {
  backend = "s3"
  config = {
    bucket = "datadog-config-terraform-state"
    key    = "datadog-config-terraform-state"
    region = "eu-west-1"
  }
  workspace = "default"
}


data "aws_iam_policy_document" "datadog_aws_integration_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::464622532012:root"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [
        "${data.terraform_remote_state.datadog_config.outputs[local.external_id[terraform.workspace]]}"
      ]
    }
  }
}


