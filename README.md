# moni-infra-terraform

moni MSA 프로젝트의 AWS 인프라를 Terraform으로 관리하는 레포지토리입니다.

---

## 아키텍처

```
인터넷
  │
  ▼
Cloudflare (api.moni.my / admin.moni.my NS 위임 → Route 53)
  │
  ▼
ALB (Application Load Balancer) — HTTPS :443
  │  ├── api.moni.my      → 서비스 EC2 :8080  (api-gateway)
  │  ├── admin.moni.my   → 서비스 EC2 :19097 (admin-service)
  │  └── grafana.moni.my → 모니터링 EC2 :3000 (Grafana)
  │
  ├── 퍼블릭 서브넷
  │     ├── Bastion Host (t2.micro) — 프라이빗 EC2 SSH 접근용
  │     └── NAT Instance            — 프라이빗 → 외부 인터넷 요청용
  │
  └── 프라이빗 서브넷
        ├── 서비스 EC2 (t4g.large)   — api-gateway, user-service 등 앱 서비스 전체
        ├── 인프라 EC2 (r8g.medium)  — PostgreSQL, Redis, Kafka
        └── 모니터링 EC2 (t4g.small) — Grafana, Prometheus, Loki, Promtail, Tempo
```

### 도메인 구성

| 도메인               | 대상                        | 포트    |
|-------------------|---------------------------|-------|
| `api.moni.my`     | 서비스 EC2 (api-gateway)     | 8080  |
| `admin.moni.my`   | 서비스 EC2 (admin-service)   | 19097 |
| `grafana.moni.my` | 모니터링 EC2 (Grafana)        | 3000  |

- 메인 도메인 `moni.my`: Cloudflare 관리 (프론트엔드 연결)
- 서브도메인 `api.moni.my`, `admin.moni.my`, `grafana.moni.my`: Cloudflare에서 Route 53으로 NS 위임
- HTTPS 인증서: ACM (`api.moni.my` + `admin.moni.my` + `grafana.moni.my` SAN)
- HTTP :80 → HTTPS :443 리다이렉트 적용
- Nginx 미사용, ALB 리스너 룰로만 라우팅

---

## EC2 인스턴스 사양

| Name 태그      | 인스턴스 타입    | 서브넷  | 역할                                                     |
|--------------|------------|------|--------------------------------------------------------|
| service      | t4g.large  | 프라이빗 | 앱 서비스 전체 (docker-compose.yml)                          |
| infra        | r8g.medium | 프라이빗 | DB, Redis, Kafka (docker-compose.infra.yml)            |
| monitor      | t4g.small  | 프라이빗 | Grafana, Prometheus, Loki (docker-compose.monitor.yml) |
| bastion_host | t2.micro   | 퍼블릭  | SSH 터널링용                                               |
| nat_instance | t2.micro   | 퍼블릭  | 프라이빗 서브넷 아웃바운드 인터넷                                     |

---

## 모듈 구조

```
moni-infra-terraform/
├── main.tf               # 루트 모듈 (모듈 호출)
├── acm/                  # ACM 인증서 (api.moni.my + admin.moni.my + grafana.moni.my SAN)
├── alb/                  # ALB + 타겟그룹 3개 + HTTPS 리스너 + 호스트 기반 룰
├── ec2/                  # EC2 인스턴스 5개
├── vpc/                  # VPC + IGW + 라우트 테이블
├── subnet/               # 퍼블릭 2개 / 프라이빗 2개
├── security-group/       # 보안 그룹
├── route53/              # ACM validation 레코드 + ALB Alias 레코드
├── s3/                   # 로그 버킷
└── docs/
    ├── IMG-0.png         # 아키텍처 초안
    └── IMG-1.png         # 아키텍처 최종본 (현재 기준)
```

---

## 주요 설정 내용

### ALB 라우팅 구조

```
HTTP :80  → HTTPS :443 리다이렉트 (301)

HTTPS :443
  ├── Host: api.moni.my     → api-target-group     (서비스 EC2 :8080)
  ├── Host: admin.moni.my   → admin-target-group   (서비스 EC2 :19097)
  └── Host: grafana.moni.my → grafana-target-group (모니터링 EC2 :3000)
```

### ACM 인증서

- Primary: `api.moni.my`
- SAN: `admin.moni.my`, `grafana.moni.my`
- Validation: DNS (Route 53 자동 등록)

### Route 53

- `api.moni.my` Hosted Zone: data source 참조 (Cloudflare에서 NS 위임 완료)
- `admin.moni.my` Hosted Zone: data source 참조 (Cloudflare에서 NS 위임 완료)
- `grafana.moni.my` Hosted Zone: data source 참조 (Cloudflare에서 NS 위임 완료)
- ACM validation CNAME 각 Hosted Zone에 자동 추가
- ALB A 레코드 (Alias) 각 Hosted Zone에 추가

---

## 적용 순서

```bash
terraform init
terraform plan
terraform apply
```

apply 완료 후 각 EC2에 SSH 접속 (Bastion 경유) 하여 docker-compose 실행:

```bash
# 인프라 EC2 (DB/Redis/Kafka 먼저)
docker compose -f docker-compose.infra.yml up -d

# 서비스 EC2
docker compose -f docker-compose.yml up -d

# 모니터링 EC2
docker compose -f docker-compose.monitor.yml up -d
```

---

## 예상 월 비용

| 항목                               | 예상 비용     |
|----------------------------------|-----------|
| EC2 service (t4g.large)          | $66.5     |
| EC2 infra (r8g.medium)           | $63.4     |
| EC2 monitor (t4g.small)          | $16.6     |
| EC2 bastion + NAT (t2.micro × 2) | $21.0     |
| ALB                              | ~$20      |
| EBS (기본 8GiB × 5)                | ~$4       |
| ACM                              | 무료        |
| Route 53                         | $0.5      |
| S3                               | ~$1       |
| **합계 (트래픽 제외)**                  | **~$193** |

> 월 예산 상한 $200 / EBS는 필요 시 무중단 확장 가능

---

## 주의사항 (구동 전 반드시 확인)

### 1. ACM validation 대기 시간
`terraform apply` 중 ACM DNS validation 완료까지 최대 **30분** 대기 필요.

### 2. 보안 그룹 전 포트 오픈 상태
개발 편의 목적. 단일 보안 그룹 전 포트 오픈. 서비스 배포 전 보안 그룹 분리 필요.

### 3. EBS service EC2 용량
기본 8GiB. 도커 이미지 11개 + 로그 누적 시 부족 가능. 운영 후 확장 필요. (무중단 확장 가능)

---

## 추후 개선 예정

### 보안
- [ ] 보안 그룹 분리 — ALB / 서비스 EC2 / Bastion / 인프라 EC2 각각 분리
- [ ] `terraform.tfvars` `.gitignore` 등록 — 시크릿 포함 시 커밋 금지
- [ ] SSM Parameter Store 또는 Secrets Manager 도입 — 환경변수 관리

### 인프라 안정성
- [ ] Terraform S3 Remote Backend 도입 — 팀원 간 state 공유 및 DynamoDB locking
- [ ] EBS 볼륨 크기 명시 — service EC2 최소 20GiB 권장

### 배포 자동화 (CD)
- [ ] ECR 레포지토리 추가 — 서비스별 도커 이미지 관리
- [ ] GitHub Actions CD 파이프라인 — 변경된 서비스만 감지하여 빌드/배포
