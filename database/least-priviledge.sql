CREATE ROLE bank_owner LOGIN PASSWORD 'owner_password';

CREATE ROLE bank_app LOGIN PASSWORD 'bank_password';

GRANT CONNECT ON DATABASE bankdb TO bank_app;

GRANT USAGE ON SCHEMA public TO bank_app;

GRANT SELECT,INSERT,UPDATE

ON TABLE accounts

TO bank_app;
