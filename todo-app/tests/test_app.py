import pytest
from moto import mock_aws
import boto3
import app


@mock_aws
def test_add_and_delete_task():
    # Create mock DynamoDB table
    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.create_table(
        TableName="todo",
        KeySchema=[{"AttributeName": "id", "KeyType": "HASH"}],
        AttributeDefinitions=[{"AttributeName": "id", "AttributeType": "S"}],
        BillingMode="PAY_PER_REQUEST",
    )

    # Add task
    with app.app.test_client() as client:
        response = client.post("/add", data={"task": "Test task"})
        assert response.status_code == 302  # redirect

    # Verify item in table
    items = list(table.scan().get("Items", []))
    assert any(i["task"] == "Test task" for i in items)

    # Delete task
    task_id = items[0]["id"]
    with app.app.test_client() as client:
        response = client.get(f"/delete/{task_id}")
        assert response.status_code == 302

    # Verify item removed
    items_after = list(table.scan().get("Items", []))
    assert not any(i["id"] == task_id for i in items_after)
