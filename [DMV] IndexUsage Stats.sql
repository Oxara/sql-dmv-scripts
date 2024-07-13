-- Index Kullaným Oranlarý
SELECT schemaname = sh.name,
       objectname = object_name(s.object_id), 
	   indexname = i.name, 
	   i.index_id,
       reads = user_seeks + user_scans + user_lookups, 
	   writes =  user_updates

  FROM sys.dm_db_index_usage_stats AS s, sys.indexes AS i
	INNER JOIN sys.tables t ON i.object_id = t.object_id 
	INNER JOIN sys.schemas sh on t.schema_id = sh.schema_id

 WHERE objectproperty(s.object_id,'IsUserTable') = 1
   AND s.object_id = i.object_id
   AND i.index_id = s.index_id
   AND s.database_id = db_id()
 ORDER BY object_name(s.object_id), writes DESC, reads DESC;