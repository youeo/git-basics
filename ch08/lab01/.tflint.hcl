config {
  # 기존: module = true (X) -> 폐기됨
  # 변경: 하위 모듈까지 샅샅이 검사하겠다는 최신 설정 방식 (O)
  call_module_type = "all"
}

# 2. 테라폼 공식 가이드 규칙셋 활성화
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# 프로바이더 버전 비어있어도 경고하지 마라
  rule "terraform_required_providers" {
    enabled = false
  }

  # 테라폼 버전 비어있어도 경고하지 마라
  rule "terraform_required_version" {
    enabled = false
  }