import json

def handler(event, context):
    return json.dumps({
        'statusCode': 200,
        'body': '{"hello": "world"}'
    })
    