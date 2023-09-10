import json
import pytest
import sys
import os
from botocore.stub import Stubber

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'lambda-news')))
import lambda_news

@pytest.fixture
def lambda_event():
    return {
        'httpMethod': '',
        'path': ''
    }

def test_get_news(lambda_event):
    dynamodb_response = {
        'Items': [{'Title': 'NewsGet', 'date': '2023-09-10', 'description': 'stuff'}]
    }

    with Stubber(lambda_news.dynamodb.meta.client) as stubber:
        stubber.add_response('scan', dynamodb_response)

        response = lambda_news.lambda_handler(lambda_event, None)

    assert response['statusCode'] == 200
    assert 'NewsGet' in response['body']

def test_post_news_existing_title(lambda_event):
    lambda_event['httpMethod'] = 'POST'
    lambda_event['body'] = json.dumps({'Title': 'NewsPostExist', 'date': '2023-09-10', 'description': 'stuff'})

    lambda_news.dynamodb = Mock()
    lambda_news.table = Mock()

    lambda_news.table.get_item.return_value = {'Item': {'Title': 'NewsPostExist'}}

    response = lambda_news.lambda_handler(lambda_event, None)

    assert response['statusCode'] == 200
    assert 'Title already exists' in response['body']

def test_post_news(lambda_event):
    lambda_event['httpMethod'] = 'POST'
    lambda_event['body'] = json.dumps({'Title': 'NewsPost', 'date': '2023-09-10', 'description': 'stuff'})

    lambda_news.dynamodb = Mock()
    lambda_news.table = Mock()

    lambda_news.table.get_item.return_value = {}

    response = lambda_news.lambda_handler(lambda_event, None)

    assert response['statusCode'] == 201
    assert 'News item added' in response['body']

def test_unknown_path(lambda_event):
    lambda_event['httpMethod'] = 'GET'
    lambda_event['path'] = '/stuff'

    # Invoke the Lambda function
    response = lambda_news.lambda_handler(lambda_event, None)

    # Check the response for unknown path
    assert response['statusCode'] == 404
    assert 'Method and Path combination not found' in response['body']
