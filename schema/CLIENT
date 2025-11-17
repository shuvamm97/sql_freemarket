-- Client table
CREATE TABLE Client (
    ClientId      VARCHAR(10) PRIMARY KEY,
    ClientName    VARCHAR(100),
    Jurisdiction  VARCHAR(50),
    RiskRating    INT,
    Vertical      VARCHAR(50),
    GroupId       VARCHAR(10) REFERENCES "Group"(GroupId)
);
