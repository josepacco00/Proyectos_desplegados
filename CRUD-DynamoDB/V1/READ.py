import os
import json
import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    # Configura el cliente de DynamoDB
    dynamodb = boto3.resource('dynamodb')
    table_name = os.environ.get('TABLE_NAME')
    table = dynamodb.Table(table_name)

    # Extrae el id del pathParameters del evento
    id_value = event['pathParameters'].get('id')
    
    if not id_value:
        return {
            'statusCode': 400,
            'body': json.dumps({
                'message': 'Falta el parámetro id en la solicitud.'
            })
        }

    try:
        # Realiza la operación de lectura
        response = table.get_item(
            Key={
                'id': id_value
            }
        )

        item = response.get('Item')
        if not item:
            return {
                'statusCode': 404,
                'body': json.dumps({
                    'message': 'Ítem no encontrado.'
                })
            }
        
        # Retorna el ítem encontrado
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Ítem recuperado exitosamente.',
                'item': item
            })
        }

    except ClientError as e:
        # Maneja errores de la operación
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Error al recuperar el ítem de DynamoDB.',
                'error': str(e)
            })
        }


# import os
# import json
# import boto3
# from botocore.exceptions import ClientError

# def lambda_handler(event, context):
#     Configura el cliente de DynamoDB
#     dynamodb = boto3.resource('dynamodb')
#     table_name = os.environ.get('TABLE_NAME')
#     table = dynamodb.Table(table_name)

#     Extrae el id del evento
#     id_value = event.get('id')
    
#     if not id_value:
#         return {
#             'statusCode': 400,
#             'body': json.dumps({
#                 'message': 'Falta el parámetro id en la solicitud.'
#             })
#         }

#     try:
#         Realiza la operación de lectura
#         response = table.get_item(
#             Key={
#                 'id': id_value
#             }
#         )

#         item = response.get('Item')
#         if not item:
#             return {
#                 'statusCode': 404,
#                 'body': json.dumps({
#                     'message': 'Ítem no encontrado.'
#                 })
#             }
        
#         Retorna el ítem encontrado
#         return {
#             'statusCode': 200,
#             'body': {
#                 'message': 'Ítem recuperado exitosamente.',
#                 'item': item
#             }
#         }

#     except ClientError as e:
#         Maneja errores de la operación
#         return {
#             'statusCode': 500,
#             'body': json.dumps({
#                 'message': 'Error al recuperar el ítem de DynamoDB.',
#                 'error': str(e)
#             })
#         }

# {
#   "id": "123"
# }
