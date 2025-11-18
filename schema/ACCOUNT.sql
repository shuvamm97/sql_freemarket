-- Account table
CREATE TABLE Account (
    AccountId      VARCHAR(10) PRIMARY KEY,
    AccountName    VARCHAR(100),
    AccountStatus  VARCHAR(20),
    ClientId       VARCHAR(10) REFERENCES Client(ClientId)
);
