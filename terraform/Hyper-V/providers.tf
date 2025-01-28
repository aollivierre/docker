terraform {
  required_providers {
    hyperv = {
      source = "taliesins/hyperv"
      version = "1.2.1"
    }
  }
}

provider "hyperv" {
  # Configuration options
  #we need to define username and password in outside in secrets.json
  username = "Administrator"
  password = "REDACTED-PASSWORD"
}