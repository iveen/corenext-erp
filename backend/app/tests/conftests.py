import pytest
import asyncio
from typing import AsyncGenerator, Generator
import os
import warnings

# Suppress specific pytest-asyncio warnings
warnings.filterwarnings("ignore", category=DeprecationWarning, module="pytest_asyncio")

# Set test environment variables before importing app
os.environ["DATABASE_URL"] = "postgresql+asyncpg://corenxt_test:test_password@localhost:5432/corenxt_test"
os.environ["REDIS_URL"] = "redis://localhost:6379/0"
os.environ["SECRET_KEY"] = "test_secret_key_for_ci_pipeline_only"
os.environ["ENVIRONMENT"] = "testing"

# Ensure the app module is in the Python path
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent.parent))

@pytest.fixture(scope="session")
def event_loop() -> Generator:
    """Create an instance of the default event loop for the test session."""
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()

@pytest.fixture
async def client():
    """Create an async test client."""
    from httpx import AsyncClient
    from app.main import app
    
    async with AsyncClient(app=app, base_url="http://test") as ac:
        yield ac