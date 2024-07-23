DECLARE @ExcludedSchemas TABLE (SchemaName NVARCHAR(128));
INSERT INTO @ExcludedSchemas VALUES ('Temp'), ('dbo'), ('Demo');

SELECT
    SchemaName = sh.name,
    TableName = o.name,
    ColumnName = s.name,

	DataType = CASE
		WHEN t.name IN ('char','varchar') THEN t.name+'('+CASE WHEN s.max_length<0 then 'MAX' ELSE CONVERT(varchar(10),s.max_length) END+')'
		WHEN t.name IN ('nvarchar','nchar') THEN t.name+'('+CASE WHEN s.max_length<0 then 'MAX' ELSE CONVERT(varchar(10),s.max_length/2) END+')'
		WHEN t.name IN ('numeric') THEN t.name+'('+CONVERT(varchar(10),s.precision)+','+CONVERT(varchar(10),s.scale)+')'
		ELSE t.name
	END,
	
	Nullable = CASE WHEN s.is_nullable=1 THEN 'NULL' ELSE 'NOT NULL' END 
     
FROM sys.columns s
	INNER JOIN sys.types t ON s.system_type_id=t.user_type_id and t.is_user_defined=0
	INNER JOIN sys.objects o ON s.object_id=o.object_id
	INNER JOIN sys.schemas sh on o.schema_id=sh.schema_id
 
WHERE O.name IN (select table_name from INFORMATION_SCHEMA.tables) 
  AND s.max_length < 0
  AND sh.name NOT IN (SELECT SchemaName FROM @ExcludedSchemas)
 
ORDER BY sh.name, o.name, s.column_id