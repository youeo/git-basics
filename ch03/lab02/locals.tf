locals {
  org     = "tf-core-ej"
  project = "lab01"

  namespace = "${local.org}-${local.project}"

  s3bucket = {
    name   = "tfstate"
    bucket = "${local.org}-tfstate"

    versioning_configuration = {
      status = "Enabled"
    }

    public_access_block = {
      block_public_acls       = true
      block_public_policy     = true
      ignore_public_acls      = true
      restrict_public_buckets = true
    }
  }
}