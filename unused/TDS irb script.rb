 require "tiny_tds"
 @@sqlDB_host="dexd5180.hr-applprep.de"
      @@sqlDB_master=""
      @@sqlDB_tenant=""
      @@sqlUser ="svc_cdm"
      @@sqlPassword ="eFDqHNhPtW"
      query = "select * from [Zenith].[dbo].[ReportingPeriodLog] where name = 'Test1873'"
   database = "Zenith"
client = TinyTds::Client.new username: "#{@@sqlUser}", password: "#{@@sqlPassword}", dataserver: "#{@@sqlDB_host}", database: "#{database}" , timeout: 600
results = client.execute(query)