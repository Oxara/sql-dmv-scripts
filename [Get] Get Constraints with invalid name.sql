SELECT * FROM(
	SELECT 
		SchemaName = t.TABLE_SCHEMA, 
		TableName = t.TABLE_NAME, 
		ColumnName = c.COLUMN_NAME,
		CurrentConstraintName = ISNULL(dc.name, 'No Default Constraint'),
		ExpectedConsraintNane = 'DF_' + t.TABLE_NAME + '_' + c.COLUMN_NAME
	FROM 
		INFORMATION_SCHEMA.COLUMNS c
		INNER JOIN INFORMATION_SCHEMA.TABLES t ON c.TABLE_NAME = t.TABLE_NAME AND c.TABLE_SCHEMA = t.TABLE_SCHEMA
		LEFT JOIN sys.columns sc ON sc.name = c.COLUMN_NAME AND sc.object_id = OBJECT_ID(QUOTENAME(t.TABLE_SCHEMA) + '.' + QUOTENAME(t.TABLE_NAME))
		LEFT JOIN sys.default_constraints dc ON dc.parent_column_id = sc.column_id AND dc.parent_object_id = sc.object_id
	WHERE  t.TABLE_TYPE = 'BASE TABLE'
) AS TMP

WHERE TMP.CurrentConstraintName <> 'No Default Constraint' 
  AND  TMP.CurrentConstraintName <> TMP.ExpectedConsraintNane

ORDER BY 
    TMP.SchemaName,
	TMP.TableName
