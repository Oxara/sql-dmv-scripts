DECLARE views_cursor CURSOR FOR
SELECT name FROM sysobjects WHERE type = 'V'

OPEN views_cursor

DECLARE @view NVARCHAR(500)
FETCH NEXT FROM views_cursor INTO @view
WHILE @@FETCH_STATUS = 0
BEGIN
	BEGIN TRY
		EXEC sp_refreshview @view
		PRINT 'VIEW NAME: ' + @view + ', STATE: SUCCESS'
	END TRY
	BEGIN CATCH
		PRINT 'VIEW NAME: ' + @view + 
		      ', ERROR NUMBER: ' + Cast(ERROR_NUMBER() as VARCHAR) + 
		      ', ERROR MESSAGE: ' + ERROR_MESSAGE()
	END CATCH
	
	FETCH NEXT FROM views_cursor INTO @view
END

CLOSE views_cursor
DEALLOCATE views_cursor