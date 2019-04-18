FROM postgres:11

RUN set -ex; \
	apt-get -qq update; \
	apt-get install -qq -y --no-install-recommends \
			postgresql-plpython3-11 \
			postgresql-11-pg-stat-kcache \
			python3-psutil; \
	rm -rf /var/lib/apt/lists/*;

RUN sed -i -e "s/#shared_preload_libraries = ''/shared_preload_libraries = 'pg_stat_statements,pg_stat_kcache'/g" \
		   -e "s/#logging_collector = off/logging_collector = on/g" \
		   -e "s/#track_io_timing = off/track_io_timing = on/g" \
		   -e "s/#track_functions = none/track_functions = pl/g" /usr/share/postgresql/postgresql.conf.sample