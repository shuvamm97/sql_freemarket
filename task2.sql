WITH client_live AS (
  -- A client is "closed" only if all of their accounts are closed
  SELECT c.ClientId,
         CASE WHEN COUNT(*) FILTER (WHERE a.AccountStatus <> 'closed') > 0
              THEN 'live' ELSE 'closed' END AS ClientLifecycleStatus,
         c.Vertical
  FROM Client c
  JOIN Account a ON a.ClientId = c.ClientId
  GROUP BY c.ClientId, c.Vertical
),
completed_2024 AS (
  SELECT it.*, da.Rate
  FROM InternalTransfers it
  JOIN Account sa ON sa.AccountId = it.SenderAccountId
  JOIN Client sc ON sc.ClientId = sa.ClientId
  JOIN DailyExchangeRate da
    ON da.FromCurrency = it.Currency
   AND da.ToCurrency   = 'GBP'
   AND da.Date = CAST(it.TransferTime AS date)
  WHERE it.TransferStatus = 'completed'
    AND it.TransferTime >= '2024-01-01'::timestamp
    AND it.TransferTime <  '2025-01-01'::timestamp
),
filtered AS (
  SELECT c2024.*, cl.ClientLifecycleStatus, cl.Vertical
  FROM completed_2024 c2024
  JOIN Account sa ON sa.AccountId = c2024.SenderAccountId
  JOIN Client sc ON sc.ClientId = sa.ClientId
  JOIN client_live cl ON cl.ClientId = sc.ClientId
  WHERE cl.Vertical = 'Gambling'
    AND cl.ClientLifecycleStatus = 'live'
)
SELECT COALESCE(SUM(Amt * Rate), 0) AS total_gbp_normalised_2024
FROM filtered;
