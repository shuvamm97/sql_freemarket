WITH Transfers AS (
  SELECT it.TransferTime::date AS TransferDate,
         it.Amt,
         sc.Vertical
  FROM InternalTransfers it
  JOIN Account sa ON it.SenderAccountId = sa.AccountId
  JOIN Client sc ON sa.ClientId = sc.ClientId
  WHERE it.TransferStatus = 'completed'
    AND it.TransferTime >= CURRENT_DATE - INTERVAL '6 months'
),
DailySums AS (
  SELECT TransferDate, Vertical, SUM(Amt) AS DailyAmt
  FROM Transfers
  GROUP BY TransferDate, Vertical
),
MovingAvg AS (
  SELECT ds.TransferDate,
         ds.Vertical,
         AVG(ds2.DailyAmt) AS MovingAvg7Day
  FROM DailySums ds
  JOIN DailySums ds2
    ON ds2.Vertical = ds.Vertical
   AND ds2.TransferDate BETWEEN ds.TransferDate - INTERVAL '6 days' AND ds.TransferDate
  GROUP BY ds.TransferDate, ds.Vertical
)
SELECT * FROM MovingAvg
ORDER BY Vertical, TransferDate;
