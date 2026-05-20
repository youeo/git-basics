config {
  module = true
}

# 프로바이더 버전 비어있어도 경고하지 마라
rule "terraform_required_providers" {
  enabled = false
}

# 테라폼 버전 비어있어도 경고하지 마라
rule "terraform_required_version" {
  enabled = false
}