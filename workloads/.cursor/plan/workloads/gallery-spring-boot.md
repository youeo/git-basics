# gallery-spring-boot

## Overview

| Field | Value |
|-------|--------|
| Path | `Cloud/Workloads/gallery-spring-boot` |
| Artifact | `cloud-workload-gallery` (Maven) |
| Stack | Java 21, Spring Boot 3.5.x, Thymeleaf, MyBatis |
| Primary series | **AWS Fundamentals** (Gallery 프로젝트) |

단일 코드베이스로 **local storage / S3**, **H2 / MariaDB(RDS 대체)** 등을 설정으로 전환한다. 시리즈 문서의 Gallery 프로젝트는 "앱 버전"이 아니라, **AWS에서 무엇을 구성/검증하는가**를 기준으로 한 프로젝트 Lab 묶음이며 별도 저장소로 쪼개지 않는다.

---

## Feature List

### Implemented (코드 기준)

| Area | Feature | Notes |
|------|---------|--------|
| Web | 메인 목록 조회 (`GET /`) | Thymeleaf `index.html` |
| Web | 이미지 업로드 (`POST /new`, multipart) | comment 필드 |
| Web | 항목 삭제 (`GET /{id}/delete`) | GET 사용 (Lab·브라우저 기준; 운영 시 HTTP 메서드·CSRF 검토 가능) |
| Persistence | `item` 테이블 (id, url, comment) | MyBatis |
| DB | H2 in-memory (MySQL 모드), `schema.sql` 초기화 | 기본 프로파일 |
| DB | MariaDB JDBC 드라이버 포함 | RDS 등 연결 시 datasource만 교체 |
| Storage | `ImageStorage` 추상화 | |
| Storage | 로컬 디스크 업로드 + 정적 리소스 매핑 | `app.storage.type=local` |
| Storage | Amazon S3 업로드·삭제 | AWS SDK v2 S3, `app.storage.type=s3` |
| Config | `dev` / `prod` 프로파일 | 포트, Thymeleaf cache, 로깅 |
| Logging | `logback-prod.xml`, logstash encoder (prod) | 구조화 로그 확장용 |
| Error | Whitelabel 비활성화, `GlobalExceptionHandler`, error forward | |

### Planned / Series-aligned (문서·설정으로 맞출 항목)

| Area | Project Lab title (AWS Fundamentals) | Workload 측 메모 |
|------|-------------------------------------|------------------|
| Deploy | Gallery - EC2 기본 배포 | EC2 + Git clone + `./mvnw` 빌드 + JAR 실행. 기본 구성은 local storage + H2. Lab에서는 `--server.port=8080` 사용. |
| Object Storage | Gallery - S3 연동 | `app.storage.type=s3`, bucket·IAM |
| Database | Gallery - RDS(MariaDB) 연동 | `spring.datasource` → RDS(MariaDB) 엔드포인트, 보안 그룹 |
| Container | Gallery - ECS(Fargate) 배포 | Dockerfile / ECS Task 정의, 동일 앱 이미지 |
| Networking | Gallery - Custom VPC 이전, Gallery - ALB 전환 | 앱 변경 최소, 인프라·타깃 그룹·헬스 경로 |

### Not in scope (시리즈 문서에만 있거나 미구현)

| Item | Notes |
|------|--------|
| CloudFront / Route 53 | 인프라·DNS 측. 앱은 URL만 맞으면 동작 |
| GCP / Azure / NCP 전용 SDK | 현재 AWS S3만. 멀티 클라우드 시 `ImageStorage` 구현 추가 검토 |

---

## Configuration Keys (요약)

| Key | Role |
|-----|------|
| `spring.profiles.active` | `dev`, `prod` |
| `app.storage.type` | `local` \| `s3` |
| `app.storage.local.path`, `app.storage.local.url-prefix` | 로컬 업로드 경로·URL prefix |
| `app.storage.s3.bucket` | S3 버킷 이름 |
| `spring.datasource.*` | H2 기본; RDS 시 JDBC URL 등으로 교체 |

AWS Fundamentals 실습 관점 메모:

- EC2에서 local storage를 사용할 때, EBS Volume을 `/mnt/data`로 마운트했다면 `--app.storage.local.path=/mnt/data/gallery-uploads` 같은 방식으로 "애플리케이션 데이터(업로드 파일)"를 루트 볼륨과 분리할 수 있다.
- ALB/ECS 헬스체크는 기본 `GET /`로도 가능하다. 운영형으로는 `/health` 같은 엔드포인트를 추가하는 것을 권장한다.

---

## Related Series Documents

- [AWS Fundamentals README.md](../../../../AWS%20Fundamentals/README.md) — Series Project: Gallery, Target Architecture
- [series-hierarchy.md](../../../../AWS%20Fundamentals/.cursor/plans/series-hierarchy.md) — Gallery 프로젝트 Lab 요약, Phase, 작업 현황
- Workloads 측 시리즈 매핑: [aws-fundamentals.md](../series/aws-fundamentals.md)
