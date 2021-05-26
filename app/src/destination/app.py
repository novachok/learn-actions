import json
import os
import boto3


def handler(event, context):
    msg = {
        'data': 'hello world'
    }
    client = boto3.client('sqs')
    client.send_message(
        QueueUrl=os.environ.get('QUEUE_URL'),
        MessageBody=json.dumps(msg)
    )
    return json.dumps({
        'statusCode': 200,
        'body': json.dumps(msg)
    })
