variable "hyperv_username" {
  description = "Hyper-V host username. Set via terraform.tfvars or TF_VAR_hyperv_username."
  type        = string
}

variable "hyperv_password" {
  description = "Hyper-V host password. Set via terraform.tfvars or TF_VAR_hyperv_password."
  type        = string
  sensitive   = true
}
