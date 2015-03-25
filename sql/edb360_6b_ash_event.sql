@@&&edb360_0g.tkprof.sql
DEF section_id = '6b';
DEF section_name = 'Active Session History (ASH) - Top Timed Events';
EXEC DBMS_APPLICATION_INFO.SET_MODULE('&&edb360_prefix.','&&section_id.');
SPO &&edb360_main_report..html APP;
PRO <h2>&&section_name.</h2>
SPO OFF;

DEF main_table = 'GV$ACTIVE_SESSION_HISTORY';
DEF slices = '15';
BEGIN
  :sql_text_backup := '
WITH
events AS (
SELECT /*+ &&sq_fact_hints. */
       CASE h.session_state WHEN ''ON CPU'' THEN h.session_state ELSE h.wait_class||'' "''||h.event||''"'' END timed_event,
       COUNT(*) samples
  FROM gv$active_session_history h
 WHERE ''&&diagnostics_pack.'' = ''Y''
   AND @filter_predicate@
 GROUP BY
       CASE h.session_state WHEN ''ON CPU'' THEN h.session_state ELSE h.wait_class||'' "''||h.event||''"'' END
 ORDER BY
       2 DESC
),
total AS (
SELECT SUM(samples) samples,
       SUM(CASE WHEN ROWNUM > &&slices. THEN samples ELSE 0 END) others
  FROM events
)
SELECT e.timed_event,
       e.samples,
       ROUND(100 * e.samples / t.samples, 1) percent,
       NULL dummy_01
  FROM events e,
       total t
 WHERE ROWNUM <= &&slices.
   AND ROUND(100 * e.samples / t.samples, 1) > 0.1
 UNION ALL
SELECT ''Others'',
       others samples,
       ROUND(100 * others / samples, 1) percent,
       NULL dummy_01
  FROM total
 WHERE others > 0
   AND ROUND(100 * others / samples, 1) > 0.1
';
END;
/

/*****************************************************************************************/

DEF skip_pch = '';
DEF title = 'ASH Top Timed Events for Cluster from MEM';
DEF title_suffix = '&&between_dates.';
--EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'CAST(h.sample_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - (1 / 24) AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', '1 = 1 /* all instances */');
@@edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE inst_id = 1;
DEF title = 'ASH Top Timed Events for Instance 1 from MEM';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.inst_id = 1');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE inst_id = 2;
DEF title = 'ASH Top Timed Events for Instance 2 from MEM';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.inst_id = 2');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE inst_id = 3;
DEF title = 'ASH Top Timed Events for Instance 3 from MEM';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.inst_id = 3');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE inst_id = 4;
DEF title = 'ASH Top Timed Events for Instance 4 from MEM';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.inst_id = 4');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE inst_id = 5;
DEF title = 'ASH Top Timed Events for Instance 5 from MEM';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.inst_id = 5');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE inst_id = 6;
DEF title = 'ASH Top Timed Events for Instance 6 from MEM';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.inst_id = 6');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE inst_id = 7;
DEF title = 'ASH Top Timed Events for Instance 7 from MEM';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.inst_id = 7');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE inst_id = 8;
DEF title = 'ASH Top Timed Events for Instance 8 from MEM';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.inst_id = 8');
@@&&skip_all.edb360_9a_pre_one.sql

/*****************************************************************************************/

DEF main_table = 'DBA_HIST_ACTIVE_SESS_HISTORY';
DEF slices = '15';
BEGIN
  :sql_text_backup := '
WITH
events AS (
SELECT /*+ &&sq_fact_hints. &&ds_hint. */
       CASE h.session_state WHEN ''ON CPU'' THEN h.session_state ELSE h.wait_class||'' "''||h.event||''"'' END timed_event,
       COUNT(*) samples
  FROM dba_hist_active_sess_history h,
       dba_hist_snapshot s
 WHERE ''&&diagnostics_pack.'' = ''Y''
   AND @filter_predicate@
   AND h.snap_id BETWEEN &&minimum_snap_id. AND &&maximum_snap_id.
   AND h.dbid = &&edb360_dbid.
   AND s.snap_id = h.snap_id
   AND s.dbid = h.dbid
   AND s.instance_number = h.instance_number
 GROUP BY
       CASE h.session_state WHEN ''ON CPU'' THEN h.session_state ELSE h.wait_class||'' "''||h.event||''"'' END
 ORDER BY
       2 DESC
),
total AS (
SELECT SUM(samples) samples,
       SUM(CASE WHEN ROWNUM > &&slices. THEN samples ELSE 0 END) others
  FROM events
)
SELECT e.timed_event,
       e.samples,
       ROUND(100 * e.samples / t.samples, 1) percent,
       NULL dummy_01
  FROM events e,
       total t
 WHERE ROWNUM <= &&slices.
   AND ROUND(100 * e.samples / t.samples, 1) > 0.1
 UNION ALL
SELECT ''Others'',
       others samples,
       ROUND(100 * others / samples, 1) percent,
       NULL dummy_01
  FROM total
 WHERE others > 0
   AND ROUND(100 * others / samples, 1) > 0.1
';
END;
/

/*****************************************************************************************/

DEF skip_pch = '';
DEF skip_all = '&&is_single_instance.';
DEF title = 'ASH Top Timed Events for Cluster for 1 day';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 1 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 1;
DEF title = 'ASH Top Timed Events for Instance 1 for 1 day';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 1 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 1 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 2;
DEF title = 'ASH Top Timed Events for Instance 2 for 1 day';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 2 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 1 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 3;
DEF title = 'ASH Top Timed Events for Instance 3 for 1 day';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 3 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 1 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 4;
DEF title = 'ASH Top Timed Events for Instance 4 for 1 day';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 4 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 1 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 5;
DEF title = 'ASH Top Timed Events for Instance 5 for 1 day';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 5 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 1 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 6;
DEF title = 'ASH Top Timed Events for Instance 6 for 1 day';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 6 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 1 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 7;
DEF title = 'ASH Top Timed Events for Instance 7 for 1 day';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 7 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 1 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 8;
DEF title = 'ASH Top Timed Events for Instance 8 for 1 day';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 8 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 1 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

/*****************************************************************************************/

DEF skip_pch = '';
DEF skip_all = '&&is_single_instance.';
DEF title = 'ASH Top Timed Events for Cluster for 5 working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 1;
DEF title = 'ASH Top Timed Events for Instance 1 for 5 working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 1 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 2;
DEF title = 'ASH Top Timed Events for Instance 2 for 5 working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 2 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 3;
DEF title = 'ASH Top Timed Events for Instance 3 for 5 working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 3 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 4;
DEF title = 'ASH Top Timed Events for Instance 4 for 5 working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 4 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 5;
DEF title = 'ASH Top Timed Events for Instance 5 for 5 working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 5 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 6;
DEF title = 'ASH Top Timed Events for Instance 6 for 5 working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 6 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 7;
DEF title = 'ASH Top Timed Events for Instance 7 for 5 working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 7 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 8;
DEF title = 'ASH Top Timed Events for Instance 8 for 5 working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 8 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

/*****************************************************************************************/

DEF skip_pch = '';
DEF skip_all = '&&is_single_instance.';
DEF title = 'ASH Top Timed Events for Cluster for 7 days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 1;
DEF title = 'ASH Top Timed Events for Instance 1 for 7 days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 1 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 2;
DEF title = 'ASH Top Timed Events for Instance 2 for 7 days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 2 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 3;
DEF title = 'ASH Top Timed Events for Instance 3 for 7 days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 3 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 4;
DEF title = 'ASH Top Timed Events for Instance 4 for 7 days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 4 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 5;
DEF title = 'ASH Top Timed Events for Instance 5 for 7 days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 5 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 6;
DEF title = 'ASH Top Timed Events for Instance 6 for 7 days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 6 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 7;
DEF title = 'ASH Top Timed Events for Instance 7 for 7 days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 7 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 8;
DEF title = 'ASH Top Timed Events for Instance 8 for 7 days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 8 AND CAST(s.end_interval_time AS DATE) BETWEEN TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'') - 7 AND TO_DATE(''&&tool_sysdate.'', ''YYYYMMDDHH24MISS'')');
@@&&skip_all.edb360_9a_pre_one.sql

/*****************************************************************************************/

DEF skip_pch = '';
DEF skip_all = '&&is_single_instance.';
DEF title = 'ASH Top Timed Events for Cluster for &&hist_work_days. working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 1;
DEF title = 'ASH Top Timed Events for Instance 1 for &&hist_work_days. working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 1 AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 2;
DEF title = 'ASH Top Timed Events for Instance 2 for &&hist_work_days. working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 2 AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 3;
DEF title = 'ASH Top Timed Events for Instance 3 for &&hist_work_days. working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 3 AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 4;
DEF title = 'ASH Top Timed Events for Instance 4 for &&hist_work_days. working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 4 AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 5;
DEF title = 'ASH Top Timed Events for Instance 5 for &&hist_work_days. working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 5 AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 6;
DEF title = 'ASH Top Timed Events for Instance 6 for &&hist_work_days. working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 6 AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 7;
DEF title = 'ASH Top Timed Events for Instance 7 for &&hist_work_days. working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 7 AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 8;
DEF title = 'ASH Top Timed Events for Instance 8 for &&hist_work_days. working days';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 8 AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''D'') BETWEEN ''2'' AND ''6'' AND TO_CHAR(CAST(s.end_interval_time AS DATE), ''HH24'') BETWEEN ''0730'' AND ''1930''');
@@&&skip_all.edb360_9a_pre_one.sql

/*****************************************************************************************/

DEF skip_pch = '';
DEF skip_all = '&&is_single_instance.';
DEF title = 'ASH Top Timed Events for Cluster for &&history_days. days of history';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', '1 = 1');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 1;
DEF title = 'ASH Top Timed Events for Instance 1 for &&history_days. days of history';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 1');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 2;
DEF title = 'ASH Top Timed Events for Instance 2 for &&history_days. days of history';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 2');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 3;
DEF title = 'ASH Top Timed Events for Instance 3 for &&history_days. days of history';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 3');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 4;
DEF title = 'ASH Top Timed Events for Instance 4 for &&history_days. days of history';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 4');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 5;
DEF title = 'ASH Top Timed Events for Instance 5 for &&history_days. days of history';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 5');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 6;
DEF title = 'ASH Top Timed Events for Instance 6 for &&history_days. days of history';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 6');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 7;
DEF title = 'ASH Top Timed Events for Instance 7 for &&history_days. days of history';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 7');
@@&&skip_all.edb360_9a_pre_one.sql

DEF skip_pch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM gv$instance WHERE instance_number = 8;
DEF title = 'ASH Top Timed Events for Instance 8 for &&history_days. days of history';
DEF title_suffix = '&&between_dates.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'h.instance_number = 8');
@@&&skip_all.edb360_9a_pre_one.sql

/*****************************************************************************************/

DEF skip_lch = 'Y';
DEF skip_pch = 'Y';