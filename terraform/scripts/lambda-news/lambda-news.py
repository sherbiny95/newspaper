import json
import boto3
import os
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['DYNAMODB_TABLE'] 
table = dynamodb.Table(table_name)

def get_news():
    try:
        response = table.scan()
        items = response.get('Items', [])
        return {
            'statusCode': 200,
            'body': json.dumps(items)
        }
    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps('Internal Server Error')
        }

def post_news(body):
    try:
        news_item = json.loads(body)
        if 'date' not in news_item or 'title' not in news_item or 'description' not in news_item:
            return {
                'statusCode': 400,
                'body': json.dumps('Invalid JSON format')
            }
        
        table.put_item(Item=news_item)
        
        return {
            'statusCode': 201,
            'body': json.dumps('News item added')
        }
    except (ClientError, ValueError) as e:
        return {
            'statusCode': 500,
            'body': json.dumps('Internal Server Error')
        }
    
def lambda_handler(event, context):
    http_method = event['httpMethod']
    path = event['path']
    
    if http_method == 'GET' and path == '/news':
        return get_news()
    elif http_method == 'POST' and :
        return post_news(event['body'])
    else:
        return {
            'statusCode': 404,
            'body': json.dumps('Method and Path combination not found')
        }


