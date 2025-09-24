-- =============================================
-- Multi-Tenant User/Tenant Schema for Email Communications App
-- =============================================

-- =======================
-- Core Entities
-- =======================

CREATE TABLE tenant (
    tenant_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name                VARCHAR(255) NOT NULL,
    legal_name          VARCHAR(255),
    domain              VARCHAR(255) NOT NULL,
    industry_code       VARCHAR(50), -- e.g., NAICS
    ein_or_vat          VARCHAR(50),
    address_line1       VARCHAR(255),
    address_line2       VARCHAR(255),
    city                VARCHAR(100),
    state_province      VARCHAR(100),
    postal_code         VARCHAR(20),
    country             VARCHAR(100),
    support_phone       VARCHAR(50),
    support_email       VARCHAR(255),
    compliance_url      VARCHAR(500), -- privacy policy, etc.
    billing_contact     VARCHAR(255),
    created_at          TIMESTAMP DEFAULT now(),
    updated_at          TIMESTAMP DEFAULT now()
);

CREATE TABLE app_user (
    user_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID NOT NULL REFERENCES tenant(tenant_id) ON DELETE CASCADE,
    email               VARCHAR(255) NOT NULL UNIQUE,
    password_hash       TEXT NOT NULL,
    first_name          VARCHAR(100),
    last_name           VARCHAR(100),
    phone               VARCHAR(50),
    role                VARCHAR(50) NOT NULL DEFAULT 'user', -- e.g., admin, sender, viewer
    timezone            VARCHAR(100),
    language_pref       VARCHAR(20),
    is_active           BOOLEAN DEFAULT TRUE,
    mfa_enabled         BOOLEAN DEFAULT FALSE,
    last_login          TIMESTAMP,
    created_at          TIMESTAMP DEFAULT now(),
    updated_at          TIMESTAMP DEFAULT now()
);

CREATE TABLE role (
    role_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID NOT NULL REFERENCES tenant(tenant_id) ON DELETE CASCADE,
    name                VARCHAR(100) NOT NULL,
    description         TEXT
);

CREATE TABLE user_role (
    user_id             UUID NOT NULL REFERENCES app_user(user_id) ON DELETE CASCADE,
    role_id             UUID NOT NULL REFERENCES role(role_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

-- =======================
-- Communications / Compliance
-- =======================

CREATE TABLE sender_identity (
    sender_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID NOT NULL REFERENCES tenant(tenant_id) ON DELETE CASCADE,
    email_address       VARCHAR(255) NOT NULL,
    display_name        VARCHAR(255),
    is_verified         BOOLEAN DEFAULT FALSE,
    dkim_key            TEXT,
    spf_record          TEXT,
    dmarc_policy        TEXT,
    created_at          TIMESTAMP DEFAULT now()
);

CREATE TABLE user_consent (
    consent_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID NOT NULL REFERENCES tenant(tenant_id) ON DELETE CASCADE,
    user_id             UUID NOT NULL REFERENCES app_user(user_id) ON DELETE CASCADE,
    marketing_opt_in    BOOLEAN DEFAULT FALSE,
    sms_opt_in          BOOLEAN DEFAULT FALSE,
    voice_opt_in        BOOLEAN DEFAULT FALSE,
    consent_date        TIMESTAMP DEFAULT now(),
    withdrawn_date      TIMESTAMP
);

CREATE TABLE tenant_branding (
    branding_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID NOT NULL REFERENCES tenant(tenant_id) ON DELETE CASCADE,
    logo_url            VARCHAR(500),
    color_primary       VARCHAR(20),
    color_secondary     VARCHAR(20),
    footer_text         TEXT,
    unsubscribe_url     VARCHAR(500)
);

-- =======================
-- Billing / Subscription
-- =======================

CREATE TABLE subscription_plan (
    plan_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name                VARCHAR(100) NOT NULL,
    description         TEXT,
    monthly_price       NUMERIC(10,2) NOT NULL,
    email_quota         INT, -- emails allowed per month
    sms_quota           INT, -- SMS allowed per month
    voice_quota         INT, -- Voice minutes allowed
    created_at          TIMESTAMP DEFAULT now(),
    updated_at          TIMESTAMP DEFAULT now()
);

CREATE TABLE tenant_subscription (
    subscription_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID NOT NULL REFERENCES tenant(tenant_id) ON DELETE CASCADE,
    plan_id             UUID NOT NULL REFERENCES subscription_plan(plan_id),
    start_date          DATE NOT NULL,
    end_date            DATE,
    is_active           BOOLEAN DEFAULT TRUE,
    created_at          TIMESTAMP DEFAULT now(),
    updated_at          TIMESTAMP DEFAULT now()
);

CREATE TABLE invoice (
    invoice_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID NOT NULL REFERENCES tenant(tenant_id) ON DELETE CASCADE,
    subscription_id     UUID NOT NULL REFERENCES tenant_subscription(subscription_id),
    amount              NUMERIC(10,2) NOT NULL,
    due_date            DATE NOT NULL,
    paid_date           DATE,
    status              VARCHAR(50) DEFAULT 'unpaid', -- unpaid, paid, overdue
    created_at          TIMESTAMP DEFAULT now()
);

CREATE TABLE usage_log (
    usage_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id           UUID NOT NULL REFERENCES tenant(tenant_id) ON DELETE CASCADE,
    date                DATE NOT NULL,
    emails_sent         INT DEFAULT 0,
    sms_sent            INT DEFAULT 0,
    voice_minutes       INT DEFAULT 0,
    created_at          TIMESTAMP DEFAULT now()
);
