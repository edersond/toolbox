--#########################################
--Retorna o DDL de uma tabela (postgres)
--#########################################


CREATE OR REPLACE FUNCTION get_table_ddl(
    p_schema_name TEXT,
    p_table_name TEXT
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_ddl TEXT;
BEGIN
    SELECT string_agg(sql, E'\n') INTO v_ddl FROM (
    -- Table DDL
    SELECT
        'CREATE TABLE ' || quote_ident(p_schema_name) || '.' || quote_ident(p_table_name) || ' (' || E'\n' ||
        string_agg(
            '    ' || column_name || ' ' || data_type ||
            CASE
                WHEN character_maximum_length IS NOT NULL THEN '(' || character_maximum_length || ')'
                ELSE ''
            END ||
            CASE
                WHEN is_nullable = 'NO' THEN ' NOT NULL'
                ELSE ''
            END ||
            CASE
                WHEN column_default IS NOT NULL THEN ' DEFAULT ' || column_default
                ELSE ''
            END
            , E',\n')
            || E'\n' || ');' as sql
    FROM information_schema.columns
    WHERE table_schema = p_schema_name
    AND table_name = p_table_name
    GROUP BY table_schema, table_name

    UNION ALL
    -- Primary key constraint
    SELECT
        'ALTER TABLE ' || quote_ident(p_schema_name) || '.' || quote_ident(p_table_name) || ' ADD CONSTRAINT ' ||
        quote_ident(con.conname) || ' ' || pg_get_constraintdef(con.oid) || ';'
    FROM pg_constraint con
    JOIN pg_class rel ON con.conrelid = rel.oid
    JOIN pg_namespace nsp ON nsp.oid = connamespace
    WHERE rel.relname = p_table_name
    AND nsp.nspname = p_schema_name
    AND con.contype = 'p'
    UNION ALL
    -- Unique constraints
        SELECT
        'ALTER TABLE ' || quote_ident(p_schema_name) || '.' || quote_ident(p_table_name) || ' ADD CONSTRAINT ' ||
        quote_ident(con.conname) || ' ' || pg_get_constraintdef(con.oid) || ';'
    FROM pg_constraint con
    JOIN pg_class rel ON con.conrelid = rel.oid
    JOIN pg_namespace nsp ON nsp.oid = connamespace
    WHERE rel.relname = p_table_name
    AND nsp.nspname = p_schema_name
    AND con.contype = 'u'
     UNION ALL
    -- Foreign key constraints
        SELECT
        'ALTER TABLE ' || quote_ident(p_schema_name) || '.' || quote_ident(p_table_name) || ' ADD CONSTRAINT ' ||
        quote_ident(con.conname) || ' ' || pg_get_constraintdef(con.oid) || ';'
    FROM pg_constraint con
    JOIN pg_class rel ON con.conrelid = rel.oid
    JOIN pg_namespace nsp ON nsp.oid = connamespace
    WHERE rel.relname = p_table_name
    AND nsp.nspname = p_schema_name
    AND con.contype = 'f'
    UNION ALL
    -- Indexes
    SELECT
    'CREATE ' ||
        CASE WHEN ind.indisunique THEN 'UNIQUE ' ELSE '' END ||
        'INDEX ' || quote_ident(indexname) || ' ON ' ||
        quote_ident(p_schema_name) || '.' || quote_ident(p_table_name) || ' ' ||
        pg_get_indexdef(indexrelid) || ';'
    FROM
    pg_indexes idx
    JOIN pg_index ind ON idx.indexname = ind.indexrelid::regclass::text
    WHERE tablename = p_table_name AND schemaname= p_schema_name
    ) as sub;
    RETURN v_ddl;
END;
$$;
