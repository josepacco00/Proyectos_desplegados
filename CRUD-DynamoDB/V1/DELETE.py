import os
import json
import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    # Configura el cliente de DynamoDB
    dynamodb = boto3.resource('dynamodb')
    table_name = os.environ.get('TABLE_NAME')
    table = dynamodb.Table(table_name)

    # Extrae el id de los pathParameters del evento
    id_value = event['pathParameters'].get('id')
    
    if not id_value:
        return {
            'statusCode': 400,
            'body': json.dumps({
                'message': 'Falta el parámetro id en la solicitud.'
            })
        }

    try:
        # Realiza la operación de eliminación
        response = table.delete_item(
            Key={
                'id': id_value
            },
            ReturnValues='ALL_OLD'  # Retorna los valores antes de la eliminación
        )

        # Verifica si el ítem existía
        if 'Attributes' not in response:
            return {
                'statusCode': 404,
                'body': json.dumps({
                    'message': 'Ítem no encontrado. No se realizó ninguna eliminación.'
                })
            }

        # Retorna un mensaje de éxito con el ítem eliminado
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Ítem eliminado exitosamente.',
                'deleted_item': response['Attributes']
            })
        }
    except ClientError as e:
        # Maneja errores de la operación
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Error al eliminar el ítem en DynamoDB.',
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
#         Realiza la operación de eliminación
#         response = table.delete_item(
#             Key={
#                 'id': id_value
#             },
#             ReturnValues='ALL_OLD'  # Esto retorna los valores antes de la eliminación
#         )

#         Verifica si el ítem existía
#         if 'Attributes' not in response:
#             return {
#                 'statusCode': 404,
#                 'body': json.dumps({
#                     'message': 'Ítem no encontrado. No se realizó ninguna eliminación.'
#                 })
#             }

#         Retorna un mensaje de éxito con el ítem eliminado
#         return {
#             'statusCode': 200,
#             'body': json.dumps({
#                 'message': 'Ítem eliminado exitosamente.',
#                 'deleted_item': response['Attributes']
#             })
#         }
#     except ClientError as e:
#         Maneja errores de la operación
#         return {
#             'statusCode': 500,
#             'body': json.dumps({
#                 'message': 'Error al eliminar el ítem en DynamoDB.',
#                 'error': str(e)
#             })
#         }
