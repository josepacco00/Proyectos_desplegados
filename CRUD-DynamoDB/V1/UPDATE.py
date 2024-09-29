import os
import json
import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    # Configura el cliente de DynamoDB
    dynamodb = boto3.resource('dynamodb')
    table_name = os.environ.get('TABLE_NAME')
    table = dynamodb.Table(table_name)

    # Extrae el id de los pathParameters y los nuevos datos del body
    id_value = event['pathParameters'].get('id')
    body = json.loads(event.get('body', '{}'))
    new_data = body.get('data')
    
    if not id_value or not new_data:
        return {
            'statusCode': 400,
            'body': json.dumps({
                'message': 'Faltan parámetros id o data en la solicitud.'
            })
        }

    try:
        # Realiza la operación de actualización
        response = table.update_item(
            Key={
                'id': id_value
            },
            UpdateExpression="set #data_attr = :d",
            ExpressionAttributeNames={
                '#data_attr': 'data'
            },
            ExpressionAttributeValues={
                ':d': new_data
            },
            ReturnValues="UPDATED_NEW"
        )

        # Retorna un mensaje de éxito con los nuevos valores
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Ítem actualizado exitosamente.',
                'updated_attributes': response['Attributes']
            })
        }
    except ClientError as e:
        # Maneja errores de la operación
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Error al actualizar el ítem en DynamoDB.',
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

#     Extrae los parámetros del evento
#     id_value = event.get('id')
#     new_data = event.get('data')
    
#     if not id_value or not new_data:
#         return {
#             'statusCode': 400,
#             'body': json.dumps({
#                 'message': 'Faltan parámetros id o data en la solicitud.'
#             })
#         }

#     try:
#         Realiza la operación de actualización
#         response = table.update_item(
#             Key={
#                 'id': id_value
#             },
#             UpdateExpression="set #data_attr = :d",
#             ExpressionAttributeNames={
#                 '#data_attr': 'data'
#             },
#             ExpressionAttributeValues={
#                 ':d': new_data
#             },
#             ReturnValues="UPDATED_NEW"
#         )
#                 response = table.update_item(
#             Key={
#                 'id': id_value
#             },
#             UpdateExpression="set #data_attr = :d",
#             ExpressionAttributeNames={
#                 '#data_attr': 'data'  # Alias para el atributo 'data'
#             },
#             ExpressionAttributeValues={
#                 ':d': new_data
#             },
#             ReturnValues="UPDATED_NEW"
#         )

#         Retorna un mensaje de éxito con los nuevos valores
#         return {
#             'statusCode': 200,
#             'body': {
#                 'message': 'Ítem actualizado exitosamente.',
#                 'updated_attributes': response['Attributes']
#             }
#         }
#     except ClientError as e:
#         Maneja errores de la operación
#         return {
#             'statusCode': 500,
#             'body': {
#                 'message': 'Error al actualizar el ítem en DynamoDB.',
#                 'error': str(e)
#             }
#         }
