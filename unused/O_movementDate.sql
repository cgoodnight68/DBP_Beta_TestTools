DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT  
	  I.[O_Life1_Full_Name]
	, C.[O_Movement_Date]
	, C.[O_Movement_Transaction_Type]
	, A.[C_First_Payment_Date]
	, A.[C_Payment_Status_Date]
	, DL.[ReportPeriodEndingDate]
	, CASE 
		WHEN C.[O_Movement_Transaction_Type] = 'INST' THEN DL.ReportPeriodEndingDate 
		WHEN C.[O_Movement_Transaction_Type] = 'NEWBU' THEN  A.[C_First_Payment_Date]
		WHEN C.[O_Movement_Transaction_Type] = 'REFUND' THEN DL.ReportPeriodEndingDate 
		WHEN C.[O_Movement_Transaction_Type] = 'SUSP' THEN A.[C_Payment_Status_Date]
		WHEN C.[O_Movement_Transaction_Type] = 'UNSUS' THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, DL.ReportPeriodEndingDate), 0)
		WHEN C.[O_Movement_Transaction_Type] = 'DEATH' THEN A.[C_Cease_Date]
		WHEN C.[O_Movement_Transaction_Type] = 'CEASE' THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, DL.ReportPeriodEndingDate), 0) 
		WHEN C.[O_Movement_Transaction_Type] = '' OR C.[O_Movement_Transaction_Type] = 'ERR' THEN ''
		ELSE '1753-01-01' END Spock_Says_Logic_Clearly_Dictates
	, CASE WHEN
		 CASE 
			WHEN C.[O_Movement_Transaction_Type] = 'INST' THEN DL.ReportPeriodEndingDate 
			WHEN C.[O_Movement_Transaction_Type] = 'NEWBU' THEN  A.[C_First_Payment_Date]
			WHEN C.[O_Movement_Transaction_Type] = 'REFUND' THEN DL.ReportPeriodEndingDate 
			WHEN C.[O_Movement_Transaction_Type] = 'SUSP' THEN A.[C_Payment_Status_Date]
			WHEN C.[O_Movement_Transaction_Type] = 'UNSUS' THEN  DATEADD(MONTH, DATEDIFF(MONTH, 0, DL.ReportPeriodEndingDate), 0) 
			WHEN C.[O_Movement_Transaction_Type] = 'DEATH' THEN A.[C_Cease_Date]
			WHEN C.[O_Movement_Transaction_Type] = 'CEASE' THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, DL.ReportPeriodEndingDate), 0)
			WHEN C.[O_Movement_Transaction_Type] = '' OR C.[O_Movement_Transaction_Type] = 'ERR' THEN ''
			ELSE '1753-01-01' END = C.[O_Movement_Date] THEN 'PASS' ELSE 'FAIL' END [PASS_FAIL]
FROM
	[CDS2].[dbo].[Correlation] cc
	INNER JOIN [CDS2].[dbo].[Component] c ON c.[FKPolicyId] = cc.[Cds2ClientRecordId]
	INNER JOIN [CDS2].[dbo].[Insured] i ON i.[InsuredId] = c.[FKInsuredId]
	INNER JOIN [CDS2].[dbo].[Policy] p ON p.[PolicyId] = c.[FKPolicyId] AND p.[FKLogID] = c.[FKLogId]
	INNER JOIN [CDS2].[dbo].[Datalog] DL ON C.[FKLogId] = DL.[LogID]
	INNER JOIN [RcDb].[dbo].[AnnuityClientData] a ON a.[AnnuityClientDataId] = cc.[RcdbClientRecordId]
	INNER JOIN [RcDb].[dbo].[AnnuityEscalationData] aed ON a.[AnnuityClientDataId] = aed.[FK_AnnuityClientDataId]
WHERE cc.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 543)
) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Current_Reinsured_Periodic_Annuity
	, CASE
		WHEN O_Component_Status = 'A' AND O_Life1_Survivor_Indicator = 'Y' THEN O_Current_Gross_Amt_Component
		WHEN O_Component_Status <> 'A' THEN '0'
		ELSE null 
	  END LogicTest
	, CASE
		WHEN
			CASE
				WHEN O_Component_Status = 'A' AND O_Life1_Survivor_Indicator = 'Y' THEN O_Current_Gross_Amt_Component
				WHEN O_Component_Status <> 'A' THEN '0'
			END = O_Current_Reinsured_Periodic_Annuity OR (
			CASE
				WHEN O_Component_Status = 'A' AND O_Life1_Survivor_Indicator = 'Y' THEN O_Current_Gross_Amt_Component
				WHEN O_Component_Status <> 'A' THEN '0'
				ELSE NULL 
			END IS NULL AND
			O_Current_Reinsured_Periodic_Annuity IS NULL)
		THEN 'PASS'
		ELSE 'FAIL'
	END PASS_FAIL
FROM
	[CDS2].[dbo].[Correlation] c
	INNER JOIN [CDS2].[dbo].[Component] d ON d.[FKPolicyId] = c.[Cds2ClientRecordId]
	INNER JOIN [CDS2].[dbo].[Insured] i ON i.[InsuredId] = d.[FKInsuredId]
	INNER JOIN [CDS2].[dbo].[Policy] b ON b.[PolicyId]    = d.[FKPolicyId] AND b.[FKLogID] = d.[FKLogId]
	INNER JOIN [RcDb].[dbo].[AnnuityClientData] a ON a.[AnnuityClientDataId] = c.[RcdbClientRecordId]
	INNER JOIN [RcDb].[dbo].[AnnuityEscalationData] aed ON a.[AnnuityClientDataId] = aed.[FK_AnnuityClientDataId]
	INNER JOIN [CDS2].[dbo].[Datalog] dl ON d.[FKLogId] = dl.[LogID]
WHERE
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 544)
) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT  
	  I.[O_Life1_Full_Name]
	, C.[O_Movement_Date]
	, C.[O_Movement_Transaction_Type]
	, A.[C_First_Payment_Date]
	, A.[C_Payment_Status_Date]
	, DL.[ReportPeriodEndingDate]
	, ISNULL(CONVERT(VARCHAR(10),CASE 
		WHEN C.[O_Movement_Transaction_Type] = 'INST' THEN DL.ReportPeriodEndingDate 
		WHEN C.[O_Movement_Transaction_Type] = 'NEWBU' THEN  A.[C_First_Payment_Date]
		WHEN C.[O_Movement_Transaction_Type] = 'REFUND' THEN DL.ReportPeriodEndingDate 
		WHEN C.[O_Movement_Transaction_Type] = 'SUSP' THEN A.[C_Payment_Status_Date]
		WHEN C.[O_Movement_Transaction_Type] = 'UNSUS' THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, DL.ReportPeriodEndingDate), 0)
		WHEN C.[O_Movement_Transaction_Type] = 'DEATH' THEN A.[C_Cease_Date]
		WHEN C.[O_Movement_Transaction_Type] = 'CEASE' THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, DL.ReportPeriodEndingDate), 0) 
		WHEN C.[O_Movement_Transaction_Type] = '' OR C.[O_Movement_Transaction_Type] = 'ERR' THEN ''
		ELSE NULL END,103),'') Spock_Says_Logic_Clearly_Dictates
	, CASE WHEN
		 ISNULL(CONVERT(VARCHAR(10),CASE 
			WHEN C.[O_Movement_Transaction_Type] = 'INST' THEN DL.ReportPeriodEndingDate 
			WHEN C.[O_Movement_Transaction_Type] = 'NEWBU' THEN  A.[C_First_Payment_Date]
			WHEN C.[O_Movement_Transaction_Type] = 'REFUND' THEN DL.ReportPeriodEndingDate 
			WHEN C.[O_Movement_Transaction_Type] = 'SUSP' THEN A.[C_Payment_Status_Date]
			WHEN C.[O_Movement_Transaction_Type] = 'UNSUS' THEN  DATEADD(MONTH, DATEDIFF(MONTH, 0, DL.ReportPeriodEndingDate), 0) 
			WHEN C.[O_Movement_Transaction_Type] = 'DEATH' THEN A.[C_Cease_Date]
			WHEN C.[O_Movement_Transaction_Type] = 'CEASE' THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, DL.ReportPeriodEndingDate), 0)
			WHEN C.[O_Movement_Transaction_Type] = '' OR C.[O_Movement_Transaction_Type] = 'ERR' THEN ''
			ELSE NULL END,103),'') IN (C.[O_Movement_Date], CASE WHEN C.[O_Movement_Date] = '' THEN '01/01/1900' ELSE C.[O_Movement_Date] END) THEN 'PASS' ELSE 'FAIL' END [PASS_FAIL]
FROM
	[CDS2].[dbo].[Correlation] cc
	INNER JOIN [CDS2].[dbo].[Component] c ON c.[FKPolicyId] = cc.[Cds2ClientRecordId]
	INNER JOIN [CDS2].[dbo].[Insured] i ON i.[InsuredId] = c.[FKInsuredId]
	INNER JOIN [CDS2].[dbo].[Policy] p ON p.[PolicyId] = c.[FKPolicyId] AND p.[FKLogID] = c.[FKLogId]
	INNER JOIN [CDS2].[dbo].[Datalog] DL ON C.[FKLogId] = DL.[LogID]
	INNER JOIN [RcDb].[dbo].[AnnuityClientData] a ON a.[AnnuityClientDataId] = cc.[RcdbClientRecordId]
	INNER JOIN [RcDb].[dbo].[AnnuityEscalationData] aed ON a.[AnnuityClientDataId] = aed.[FK_AnnuityClientDataId]
WHERE cc.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 544)
) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Current_Reinsured_Periodic_Annuity
	, CASE
		WHEN O_Component_Status = 'A' AND O_Life1_Survivor_Indicator = 'Y' THEN O_Current_Gross_Amt_Component
		WHEN O_Component_Status <> 'A' THEN '0'
		ELSE null 
	  END LogicTest
	, CASE
		WHEN
			CASE
				WHEN O_Component_Status = 'A' AND O_Life1_Survivor_Indicator = 'Y' THEN O_Current_Gross_Amt_Component
				WHEN O_Component_Status <> 'A' THEN '0'
			END = O_Current_Reinsured_Periodic_Annuity OR (
			CASE
				WHEN O_Component_Status = 'A' AND O_Life1_Survivor_Indicator = 'Y' THEN O_Current_Gross_Amt_Component
				WHEN O_Component_Status <> 'A' THEN '0'
				ELSE NULL 
			END IS NULL AND
			O_Current_Reinsured_Periodic_Annuity IS NULL)
		THEN 'PASS'
		ELSE 'FAIL'
	END PASS_FAIL
FROM
	[CDS2].[dbo].[Correlation] c
	INNER JOIN [CDS2].[dbo].[Component] d ON d.[FKPolicyId] = c.[Cds2ClientRecordId]
	INNER JOIN [CDS2].[dbo].[Insured] i ON i.[InsuredId] = d.[FKInsuredId]
	INNER JOIN [CDS2].[dbo].[Policy] b ON b.[PolicyId]    = d.[FKPolicyId] AND b.[FKLogID] = d.[FKLogId]
	INNER JOIN [RcDb].[dbo].[AnnuityClientData] a ON a.[AnnuityClientDataId] = c.[RcdbClientRecordId]
	INNER JOIN [RcDb].[dbo].[AnnuityEscalationData] aed ON a.[AnnuityClientDataId] = aed.[FK_AnnuityClientDataId]
	INNER JOIN [CDS2].[dbo].[Datalog] dl ON d.[FKLogId] = dl.[LogID]
WHERE
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 545)
) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT  
	  I.[O_Life1_Full_Name]
	, C.[O_Movement_Date]
	, C.[O_Movement_Transaction_Type]
	, A.[C_First_Payment_Date]
	, A.[C_Payment_Status_Date]
	, DL.[ReportPeriodEndingDate]
	, ISNULL(CONVERT(VARCHAR(10),CASE 
		WHEN C.[O_Movement_Transaction_Type] = 'INST' THEN DL.ReportPeriodEndingDate 
		WHEN C.[O_Movement_Transaction_Type] = 'NEWBU' THEN  A.[C_First_Payment_Date]
		WHEN C.[O_Movement_Transaction_Type] = 'REFUND' THEN DL.ReportPeriodEndingDate 
		WHEN C.[O_Movement_Transaction_Type] = 'SUSP' THEN A.[C_Payment_Status_Date]
		WHEN C.[O_Movement_Transaction_Type] = 'UNSUS' THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, DL.ReportPeriodEndingDate), 0)
		WHEN C.[O_Movement_Transaction_Type] = 'DEATH' THEN A.[C_Cease_Date]
		WHEN C.[O_Movement_Transaction_Type] = 'CEASE' THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, DL.ReportPeriodEndingDate), 0) 
		WHEN C.[O_Movement_Transaction_Type] = '' OR C.[O_Movement_Transaction_Type] = 'ERR' THEN ''
		ELSE NULL END,103),'') Spock_Says_Logic_Clearly_Dictates
	, CASE WHEN
		 ISNULL(CONVERT(VARCHAR(10),CASE 
			WHEN C.[O_Movement_Transaction_Type] = 'INST' THEN DL.ReportPeriodEndingDate 
			WHEN C.[O_Movement_Transaction_Type] = 'NEWBU' THEN  A.[C_First_Payment_Date]
			WHEN C.[O_Movement_Transaction_Type] = 'REFUND' THEN DL.ReportPeriodEndingDate 
			WHEN C.[O_Movement_Transaction_Type] = 'SUSP' THEN A.[C_Payment_Status_Date]
			WHEN C.[O_Movement_Transaction_Type] = 'UNSUS' THEN  DATEADD(MONTH, DATEDIFF(MONTH, 0, DL.ReportPeriodEndingDate), 0) 
			WHEN C.[O_Movement_Transaction_Type] = 'DEATH' THEN A.[C_Cease_Date]
			WHEN C.[O_Movement_Transaction_Type] = 'CEASE' THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, DL.ReportPeriodEndingDate), 0)
			WHEN C.[O_Movement_Transaction_Type] = '' OR C.[O_Movement_Transaction_Type] = 'ERR' THEN ''
			ELSE NULL END,103),'') IN (C.[O_Movement_Date], CASE WHEN C.[O_Movement_Date] = '' THEN '01/01/1900' ELSE C.[O_Movement_Date] END) THEN 'PASS' ELSE 'FAIL' END [PASS_FAIL]
FROM
	[CDS2].[dbo].[Correlation] cc
	INNER JOIN [CDS2].[dbo].[Component] c ON c.[FKPolicyId] = cc.[Cds2ClientRecordId]
	INNER JOIN [CDS2].[dbo].[Insured] i ON i.[InsuredId] = c.[FKInsuredId]
	INNER JOIN [CDS2].[dbo].[Policy] p ON p.[PolicyId] = c.[FKPolicyId] AND p.[FKLogID] = c.[FKLogId]
	INNER JOIN [CDS2].[dbo].[Datalog] DL ON C.[FKLogId] = DL.[LogID]
	INNER JOIN [RcDb].[dbo].[AnnuityClientData] a ON a.[AnnuityClientDataId] = cc.[RcdbClientRecordId]
	INNER JOIN [RcDb].[dbo].[AnnuityEscalationData] aed ON a.[AnnuityClientDataId] = aed.[FK_AnnuityClientDataId]
WHERE cc.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 545)
) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
