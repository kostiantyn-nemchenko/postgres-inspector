\c sample

GRANT EXECUTE ON FUNCTION pg_current_logfile() TO sql_exporter;
GRANT EXECUTE ON FUNCTION pg_hba_file_rules() TO sql_exporter;
GRANT SELECT ON TABLE pg_hba_file_rules TO sql_exporter;