WITH LiveClients AS (
  SELECT c.ClientId
  FROM Client c
  JOIN Account a ON c.ClientId = a.ClientId
  GROUP BY c.ClientId
  HAVING SUM(CASE WHEN a.AccountStatus = 'live' THEN 1 ELSE 0 END) > 0
),
TransfersWithGBP AS (
  SELECT it.*, der.Rate,
         it.Amt * der.Rate AS GbpAmount,
         sa.ClientId AS SenderClientId
  FROM InternalTransfers it
  JOIN Account sa ON it.SenderAccountId = sa.AccountId
  JOIN Client sc ON sa.ClientId = sc.ClientId
  JOIN DailyExchangeRate der
    ON it.Currency = der.FromCurrency
   AND DATE(it.TransferTime) = der.Date
  WHERE it.TransferStatus = 'completed'
    AND EXTRACT(YEAR FROM it.TransferTime) = 2024
    AND sc.Vertical = 'Gambling'
    AND sc.ClientId IN (SELECT ClientId FROM LiveClients)
)
SELECT SUM(GbpAmount) AS TotalGbpTransfers
FROM TransfersWithGBP;
