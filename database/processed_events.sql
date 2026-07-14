-- =====================================================
-- Processed Events Table
-- Prevents duplicate message processing
-- =====================================================

CREATE TABLE IF NOT EXISTS processed_events (

    event_id UUID PRIMARY KEY,

    processed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP

);

-- =====================================================
-- Audit Log Table
-- Consumer writes successful events here
-- =====================================================

CREATE TABLE IF NOT EXISTS audit_log (

    id BIGSERIAL PRIMARY KEY,

    account_id INTEGER NOT NULL,

    event_type VARCHAR(100) NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP

);

-- =====================================================
-- Optional Indexes
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_audit_account
ON audit_log(account_id);

CREATE INDEX IF NOT EXISTS idx_audit_created
ON audit_log(created_at);
