locals {
  project = "tf-core-lab02"

  allow_access = {
    port = 80,
    cidr_blocks = ["0.0.0.0/0"]
  }
}