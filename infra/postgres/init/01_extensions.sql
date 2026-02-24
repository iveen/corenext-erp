-- Enable essential extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- For high-performance text search
CREATE EXTENSION IF NOT EXISTS "btree_gin"; -- For composite indexing

-- Comment: SOW Section 6.2 (Performance)
-- pg_trgm and btree_gin help achieve <250ms response times on large datasets
