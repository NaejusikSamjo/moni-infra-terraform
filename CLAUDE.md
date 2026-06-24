
Claude · MD
# moni-infra-terraform CLAUDE.md

## 프로젝트 개요

moni MSA 프로젝트의 AWS 인프라를 Terraform으로 관리하는 레포지토리입니다.
 
---

## 백엔드 프로젝트 참조

백엔드 프로젝트는 `/Users/dong-won/Downloads/moni/moni` 에 위치합니다.

- 서비스별 포트, 도커 컴포즈 구성, 환경변수 등은 해당 프로젝트의 `docs/.backend/CLAUDE.md` 를 참조하세요.
- 포트 구성, 서비스 의존성 등 인프라 작업 전 반드시 백엔드 문서를 먼저 확인하세요.
---

## 인프라 아키텍처

### 네트워크 구조

```
인터넷
  │
  ▼
Internet Gateway (VPC 진입점)
  │
  ▼
ALB (Application Load Balancer)
  │  ├── api.moni.my     → 서비스 EC2 :8080 (api-gateway)
  │  └── admin.moni.my   → 서비스 EC2 :19097 (admin-service)
  │
  ├── 퍼블릭 서브넷
  │     ├── Bastion Host (t2.micro) - 프라이빗 EC2 SSH 접근용
  │     └── NAT Instance (ami 전용) - 프라이빗 → 외부 인터넷 요청용
  │
  └── 프라이빗 서브넷
        ├── 서비스 EC2 (t4g.large)   - 앱 서비스 전체 (api-gateway, user-service 등)
        ├── 인프라 EC2 (r8g.medium)  - DB, Redis, Kafka 등
        └── 모니터링 EC2 (t4g.small) - Grafana, Prometheus 등
```

### 도메인 구성

| 도메인             | 대상                      | 포트    |
|-----------------|-------------------------|-------|
| `api.moni.my`   | 서비스 EC2 (api-gateway)   | 8080  |
| `admin.moni.my` | 서비스 EC2 (admin-service) | 19097 |

- DNS: AWS Route 53
- HTTPS 인증서: AWS Certificate Manager (내보내기 불가 공인 인증서, 추가 비용 없음)
- ALB 리스너에서 호스트 기반 라우팅으로 포트 분기 처리
- Nginx 미사용, ALB로만 라우팅
### Okta 커스텀 도메인

- Okta 인증 도메인: `auth.moni.my`
- Cloudflare DNS에서 CNAME으로 Okta로 연결
- admin-service OIDC issuer: `https://auth.moni.my/oauth2/{auth-server-id}`
---

## EC2 인스턴스 사양

| 용도   | Name 태그      | 인스턴스 타입    | 스펙             | 서브넷  |
|------|--------------|------------|----------------|------|
| 서비스  | service      | t4g.large  | 2 vCPU / 8 GiB | 프라이빗 |
| 인프라  | infra        | r8g.medium | 1 vCPU / 8 GiB | 프라이빗 |
| 모니터링 | monitor      | t4g.small  | 2 vCPU / 2 GiB | 프라이빗 |
| 베스천  | bastion_host | t2.micro   | -              | 퍼블릭  |
| NAT  | nat_instance | ami 전용     | -              | 퍼블릭  |
 
---

## 비용 관련 주의사항

- **월 예산 상한: $200**
- 작업 전 AWS 요금 계산기로 비용 산정 필수
- EBS, NAT 트래픽, 데이터 전송 등 추가 비용 발생 가능
- **S3**: 타 팀원 사용 가능, 단 비용 발생 시 활성화 금지
- **ACM 인증서**: 내보내기 불가 공인 인증서 사용 (추가 비용 없음)
- 비용이 발생하는 작업은 반드시 사전 안내 후 진행
---

## DB 접근

- 개발 편의를 위해 Bastion Host를 통해 팀원 전체가 프라이빗 DB에 접근 가능해야 함
- Bastion Host SSH 터널링 방식으로 접근
---

## Terraform 모듈 구조

```
moni-infra-terraform/
├── main.tf                  # 루트 모듈 (모듈 호출)
├── variables.tf
├── outputs.tf
├── alb/                     # ALB + 타겟그룹 + 리스너
├── ec2/                     # EC2 인스턴스
├── vpc/                     # VPC
├── subnet/                  # 서브넷 (퍼블릭/프라이빗)
├── security-group/          # 보안 그룹
├── route53/                 # DNS 레코드
└── docs/
    ├── CLAUDE.md            # 이 파일
    ├── .backend/
    │   └── CLAUDE.md        # 백엔드 서비스 상세 문서 (포트, 도커 구성 등)
    ├── IMG-0.png            # 아키텍처 다이어그램 초안
    └── IMG-1.png            # 아키텍처 다이어그램 최종본 (현재 기준)
```
 
---

## 작업 시 주의사항

1. **포트 정보는 백엔드 CLAUDE.md 참조** - `/moni` 의 백엔드 프로젝트 및 `docs/.backend/CLAUDE.md` 확인
2. **Nginx 미사용** - 포트 라우팅은 ALB 리스너 룰로만 처리
3. **비용 발생 작업은 사전 안내** - 요금 계산기 사용 후 진행
4. **ACM 인증서** - `*.moni.my` 와일드카드 인증서 사용, DNS validation
5. **IMG-1.png 기준으로 작업** - 초안(IMG-0)과 다를 수 있으니 IMG-1 우선