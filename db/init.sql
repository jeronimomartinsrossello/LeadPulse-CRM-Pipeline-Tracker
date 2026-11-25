CREATE TABLE if NOT EXISTS companies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    industry VARCHAR(100),
    website VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_companies_name UNIQUE (name)
  );

CREATE TABLE if NOT EXISTS leads(
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES companies(id) ON DELETE RESTRICT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    role_title VARCHAR(100),
    status VARCHAR(100) NOT NULL DEFAULT 'NEW',
    estimated_value NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_leads_email UNIQUE (email),
    CONSTRAINT chk_leads_status CHECK (status IN ('NEW', 'CONTACTED', 'QUALIFIED', 'PROPOSAL',
    'WON', 'LOST')),
    CONSTRAINT chk_leads_value CHECK(estimated_value >= 0)
);

CREATE TABLE if NOT EXISTS interactions (
    id SERIAL PRIMARY KEY,
    lead_id INTEGER NOT NULL REFERENCES leads(id) ON DELETE CASCADE,
    channel VARCHAR(30) NOT NULL,
    summary TEXT NOT NULL,
    occurred_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_interactions_channel CHECK(
        channel IN ('CALL', 'EMAIL','MEETING','DEMO','NOTE')
    )
);
 
CREATE INDEX IF NOT EXISTS idx_leads_status ON leads(status);
CREATE INDEX IF NOT EXISTS idx_leads_company_id ON leads(company_id);
CREATE INDEX IF NOT EXISTS idx_interactions_lead_id ON interactions(lead_id);
