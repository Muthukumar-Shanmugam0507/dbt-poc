from prefect import flow
from prefect_dbt.cli.commands import DbtCoreOperation
from pathlib import Path

product_data = Path(__file__).parent.parent.parent / 'product_data'


@flow(flow_run_name="{mart}")
def trigger_run_flow(mart: str) -> str:
    """Runs a mart model with Prefect and gives the mart's name as flow name"""
    result = DbtCoreOperation(
        commands=["dbt run -s product_data.marts." + mart + " --target dev"],
        profiles_dir=product_data,
        project_dir=product_data
    ).run()
    return result


@flow(flow_run_name="{snapshot}")
def trigger_snapshot_flow(snapshot: str) -> str:
    """Runs a snapshot with Prefect and gives the snapshot's name as flow name"""
    result = DbtCoreOperation(
        commands=["dbt snapshot -s " + snapshot + " --target dev"],
        profiles_dir=product_data,
        project_dir=product_data
    ).run()
    return result


@flow(flow_run_name="update-testing")
def trigger_test_flow() -> str:
    """Runs the dbt test and raises an exception if it fails"""
    result = DbtCoreOperation(
        commands=["dbt test --target dev"],
        profiles_dir=product_data,
        project_dir=product_data
    ).run()
    return result
