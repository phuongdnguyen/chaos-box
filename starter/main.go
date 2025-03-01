package main

import (
	"context"
	"fmt"
	"log"
	"sync"

	"go.temporal.io/sdk/client"
)

func main() {
	// Create a Temporal client
	c, err := client.Dial(client.Options{})
	if err != nil {
		log.Fatalf("Failed to create Temporal client: %v", err)
	}
	defer c.Close()

	var wg sync.WaitGroup
	for i := 0; i < 10000; i++ {
		wg.Add(1)
		go func(i int) {
			defer wg.Done()
			workflowID := fmt.Sprintf("workflow-1-%d", i)
			workflowOptions := client.StartWorkflowOptions{
				ID:        workflowID,
				TaskQueue: "my-task-queue",
			}

			we, err := c.ExecuteWorkflow(context.Background(), workflowOptions, "MyWorkflow")
			if err != nil {
				log.Printf("Failed to start workflow %d: %v", i, err)
			} else {
				log.Printf("Started workflow %d with RunID: %s", i, we.GetRunID())
			}
		}(i)
	}
	wg.Wait()
}
