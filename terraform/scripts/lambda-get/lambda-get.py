import json
import boto3
import os
from botocore.exceptions import ClientError
import logging

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['DYNAMODB_TABLE'] 
table = dynamodb.Table(table_name)

logger = logging.getLogger()
logger.setLevel(logging.INFO) 

def get_news():
    try:
        response = table.scan()
        items = response.get('Items', [])
        return {
            'statusCode': 200,
            'body': json.dumps(items)
        }
    except ClientError as e:
        logger.error(f"Error in get_news: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps('Internal Server Error')
        }
    
def lambda_handler(event, context):
    http_method = event['httpMethod']
    path = event['path']
    
    if http_method == 'GET' and path == '/news':
        return get_news()
    else:
        return {
            'statusCode': 404,
            'body': json.dumps('Method and Path combination not found')
        }
