config {
  # 기존: module = true (X) -> 폐기됨
  # 변경: 하위 모듈까지 샅샅이 검사하겠다는 최신 설정 방식 (O)
  call_module_type = "all"
}

# 프로바이더 버전 비어있어도 경고하지 마라
# 프로바이더 버전 검사 규칙을 모듈 내부까지 통째로 끄기
rule "terraform_required_providers" {
  enabled = false
  style   = "all" # 하위 모듈 전체에 적용
}

# 테라폼 버전 비어있어도 경고하지 마라
# 테라폼 버전 검사 규칙을 모듈 내부까지 통째로 끄기
rule "terraform_required_version" {
  enabled = false
  style   = "all" # 하위 모듈 전체에 적용
}