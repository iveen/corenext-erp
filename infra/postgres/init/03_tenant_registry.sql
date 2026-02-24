-- Ensure public schema is clean
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO corenxt_app;

-- Create Tenant Registry Table
-- This table lives in 'public' and maps tenant IDs to their specific schemas
CREATE TABLE public.tenants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_name VARCHAR(255) NOT NULL,
    schema_name VARCHAR(63) NOT NULL UNIQUE,
    status VARCHAR(20) DEFAULT 'active', -- active, suspended, deleted
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for quick lookup during middleware authentication
CREATE INDEX idx_tenants_schema ON public.tenants(schema_name);
CREATE INDEX idx_tenants_status ON public.tenants(status);

-- Grant access to registry (App needs to read this to set search_path)
GRANT SELECT ON public.tenants TO corenxt_read;
GRANT SELECT, INSERT, UPDATE ON public.tenants TO corenxt_write;
