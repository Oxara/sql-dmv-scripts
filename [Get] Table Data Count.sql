SELECT SchemaName = S.name,
	   TableName = T.name,
	   NumberOfRows = I.Rows 

FROM sys.tables T
	JOIN sys.sysindexes I ON T.object_id = I.id
	JOIN sys.schemas S ON T.schema_id = S.schema_id

WHERE indid IN (0,1)

ORDER BY I.Rows DESC, T.name