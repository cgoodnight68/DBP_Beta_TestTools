require "tiny_tds"
require "pry"
database ="CDS2"
  @@sqlDB_host = "detd5080.hr-appltest.de"
      @@sqlDB_master=""
      @@sqlDB_tenant=""
      @@sqlUser ="svc_cdm"
      @@sqlPassword ="password"
     # query = "SET TEXTSIZE 2147483647;SET ANSI_DEFAULTS ON;"
   query = "DECLARE @FailOnlyInd INT = 1;  WITH cte AS (SELECT  	  I.[O_Life1_Full_Name]	, C.[O_Movement_Date]	, C.[O_Movement_Transaction_Type]	, A.[C_First_Payment_Date]	, A.[C_Payment_Status_Date]	, DL.[ReportPeriodEndingDate]	, CASE 		WHEN C.[O_Movement_Transaction_Type] = 'INST' THEN DL.ReportPeriodEndingDate 		WHEN C.[O_Movement_Transaction_Type] = 'NEWBU' THEN  A.[C_First_Payment_Date]		WHEN C.[O_Movement_Transaction_Type] = 'REFUND' THEN DL.ReportPeriodEndingDate 		WHEN C.[O_Movement_Transaction_Type] = 'SUSP' THEN A.[C_Payment_Status_Date]		WHEN C.[O_Movement_Transaction_Type] = 'UNSUS' THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, DL.ReportPeriodEndingDate), 0)		WHEN C.[O_Movement_Transaction_Type] = 'DEATH' THEN A.[C_Cease_Date]		WHEN C.[O_Movement_Transaction_Type] = 'CEASE' THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, DL.ReportPeriodEndingDate), 0) 		WHEN C.[O_Movement_Transaction_Type] = '' OR C.[O_Movement_Transaction_Type] = 'ERR' THEN null		ELSE convert(datetime,'1753-01-01',103) END Spock_Says_Logic_Clearly_Dictates	, CASE WHEN		 CASE 			WHEN C.[O_Movement_Transaction_Type] = 'INST' THEN DL.ReportPeriodEndingDate 			WHEN C.[O_Movement_Transaction_Type] = 'NEWBU' THEN  A.[C_First_Payment_Date]			WHEN C.[O_Movement_Transaction_Type] = 'REFUND' THEN DL.ReportPeriodEndingDate 			WHEN C.[O_Movement_Transaction_Type] = 'SUSP' THEN A.[C_Payment_Status_Date]			WHEN C.[O_Movement_Transaction_Type] = 'UNSUS' THEN  DATEADD(MONTH, DATEDIFF(MONTH, 0, DL.ReportPeriodEndingDate), 0) 			WHEN C.[O_Movement_Transaction_Type] = 'DEATH' THEN A.[C_Cease_Date]			WHEN C.[O_Movement_Transaction_Type] = 'CEASE' THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, DL.ReportPeriodEndingDate), 0)			WHEN C.[O_Movement_Transaction_Type] = '' OR C.[O_Movement_Transaction_Type] = 'ERR' THEN ''			ELSE  convert(datetime,'1753-01-01',103) END = C.[O_Movement_Date] THEN 'PASS' ELSE 'FAIL' END [PASS_FAIL]FROM	[CDS2].[dbo].[Correlation] cc	INNER JOIN [CDS2].[dbo].[Component] c ON c.[FKPolicyId] = cc.[Cds2ClientRecordId]	INNER JOIN [CDS2].[dbo].[Insured] i ON i.[InsuredId] = c.[FKInsuredId]	INNER JOIN [CDS2].[dbo].[Policy] p ON p.[PolicyId] = c.[FKPolicyId] AND p.[FKLogID] = c.[FKLogId]	INNER JOIN [CDS2].[dbo].[Datalog] DL ON C.[FKLogId] = DL.[LogID]	INNER JOIN [RcDb].[dbo].[AnnuityClientData] a ON a.[AnnuityClientDataId] = cc.[RcdbClientRecordId]	INNER JOIN [RcDb].[dbo].[AnnuityEscalationData] aed ON a.[AnnuityClientDataId] = aed.[FK_AnnuityClientDataId]WHERE cc.[RcDbLogId] = (SELECT [RcdbClientLogId] FROM [Zenith].[dbo].[ReportingPeriodLog] WHERE [ReportingPeriodLogId] = 543)) SELECT * FROM cte WHERE (@FailOnlyInd = 0 OR PASS_FAIL = 'FAIL')"
     client = TinyTds::Client.new username: "#{@@sqlUser}", password: "#{@@sqlPassword}", dataserver: "#{@@sqlDB_host}", database: "#{database}" , timeout: 60
   client.execute('SET TEXTSIZE 2147483647;').do
     client.execute('SET ANSI_DEFAULTS ON;').do
    client.execute('SET QUOTED_IDENTIFIER ON;').do
    client.execute('SET DATEFORMAT DMY')
  #  client.execute('SET CURSOR_CLOSE_ON_COMMIT OFF;').do
  #  client.execute('SET IMPLICIT_TRANSACTIONS OFF;').do
   binding.pry
 results = client.execute(query)
