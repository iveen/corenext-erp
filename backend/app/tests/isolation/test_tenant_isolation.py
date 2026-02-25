import pytest
from httpx import AsyncClient
from app.main import app

@pytest.mark.asyncio
async def test_tenant_a_cannot_access_tenant_b_data():
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response_a = await ac.get(
            "/api/v1/companies",
            headers={"X-Tenant-ID": "550e8400-e29b-41d4-a716-446655440001"}
        )
        response_b = await ac.get(
            "/api/v1/companies",
            headers={"X-Tenant-ID": "550e8400-e29b-41d4-a716-446655440002"}
        )
        
        assert response_a.status_code == 200
        assert response_b.status_code == 200
        assert response_a.json() == []
        assert response_b.json() == []

@pytest.mark.asyncio
async def test_invalid_tenant_returns_403():
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.get(
            "/api/v1/companies",
            headers={"X-Tenant-ID": "invalid-tenant"}
        )
        assert response.status_code == 403
        assert "Invalid Tenant ID" in response.json()["detail"]

@pytest.mark.asyncio
async def test_missing_tenant_header_returns_403():
    """Test 3: No X-Tenant-ID header should return 403"""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        # Do NOT send X-Tenant-ID header
        response = await ac.get("/api/v1/companies")
        
        # Debug: Print response for troubleshooting
        print(f"Status: {response.status_code}")
        print(f"Body: {response.json()}")
        
        assert response.status_code == 403
        assert "Tenant ID required" in response.json()["detail"]

@pytest.mark.asyncio
async def test_health_endpoint_does_not_require_tenant():
    """Test 4: Health endpoint should work without tenant header"""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        # Do NOT send X-Tenant-ID header
        response = await ac.get("/health")
        
        # Debug: Print response for troubleshooting
        print(f"Status: {response.status_code}")
        print(f"Body: {response.json()}")
        
        assert response.status_code == 200
        assert response.json()["status"] == "healthy"