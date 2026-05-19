output "vpc" {
  value = {
    (local.vpc.name) = {
      id = aws_vpc.this.id
    }
  }
}