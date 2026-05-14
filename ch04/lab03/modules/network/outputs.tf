output "vpc" {
  value = {
    id = aws_vpc.this.id
  }
}

output "subnet" {
  value = {
    id = aws_subnet.this.id
  }
}