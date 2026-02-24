-- Create application roles (No login, just permissions)
CREATE ROLE corenxt_read;
CREATE ROLE corenxt_write;
CREATE ROLE corenxt_admin;

-- Create the main application user
-- NOTE: In production, manage this password via Secrets Manager, not hardcoded
DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'corenxt_app') THEN
      CREATE ROLE corenxt_app WITH LOGIN PASSWORD 'CHANGE_ME_IN_PROD';
   END IF;
END
$$;

-- Grant role inheritance
GRANT corenxt_read TO corenxt_app;
GRANT corenxt_write TO corenxt_app;
GRANT corenxt_admin TO corenxt_app;
