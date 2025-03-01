workflow_list=$(tctl workflow list --pagesize 1000  --open | awk '{print $3}' | tail -n +2)
for workflow in $workflow_list
  do
    echo "clean up $workflow"
    tctl workflow terminate  --workflow_id $workflow
  done

# SELECT * from temporal.executions WHERE namespace_id=bf026cb5-b71b-48e7-8494-0e74e5a5232c AND workflow_id='workflow-1740645953203354000-474' AND type=1;


# DELETE FROM temporal.executions WHERE shard_id=2 AND namespace_id=bf026cb5-b71b-48e7-8494-0e74e5a5232c AND workflow_id='workflow-1740645953203354000-474' AND type=1 AND run_id=30000000-0000-f000-f000-000000000001 AND visibility_ts='2000-01-01' AND task_id=-10 IF current_run_id=6e3945fb-c8f4-497d-a475-a1e2bb4719ee;