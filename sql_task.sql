-- Account table
CREATE TABLE Account (
    AccountId      VARCHAR(10) PRIMARY KEY,
    AccountName    VARCHAR(100),
    AccountStatus  VARCHAR(20),
    ClientId       VARCHAR(10) REFERENCES Client(ClientId)
);

-- Client table
CREATE TABLE Client (
    ClientId      VARCHAR(10) PRIMARY KEY,
    ClientName    VARCHAR(100),
    Jurisdiction  VARCHAR(50),
    RiskRating    INT,
    Vertical      VARCHAR(50),
    GroupId       VARCHAR(10) REFERENCES "Group"(GroupId)
);

-- Group table
CREATE TABLE "Group" (
    GroupId     VARCHAR(10) PRIMARY KEY,
    GroupName   VARCHAR(100),
    GroupPod    VARCHAR(50)
);

-- InternalTransfers table
CREATE TABLE InternalTransfers (
    SenderAccountId   VARCHAR(10) REFERENCES Account(AccountId),
    ReceiverAccountId VARCHAR(10) REFERENCES Account(AccountId),
    Amt              DECIMAL(18,2),
    Currency         VARCHAR(10),
    TransferStatus   VARCHAR(20),
    TransferTime     TIMESTAMP,
    PRIMARY KEY (SenderAccountId, ReceiverAccountId, TransferTime)
);

-- DailyExchangeRate table
CREATE TABLE DailyExchangeRate (
    FromCurrency VARCHAR(10),
    ToCurrency   VARCHAR(10),
    Rate         DECIMAL(18,6),
    Date         DATE,
    PRIMARY KEY (FromCurrency, ToCurrency, Date)
);
