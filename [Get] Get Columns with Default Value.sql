SELECT 
    s.name AS SchemaName,
    t.name AS TableName,
    c.name AS ColumnName,
    d.definition AS DefaultValue
FROM 
    sys.schemas s
    INNER JOIN sys.tables t ON s.schema_id = t.schema_id
    INNER JOIN sys.columns c ON t.object_id = c.object_id
    INNER JOIN sys.default_constraints d ON c.default_object_id = d.object_id
ORDER BY 
    s.name, t.name, c.name;