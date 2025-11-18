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
