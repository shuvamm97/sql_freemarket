WITH sender_vertical AS (
  SELECT it.*,
         sc.Vertical AS SenderVertical
  FROM InternalTransfers it
  JOIN Account sa ON sa.AccountId = it.SenderAccountId
  JOIN Client sc ON sc.ClientId = sa.ClientId
  WHERE it.TransferStatus = 'completed'
    AND it.TransferTime >= (date_trunc('day', now()) - INTERVAL '6 months')
    AND it.TransferTime <  (date_trunc('day', now()) + INTERVAL '1 day')
),
daily_totals AS (
  SELECT
    CAST(TransferTime AS date) AS transfer_date,
    SenderVertical,
    SUM(Amt) AS daily_amt
  FROM sender_vertical
  GROUP BY CAST(TransferTime AS date), SenderVertical
),
calendar AS (
  -- Build a date series for continuity across the 6-month window
  SELECT generate_series(
           date_trunc('day', now())::date - INTERVAL '6 months',
           (date_trunc('day', now())::date),
           INTERVAL '1 day'
         )::date AS d
),
verticals AS (
  SELECT DISTINCT SenderVertical FROM sender_vertical
),
date_vertical_grid AS (
  SELECT c.d AS transfer_date, v.SenderVertical
  FROM calendar c CROSS JOIN verticals v
),
filled AS (
  SELECT g.transfer_date,
         g.SenderVertical,
         COALESCE(dt.daily_amt, 0) AS daily_amt
  FROM date_vertical_grid g
  LEFT JOIN daily_totals dt
    ON dt.transfer_date = g.transfer_date
   AND dt.SenderVertical = g.SenderVertical
)
SELECT
  SenderVertical,
  transfer_date,
  AVG(daily_amt) OVER (
    PARTITION BY SenderVertical
    ORDER BY transfer_date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) AS moving_avg_7d
FROM filled
ORDER BY SenderVertical, transfer_date;
