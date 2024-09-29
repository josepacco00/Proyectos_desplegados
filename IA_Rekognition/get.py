import json
import boto3
import os

# Inicializar el cliente de DynamoDB
dynamodb = boto3.resource('dynamodb')
# Obtener el nombre de la tabla desde las variables de entorno
TABLE_NAME = os.environ['TABLE_NAME']

def lambda_handler(event, context):
    # Obtener el parámetro {id} desde el pathParameters del evento
    image_id = event['pathParameters']['id']
    
    # Conectar a la tabla DynamoDB
    table = dynamodb.Table(TABLE_NAME)
    
    try:
        # Obtener el elemento desde DynamoDB
        response = table.get_item(
            Key={
                'ImageID': image_id  # ImageID es la clave primaria en DynamoDB
            }
        )
        
        # Verificar si el ítem existe
        if 'Item' in response:
            return {
                'statusCode': 200,
                'body': json.dumps(response['Item'])
            }
        else:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Imagen no encontrada'})
            }
    
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
