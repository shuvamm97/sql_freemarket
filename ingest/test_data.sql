-- ===========================
-- Seed Data for Raw Tables
-- ===========================

-- Group table
INSERT INTO "Group" (GroupId, GroupName, GroupPod) VALUES
('G001', 'Group Alpha', 'PodA'),
('G002', 'Group Beta',  'PodB'),
('G003', 'Group Gamma', 'PodA');

-- Client table
INSERT INTO Client (ClientId, ClientName, Jurisdiction, RiskRating, Vertical, GroupId) VALUES
('C001', 'Alice Ltd', 'UK',    2, 'Gambling',   'G001'),
('C002', 'Bob Inc',   'Malta', 3, 'E-Commerce', 'G002'),
('C003', 'Carol LLC', 'UK',    4, 'Gambling',   'G003');

-- Account table
INSERT INTO Account (AccountId, AccountName, AccountStatus, ClientId) VALUES
('A1001', 'Wallet1', 'live',   'C001'),
('A1002', 'Wallet2', 'closed', 'C002'),
('A1003', 'Wallet3', 'live',   'C003');

-- InternalTransfers table
INSERT INTO InternalTransfers (SenderAccountId, ReceiverAccountId, Amt, Currency, TransferStatus, TransferTime) VALUES
('A1001', 'A1002', 500, 'USD', 'completed', '2025-01-20 10:00:00'),
('A1001', 'A1003', 800, 'EUR', 'completed', '2025-02-15 12:30:00'),
('A1002', 'A1001', 300, 'GBP', 'failed',    '2025-01-25 14:00:00');

-- DailyExchangeRate table
INSERT INTO DailyExchangeRate (FromCurrency, ToCurrency, Rate, Date) VALUES
('USD', 'GBP', 0.78, '2025-01-20'),
('EUR', 'GBP', 0.85, '2025-02-15'),
('GBP', 'GBP', 1.00, '2025-01-25');
