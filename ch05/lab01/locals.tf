locals {
  org       = "tf-core-ej"
  project   = "lab01"
  namespace = "${local.org}-${local.project}-${var.env}"

  network = {
    cidr = "10.0.0.0/16"
    eip_count = 2
  }
}
