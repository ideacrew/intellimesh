# Intellimesh

## Tracked Events

1. We want to ensure that any tracked event publisher is required to be bound (entangled? paired?) with a corresponding status/response handler (whether provided by convention or auto-made and started by the mesh).  How do we implement this?
2. Should we use an 'always on' correlated subscriber/listener to process status responses, or create a 'one shot' queue?
   1. Full disclosure - I'm leaning more towards a long-lived correlated subscriber (Trey)
   2. For a 'one shot' - We'd have to create a custom throw-away queue, attach it for each message we broadcast, spawn another thread/process to watch/reap the queue which might not service restarts (especially over long lived service actions) and - ugh, I'm already talking myself out of it.  It sounds brittle and ugly.

## Active Job

1. Typically ActiveJob combines the code for both the publisher and the worker in the same class.  While you **can** run the subscriber and publisher on different servers - they will need to run the same **code**.
   1. What impact does this have on our desire to move to a pub/sub or microservice architecture?
   2. Is this a symmetry we should examine breaking, or develop a strategy to mitigate?

## Process Monitor

Right now we use Eye as our process monitor - but:
1. We don't have a well understood convention for how we break out our Rails Webapp/Listener workers
2. We don't offer any generators for the eye config to make the life of a DevOps person who may want to spin up different combinations of workers/subscribers/subscriber hosts easier