data "terraform_remote_state" "refinitiv_remote_state" {
  backend = "s3"
  config {
    bucket = "refinitiv-tfstate-${var.env}"
    region = "eu-west-1"
    key = "env-${var.env}.tfstate"
  }
}
