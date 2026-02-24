-- Function to create a new tenant schema and base tables
CREATE OR REPLACE FUNCTION public.create_tenant_schema(t_name VARCHAR, t_schema VARCHAR)
RETURNS UUID AS $$
DECLARE
    new_tenant_id UUID;
BEGIN
    -- 1. Create the isolated schema
    EXECUTE format('CREATE SCHEMA IF NOT EXISTS %I', t_schema);

    -- 2. Grant permissions to app roles
    EXECUTE format('GRANT USAGE ON SCHEMA %I TO corenxt_app', t_schema);
    EXECUTE format('GRANT ALL ON ALL TABLES IN SCHEMA %I TO corenxt_app', t_schema);
    EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT ALL ON TABLES TO corenxt_app', t_schema);

    -- 3. Create Base RBAC & Multi-Company Tables inside the new schema
    -- These tables enforce SOW Section 2.1 (Multi-Company isolation within tenancy)
    EXECUTE format('
        CREATE TABLE %I.companies (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            name VARCHAR(255) NOT NULL,
            currency CHAR(3) DEFAULT ''USD'',
            created_at TIMESTAMPTZ DEFAULT NOW()
        );

        CREATE TABLE %I.roles (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            name VARCHAR(50) NOT NULL, -- e.g., Admin, Accountant, Viewer
            permissions JSONB DEFAULT ''[]''::jsonb,
            company_id UUID REFERENCES %I.companies(id) ON DELETE CASCADE
        );

        CREATE TABLE %I.users (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            email VARCHAR(255) NOT NULL UNIQUE,
            password_hash VARCHAR(255) NOT NULL,
            is_active BOOLEAN DEFAULT TRUE,
            created_at TIMESTAMPTZ DEFAULT NOW()
        );

        CREATE TABLE %I.user_roles (
            user_id UUID REFERENCES %I.users(id) ON DELETE CASCADE,
            role_id UUID REFERENCES %I.roles(id) ON DELETE CASCADE,
            company_id UUID REFERENCES %I.companies(id) ON DELETE CASCADE,
            PRIMARY KEY (user_id, role_id, company_id)
        );
    ', t_schema, t_schema, t_schema, t_schema, t_schema, t_schema);

    -- 4. Register tenant in public registry
    INSERT INTO public.tenants (tenant_name, schema_name)
    VALUES (t_name, t_schema)
    RETURNING id INTO new_tenant_id;

    RETURN new_tenant_id;
END;
$$ LANGUAGE plpgsql;

-- Grant execution rights to admin role only
GRANT EXECUTE ON FUNCTION public.create_tenant_schema TO corenxt_admin;
