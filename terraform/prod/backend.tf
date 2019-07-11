terraform {
  backend "gcs" {
    bucket = "storage-bucket-artshutter2"
    prefix = "prod"
  }
}
