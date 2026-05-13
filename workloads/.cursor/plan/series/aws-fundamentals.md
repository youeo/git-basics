# AWS Fundamentals ↔ Workloads

## Series location

- `Learning Series/Cloud/AWS Fundamentals`
- 시리즈 `AGENTS.md`, `.cursor/plans/`, `README.md` 에서 Gallery 로드맵 정의.

## Workload connections

| Workload | Relationship | Summary |
|----------|--------------|---------|
| **gallery-spring-boot** | **primary** | 시리즈 **Series Project: Gallery** 의 단일 Spring Boot 구현체. Ch03(EC2)·Ch06(S3)·Ch07(RDS)·Ch08(ECS) 및 Ch04·Ch05 인프라 전환 Lab과 **설정·배포 환경**으로 대응. |

## Project Lab titles ↔ implementation

시리즈 문서의 Gallery 프로젝트는 "앱 버전"이 아니라, **AWS에서 무엇을 구성/검증하는가**를 기준으로 한 프로젝트 Lab 묶음이다. 구현은 **하나의 애플리케이션**에서 프로파일·`app.storage.*`·`spring.datasource.*` 같은 설정으로 맞춘다.

| Project Lab title | Typical focus | Workload hook |
|------------------|---------------|--------------|
| Gallery - EC2 기본 배포 | EC2 배포, SG/EIP 경로로 외부 접근 검증 | 기본 `dev` + `--server.port=8080`, local storage + H2 |
| Gallery - Custom VPC 이전 | 동일 앱, 네트워크 경계를 Custom VPC로 전환 | 앱 변경 없음. 인프라/VPC/Subnet/Route/SG가 핵심 |
| Gallery - ALB 전환 | Private Subnet + ALB로 접근 경로 전환 | 헬스 체크 경로(`/` 또는 `/health`), Target Group/Listener |
| Gallery - S3 연동 | 업로드 저장소를 S3로 전환 | `app.storage.type=s3`, `app.storage.s3.bucket`, IAM Role/Policy |
| Gallery - RDS(MariaDB) 연동 | DB를 RDS(MariaDB)로 전환 | `spring.datasource.url=jdbc:mariadb://...`, SG/Private Subnet |
| Gallery - ECS(Fargate) 배포 | 컨테이너로 전환해 ECS에 배포 | Image/ECR, Task/Service, env(`app.storage.*`, `spring.datasource.*`) |

## References

- [../workloads/gallery-spring-boot.md](../workloads/gallery-spring-boot.md)
- [../matrix.md](../matrix.md)
