CREATE TABLE accounts(

id SERIAL PRIMARY KEY,

name VARCHAR(100),

balance NUMERIC,

currency VARCHAR(3)

);

INSERT INTO accounts(name,balance,currency)

VALUES

('John Doe',1500.25,'USD');
