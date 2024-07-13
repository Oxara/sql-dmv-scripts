-- Data Management View : Recommandation of Missing Indexes --
-- The missing index DMVs can give you a rough idea of the tables that may benefit most from index tuning, 
-- but you shouldn’t rely on them completely for designing indexes against a live database. 
-- The feature is just too limited.

--The missing index feature in SQL Server does NOT:
--	* Recommend key column order in an index (this is a big deal!)
--	* Make any recommendation for queries that qualify for ‘trivial’ optimization – which means you could miss some dead simple opportunities to speed up frequent queries
--	* Suggest filtered indexes, clustered indexes, column store indexes

SELECT
	-- Table Name --
	TableName = D.statement,

	-- Potential Indexes that wil be created
	D.equality_columns,		-- Equality is when you are looking for a specific value Ex: select * from users where username = 'Sach Vaidya'
	D.inequality_columns,	-- Inequality is used more for scan based queries, for example you may wish to list every user who is not in IT, 
							-- The key thing to remember here is that inequality means "not equal" so the query could contain <>, <, >
    D.included_columns,

	-- Stats why SQL Server thinks creating an index is a good idea
	S.user_scans,           -- Number of seeks caused by user queries that the recommended index in the group could have been used for.
	S.user_seeks,			-- Number of scans caused by user queries that the recommended index in the group could have been used for.

	-- Statistics on costs & cost savings
	S.avg_total_user_cost,  -- Average cost of the user queries that could be reduced by the index in the group.
	S.avg_user_impact,		-- Average percentage benefit that user queries could experience if this missing index group was implemented. 
							-- The value means that the query cost would on average drop by this percentage if this missing index group was implemented.

	AvarageCostSavings = ROUND(S.avg_total_user_cost * (S.avg_user_impact / 100.0), 3),
	TotalCostSavings   = ROUND(S.avg_total_user_cost * (S.avg_user_impact / 100.0) * (S.user_seeks + S.user_scans), 3)

FROM sys.dm_db_missing_index_groups G
 
	INNER JOIN sys.dm_db_missing_index_group_stats S ON S.group_handle = G.index_group_handle
	INNER JOIN sys.dm_db_missing_index_details D ON D.index_handle = G.index_handle

WHERE D.database_id = DB_ID()
ORDER BY user_seeks DESC, AvarageCostSavings DESC;
