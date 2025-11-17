WITH acct AS (
  SELECT a.AccountId, c.ClientId, c.Vertical, g.GroupPod
  FROM Account a
  JOIN Client c ON a.ClientId = c.ClientId
  JOIN "Group" g ON c.GroupId = g.GroupId
),
q1 AS (
  SELECT it.*, sa.GroupPod AS SenderPod, ra.GroupPod AS ReceiverPod
  FROM InternalTransfers it
  JOIN acct sa ON it.SenderAccountId = sa.AccountId
  JOIN acct ra ON it.ReceiverAccountId = ra.AccountId
  WHERE it.TransferStatus = 'completed'
    AND it.TransferTime >= '2025-01-01'::timestamp
    AND it.TransferTime <  '2025-04-01'::timestamp
)
SELECT SenderAccountId, ReceiverAccountId, Amt, Currency, TransferStatus, TransferTime
FROM q1
WHERE SenderPod <> ReceiverPod
ORDER BY TransferTime;
