SELECT 
     SchemaName = sh.name,
     TableName = t.name,
     IndexName = ind.name,
     ColumnId = ic.index_column_id,
     ColumnName = col.name,
	 Clustared = ind.type_desc

FROM sys.indexes ind 
	INNER JOIN sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
	INNER JOIN sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
	INNER JOIN sys.tables t ON ind.object_id = t.object_id 
	INNER JOIN sys.schemas sh on t.schema_id = sh.schema_id

WHERE t.Name NOT IN ('sysdiagrams')
ORDER BY t.name, ind.name