terraform {
  backend "gcs" {
    bucket = "inkdev-bucket1"
    prefix = "terraform/state"
  }
}
