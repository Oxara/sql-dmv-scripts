-- Index Fragmante oran� %30 dan fazla oldu�u i�in bu index�i  ReBuild, az olanlar i�in ReOrganize yap�labilir
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

--Bir index�i reorganize etmek, clustered veya nonclustered Index�te bulunan leaf level page�lerin tekrardan fiziksel s�ralamaya sokulmas� demektir. 
--Bu da index �zerinde yap�lan sorgulamalar�n daha performansl� �al��mas�n� sa�lar. 
--Reorganize i�lemi s�ras�nda eski page�ler kullan�l�r ve yeni hi� bir page allocate edilmez. 
--Dolay�s�yla reorganize yapmak i�in ekstra bir disk alan�na ihtiya� duyulmaz.
--Reorganize minimum sistem kayna�� t�ketti�i ve online olarak yap�l�p blocking lere sebep olmad��� i�in 
--%30 dan az fragmante olmu� index�lerde kullan�m� tercih edilir.

--�rnek kullan�m� a�a��daki gibidir.

--Use AdventureWorks
--GO
--ALTER INDEX [PXML_Individual_Demographics]
--      ON [Sales].[Individual] REORGANIZE


--Rebuild Index
--Rebuild i�lemi asl�nda index�i drop edip tekrar create etmektir. 
--Dolay�s�yla fragmante tamamiyle kald�r�l�r ve index fill factor de�eri g�z �n�nde tutularak index page�leri tekrar allocate edilir. 
--Index row�lar� birbirini takip eden page�lerin i�ine s�ras�yla kay�t edilir. 
--Bu da bir index sorgulamas�nda gerekli kay�d� getirmek i�in daha az page okunaca��ndan dolay� performans art��� sa�lar.
--Tekrar bir index create i s�z konusu oldu�u i�in ekstra disk alan�na ihtiya� duymaktad�r.

--�rnek kullan�m� a�a��daki gibidir.

--ALTER INDEX [PXML_Individual_Demographics]
--      ON [Sales].[Individual]  REBUILD   WITH (ONLINE = ON)

 

 