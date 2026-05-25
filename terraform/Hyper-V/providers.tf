terraform {
  required_providers {
    hyperv = {
      source = "taliesins/hyperv"
      version = "1.2.1"
    }
  }
}

provider "hyperv" {
  # Configuration options.
  # Credentials are supplied via variables (see variables.tf); set real
  # values in a gitignored terraform.tfvars (see terraform.tfvars.example)
  # or via TF_VAR_hyperv_username / TF_VAR_hyperv_password env vars.
  username = var.hyperv_username
  password = var.hyperv_password
}