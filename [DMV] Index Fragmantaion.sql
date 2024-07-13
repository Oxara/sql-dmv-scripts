-- Index Fragmante oraný %30 dan fazla olduðu için bu index’i  ReBuild, az olanlar için ReOrganize yapýlabilir
SELECT ps.object_id,
       i.name as IndexName,
       OBJECT_SCHEMA_NAME(ps.object_id) as ObjectSchemaName,
       OBJECT_NAME (ps.object_id) as ObjectName,
       ps.avg_fragmentation_in_percent

  FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED') ps
    INNER JOIN sys.indexes i ON i.object_id=ps.object_id and i.index_id=ps.index_id
    WHERE avg_fragmentation_in_percent > 5 AND ps.index_id > 0
    ORDER BY avg_fragmentation_in_percent desc

--Reorganize Index

--Bir index’i reorganize etmek, clustered veya nonclustered Index’te bulunan leaf level page’lerin tekrardan fiziksel sýralamaya sokulmasý demektir. 
--Bu da index üzerinde yapýlan sorgulamalarýn daha performanslý çalýþmasýný saðlar. 
--Reorganize iþlemi sýrasýnda eski page’ler kullanýlýr ve yeni hiç bir page allocate edilmez. 
--Dolayýsýyla reorganize yapmak için ekstra bir disk alanýna ihtiyaç duyulmaz.
--Reorganize minimum sistem kaynaðý tükettiði ve online olarak yapýlýp blocking lere sebep olmadýðý için 
--%30 dan az fragmante olmuþ index’lerde kullanýmý tercih edilir.

--Örnek kullanýmý aþaðýdaki gibidir.

--Use AdventureWorks
--GO
--ALTER INDEX [PXML_Individual_Demographics]
--      ON [Sales].[Individual] REORGANIZE


--Rebuild Index
--Rebuild iþlemi aslýnda index’i drop edip tekrar create etmektir. 
--Dolayýsýyla fragmante tamamiyle kaldýrýlýr ve index fill factor deðeri göz önünde tutularak index page’leri tekrar allocate edilir. 
--Index row’larý birbirini takip eden page’lerin içine sýrasýyla kayýt edilir. 
--Bu da bir index sorgulamasýnda gerekli kayýdý getirmek için daha az page okunacaðýndan dolayý performans artýþý saðlar.
--Tekrar bir index create i söz konusu olduðu için ekstra disk alanýna ihtiyaç duymaktadýr.

--Örnek kullanýmý aþaðýdaki gibidir.

--ALTER INDEX [PXML_Individual_Demographics]
--      ON [Sales].[Individual]  REBUILD   WITH (ONLINE = ON)

 

 