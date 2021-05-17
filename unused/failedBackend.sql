DECLARE @FailOnlyInd INT = 1; 
 
WITH cte2 AS (
	SELECT ReportingPeriodLogId, wfs.Status, rpl.EventStatusId,
	(select COUNT(*) from cds2.dbo.insured where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Insured_Count,
	(select COUNT(*) FROM cds2.dbo.policy where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Policy_Count,
	(select COUNT(*) from cds2.dbo.component where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Component_Count,
	(select COUNT(DISTINCT cds2logid) from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) AS CDS2_Correlation_Count,
	(select COUNT(*) from rcdb.dbo.annuityclientdata where fklogid = rpl.RcdbClientLogId) AS RcDB_ACD_Count,
	(select COUNT(*) from rcdb.dbo.AnnuityEscalationData AED JOIN rcdb.dbo.AnnuityClientData ACD ON ACD.AnnuityClientDataId = AED.FK_AnnuityClientDataId Where ACD.fklogid = rpl.RcdbClientLogId) AS RcDB_AED_Count,
	(select COUNT(DISTINCT cs.FK_OutputCompanyId)
		from 
			Zenith.dbo.ClientFile cf 
			JOIN Zenith.dbo.OutputCompanyCriteriaClientFileLink OCCCFL ON OCCCFL.ClientFileId = cf.ClientFileId
			JOIN Zenith.dbo.OutputCompanyCriteria OCC ON OCC.OutputCompanyCriteriaId = OCCCFL.OutputCompanyCriteriaId
			JOIN Zenith.dbo.CompanySplit cs on cs.CriteriaId = occ.OutputCompanyCriteriaId 
		WHERE cf.clientfileid = rpl.ClientFileId) AS CedentCount
	FROM Zenith.dbo.ReportingPeriodLog rpl JOIN Zenith.dbo.WorkflowStatus wfs ON rpl.WorkflowStatusId = wfs.WorkFlowStatusId
	WHERE rpl.ReportingPeriodLogId = 546
), cte AS(
	SELECT *,
	CASE WHEN 
		[Status] = 'Ready for Review' AND 
		EventStatusId IS NULL AND 
		CDS2_Insured_Count = RcDB_ACD_Count AND
		CDS2_Policy_Count = RcDB_ACD_Count AND
		CedentCount = CDS2_Correlation_Count AND
		CDS2_Component_Count >= RcDB_ACD_Count
		THEN 'PASS' ELSE 'FAIL' END AS PASS_FAIL
	FROM cte2
)
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte2 AS (
	SELECT ReportingPeriodLogId, wfs.Status, rpl.EventStatusId,
	(select COUNT(*) from cds2.dbo.insured where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Insured_Count,
	(select COUNT(*) FROM cds2.dbo.policy where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Policy_Count,
	(select COUNT(*) from cds2.dbo.component where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Component_Count,
	(select COUNT(DISTINCT cds2logid) from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) AS CDS2_Correlation_Count,
	(select COUNT(*) from rcdb.dbo.annuityclientdata where fklogid = rpl.RcdbClientLogId) AS RcDB_ACD_Count,
	(select COUNT(*) from rcdb.dbo.AnnuityEscalationData AED JOIN rcdb.dbo.AnnuityClientData ACD ON ACD.AnnuityClientDataId = AED.FK_AnnuityClientDataId Where ACD.fklogid = rpl.RcdbClientLogId) AS RcDB_AED_Count,
	(select COUNT(DISTINCT cs.FK_OutputCompanyId)
		from 
			Zenith.dbo.ClientFile cf 
			JOIN Zenith.dbo.OutputCompanyCriteriaClientFileLink OCCCFL ON OCCCFL.ClientFileId = cf.ClientFileId
			JOIN Zenith.dbo.OutputCompanyCriteria OCC ON OCC.OutputCompanyCriteriaId = OCCCFL.OutputCompanyCriteriaId
			JOIN Zenith.dbo.CompanySplit cs on cs.CriteriaId = occ.OutputCompanyCriteriaId 
		WHERE cf.clientfileid = rpl.ClientFileId) AS CedentCount
	FROM Zenith.dbo.ReportingPeriodLog rpl JOIN Zenith.dbo.WorkflowStatus wfs ON rpl.WorkflowStatusId = wfs.WorkFlowStatusId
	WHERE rpl.ReportingPeriodLogId = 546
), cte AS(
	SELECT *,
	CASE WHEN 
		[Status] = 'Ready for Review' AND 
		EventStatusId IS NULL AND 
		CDS2_Insured_Count = RcDB_ACD_Count AND
		CDS2_Policy_Count = RcDB_ACD_Count AND
		CedentCount = CDS2_Correlation_Count AND
		CDS2_Component_Count >= RcDB_ACD_Count
		THEN 'PASS' ELSE 'FAIL' END AS PASS_FAIL
	FROM cte2
)
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte2 AS (
	SELECT ReportingPeriodLogId, wfs.Status, rpl.EventStatusId,
	(select COUNT(*) from cds2.dbo.insured where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Insured_Count,
	(select COUNT(*) FROM cds2.dbo.policy where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Policy_Count,
	(select COUNT(*) from cds2.dbo.component where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Component_Count,
	(select COUNT(DISTINCT cds2logid) from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) AS CDS2_Correlation_Count,
	(select COUNT(*) from rcdb.dbo.annuityclientdata where fklogid = rpl.RcdbClientLogId) AS RcDB_ACD_Count,
	(select COUNT(*) from rcdb.dbo.AnnuityEscalationData AED JOIN rcdb.dbo.AnnuityClientData ACD ON ACD.AnnuityClientDataId = AED.FK_AnnuityClientDataId Where ACD.fklogid = rpl.RcdbClientLogId) AS RcDB_AED_Count,
	(select COUNT(DISTINCT cs.FK_OutputCompanyId)
		from 
			Zenith.dbo.ClientFile cf 
			JOIN Zenith.dbo.OutputCompanyCriteriaClientFileLink OCCCFL ON OCCCFL.ClientFileId = cf.ClientFileId
			JOIN Zenith.dbo.OutputCompanyCriteria OCC ON OCC.OutputCompanyCriteriaId = OCCCFL.OutputCompanyCriteriaId
			JOIN Zenith.dbo.CompanySplit cs on cs.CriteriaId = occ.OutputCompanyCriteriaId 
		WHERE cf.clientfileid = rpl.ClientFileId) AS CedentCount
	FROM Zenith.dbo.ReportingPeriodLog rpl JOIN Zenith.dbo.WorkflowStatus wfs ON rpl.WorkflowStatusId = wfs.WorkFlowStatusId
	WHERE rpl.ReportingPeriodLogId = 547
), cte AS(
	SELECT *,
	CASE WHEN 
		[Status] = 'Ready for Review' AND 
		EventStatusId IS NULL AND 
		CDS2_Insured_Count = RcDB_ACD_Count AND
		CDS2_Policy_Count = RcDB_ACD_Count AND
		CedentCount = CDS2_Correlation_Count AND
		CDS2_Component_Count >= RcDB_ACD_Count
		THEN 'PASS' ELSE 'FAIL' END AS PASS_FAIL
	FROM cte2
)
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte2 AS (
	SELECT ReportingPeriodLogId, wfs.Status, rpl.EventStatusId,
	(select COUNT(*) from cds2.dbo.insured where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Insured_Count,
	(select COUNT(*) FROM cds2.dbo.policy where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Policy_Count,
	(select COUNT(*) from cds2.dbo.component where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Component_Count,
	(select COUNT(DISTINCT cds2logid) from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) AS CDS2_Correlation_Count,
	(select COUNT(*) from rcdb.dbo.annuityclientdata where fklogid = rpl.RcdbClientLogId) AS RcDB_ACD_Count,
	(select COUNT(*) from rcdb.dbo.AnnuityEscalationData AED JOIN rcdb.dbo.AnnuityClientData ACD ON ACD.AnnuityClientDataId = AED.FK_AnnuityClientDataId Where ACD.fklogid = rpl.RcdbClientLogId) AS RcDB_AED_Count,
	(select COUNT(DISTINCT cs.FK_OutputCompanyId)
		from 
			Zenith.dbo.ClientFile cf 
			JOIN Zenith.dbo.OutputCompanyCriteriaClientFileLink OCCCFL ON OCCCFL.ClientFileId = cf.ClientFileId
			JOIN Zenith.dbo.OutputCompanyCriteria OCC ON OCC.OutputCompanyCriteriaId = OCCCFL.OutputCompanyCriteriaId
			JOIN Zenith.dbo.CompanySplit cs on cs.CriteriaId = occ.OutputCompanyCriteriaId 
		WHERE cf.clientfileid = rpl.ClientFileId) AS CedentCount
	FROM Zenith.dbo.ReportingPeriodLog rpl JOIN Zenith.dbo.WorkflowStatus wfs ON rpl.WorkflowStatusId = wfs.WorkFlowStatusId
	WHERE rpl.ReportingPeriodLogId = 547
), cte AS(
	SELECT *,
	CASE WHEN 
		[Status] = 'Ready for Review' AND 
		EventStatusId IS NULL AND 
		CDS2_Insured_Count = RcDB_ACD_Count AND
		CDS2_Policy_Count = RcDB_ACD_Count AND
		CedentCount = CDS2_Correlation_Count AND
		CDS2_Component_Count >= RcDB_ACD_Count
		THEN 'PASS' ELSE 'FAIL' END AS PASS_FAIL
	FROM cte2
)
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte2 AS (
	SELECT ReportingPeriodLogId, wfs.Status, rpl.EventStatusId,
	(select COUNT(*) from cds2.dbo.insured where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Insured_Count,
	(select COUNT(*) FROM cds2.dbo.policy where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Policy_Count,
	(select COUNT(*) from cds2.dbo.component where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Component_Count,
	(select COUNT(DISTINCT cds2logid) from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) AS CDS2_Correlation_Count,
	(select COUNT(*) from rcdb.dbo.annuityclientdata where fklogid = rpl.RcdbClientLogId) AS RcDB_ACD_Count,
	(select COUNT(*) from rcdb.dbo.AnnuityEscalationData AED JOIN rcdb.dbo.AnnuityClientData ACD ON ACD.AnnuityClientDataId = AED.FK_AnnuityClientDataId Where ACD.fklogid = rpl.RcdbClientLogId) AS RcDB_AED_Count,
	(select COUNT(DISTINCT cs.FK_OutputCompanyId)
		from 
			Zenith.dbo.ClientFile cf 
			JOIN Zenith.dbo.OutputCompanyCriteriaClientFileLink OCCCFL ON OCCCFL.ClientFileId = cf.ClientFileId
			JOIN Zenith.dbo.OutputCompanyCriteria OCC ON OCC.OutputCompanyCriteriaId = OCCCFL.OutputCompanyCriteriaId
			JOIN Zenith.dbo.CompanySplit cs on cs.CriteriaId = occ.OutputCompanyCriteriaId 
		WHERE cf.clientfileid = rpl.ClientFileId) AS CedentCount
	FROM Zenith.dbo.ReportingPeriodLog rpl JOIN Zenith.dbo.WorkflowStatus wfs ON rpl.WorkflowStatusId = wfs.WorkFlowStatusId
	WHERE rpl.ReportingPeriodLogId = 548
), cte AS(
	SELECT *,
	CASE WHEN 
		[Status] = 'Ready for Review' AND 
		EventStatusId IS NULL AND 
		CDS2_Insured_Count = RcDB_ACD_Count AND
		CDS2_Policy_Count = RcDB_ACD_Count AND
		CedentCount = CDS2_Correlation_Count AND
		CDS2_Component_Count >= RcDB_ACD_Count
		THEN 'PASS' ELSE 'FAIL' END AS PASS_FAIL
	FROM cte2
)
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte2 AS (
	SELECT ReportingPeriodLogId, wfs.Status, rpl.EventStatusId,
	(select COUNT(*) from cds2.dbo.insured where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Insured_Count,
	(select COUNT(*) FROM cds2.dbo.policy where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Policy_Count,
	(select COUNT(*) from cds2.dbo.component where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Component_Count,
	(select COUNT(DISTINCT cds2logid) from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) AS CDS2_Correlation_Count,
	(select COUNT(*) from rcdb.dbo.annuityclientdata where fklogid = rpl.RcdbClientLogId) AS RcDB_ACD_Count,
	(select COUNT(*) from rcdb.dbo.AnnuityEscalationData AED JOIN rcdb.dbo.AnnuityClientData ACD ON ACD.AnnuityClientDataId = AED.FK_AnnuityClientDataId Where ACD.fklogid = rpl.RcdbClientLogId) AS RcDB_AED_Count,
	(select COUNT(DISTINCT cs.FK_OutputCompanyId)
		from 
			Zenith.dbo.ClientFile cf 
			JOIN Zenith.dbo.OutputCompanyCriteriaClientFileLink OCCCFL ON OCCCFL.ClientFileId = cf.ClientFileId
			JOIN Zenith.dbo.OutputCompanyCriteria OCC ON OCC.OutputCompanyCriteriaId = OCCCFL.OutputCompanyCriteriaId
			JOIN Zenith.dbo.CompanySplit cs on cs.CriteriaId = occ.OutputCompanyCriteriaId 
		WHERE cf.clientfileid = rpl.ClientFileId) AS CedentCount
	FROM Zenith.dbo.ReportingPeriodLog rpl JOIN Zenith.dbo.WorkflowStatus wfs ON rpl.WorkflowStatusId = wfs.WorkFlowStatusId
	WHERE rpl.ReportingPeriodLogId = 548
), cte AS(
	SELECT *,
	CASE WHEN 
		[Status] = 'Ready for Review' AND 
		EventStatusId IS NULL AND 
		CDS2_Insured_Count = RcDB_ACD_Count AND
		CDS2_Policy_Count = RcDB_ACD_Count AND
		CedentCount = CDS2_Correlation_Count AND
		CDS2_Component_Count >= RcDB_ACD_Count
		THEN 'PASS' ELSE 'FAIL' END AS PASS_FAIL
	FROM cte2
)
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte2 AS (
	SELECT ReportingPeriodLogId, wfs.Status, rpl.EventStatusId,
	(select COUNT(*) from cds2.dbo.insured where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Insured_Count,
	(select COUNT(*) FROM cds2.dbo.policy where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Policy_Count,
	(select COUNT(*) from cds2.dbo.component where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Component_Count,
	(select COUNT(DISTINCT cds2logid) from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) AS CDS2_Correlation_Count,
	(select COUNT(*) from rcdb.dbo.annuityclientdata where fklogid = rpl.RcdbClientLogId) AS RcDB_ACD_Count,
	(select COUNT(*) from rcdb.dbo.AnnuityEscalationData AED JOIN rcdb.dbo.AnnuityClientData ACD ON ACD.AnnuityClientDataId = AED.FK_AnnuityClientDataId Where ACD.fklogid = rpl.RcdbClientLogId) AS RcDB_AED_Count,
	(select COUNT(DISTINCT cs.FK_OutputCompanyId)
		from 
			Zenith.dbo.ClientFile cf 
			JOIN Zenith.dbo.OutputCompanyCriteriaClientFileLink OCCCFL ON OCCCFL.ClientFileId = cf.ClientFileId
			JOIN Zenith.dbo.OutputCompanyCriteria OCC ON OCC.OutputCompanyCriteriaId = OCCCFL.OutputCompanyCriteriaId
			JOIN Zenith.dbo.CompanySplit cs on cs.CriteriaId = occ.OutputCompanyCriteriaId 
		WHERE cf.clientfileid = rpl.ClientFileId) AS CedentCount
	FROM Zenith.dbo.ReportingPeriodLog rpl JOIN Zenith.dbo.WorkflowStatus wfs ON rpl.WorkflowStatusId = wfs.WorkFlowStatusId
	WHERE rpl.ReportingPeriodLogId = 549
), cte AS(
	SELECT *,
	CASE WHEN 
		[Status] = 'Ready for Review' AND 
		EventStatusId IS NULL AND 
		CDS2_Insured_Count = RcDB_ACD_Count AND
		CDS2_Policy_Count = RcDB_ACD_Count AND
		CedentCount = CDS2_Correlation_Count AND
		CDS2_Component_Count >= RcDB_ACD_Count
		THEN 'PASS' ELSE 'FAIL' END AS PASS_FAIL
	FROM cte2
)
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte2 AS (
	SELECT ReportingPeriodLogId, wfs.Status, rpl.EventStatusId,
	(select COUNT(*) from cds2.dbo.insured where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Insured_Count,
	(select COUNT(*) FROM cds2.dbo.policy where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Policy_Count,
	(select COUNT(*) from cds2.dbo.component where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Component_Count,
	(select COUNT(DISTINCT cds2logid) from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) AS CDS2_Correlation_Count,
	(select COUNT(*) from rcdb.dbo.annuityclientdata where fklogid = rpl.RcdbClientLogId) AS RcDB_ACD_Count,
	(select COUNT(*) from rcdb.dbo.AnnuityEscalationData AED JOIN rcdb.dbo.AnnuityClientData ACD ON ACD.AnnuityClientDataId = AED.FK_AnnuityClientDataId Where ACD.fklogid = rpl.RcdbClientLogId) AS RcDB_AED_Count,
	(select COUNT(DISTINCT cs.FK_OutputCompanyId)
		from 
			Zenith.dbo.ClientFile cf 
			JOIN Zenith.dbo.OutputCompanyCriteriaClientFileLink OCCCFL ON OCCCFL.ClientFileId = cf.ClientFileId
			JOIN Zenith.dbo.OutputCompanyCriteria OCC ON OCC.OutputCompanyCriteriaId = OCCCFL.OutputCompanyCriteriaId
			JOIN Zenith.dbo.CompanySplit cs on cs.CriteriaId = occ.OutputCompanyCriteriaId 
		WHERE cf.clientfileid = rpl.ClientFileId) AS CedentCount
	FROM Zenith.dbo.ReportingPeriodLog rpl JOIN Zenith.dbo.WorkflowStatus wfs ON rpl.WorkflowStatusId = wfs.WorkFlowStatusId
	WHERE rpl.ReportingPeriodLogId = 550
), cte AS(
	SELECT *,
	CASE WHEN 
		[Status] = 'Ready for Review' AND 
		EventStatusId IS NULL AND 
		CDS2_Insured_Count = RcDB_ACD_Count AND
		CDS2_Policy_Count = RcDB_ACD_Count AND
		CedentCount = CDS2_Correlation_Count AND
		CDS2_Component_Count >= RcDB_ACD_Count
		THEN 'PASS' ELSE 'FAIL' END AS PASS_FAIL
	FROM cte2
)
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte2 AS (
	SELECT ReportingPeriodLogId, wfs.Status, rpl.EventStatusId,
	(select COUNT(*) from cds2.dbo.insured where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Insured_Count,
	(select COUNT(*) FROM cds2.dbo.policy where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Policy_Count,
	(select COUNT(*) from cds2.dbo.component where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Component_Count,
	(select COUNT(DISTINCT cds2logid) from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) AS CDS2_Correlation_Count,
	(select COUNT(*) from rcdb.dbo.annuityclientdata where fklogid = rpl.RcdbClientLogId) AS RcDB_ACD_Count,
	(select COUNT(*) from rcdb.dbo.AnnuityEscalationData AED JOIN rcdb.dbo.AnnuityClientData ACD ON ACD.AnnuityClientDataId = AED.FK_AnnuityClientDataId Where ACD.fklogid = rpl.RcdbClientLogId) AS RcDB_AED_Count,
	(select COUNT(DISTINCT cs.FK_OutputCompanyId)
		from 
			Zenith.dbo.ClientFile cf 
			JOIN Zenith.dbo.OutputCompanyCriteriaClientFileLink OCCCFL ON OCCCFL.ClientFileId = cf.ClientFileId
			JOIN Zenith.dbo.OutputCompanyCriteria OCC ON OCC.OutputCompanyCriteriaId = OCCCFL.OutputCompanyCriteriaId
			JOIN Zenith.dbo.CompanySplit cs on cs.CriteriaId = occ.OutputCompanyCriteriaId 
		WHERE cf.clientfileid = rpl.ClientFileId) AS CedentCount
	FROM Zenith.dbo.ReportingPeriodLog rpl JOIN Zenith.dbo.WorkflowStatus wfs ON rpl.WorkflowStatusId = wfs.WorkFlowStatusId
	WHERE rpl.ReportingPeriodLogId = 550
), cte AS(
	SELECT *,
	CASE WHEN 
		[Status] = 'Ready for Review' AND 
		EventStatusId IS NULL AND 
		CDS2_Insured_Count = RcDB_ACD_Count AND
		CDS2_Policy_Count = RcDB_ACD_Count AND
		CedentCount = CDS2_Correlation_Count AND
		CDS2_Component_Count >= RcDB_ACD_Count
		THEN 'PASS' ELSE 'FAIL' END AS PASS_FAIL
	FROM cte2
)
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte2 AS (
	SELECT ReportingPeriodLogId, wfs.Status, rpl.EventStatusId,
	(select COUNT(*) from cds2.dbo.insured where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Insured_Count,
	(select COUNT(*) FROM cds2.dbo.policy where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Policy_Count,
	(select COUNT(*) from cds2.dbo.component where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Component_Count,
	(select COUNT(DISTINCT cds2logid) from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) AS CDS2_Correlation_Count,
	(select COUNT(*) from rcdb.dbo.annuityclientdata where fklogid = rpl.RcdbClientLogId) AS RcDB_ACD_Count,
	(select COUNT(*) from rcdb.dbo.AnnuityEscalationData AED JOIN rcdb.dbo.AnnuityClientData ACD ON ACD.AnnuityClientDataId = AED.FK_AnnuityClientDataId Where ACD.fklogid = rpl.RcdbClientLogId) AS RcDB_AED_Count,
	(select COUNT(DISTINCT cs.FK_OutputCompanyId)
		from 
			Zenith.dbo.ClientFile cf 
			JOIN Zenith.dbo.OutputCompanyCriteriaClientFileLink OCCCFL ON OCCCFL.ClientFileId = cf.ClientFileId
			JOIN Zenith.dbo.OutputCompanyCriteria OCC ON OCC.OutputCompanyCriteriaId = OCCCFL.OutputCompanyCriteriaId
			JOIN Zenith.dbo.CompanySplit cs on cs.CriteriaId = occ.OutputCompanyCriteriaId 
		WHERE cf.clientfileid = rpl.ClientFileId) AS CedentCount
	FROM Zenith.dbo.ReportingPeriodLog rpl JOIN Zenith.dbo.WorkflowStatus wfs ON rpl.WorkflowStatusId = wfs.WorkFlowStatusId
	WHERE rpl.ReportingPeriodLogId = 551
), cte AS(
	SELECT *,
	CASE WHEN 
		[Status] = 'Ready for Review' AND 
		EventStatusId IS NULL AND 
		CDS2_Insured_Count = RcDB_ACD_Count AND
		CDS2_Policy_Count = RcDB_ACD_Count AND
		CedentCount = CDS2_Correlation_Count AND
		CDS2_Component_Count >= RcDB_ACD_Count
		THEN 'PASS' ELSE 'FAIL' END AS PASS_FAIL
	FROM cte2
)
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Movement_Transaction_Type,
	O_Component_Commencement_Date,
	i.[O_Life1_Full_Name],
	CASE 
		WHEN O_Movement_Transaction_Type = 'NEWBU' 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
		WHEN p.O_policyholder_status = 'DEPENDENT'
			THEN CONVERT(VARCHAR, O_Component_Commencement_Date, 103)
		ELSE 
			CONVERT(VARCHAR, O_Policy_Commencement_Date, 103)
		END CalculatedDate,
	CASE WHEN 
		CASE 
		WHEN O_Movement_Transaction_Type = 'NEWBU' 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
		WHEN p.O_policyholder_status = 'DEPENDENT'
			THEN CONVERT(VARCHAR, O_Component_Commencement_Date, 103)
		ELSE 
			CONVERT(VARCHAR, O_Policy_Commencement_Date, 103)
		END = O_Component_Commencement_Date THEN
		'PASS'
	ELSE
		'FAIL'
	END PASS_FAIL
FROM 
	[CDS2].[dbo].[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId] AND p.FKLogID = s.FKLogId
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].[dbo].[Insured] i on i.[FKLogID] = a.[LogID]
where 
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1036)
	AND s.FKPolicyId = p.PolicyId 
	AND s.FKInsuredId = i.InsuredId

) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Component_Effective_Date,
	O_Movement_Transaction_Type,
	O_Policy_Commencement_Date,
	CASE
		WHEN O_Movement_Transaction_Type ='NEWBU' Then
		CASE 
			WHEN a.[ReportPeriodEndingDate] IS NOT NULL 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
			END
		ELSE
			CASE
				When p.O_Policy_Commencement_Date IS NULL or p.O_Policy_Commencement_Date = '' 
					Then 'Err'
				ELSE p.O_Policy_Commencement_Date
				END
			END CalculatedDate,
	ReportPeriodEndingDate,
	CASE WHEN 
		CASE
		WHEN O_Movement_Transaction_Type ='NEWBU' Then
		CASE 
			WHEN a.[ReportPeriodEndingDate] IS NOT NULL 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
			END
		ELSE
			CASE
				When p.O_Policy_Commencement_Date IS NULL or p.O_Policy_Commencement_Date = '' 
					Then 'Err'
				ELSE p.O_Policy_Commencement_Date
				END
		END = O_Component_Effective_Date THEN 'PASS'
		ELSE 'FAIL'
	END PASS_FAIL
from 
	[CDS2].dbo.[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId]
where 
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1036)

) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
     i.[O_Life1_Full_Name]
   , O_Subproduct_Code
   , C_Annuity_Commencement_Date
   , C_Next_Escalation_Date
   , C_Advance_Arrears_Instalment_Indicator
   , O_Escalation_Anniversary
   , CASE 
		WHEN O_Subproduct_Code NOT IN ('UKANN11', 'UKANN21')
		THEN 'MEETS'
		ELSE 'NOT MEETS'
	END MeetsInitialCriteria
   , case 
		when o_subproduct_code NOT IN ('UKANN11', 'UKANN21') AND C_Advance_Arrears_Instalment_Indicator = 'AD' then
			case 
				when RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2) = '29 02'
					then '28 02'
				else RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2)
			end
		else ''
	end LogicTest
	 , CASE
		WHEN
		CASE
			when o_subproduct_code NOT IN ('UKANN11', 'UKANN21') AND C_Advance_Arrears_Instalment_Indicator = 'AD' then
				case 
					when RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2) = '29 02'
						then '28 02'
					else RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2)
				end
			else ''
	 END = ISNULL(O_Escalation_Anniversary,'')
	 THEN 'PASS'
	 ELSE 'FAIL'
	 END PASS_FAIL
FROM
     [CDS2].[dbo].[Correlation] c
     INNER JOIN [CDS2].[dbo].[Component] cc ON cc.[FKPolicyId] = c.[Cds2ClientRecordId]
     INNER JOIN [CDS2].[dbo].[Insured] i ON i.[InsuredId] = cc.[FKInsuredId]
     INNER JOIN [CDS2].[dbo].[Policy] p ON p.[PolicyId]    = cc.[FKPolicyId] AND p.[FKLogID] = cc.[FKLogId]
     INNER JOIN [RcDb].[dbo].[AnnuityClientData] a ON a.[AnnuityClientDataId] = c.[RcdbClientRecordId]
     INNER JOIN [RcDb].[dbo].[AnnuityEscalationData] aed ON a.[AnnuityClientDataId] = aed.[FK_AnnuityClientDataId]
WHERE
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1036)
) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte2 AS (
	SELECT ReportingPeriodLogId, wfs.Status, rpl.EventStatusId,
	(select COUNT(*) from cds2.dbo.insured where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Insured_Count,
	(select COUNT(*) FROM cds2.dbo.policy where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Policy_Count,
	(select COUNT(*) from cds2.dbo.component where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Component_Count,
	(select COUNT(DISTINCT cds2logid) from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) AS CDS2_Correlation_Count,
	(select COUNT(*) from rcdb.dbo.annuityclientdata where fklogid = rpl.RcdbClientLogId) AS RcDB_ACD_Count,
	(select COUNT(*) from rcdb.dbo.AnnuityEscalationData AED JOIN rcdb.dbo.AnnuityClientData ACD ON ACD.AnnuityClientDataId = AED.FK_AnnuityClientDataId Where ACD.fklogid = rpl.RcdbClientLogId) AS RcDB_AED_Count,
	(select COUNT(DISTINCT cs.FK_OutputCompanyId)
		from 
			Zenith.dbo.ClientFile cf 
			JOIN Zenith.dbo.OutputCompanyCriteriaClientFileLink OCCCFL ON OCCCFL.ClientFileId = cf.ClientFileId
			JOIN Zenith.dbo.OutputCompanyCriteria OCC ON OCC.OutputCompanyCriteriaId = OCCCFL.OutputCompanyCriteriaId
			JOIN Zenith.dbo.CompanySplit cs on cs.CriteriaId = occ.OutputCompanyCriteriaId 
		WHERE cf.clientfileid = rpl.ClientFileId) AS CedentCount
	FROM Zenith.dbo.ReportingPeriodLog rpl JOIN Zenith.dbo.WorkflowStatus wfs ON rpl.WorkflowStatusId = wfs.WorkFlowStatusId
	WHERE rpl.ReportingPeriodLogId = 552
), cte AS(
	SELECT *,
	CASE WHEN 
		[Status] = 'Ready for Review' AND 
		EventStatusId IS NULL AND 
		CDS2_Insured_Count = RcDB_ACD_Count AND
		CDS2_Policy_Count = RcDB_ACD_Count AND
		CedentCount = CDS2_Correlation_Count AND
		CDS2_Component_Count >= RcDB_ACD_Count
		THEN 'PASS' ELSE 'FAIL' END AS PASS_FAIL
	FROM cte2
)
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte2 AS (
	SELECT ReportingPeriodLogId, wfs.Status, rpl.EventStatusId,
	(select COUNT(*) from cds2.dbo.insured where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Insured_Count,
	(select COUNT(*) FROM cds2.dbo.policy where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Policy_Count,
	(select COUNT(*) from cds2.dbo.component where fklogid in (select DISTINCT cds2logid from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) ) AS CDS2_Component_Count,
	(select COUNT(DISTINCT cds2logid) from cds2.dbo.correlation where rcdblogid = rpl.RcdbClientLogId) AS CDS2_Correlation_Count,
	(select COUNT(*) from rcdb.dbo.annuityclientdata where fklogid = rpl.RcdbClientLogId) AS RcDB_ACD_Count,
	(select COUNT(*) from rcdb.dbo.AnnuityEscalationData AED JOIN rcdb.dbo.AnnuityClientData ACD ON ACD.AnnuityClientDataId = AED.FK_AnnuityClientDataId Where ACD.fklogid = rpl.RcdbClientLogId) AS RcDB_AED_Count,
	(select COUNT(DISTINCT cs.FK_OutputCompanyId)
		from 
			Zenith.dbo.ClientFile cf 
			JOIN Zenith.dbo.OutputCompanyCriteriaClientFileLink OCCCFL ON OCCCFL.ClientFileId = cf.ClientFileId
			JOIN Zenith.dbo.OutputCompanyCriteria OCC ON OCC.OutputCompanyCriteriaId = OCCCFL.OutputCompanyCriteriaId
			JOIN Zenith.dbo.CompanySplit cs on cs.CriteriaId = occ.OutputCompanyCriteriaId 
		WHERE cf.clientfileid = rpl.ClientFileId) AS CedentCount
	FROM Zenith.dbo.ReportingPeriodLog rpl JOIN Zenith.dbo.WorkflowStatus wfs ON rpl.WorkflowStatusId = wfs.WorkFlowStatusId
	WHERE rpl.ReportingPeriodLogId = 552
), cte AS(
	SELECT *,
	CASE WHEN 
		[Status] = 'Ready for Review' AND 
		EventStatusId IS NULL AND 
		CDS2_Insured_Count = RcDB_ACD_Count AND
		CDS2_Policy_Count = RcDB_ACD_Count AND
		CedentCount = CDS2_Correlation_Count AND
		CDS2_Component_Count >= RcDB_ACD_Count
		THEN 'PASS' ELSE 'FAIL' END AS PASS_FAIL
	FROM cte2
)
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Movement_Transaction_Type,
	O_Component_Commencement_Date,
	i.[O_Life1_Full_Name],
	CASE 
		WHEN O_Movement_Transaction_Type = 'NEWBU' 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
		WHEN p.O_policyholder_status = 'DEPENDENT'
			THEN CONVERT(VARCHAR, O_Component_Commencement_Date, 103)
		ELSE 
			CONVERT(VARCHAR, O_Policy_Commencement_Date, 103)
		END CalculatedDate,
	CASE WHEN 
		CASE 
		WHEN O_Movement_Transaction_Type = 'NEWBU' 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
		WHEN p.O_policyholder_status = 'DEPENDENT'
			THEN CONVERT(VARCHAR, O_Component_Commencement_Date, 103)
		ELSE 
			CONVERT(VARCHAR, O_Policy_Commencement_Date, 103)
		END = O_Component_Commencement_Date THEN
		'PASS'
	ELSE
		'FAIL'
	END PASS_FAIL
FROM 
	[CDS2].[dbo].[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId] AND p.FKLogID = s.FKLogId
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].[dbo].[Insured] i on i.[FKLogID] = a.[LogID]
where 
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1037)
	AND s.FKPolicyId = p.PolicyId 
	AND s.FKInsuredId = i.InsuredId

) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Component_Effective_Date,
	O_Movement_Transaction_Type,
	O_Policy_Commencement_Date,
	CASE
		WHEN O_Movement_Transaction_Type ='NEWBU' Then
		CASE 
			WHEN a.[ReportPeriodEndingDate] IS NOT NULL 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
			END
		ELSE
			CASE
				When p.O_Policy_Commencement_Date IS NULL or p.O_Policy_Commencement_Date = '' 
					Then 'Err'
				ELSE p.O_Policy_Commencement_Date
				END
			END CalculatedDate,
	ReportPeriodEndingDate,
	CASE WHEN 
		CASE
		WHEN O_Movement_Transaction_Type ='NEWBU' Then
		CASE 
			WHEN a.[ReportPeriodEndingDate] IS NOT NULL 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
			END
		ELSE
			CASE
				When p.O_Policy_Commencement_Date IS NULL or p.O_Policy_Commencement_Date = '' 
					Then 'Err'
				ELSE p.O_Policy_Commencement_Date
				END
		END = O_Component_Effective_Date THEN 'PASS'
		ELSE 'FAIL'
	END PASS_FAIL
from 
	[CDS2].dbo.[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId]
where 
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1037)

) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
     i.[O_Life1_Full_Name]
   , O_Subproduct_Code
   , C_Annuity_Commencement_Date
   , C_Next_Escalation_Date
   , C_Advance_Arrears_Instalment_Indicator
   , O_Escalation_Anniversary
   , CASE 
		WHEN O_Subproduct_Code NOT IN ('UKANN11', 'UKANN21')
		THEN 'MEETS'
		ELSE 'NOT MEETS'
	END MeetsInitialCriteria
   , case 
		when o_subproduct_code NOT IN ('UKANN11', 'UKANN21') AND C_Advance_Arrears_Instalment_Indicator = 'AD' then
			case 
				when RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2) = '29 02'
					then '28 02'
				else RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2)
			end
		else ''
	end LogicTest
	 , CASE
		WHEN
		CASE
			when o_subproduct_code NOT IN ('UKANN11', 'UKANN21') AND C_Advance_Arrears_Instalment_Indicator = 'AD' then
				case 
					when RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2) = '29 02'
						then '28 02'
					else RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2)
				end
			else ''
	 END = ISNULL(O_Escalation_Anniversary,'')
	 THEN 'PASS'
	 ELSE 'FAIL'
	 END PASS_FAIL
FROM
     [CDS2].[dbo].[Correlation] c
     INNER JOIN [CDS2].[dbo].[Component] cc ON cc.[FKPolicyId] = c.[Cds2ClientRecordId]
     INNER JOIN [CDS2].[dbo].[Insured] i ON i.[InsuredId] = cc.[FKInsuredId]
     INNER JOIN [CDS2].[dbo].[Policy] p ON p.[PolicyId]    = cc.[FKPolicyId] AND p.[FKLogID] = cc.[FKLogId]
     INNER JOIN [RcDb].[dbo].[AnnuityClientData] a ON a.[AnnuityClientDataId] = c.[RcdbClientRecordId]
     INNER JOIN [RcDb].[dbo].[AnnuityEscalationData] aed ON a.[AnnuityClientDataId] = aed.[FK_AnnuityClientDataId]
WHERE
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1037)
) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Movement_Transaction_Type,
	O_Component_Commencement_Date,
	i.[O_Life1_Full_Name],
	CASE 
		WHEN O_Movement_Transaction_Type = 'NEWBU' 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
		WHEN p.O_policyholder_status = 'DEPENDENT'
			THEN CONVERT(VARCHAR, O_Component_Commencement_Date, 103)
		ELSE 
			CONVERT(VARCHAR, O_Policy_Commencement_Date, 103)
		END CalculatedDate,
	CASE WHEN 
		CASE 
		WHEN O_Movement_Transaction_Type = 'NEWBU' 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
		WHEN p.O_policyholder_status = 'DEPENDENT'
			THEN CONVERT(VARCHAR, O_Component_Commencement_Date, 103)
		ELSE 
			CONVERT(VARCHAR, O_Policy_Commencement_Date, 103)
		END = O_Component_Commencement_Date THEN
		'PASS'
	ELSE
		'FAIL'
	END PASS_FAIL
FROM 
	[CDS2].[dbo].[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId] AND p.FKLogID = s.FKLogId
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].[dbo].[Insured] i on i.[FKLogID] = a.[LogID]
where 
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1038)
	AND s.FKPolicyId = p.PolicyId 
	AND s.FKInsuredId = i.InsuredId

) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Component_Effective_Date,
	O_Movement_Transaction_Type,
	O_Policy_Commencement_Date,
	CASE
		WHEN O_Movement_Transaction_Type ='NEWBU' Then
		CASE 
			WHEN a.[ReportPeriodEndingDate] IS NOT NULL 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
			END
		ELSE
			CASE
				When p.O_Policy_Commencement_Date IS NULL or p.O_Policy_Commencement_Date = '' 
					Then 'Err'
				ELSE p.O_Policy_Commencement_Date
				END
			END CalculatedDate,
	ReportPeriodEndingDate,
	CASE WHEN 
		CASE
		WHEN O_Movement_Transaction_Type ='NEWBU' Then
		CASE 
			WHEN a.[ReportPeriodEndingDate] IS NOT NULL 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
			END
		ELSE
			CASE
				When p.O_Policy_Commencement_Date IS NULL or p.O_Policy_Commencement_Date = '' 
					Then 'Err'
				ELSE p.O_Policy_Commencement_Date
				END
		END = O_Component_Effective_Date THEN 'PASS'
		ELSE 'FAIL'
	END PASS_FAIL
from 
	[CDS2].dbo.[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId]
where 
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1038)

) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
     i.[O_Life1_Full_Name]
   , O_Subproduct_Code
   , C_Annuity_Commencement_Date
   , C_Next_Escalation_Date
   , C_Advance_Arrears_Instalment_Indicator
   , O_Escalation_Anniversary
   , CASE 
		WHEN O_Subproduct_Code NOT IN ('UKANN11', 'UKANN21')
		THEN 'MEETS'
		ELSE 'NOT MEETS'
	END MeetsInitialCriteria
   , case 
		when o_subproduct_code NOT IN ('UKANN11', 'UKANN21') AND C_Advance_Arrears_Instalment_Indicator = 'AD' then
			case 
				when RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2) = '29 02'
					then '28 02'
				else RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2)
			end
		else ''
	end LogicTest
	 , CASE
		WHEN
		CASE
			when o_subproduct_code NOT IN ('UKANN11', 'UKANN21') AND C_Advance_Arrears_Instalment_Indicator = 'AD' then
				case 
					when RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2) = '29 02'
						then '28 02'
					else RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2)
				end
			else ''
	 END = ISNULL(O_Escalation_Anniversary,'')
	 THEN 'PASS'
	 ELSE 'FAIL'
	 END PASS_FAIL
FROM
     [CDS2].[dbo].[Correlation] c
     INNER JOIN [CDS2].[dbo].[Component] cc ON cc.[FKPolicyId] = c.[Cds2ClientRecordId]
     INNER JOIN [CDS2].[dbo].[Insured] i ON i.[InsuredId] = cc.[FKInsuredId]
     INNER JOIN [CDS2].[dbo].[Policy] p ON p.[PolicyId]    = cc.[FKPolicyId] AND p.[FKLogID] = cc.[FKLogId]
     INNER JOIN [RcDb].[dbo].[AnnuityClientData] a ON a.[AnnuityClientDataId] = c.[RcdbClientRecordId]
     INNER JOIN [RcDb].[dbo].[AnnuityEscalationData] aed ON a.[AnnuityClientDataId] = aed.[FK_AnnuityClientDataId]
WHERE
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1038)
) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Movement_Transaction_Type,
	O_Component_Commencement_Date,
	i.[O_Life1_Full_Name],
	CASE 
		WHEN O_Movement_Transaction_Type = 'NEWBU' 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
		WHEN p.O_policyholder_status = 'DEPENDENT'
			THEN CONVERT(VARCHAR, O_Component_Commencement_Date, 103)
		ELSE 
			CONVERT(VARCHAR, O_Policy_Commencement_Date, 103)
		END CalculatedDate,
	CASE WHEN 
		CASE 
		WHEN O_Movement_Transaction_Type = 'NEWBU' 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
		WHEN p.O_policyholder_status = 'DEPENDENT'
			THEN CONVERT(VARCHAR, O_Component_Commencement_Date, 103)
		ELSE 
			CONVERT(VARCHAR, O_Policy_Commencement_Date, 103)
		END = O_Component_Commencement_Date THEN
		'PASS'
	ELSE
		'FAIL'
	END PASS_FAIL
FROM 
	[CDS2].[dbo].[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId] AND p.FKLogID = s.FKLogId
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].[dbo].[Insured] i on i.[FKLogID] = a.[LogID]
where 
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1039)
	AND s.FKPolicyId = p.PolicyId 
	AND s.FKInsuredId = i.InsuredId

) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Component_Effective_Date,
	O_Movement_Transaction_Type,
	O_Policy_Commencement_Date,
	CASE
		WHEN O_Movement_Transaction_Type ='NEWBU' Then
		CASE 
			WHEN a.[ReportPeriodEndingDate] IS NOT NULL 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
			END
		ELSE
			CASE
				When p.O_Policy_Commencement_Date IS NULL or p.O_Policy_Commencement_Date = '' 
					Then 'Err'
				ELSE p.O_Policy_Commencement_Date
				END
			END CalculatedDate,
	ReportPeriodEndingDate,
	CASE WHEN 
		CASE
		WHEN O_Movement_Transaction_Type ='NEWBU' Then
		CASE 
			WHEN a.[ReportPeriodEndingDate] IS NOT NULL 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
			END
		ELSE
			CASE
				When p.O_Policy_Commencement_Date IS NULL or p.O_Policy_Commencement_Date = '' 
					Then 'Err'
				ELSE p.O_Policy_Commencement_Date
				END
		END = O_Component_Effective_Date THEN 'PASS'
		ELSE 'FAIL'
	END PASS_FAIL
from 
	[CDS2].dbo.[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId]
where 
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1039)

) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
     i.[O_Life1_Full_Name]
   , O_Subproduct_Code
   , C_Annuity_Commencement_Date
   , C_Next_Escalation_Date
   , C_Advance_Arrears_Instalment_Indicator
   , O_Escalation_Anniversary
   , CASE 
		WHEN O_Subproduct_Code NOT IN ('UKANN11', 'UKANN21')
		THEN 'MEETS'
		ELSE 'NOT MEETS'
	END MeetsInitialCriteria
   , case 
		when o_subproduct_code NOT IN ('UKANN11', 'UKANN21') AND C_Advance_Arrears_Instalment_Indicator = 'AD' then
			case 
				when RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2) = '29 02'
					then '28 02'
				else RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2)
			end
		else ''
	end LogicTest
	 , CASE
		WHEN
		CASE
			when o_subproduct_code NOT IN ('UKANN11', 'UKANN21') AND C_Advance_Arrears_Instalment_Indicator = 'AD' then
				case 
					when RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2) = '29 02'
						then '28 02'
					else RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2)
				end
			else ''
	 END = ISNULL(O_Escalation_Anniversary,'')
	 THEN 'PASS'
	 ELSE 'FAIL'
	 END PASS_FAIL
FROM
     [CDS2].[dbo].[Correlation] c
     INNER JOIN [CDS2].[dbo].[Component] cc ON cc.[FKPolicyId] = c.[Cds2ClientRecordId]
     INNER JOIN [CDS2].[dbo].[Insured] i ON i.[InsuredId] = cc.[FKInsuredId]
     INNER JOIN [CDS2].[dbo].[Policy] p ON p.[PolicyId]    = cc.[FKPolicyId] AND p.[FKLogID] = cc.[FKLogId]
     INNER JOIN [RcDb].[dbo].[AnnuityClientData] a ON a.[AnnuityClientDataId] = c.[RcdbClientRecordId]
     INNER JOIN [RcDb].[dbo].[AnnuityEscalationData] aed ON a.[AnnuityClientDataId] = aed.[FK_AnnuityClientDataId]
WHERE
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1039)
) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Movement_Transaction_Type,
	O_Component_Commencement_Date,
	i.[O_Life1_Full_Name],
	CASE 
		WHEN O_Movement_Transaction_Type = 'NEWBU' 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
		WHEN p.O_policyholder_status = 'DEPENDENT'
			THEN CONVERT(VARCHAR, O_Component_Commencement_Date, 103)
		ELSE 
			CONVERT(VARCHAR, O_Policy_Commencement_Date, 103)
		END CalculatedDate,
	CASE WHEN 
		CASE 
		WHEN O_Movement_Transaction_Type = 'NEWBU' 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
		WHEN p.O_policyholder_status = 'DEPENDENT'
			THEN CONVERT(VARCHAR, O_Component_Commencement_Date, 103)
		ELSE 
			CONVERT(VARCHAR, O_Policy_Commencement_Date, 103)
		END = O_Component_Commencement_Date THEN
		'PASS'
	ELSE
		'FAIL'
	END PASS_FAIL
FROM 
	[CDS2].[dbo].[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId] AND p.FKLogID = s.FKLogId
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].[dbo].[Insured] i on i.[FKLogID] = a.[LogID]
where 
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1040)
	AND s.FKPolicyId = p.PolicyId 
	AND s.FKInsuredId = i.InsuredId

) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Component_Effective_Date,
	O_Movement_Transaction_Type,
	O_Policy_Commencement_Date,
	CASE
		WHEN O_Movement_Transaction_Type ='NEWBU' Then
		CASE 
			WHEN a.[ReportPeriodEndingDate] IS NOT NULL 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
			END
		ELSE
			CASE
				When p.O_Policy_Commencement_Date IS NULL or p.O_Policy_Commencement_Date = '' 
					Then 'Err'
				ELSE p.O_Policy_Commencement_Date
				END
			END CalculatedDate,
	ReportPeriodEndingDate,
	CASE WHEN 
		CASE
		WHEN O_Movement_Transaction_Type ='NEWBU' Then
		CASE 
			WHEN a.[ReportPeriodEndingDate] IS NOT NULL 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
			END
		ELSE
			CASE
				When p.O_Policy_Commencement_Date IS NULL or p.O_Policy_Commencement_Date = '' 
					Then 'Err'
				ELSE p.O_Policy_Commencement_Date
				END
		END = O_Component_Effective_Date THEN 'PASS'
		ELSE 'FAIL'
	END PASS_FAIL
from 
	[CDS2].dbo.[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId]
where 
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1040)

) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
     i.[O_Life1_Full_Name]
   , O_Subproduct_Code
   , C_Annuity_Commencement_Date
   , C_Next_Escalation_Date
   , C_Advance_Arrears_Instalment_Indicator
   , O_Escalation_Anniversary
   , CASE 
		WHEN O_Subproduct_Code NOT IN ('UKANN11', 'UKANN21')
		THEN 'MEETS'
		ELSE 'NOT MEETS'
	END MeetsInitialCriteria
   , case 
		when o_subproduct_code NOT IN ('UKANN11', 'UKANN21') AND C_Advance_Arrears_Instalment_Indicator = 'AD' then
			case 
				when RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2) = '29 02'
					then '28 02'
				else RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2)
			end
		else ''
	end LogicTest
	 , CASE
		WHEN
		CASE
			when o_subproduct_code NOT IN ('UKANN11', 'UKANN21') AND C_Advance_Arrears_Instalment_Indicator = 'AD' then
				case 
					when RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2) = '29 02'
						then '28 02'
					else RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2)
				end
			else ''
	 END = ISNULL(O_Escalation_Anniversary,'')
	 THEN 'PASS'
	 ELSE 'FAIL'
	 END PASS_FAIL
FROM
     [CDS2].[dbo].[Correlation] c
     INNER JOIN [CDS2].[dbo].[Component] cc ON cc.[FKPolicyId] = c.[Cds2ClientRecordId]
     INNER JOIN [CDS2].[dbo].[Insured] i ON i.[InsuredId] = cc.[FKInsuredId]
     INNER JOIN [CDS2].[dbo].[Policy] p ON p.[PolicyId]    = cc.[FKPolicyId] AND p.[FKLogID] = cc.[FKLogId]
     INNER JOIN [RcDb].[dbo].[AnnuityClientData] a ON a.[AnnuityClientDataId] = c.[RcdbClientRecordId]
     INNER JOIN [RcDb].[dbo].[AnnuityEscalationData] aed ON a.[AnnuityClientDataId] = aed.[FK_AnnuityClientDataId]
WHERE
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1040)
) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Movement_Transaction_Type,
	O_Component_Commencement_Date,
	i.[O_Life1_Full_Name],
	CASE 
		WHEN O_Movement_Transaction_Type = 'NEWBU' 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
		WHEN p.O_policyholder_status = 'DEPENDENT'
			THEN CONVERT(VARCHAR, O_Component_Commencement_Date, 103)
		ELSE 
			CONVERT(VARCHAR, O_Policy_Commencement_Date, 103)
		END CalculatedDate,
	CASE WHEN 
		CASE 
		WHEN O_Movement_Transaction_Type = 'NEWBU' 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
		WHEN p.O_policyholder_status = 'DEPENDENT'
			THEN CONVERT(VARCHAR, O_Component_Commencement_Date, 103)
		ELSE 
			CONVERT(VARCHAR, O_Policy_Commencement_Date, 103)
		END = O_Component_Commencement_Date THEN
		'PASS'
	ELSE
		'FAIL'
	END PASS_FAIL
FROM 
	[CDS2].[dbo].[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId] AND p.FKLogID = s.FKLogId
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].[dbo].[Insured] i on i.[FKLogID] = a.[LogID]
where 
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1041)
	AND s.FKPolicyId = p.PolicyId 
	AND s.FKInsuredId = i.InsuredId

) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Component_Effective_Date,
	O_Movement_Transaction_Type,
	O_Policy_Commencement_Date,
	CASE
		WHEN O_Movement_Transaction_Type ='NEWBU' Then
		CASE 
			WHEN a.[ReportPeriodEndingDate] IS NOT NULL 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
			END
		ELSE
			CASE
				When p.O_Policy_Commencement_Date IS NULL or p.O_Policy_Commencement_Date = '' 
					Then 'Err'
				ELSE p.O_Policy_Commencement_Date
				END
			END CalculatedDate,
	ReportPeriodEndingDate,
	CASE WHEN 
		CASE
		WHEN O_Movement_Transaction_Type ='NEWBU' Then
		CASE 
			WHEN a.[ReportPeriodEndingDate] IS NOT NULL 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
			END
		ELSE
			CASE
				When p.O_Policy_Commencement_Date IS NULL or p.O_Policy_Commencement_Date = '' 
					Then 'Err'
				ELSE p.O_Policy_Commencement_Date
				END
		END = O_Component_Effective_Date THEN 'PASS'
		ELSE 'FAIL'
	END PASS_FAIL
from 
	[CDS2].dbo.[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId]
where 
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1041)

) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
     i.[O_Life1_Full_Name]
   , O_Subproduct_Code
   , C_Annuity_Commencement_Date
   , C_Next_Escalation_Date
   , C_Advance_Arrears_Instalment_Indicator
   , O_Escalation_Anniversary
   , CASE 
		WHEN O_Subproduct_Code NOT IN ('UKANN11', 'UKANN21')
		THEN 'MEETS'
		ELSE 'NOT MEETS'
	END MeetsInitialCriteria
   , case 
		when o_subproduct_code NOT IN ('UKANN11', 'UKANN21') AND C_Advance_Arrears_Instalment_Indicator = 'AD' then
			case 
				when RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2) = '29 02'
					then '28 02'
				else RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2)
			end
		else ''
	end LogicTest
	 , CASE
		WHEN
		CASE
			when o_subproduct_code NOT IN ('UKANN11', 'UKANN21') AND C_Advance_Arrears_Instalment_Indicator = 'AD' then
				case 
					when RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2) = '29 02'
						then '28 02'
					else RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2)
				end
			else ''
	 END = ISNULL(O_Escalation_Anniversary,'')
	 THEN 'PASS'
	 ELSE 'FAIL'
	 END PASS_FAIL
FROM
     [CDS2].[dbo].[Correlation] c
     INNER JOIN [CDS2].[dbo].[Component] cc ON cc.[FKPolicyId] = c.[Cds2ClientRecordId]
     INNER JOIN [CDS2].[dbo].[Insured] i ON i.[InsuredId] = cc.[FKInsuredId]
     INNER JOIN [CDS2].[dbo].[Policy] p ON p.[PolicyId]    = cc.[FKPolicyId] AND p.[FKLogID] = cc.[FKLogId]
     INNER JOIN [RcDb].[dbo].[AnnuityClientData] a ON a.[AnnuityClientDataId] = c.[RcdbClientRecordId]
     INNER JOIN [RcDb].[dbo].[AnnuityEscalationData] aed ON a.[AnnuityClientDataId] = aed.[FK_AnnuityClientDataId]
WHERE
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1041)
) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Movement_Transaction_Type,
	O_Component_Commencement_Date,
	i.[O_Life1_Full_Name],
	CASE 
		WHEN O_Movement_Transaction_Type = 'NEWBU' 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
		WHEN p.O_policyholder_status = 'DEPENDENT'
			THEN CONVERT(VARCHAR, O_Component_Commencement_Date, 103)
		ELSE 
			CONVERT(VARCHAR, O_Policy_Commencement_Date, 103)
		END CalculatedDate,
	CASE WHEN 
		CASE 
		WHEN O_Movement_Transaction_Type = 'NEWBU' 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
		WHEN p.O_policyholder_status = 'DEPENDENT'
			THEN CONVERT(VARCHAR, O_Component_Commencement_Date, 103)
		ELSE 
			CONVERT(VARCHAR, O_Policy_Commencement_Date, 103)
		END = O_Component_Commencement_Date THEN
		'PASS'
	ELSE
		'FAIL'
	END PASS_FAIL
FROM 
	[CDS2].[dbo].[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId] AND p.FKLogID = s.FKLogId
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].[dbo].[Insured] i on i.[FKLogID] = a.[LogID]
where 
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1042)
	AND s.FKPolicyId = p.PolicyId 
	AND s.FKInsuredId = i.InsuredId

) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Component_Effective_Date,
	O_Movement_Transaction_Type,
	O_Policy_Commencement_Date,
	CASE
		WHEN O_Movement_Transaction_Type ='NEWBU' Then
		CASE 
			WHEN a.[ReportPeriodEndingDate] IS NOT NULL 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
			END
		ELSE
			CASE
				When p.O_Policy_Commencement_Date IS NULL or p.O_Policy_Commencement_Date = '' 
					Then 'Err'
				ELSE p.O_Policy_Commencement_Date
				END
			END CalculatedDate,
	ReportPeriodEndingDate,
	CASE WHEN 
		CASE
		WHEN O_Movement_Transaction_Type ='NEWBU' Then
		CASE 
			WHEN a.[ReportPeriodEndingDate] IS NOT NULL 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
			END
		ELSE
			CASE
				When p.O_Policy_Commencement_Date IS NULL or p.O_Policy_Commencement_Date = '' 
					Then 'Err'
				ELSE p.O_Policy_Commencement_Date
				END
		END = O_Component_Effective_Date THEN 'PASS'
		ELSE 'FAIL'
	END PASS_FAIL
from 
	[CDS2].dbo.[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId]
where 
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1042)

) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
     i.[O_Life1_Full_Name]
   , O_Subproduct_Code
   , C_Annuity_Commencement_Date
   , C_Next_Escalation_Date
   , C_Advance_Arrears_Instalment_Indicator
   , O_Escalation_Anniversary
   , CASE 
		WHEN O_Subproduct_Code NOT IN ('UKANN11', 'UKANN21')
		THEN 'MEETS'
		ELSE 'NOT MEETS'
	END MeetsInitialCriteria
   , case 
		when o_subproduct_code NOT IN ('UKANN11', 'UKANN21') AND C_Advance_Arrears_Instalment_Indicator = 'AD' then
			case 
				when RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2) = '29 02'
					then '28 02'
				else RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2)
			end
		else ''
	end LogicTest
	 , CASE
		WHEN
		CASE
			when o_subproduct_code NOT IN ('UKANN11', 'UKANN21') AND C_Advance_Arrears_Instalment_Indicator = 'AD' then
				case 
					when RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2) = '29 02'
						then '28 02'
					else RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2)
				end
			else ''
	 END = ISNULL(O_Escalation_Anniversary,'')
	 THEN 'PASS'
	 ELSE 'FAIL'
	 END PASS_FAIL
FROM
     [CDS2].[dbo].[Correlation] c
     INNER JOIN [CDS2].[dbo].[Component] cc ON cc.[FKPolicyId] = c.[Cds2ClientRecordId]
     INNER JOIN [CDS2].[dbo].[Insured] i ON i.[InsuredId] = cc.[FKInsuredId]
     INNER JOIN [CDS2].[dbo].[Policy] p ON p.[PolicyId]    = cc.[FKPolicyId] AND p.[FKLogID] = cc.[FKLogId]
     INNER JOIN [RcDb].[dbo].[AnnuityClientData] a ON a.[AnnuityClientDataId] = c.[RcdbClientRecordId]
     INNER JOIN [RcDb].[dbo].[AnnuityEscalationData] aed ON a.[AnnuityClientDataId] = aed.[FK_AnnuityClientDataId]
WHERE
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1042)
) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Movement_Transaction_Type,
	O_Component_Commencement_Date,
	i.[O_Life1_Full_Name],
	CASE 
		WHEN O_Movement_Transaction_Type = 'NEWBU' 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
		WHEN p.O_policyholder_status = 'DEPENDENT'
			THEN CONVERT(VARCHAR, O_Component_Commencement_Date, 103)
		ELSE 
			CONVERT(VARCHAR, O_Policy_Commencement_Date, 103)
		END CalculatedDate,
	CASE WHEN 
		CASE 
		WHEN O_Movement_Transaction_Type = 'NEWBU' 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
		WHEN p.O_policyholder_status = 'DEPENDENT'
			THEN CONVERT(VARCHAR, O_Component_Commencement_Date, 103)
		ELSE 
			CONVERT(VARCHAR, O_Policy_Commencement_Date, 103)
		END = O_Component_Commencement_Date THEN
		'PASS'
	ELSE
		'FAIL'
	END PASS_FAIL
FROM 
	[CDS2].[dbo].[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId] AND p.FKLogID = s.FKLogId
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].[dbo].[Insured] i on i.[FKLogID] = a.[LogID]
where 
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1047)
	AND s.FKPolicyId = p.PolicyId 
	AND s.FKInsuredId = i.InsuredId

) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Component_Effective_Date,
	O_Movement_Transaction_Type,
	O_Policy_Commencement_Date,
	CASE
		WHEN O_Movement_Transaction_Type ='NEWBU' Then
		CASE 
			WHEN a.[ReportPeriodEndingDate] IS NOT NULL 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
			END
		ELSE
			CASE
				When p.O_Policy_Commencement_Date IS NULL or p.O_Policy_Commencement_Date = '' 
					Then 'Err'
				ELSE p.O_Policy_Commencement_Date
				END
			END CalculatedDate,
	ReportPeriodEndingDate,
	CASE WHEN 
		CASE
		WHEN O_Movement_Transaction_Type ='NEWBU' Then
		CASE 
			WHEN a.[ReportPeriodEndingDate] IS NOT NULL 
			THEN CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
			END
		ELSE
			CASE
				When p.O_Policy_Commencement_Date IS NULL or p.O_Policy_Commencement_Date = '' 
					Then 'Err'
				ELSE p.O_Policy_Commencement_Date
				END
		END = O_Component_Effective_Date THEN 'PASS'
		ELSE 'FAIL'
	END PASS_FAIL
from 
	[CDS2].dbo.[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId]
where 
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1047)

) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
     i.[O_Life1_Full_Name]
   , O_Subproduct_Code
   , C_Annuity_Commencement_Date
   , C_Next_Escalation_Date
   , C_Advance_Arrears_Instalment_Indicator
   , O_Escalation_Anniversary
   , CASE 
		WHEN O_Subproduct_Code NOT IN ('UKANN11', 'UKANN21')
		THEN 'MEETS'
		ELSE 'NOT MEETS'
	END MeetsInitialCriteria
   , case 
		when o_subproduct_code NOT IN ('UKANN11', 'UKANN21') AND C_Advance_Arrears_Instalment_Indicator = 'AD' then
			case 
				when RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2) = '29 02'
					then '28 02'
				else RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2)
			end
		else ''
	end LogicTest
	 , CASE
		WHEN
		CASE
			when o_subproduct_code NOT IN ('UKANN11', 'UKANN21') AND C_Advance_Arrears_Instalment_Indicator = 'AD' then
				case 
					when RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2) = '29 02'
						then '28 02'
					else RIGHT('0' + CAST(DAY(C_Next_Escalation_Date) AS varchar(2)), 2) + ' ' + RIGHT('0'+CAST(MONTH(C_Next_Escalation_Date) AS varchar(2)),2)
				end
			else ''
	 END = ISNULL(O_Escalation_Anniversary,'')
	 THEN 'PASS'
	 ELSE 'FAIL'
	 END PASS_FAIL
FROM
     [CDS2].[dbo].[Correlation] c
     INNER JOIN [CDS2].[dbo].[Component] cc ON cc.[FKPolicyId] = c.[Cds2ClientRecordId]
     INNER JOIN [CDS2].[dbo].[Insured] i ON i.[InsuredId] = cc.[FKInsuredId]
     INNER JOIN [CDS2].[dbo].[Policy] p ON p.[PolicyId]    = cc.[FKPolicyId] AND p.[FKLogID] = cc.[FKLogId]
     INNER JOIN [RcDb].[dbo].[AnnuityClientData] a ON a.[AnnuityClientDataId] = c.[RcdbClientRecordId]
     INNER JOIN [RcDb].[dbo].[AnnuityEscalationData] aed ON a.[AnnuityClientDataId] = aed.[FK_AnnuityClientDataId]
WHERE
	c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1047)
) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	   O_Active_Component_Count
	,  O_Policy_Status_Ind
	, CASE
		WHEN O_Active_Component_Count > 0 THEN 'A'
		ELSE 'C' END LogicTest
	, CASE
		WHEN
			CASE
				WHEN O_Active_Component_Count > 0 THEN 'A'
			ELSE 'C'
			END = O_Policy_Status_Ind 
	  THEN 'PASS'
	  ELSE 'FAIL'
	  END PASS_FAIL
FROM
     [CDS2].[dbo].[Correlation] c
     INNER JOIN [CDS2].[dbo].[Component] d ON d.[FKPolicyId] = c.[Cds2ClientRecordId]
     INNER JOIN [CDS2].[dbo].[Insured] i ON i.[InsuredId] = d.[FKInsuredId]
     INNER JOIN [CDS2].[dbo].[Policy] b ON b.[PolicyId] = d.[FKPolicyId] AND b.[FKLogID] = d.[FKLogId]
     INNER JOIN [RcDb].[dbo].[AnnuityClientData] a ON a.[AnnuityClientDataId] = c.[RcdbClientRecordId]
     INNER JOIN [RcDb].[dbo].[AnnuityEscalationData] aed ON a.[AnnuityClientDataId] = aed.[FK_AnnuityClientDataId]
     INNER JOIN [CDS2].[dbo].[Datalog] dl ON d.[FKLogId] = dl.[LogID]
WHERE c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1047)
) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
DECLARE @FailOnlyInd INT = 1; 
 
WITH cte AS (
SELECT
	O_Movement_Transaction_Type,
	O_Reinsurance_Commencement_Date,
	i.[O_Life1_Full_Name],
	CASE WHEN O_Movement_Transaction_Type = 'NEWBU' THEN 
		CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
	ELSE 
		CONVERT(VARCHAR, O_Reinsurance_Commencement_Date, 103)
	END CalculatedDate,
	CASE WHEN 
		CASE WHEN O_Movement_Transaction_Type = 'NEWBU' THEN 
		CONVERT(VARCHAR, DATEADD(DAY, 1, EOMONTH(CONVERT(DATETIME, a.ReportPeriodEndingDate, 103), -1)), 103)
	ELSE 
		CONVERT(VARCHAR, O_Reinsurance_Commencement_Date, 103)
	END = O_Reinsurance_Commencement_Date THEN
		'PASS'
	ELSE
		'FAIL'
	END PASS_FAIL
FROM 
	[CDS2].[dbo].[Component] s
	inner join [CDS2].dbo.[Correlation] c on s.[FKPolicyId] = c.[Cds2ClientRecordId] and s.[fkLogId] = c.[Cds2LogId]
	inner join [CDS2].dbo.[policy] p on p.[PolicyId] = s.[FKPolicyId] AND p.FKLogID = s.FKLogId
	inner join [CDS2].dbo.[DataLog] a on s.[fkLogId] = a.[LogID]
	inner join [CDS2].[dbo].[Insured] i on i.[FKLogID] = a.[LogID]
WHERE c.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 1047)
) 
SELECT * FROM cte 
WHERE 
(@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL') 
