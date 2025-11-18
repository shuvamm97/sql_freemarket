SELECT it.*
FROM InternalTransfers it
JOIN Account sa ON it.SenderAccountId = sa.AccountId
JOIN Client sc ON sa.ClientId = sc.ClientId
JOIN Group sg ON sc.GroupId = sg.GroupId
JOIN Account ra ON it.ReceiverAccountId = ra.AccountId
JOIN Client rc ON ra.ClientId = rc.ClientId
JOIN Group rg ON rc.GroupId = rg.GroupId
WHERE it.TransferStatus = 'completed'
  AND it.TransferTime >= '2025-01-01' AND it.TransferTime < '2025-04-01'
  AND sg.GroupPod <> rg.GroupPod;
