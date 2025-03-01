package main

import (
	"log"
	"time"

	"go.temporal.io/sdk/client"
	"go.temporal.io/sdk/worker"
	"go.temporal.io/sdk/workflow"
)

// MyWorkflow defines a workflow that waits for 5 seconds and continues as new
func MyWorkflow(ctx workflow.Context) error {
	logger := workflow.GetLogger(ctx)
	logger.Info("Workflow started")

	// Sleep for 1 minute
	sleepDuration := 1 * time.Minute
	f := workflow.NewTimer(ctx, sleepDuration)
	s := workflow.NewSelector(ctx)
	s.AddFuture(f, func(f workflow.Future) {
		_ = f.Get(ctx, nil)
	})
	s.Select(ctx)

	logger.Info("Timer completed, continuing as new")

	// Continue as new
	return workflow.NewContinueAsNewError(ctx, MyWorkflow)
}

func main() {
	// Create a Temporal client
	c, err := client.Dial(client.Options{})
	if err != nil {
		log.Fatalf("Failed to create Temporal client: %v", err)
	}
	defer c.Close()

	// Create a worker that listens to a task queue
	w := worker.New(c, "my-task-queue", worker.Options{
		MaxConcurrentWorkflowTaskPollers: 20,
		MaxConcurrentActivityTaskPollers: 20,
	})

	// Register the workflow with the worker
	w.RegisterWorkflow(MyWorkflow)

	// Start the worker
	err = w.Run(worker.InterruptCh())
	if err != nil {
		log.Fatalf("Failed to start worker: %v", err)
	}
}
