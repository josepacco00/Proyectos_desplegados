import json
import boto3
import os
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    # Configura el cliente de DynamoDB
    dynamodb = boto3.resource('dynamodb')
    table_name = os.environ.get('TABLE_NAME') # table_name = 'CRUD-table'
    table = dynamodb.Table(table_name)

    try:
        # Realiza una operación de lectura de prueba (por ejemplo, obtener un ítem con un id específico)
        # Cambia 'sample-id' por un valor de id válido para tu prueba
        response = table.get_item(
            Key={
                'id': '1'
            }
        )
        
        # Si la operación tiene éxito, retorna un mensaje de éxito
        return {
            'statusCode': 200,
            'body': ({
                'message': 'Conexión exitosa a la tabla DynamoDB.',
                'item': response.get('Item', 'No se encontró el ítem')
            })
        }
    except ClientError as e:
        # Maneja errores de la operación
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Error al conectar con DynamoDB.',
                'error': str(e)
            })
        }
