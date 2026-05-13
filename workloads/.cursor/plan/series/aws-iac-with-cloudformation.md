# AWS IaC with CloudFormation ↔ Workloads

## Series location

- `Learning Series/Cloud/AWS IaC with CloudFormation`

## Workload connections

| Workload | Relationship | Summary |
|----------|--------------|---------|
| gallery-spring-boot | **planned / reference** | CloudFormation Stack으로 EC2·RDS·S3·보안 그룹 등을 올린 뒤, **동일 Workload JAR/이미지**를 배포 대상으로 둘 수 있음. 시리즈 내 Lab은 주로 Template·CLI·SDK 예제. |

## Notes

- 인프라 정의는 이 시리즈 디렉터리, **애플리케이션 바이너리**는 `Workloads/` 에 두는 구조를 유지한다.
- 매트릭스·기능 목록 갱신: 배포 파이프라인이 확정되면 [../matrix.md](../matrix.md) 상태를 `reference` 또는 `primary` 보조로 조정.

## References

- [../matrix.md](../matrix.md)
- [../workloads/gallery-spring-boot.md](../workloads/gallery-spring-boot.md)
