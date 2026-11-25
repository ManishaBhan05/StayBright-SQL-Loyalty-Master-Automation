SELECT          LM.MemberID,
                LM.Email,
                LM.FirstName,
                LM.LastName, 
                LM.JoinDate, 
                LM.Status, 
                LM.CurrentTier,
                LM.CurrentPoints, 
                
                /* POINTS,SPENDING AND VISITS */
                ISNULL(T6.Points_6m, 0) AS Points_6m,
                ISNULL(T12.Points_12m, 0) AS Points_12m,
                ISNULL(T6.Spend_6m, 0) AS Spend_6m,
                ISNULL(T12.Spend_12m, 0) AS Spend_12m,
                ISNULL(T6.Visits_6m, 0) AS Visits_6m,
                ISNULL(T12.Visits_12m, 0) AS Visits_12m,
                
                
                /* POINTS NEEDED FOR NEXT TIER */
                CASE
                      WHEN LM.CurrentTier = 'Platinum' THEN 0
                      ELSE TM.MaxPoints + 1 - LM.CurrentPoints
                END AS PointsToNextTier, 
                
                /* LAST TRANSACTION */
                LT.LastTransactionDate, 
                DATEDIFF(D, LT.LastTransactionDate, '2025-10-10') AS DaysSinceLastPurchase, 
                
                /* LAST VISITED PROPERTY */
                LV.PropertyID AS LastVisitedPropertyID, 
                PD.PropertyName AS LastVisitedPropertyName, 
                
                
                /* APP LOGIN AND UPDATE DATE */
                APP.LastAppLoginDate, 
                
                 /* LAST UPDATED */
                 '2025-10-10' AS LastUpdated

FROM            [Loyalty_Members_StayBright] LM

/* LAST 6 MONTHS TRANSACTIONS */
LEFT JOIN     (
                     SELECT     T.MemberID,
                                SUM(PointsEarned) AS Points_6m,
                                SUM(Amount) AS Spend_6m,
                                SUM(CASE
                                            WHEN Channel = 'in_property' THEN 1
                                            ELSE 0
                                    END 
                                    )       AS Visits_6m
                      FROM      [Loyalty_Transactions_StayBright] T
                      WHERE     TransactionDate >= DATEADD(M, -6, '2025-10-10')
                      AND       TransactionDate <= '2025-10-10'
                      GROUP BY  MemberID

                )     AS        T6 
ON                              LM.MemberID = T6.MemberID

/* LAST 12 MONTHS TRANSACTIONS */                  
 LEFT JOIN    (
                     SELECT     T.MemberID,
                                SUM(PointsEarned) AS Points_12m,
                                SUM(Amount) AS Spend_12m,
                                SUM(CASE
                                            WHEN Channel = 'in_property' THEN 1
                                            ELSE 0
                                    END
                                    )       AS Visits_12m
                      FROM      [Loyalty_Transactions_StayBright] T
                      WHERE     TransactionDate >= DATEADD(M, -12, '2025-10-10')
                      AND       TransactionDate <= '2025-10-10'
                      GROUP BY  MemberID

                )     AS        T12 
ON                              LM.MemberID = T12.MemberID     

/* LAST TRANSACTION DATE */
LEFT JOIN     (
                     SELECT     T.MemberID,
                                MAX(T.TransactionDate) AS LastTransactionDate
                     FROM       [Loyalty_Transactions_StayBright] T
                     WHERE      T.TransactionDate <= '2025-10-10'
                     GROUP BY   T.MemberID

                )    AS         LT
ON                              LM.MemberID = LT.MemberID

/* LAST VISITED PROPERTY */   
LEFT JOIN (
                     SELECT      T.MemberID,
                                 T.PropertyID
                     FROM        [Loyalty_Transactions_StayBright] T
                     WHERE       T.Channel = 'in_property'
                     AND         T.TransactionDate <= '2025-10-10'

                     AND NOT EXISTS (
                                             SELECT 1
                                             FROM   [Loyalty_Transactions_StayBright] T2

                     WHERE                   T2.MemberID = T.MemberID
                     AND                     T2.Channel = 'in_property'
                     AND                     T2.TransactionDate <= '2025-10-10'
                     AND              (
                                             T2.TransactionDate > T.TransactionDate
                     OR                  (
                                              T2.TransactionDate = T.TransactionDate
                    AND                       T2.TransactionID > T.TransactionID
                )
            )
      )

)                   AS              LV
ON                                  LM.MemberID = LV.MemberID


/* LAST VISITED PROPERTY NAME */
LEFT JOIN           [Property_Dictionary] PD
ON                  LV.PropertyID = PD.PropertyID

/* LAST APP LOGIN */
LEFT JOIN (
                    SELECT          AE.MemberID,
                                    MAX(AE.EventDate) AS LastAppLoginDate
                    FROM            [App_Events] AE
                    WHERE           AE.EventType = 'app_login'
                    AND             AE.EventDate <= '2025-10-10'
                    GROUP BY        AE.MemberID

           )        AS               APP
ON                                  LM.MemberID = APP.MemberID

/* TIER INFORMATION */
LEFT JOIN                           [Tier_Matrix] TM
ON                                  LM.CurrentTier = TM.TierName
