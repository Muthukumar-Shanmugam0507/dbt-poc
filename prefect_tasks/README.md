## Helper package to run a mart model, as well as its predecessors

Creates a custom data structure to store mart dependency chains. <br>
Running a mart from the data structure also runs the preceding marts as needed. <br>
### Create All Marts
1. Create `DependencyManager` instance
2. Call `run_all_marts()` from the instance

This will start the process of building all marts, as long as `fbb_info_schema` is up-to-date

### Specific Mart Example
1. Create `DependencyManager` instance
2. Call `run_mart("fbb.fbb_active_products")` from the instance

- `fbb.` is needed at the start to specify the mart's folder
- Then, if the mart exists, it will start creating the predecessors from the beginning
- In this case: `fbb_daily_active_products` > `snapshot_fbb_active_products` > `fbb_active_products`