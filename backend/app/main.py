from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from app.core.config import settings

app = FastAPI(
    title="CoreNxt ERP",
    version="0.1.0",
    description="Multi-Tenant ERP System (SOW Phase 1)"
)

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ─────────────────────────────────────────────────────────────
# TENANT MIDDLEWARE (SOW Section 2.1 - Multi-Tenancy)
# ─────────────────────────────────────────────────────────────
@app.middleware("http")
async def tenant_middleware(request: Request, call_next):
    # EXEMPT PATHS: Skip tenant check for these endpoints
    exempt_paths = ["/health", "/docs", "/openapi.json", "/redoc"]
    
    # Check if path matches any exempt path
    if any(request.url.path.startswith(path) for path in exempt_paths):
        return await call_next(request)
    
    # Get tenant ID from headers
    tenant_id = request.headers.get("X-Tenant-ID")
    
    # Check if tenant ID is missing
    if not tenant_id:
        return JSONResponse(
            status_code=status.HTTP_403_FORBIDDEN,
            content={"detail": "Tenant ID required"}
        )
    
    # Validate UUID format
    import re
    uuid_pattern = re.compile(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', 
        re.I
    )
    if not uuid_pattern.match(tenant_id):
        return JSONResponse(
            status_code=status.HTTP_403_FORBIDDEN,
            content={"detail": "Invalid Tenant ID"}
        )
    
    # Store tenant_id in request state for later use
    request.state.tenant_id = tenant_id
    
    # Continue to next middleware/endpoint
    return await call_next(request)

# ─────────────────────────────────────────────────────────────
# HEALTH CHECK
# ─────────────────────────────────────────────────────────────
@app.get("/health")
async def health_check():
    return {"status": "healthy", "environment": settings.ENVIRONMENT}

# ─────────────────────────────────────────────────────────────
# COMPANIES ENDPOINT (Placeholder for TDD)
# ─────────────────────────────────────────────────────────────
@app.get("/api/v1/companies")
async def get_companies():
    return []