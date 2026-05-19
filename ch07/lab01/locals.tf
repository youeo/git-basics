locals {
  org       = "tf-core"
  project   = "lab01"
  namespace = "${local.org}-${local.project}"

  message = "hello world from ${local.namespace}"
}
