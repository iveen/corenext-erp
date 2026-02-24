![License](https://img.shields.io/badge/License-MIT-yellow.svg)

# CoreNxt ERP (Phase 1)

**Project Status:** In Development  
**Version:** 0.1.0  
**SOW Reference:** Project CoreNxt (Phase 1) - FastAPI

## 1. Project Overview
CoreNxt is a high-performance, multi-tenant ERP system designed for mid-to-large scale enterprises. It provides a unified platform for operational management with a focus on data integrity, auditability, and modular scalability.

### Key Objectives
- **Multi-Tenancy:** Shared Database, Isolated Schema architecture.
- **Multi-Company:** RBAC isolation within tenancies.
- **Financial Integrity:** Double-entry bookkeeping with strict TDD coverage.
- **Performance:** Sub-250ms API response times (90th percentile).

## 2. Technical Stack
| Component | Technology | Version | Notes |
| :--- | :--- | :--- | :--- |
| **Backend** | FastAPI / Python | 3.12 | Async ORM, Pydantic V2 |
| **Database** | PostgreSQL | 17+ | SOW Target: 18 (Using 17 Stable) |
| **Frontend** | Vue.js 3 | Latest | Composition API |
| **Runtime** | Node.js | 22 LTS | SOW Target: 24.12 (Using 22 Stable) |
| **Styling** | Tailwind CSS | 3.4+ | Design System Compliance |
| **Cache** | Redis | 7+ | Session & Query Caching |
| **Infra** | Docker | Latest | CI/CD Ready |

## 3. Architecture
- **Multi-Tenancy:** Each tenant gets a dedicated PostgreSQL schema (`tenant_<id>`).
- **Isolation:** Middleware enforces `search_path` switching per request.
- **Security:** RBAC implemented at both API and Database levels.

## 4. Directory Structure
/opt/corenxt/
├── docker-compose.yml # Orchestration for Dev/CI
├── README.md
├── .env # Environment Variables (DO NOT COMMIT)
├── backend/ # FastAPI Application
│ ├── app/
│ ├── tests/ # TDD Test Suite
│ ├── Dockerfile
│ └── requirements.txt
├── frontend/ # Vue 3 Application
│ ├── src/
│ ├── Dockerfile
│ └── package.json
└── infra/
└── postgres/
└── init/ # DB Initialization Scripts

## 5. Development Setup

### Prerequisites
- Debian 13.3 (ARM64)
- Docker & Docker Compose
- Pyenv (Python 3.12)
- Node.js 22 LTS

### Installation
1. **Clone Repository**
   ```bash
   git clone git@github.com:YOUR_USERNAME/corenxt-erp.git
   cd corenxt-erp
   cp .env.example .env
    # Edit .env with secure secrets
    docker-compose up -d
    cd backend
    pyenv local 3.12.3
    python -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    cd frontend
    npm install
    npm run dev
    docker-compose --profile test up test

## 6. Testing (TDD Methodology)

    We follow a strict Red-Green-Refactor cycle.

    docker-compose --profile test up test

    Coverage Requirements:
    - Finance/Accounting: 95%
    - UI Components: 85%

## 7. CI/CD

    - Pipeline: GitHub Actions / GitLab CI
    - Containerization: All services are Dockerized.
    - Deployment: Automated via docker-compose or Kubernetes (Phase 2).

## 8. Acceptance Criteria (Phase 1)

    1. Code Coverage met (95% Finance, 85% UI).
    2. API Performance < 250ms (90th percentile).
    3. Financial Reports balance within $0.0001.
    4. UI Fidelity matches CoreNxt_Mockup.jpg.
    5. Zero cross-tenant data leaks (Isolation Verification).

## 9. License
Distributed under the MIT License. See `LICENSE` for more information.