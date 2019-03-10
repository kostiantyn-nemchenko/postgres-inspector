\c sample

CREATE OR REPLACE FUNCTION pg_current_logfile_errors(logfile text DEFAULT pg_current_logfile())
    RETURNS RECORD AS
$$
    errors_count, corrupted_pages = 0, 0

    with open(logfile) as f:
        for line in f:
            if any(error in line for error in ['ERROR', 'FATAL', 'PANIC']):
                errors_count += 1
            if 'page verification failed' in line:
                corrupted_pages += 1

    return errors_count, corrupted_pages
$$
LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION pg_os_getloadavg()
    RETURNS RECORD AS
$$
    from os import getloadavg

    return getloadavg()
$$
LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION pg_psutil_cpu_times_percent(
    OUT "user" float,
    OUT system float,
    OUT idle float,
    OUT iowait float,
    OUT irqs float,
    OUT other float
) AS
$$
    from psutil import cpu_times_percent

    cpu_stats = cpu_times_percent()

    return cpu_stats.user, \
           cpu_stats.system, \
           cpu_stats.idle, \
           cpu_stats.iowait, \
           cpu_stats.irq + cpu_stats.softirq, \
           cpu_stats.steal + cpu_stats.guest + cpu_stats.guest_nice
$$
LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION pg_psutil_disk_io_counters(
    OUT read_bytes float,
    OUT write_bytes float
) AS
$$
    from psutil import disk_io_counters

    disk_io = disk_io_counters(perdisk=False)

    return disk_io.read_bytes, \
           disk_io.write_bytes
$$
LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION pg_psutil_net_io_counters(
    OUT sent_bytes float,
    OUT received_bytes float
) AS
$$
    from psutil import net_io_counters

    net_io = net_io_counters(pernic=False)

    return net_io.bytes_sent, \
           net_io.bytes_recv
$$
LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION pg_psutil_swap_memory(
	OUT total float,
    OUT used float,
    OUT free float,
    OUT percent float
) AS
$$
    from psutil import swap_memory

    sm = swap_memory()

    return sm.total, \
           sm.used, \
           sm.free, \
           sm.percent
$$
LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION pg_psutil_virtual_memory(
	OUT total float,
    OUT used float,
    OUT free float,
    OUT buffers_cached float,
    OUT available float,
    OUT percent float

) AS
$$
    from psutil import virtual_memory

    vm = virtual_memory()

    return vm.total, \
           vm.used, \
           vm.free, \
           vm.buffers + vm.cached, \
           vm.available, \
           vm.percent
$$
LANGUAGE plpython3u;