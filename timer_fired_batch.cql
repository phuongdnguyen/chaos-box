BEGIN BATCH
--     update current execution
--     update execution
--     delete fired timer in execution
--     create transfer task
--     create timer task (schedule to start timeout) for this transfer task
--     verify still have the lease


-- update current execution
UPDATE temporal.executions USING TTL 0
SET current_run_id = '9dcc1140-afa5-4f41-9b6a-2030dec81551', execution_state = '[10 36 49 97 99 97 99 53 54 53 45 98 50 100 57 45 52 101 100 102 45 97 48 99 51 45 49 49 48 51 101 54 50 49 52 99 97 48 18 36 57 100 99 99 49 49 52 48 45 97 102 97 53 45 52 102 52 49 45 57 98 54 97 45 50 48 51 48 100 101 99 56 49 53 53 49 24 2 32 1]', execution_state_encoding = 'Proto3', workflow_last_write_version = 0, workflow_state = 'Running'
WHERE shard_id = 2 AND type = 1 AND namespace_id = '0e6dca44-271a-405e-9ab1-b757ed5ab31a' AND workflow_id = 'foo' AND run_id = '30000000-0000-f000-f000-000000000001' AND visibility_ts = 946684800000 AND task_id = -10
    IF current_run_id = '9dcc1140-afa5-4f41-9b6a-2030dec81551';

--  update execution
UPDATE temporal.executions
SET execution = '[10 36 48 101 54 100 99 97 52 52 45 50 55 49 97 45 52 48 53 101 45 57 97 98 49 45 98 55 53 55 101 100 53 97 98 51 49 97 18 3 102 111 111 74 13 109 121 45 116 97 115 107 45 113 117 101 117 101 82 10 77 121 87 111 114 107 102 108 111 119 90 0 98 0 106 2 8 10]', execution_encoding = 'Proto3', execution_state = '[10 36 49 97 99 97 99 53 54 53 45 98 50 100 57 45 52 101 100 102 45 97 48 99 51 45 49 49 48 51 101 54 50 49 52 99 97 48 18 36 57 100 99 99 49 49 52 48 45 97 102 97 53 45 52 102 52 49 45 57 98 54 97 45 50 48 51 48 100 101 99 56 49 53 53 49 24 2 32 1]', execution_state_encoding = 'Proto3', next_event_id = 8, db_record_version = 5, checksum = '[]', checksum_encoding = 'Proto3'
WHERE shard_id = 2 AND type = 1 AND namespace_id = '0e6dca44-271a-405e-9ab1-b757ed5ab31a' AND workflow_id = 'foo' AND run_id = '9dcc1140-afa5-4f41-9b6a-2030dec81551' AND visibility_ts = 946684800000 AND task_id = -10
    IF db_record_version = 4;

-- delete timer in timer info table
DELETE timer_map[5] FROM temporal.executions
WHERE shard_id = 2 AND type = 1 AND namespace_id = '0e6dca44-271a-405e-9ab1-b757ed5ab31a' AND workflow_id = 'foo' AND run_id = '9dcc1140-afa5-4f41-9b6a-2030dec81551' AND visibility_ts = 946684800000 AND task_id = -10;

-- create timer task (schedule to start timeout) for this transfer task
INSERT INTO temporal.executions (shard_id, type, namespace_id, workflow_id, run_id, timer, timer_encoding, visibility_ts, task_id)
-- VALUES (2, 3, '10000000-4000-f000-f000-000000000000', '20000000-4000-f000-f000-000000000000', '30000000-4000-f000-f000-000000000000', '[10 36 48 101 54 100 99 97 52 52 45 50 55 49 97 45 52 48 53 101 45 57 97 98 49 45 98 55 53 55 101 100 53 97 98 51 49 97 18 3 102 111 111]', 'Proto3', 1740757517313, 3145776);

-- create a transfer task
INSERT INTO temporal.executions (shard_id, type, namespace_id, workflow_id, run_id, transfer, transfer_encoding, visibility_ts, task_id)
VALUES (2, 2, '10000000-3000-f000-f000-000000000000', '20000000-3000-f000-f000-000000000000', '30000000-3000-f000-f000-000000000000', '[10 36 48 101 54 100 99 97 52 52 45 50 55 49 97 45 52 48 53 101 45 57 97 98 49 45 98 55 53 55 101 100 53 97 98 51 49 97 18 3 102 111 111]', 'Proto3', 946684800000, 3145777);

-- verify still have the lease
UPDATE temporal.executions
SET range_id = 3
WHERE shard_id = 2 AND type = 0 AND namespace_id = '10000000-1000-f000-f000-000000000000' AND workflow_id = '20000000-1000-f000-f000-000000000000' AND run_id = '30000000-1000-f000-f000-000000000000' AND visibility_ts = 946684800000 AND task_id = -11
    IF range_id = 3;

APPLY BATCH;
