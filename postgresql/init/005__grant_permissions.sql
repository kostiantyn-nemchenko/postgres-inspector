\c sample

GRANT EXECUTE ON FUNCTION pg_current_logfile() TO sql_exporter;
GRANT EXECUTE ON FUNCTION pg_hba_file_rules() TO sql_exporter;
GRANT SELECT ON TABLE pg_hba_file_rules TO sql_exporter;

DO $$
DECLARE
    sch text;
BEGIN
    FOR sch IN SELECT nspname FROM pg_namespace 
    LOOP
        EXECUTE format('GRANT USAGE ON SCHEMA %I TO sql_exporter', sch);
    END LOOP;
END;
$$;

ALTER DEFAULT PRIVILEGES GRANT USAGE ON SCHEMAS TO sql_exporter;