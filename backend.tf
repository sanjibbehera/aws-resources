terraform {
  backend "s3" {
    region    = "ap-southeast-1"
    bucket    = "sanjib-terraform-eg-12345678"
    key       = "sanjibbehera/dev/terraform-state.tfstate"
    encrypt   = true    #AES-256 encryption
  }
}