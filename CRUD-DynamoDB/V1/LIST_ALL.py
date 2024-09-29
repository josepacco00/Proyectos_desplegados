import os
import json
import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    # Configura el cliente de DynamoDB
    dynamodb = boto3.resource('dynamodb')
    table_name = os.environ.get('TABLE_NAME')
    table = dynamodb.Table(table_name)

    try:
        # Escanea la tabla para obtener todos los ítems
        response = table.scan()
        items = response.get('Items', [])

        # Retorna los ítems
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Ítems obtenidos exitosamente.',
                'items': items
            })
        }

    except ClientError as e:
        # Maneja errores de la operación
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Error al obtener los ítems de DynamoDB.',
                'error': str(e)
            })
        }
