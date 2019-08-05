terraform {
  backend "gcs" {
    bucket = "storage-bucket-artshutter"
    prefix = "stage"
  }
}
