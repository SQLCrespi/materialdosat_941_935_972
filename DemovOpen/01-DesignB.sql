/*Demo 1/B - Suporte
Data da criaçao: 25/09/2020
Desenvolvedor: Rodrigo Crespi
Objetivo: Suporte... limpeza de cache, conte�do ...
*/


--Limpa o cache
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;

--Conte�do do cache
SELECT    objtype AS "TipoNoCache", COUNT_BIG(*) "Total de Planos",
          SUM(CAST(size_in_bytes AS DECIMAL(18, 2))) / 1024 / 1024 AS "Total MBs", AVG(usecounts) AS "M�diaUso",
          SUM(CAST((CASE WHEN usecounts = 1 THEN size_in_bytes ELSE 0 END) AS DECIMAL(18, 2))) / 1024 / 1024 AS "Total MBs - use cont 1",
          SUM(CASE WHEN usecounts = 1 THEN 1 ELSE 0 END) AS "Total de Planos - Use count 1"
FROM      sys.dm_exec_cached_plans
GROUP BY  objtype
ORDER BY  [Total MBs - use cont 1] DESC;


--Mostra as queries marcadas
SELECT      CAST(total_elapsed_time / 1000000.0 AS DECIMAL(28, 2)) AS [Total Duration (s)],
            CAST(total_worker_time * 100.0 / total_elapsed_time AS DECIMAL(28, 2)) AS [% CPU],
            CAST((total_elapsed_time - total_worker_time) * 100.0 / total_elapsed_time AS DECIMAL(28, 2)) AS [% Waiting],
            execution_count,
            CAST(total_elapsed_time / 1000000.0 / execution_count AS DECIMAL(28, 2)) AS [Average Duration (s)],
            SUBSTRING(qt.text,
                      (qs.statement_start_offset / 2) + 1,
                      ((CASE
                          WHEN qs.statement_end_offset = -1 THEN
                            LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
                          ELSE
                            qs.statement_end_offset
                        END - qs.statement_start_offset) / 2) + 1) AS [Individual Query],
            SUBSTRING(qt.text, 1, 100) AS [Parent Query], DB_NAME(CAST(pa.value AS INT)) AS [Database]
FROM        sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
CROSS APPLY sys.dm_exec_plan_attributes(qs.plan_handle) AS pa
WHERE       total_elapsed_time > 0
            AND pa.attribute = 'dbid'
            AND DB_NAME(CAST(pa.value AS INT)) = 'tsql'
ORDER BY    total_elapsed_time DESC;