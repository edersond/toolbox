--#########################################
--Retorna o DDL de uma materialized view (postgres)
--#########################################

CREATE OR REPLACE FUNCTION get_materialized_view_ddl(
     p_schema_name TEXT,
    p_matview_name TEXT
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_ddl TEXT;
BEGIN
    SELECT string_agg(sql, E'\n') INTO v_ddl FROM (
        -- Materialized view DDL
    SELECT
        'CREATE MATERIALIZED VIEW ' || quote_ident(p_schema_name) || '.' || quote_ident(p_matview_name) || E'\n' ||
        CASE WHEN m.tablespace is not null THEN 'TABLESPACE ' || quote_ident(m.tablespace) || E'\n' ELSE '' END ||
        'AS ' || pg_get_viewdef( (p_schema_name||'.'||p_matview_name)::regclass, true) || E'\n' ||
        CASE WHEN m.ispopulated THEN 'WITH DATA' ELSE 'WITH NO DATA' END as sql
    FROM pg_matviews m
    JOIN pg_namespace n ON n.oid = m.schemaname::regnamespace
    WHERE m.matviewname = p_matview_name
    AND n.nspname = p_schema_name
    UNION ALL
    -- Indexes
    SELECT
    'CREATE ' ||
        CASE WHEN ind.indisunique THEN 'UNIQUE ' ELSE '' END ||
        'INDEX ' || quote_ident(indexname) || ' ON ' ||
        quote_ident(p_schema_name) || '.' || quote_ident(p_matview_name) || ' ' ||
        pg_get_indexdef(indexrelid) || ';'
    FROM
    pg_indexes idx
    JOIN pg_index ind ON idx.indexname = ind.indexrelid::regclass::text
    WHERE tablename = p_matview_name AND schemaname= p_schema_name
    ) as sub;
    RETURN v_ddl;
END;
$$;
