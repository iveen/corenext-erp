-- Prevent public access to information_schema about other schemas
REVOKE ALL ON ALL TABLES IN SCHEMA information_schema FROM PUBLIC;
GRANT SELECT ON ALL TABLES IN SCHEMA information_schema TO corenxt_app;

-- Ensure future tables in public schema are not writable by app (only registry is)
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM corenxt_write;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO corenxt_read;

-- Comment: SOW Section 3 (Isolation Verification)
-- These policies ensure that even if the app user is compromised, 
-- they cannot drop schemas or access system catalogs excessively.
-- Actual data isolation is enforced by the Application Middleware setting search_path.
