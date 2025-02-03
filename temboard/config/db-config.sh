#!/usr/bin/env bash


	psql -v ON_ERROR_STOP=1 -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;"

	
