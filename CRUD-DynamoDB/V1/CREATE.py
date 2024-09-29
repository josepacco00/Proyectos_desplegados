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
        # Deserializa el cuerpo de la solicitud
        body = json.loads(event.get("body", "{}"))
        id_value = body.get('id')
        data_value = body.get('data')
        
        if not id_value or not data_value:
            return {
                'statusCode': 400,
                'body': json.dumps({
                    'message': 'Faltan parámetros id o data en la solicitud.'
                })
            }

        # Inserta el ítem en la tabla
        response = table.put_item(
            Item={
                'id': id_value,
                'data': data_value
            }
        )

        # Retorna un mensaje de éxito
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Ítem creado exitosamente.',
                'item': {
                    'id': id_value,
                    'data': data_value
                }
            })
        }

    except ClientError as e:
        # Maneja errores de la operación
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Error al crear el ítem en DynamoDB.',
                'error': str(e)
            })
        }
    except json.JSONDecodeError:
        # Maneja errores de deserialización JSON
        return {
            'statusCode': 400,
            'body': json.dumps({
                'message': 'El cuerpo de la solicitud no es un JSON válido.'
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

#     Extrae los parámetros del evento (puedes ajustar esto según cómo estés enviando los datos)
#     id_value = event.get('id')
#     data_value = event.get('data')
    
#     if not id_value or not data_value:
#         return {
#             'statusCode': 400,
#             'body': json.dumps({
#                 'message': 'Faltan parámetros id o data en la solicitud.'
#             })
#         }

#     try:
#         Inserta el ítem en la tabla
#         response = table.put_item(
#             Item={
#                 'id': id_value,
#                 'data': data_value
#             }
#         )

#         Retorna un mensaje de éxito
#         return {
#             'statusCode': 200,
#             'body': json.dumps({
#                 'message': 'Ítem creado exitosamente.',
#                 'item': {
#                     'id': id_value,
#                     'data': data_value
#                 }
#             })
#         }
#     except ClientError as e:
#         Maneja errores de la operación
#         return {
#             'statusCode': 500,
#             'body': json.dumps({
#                 'message': 'Error al crear el ítem en DynamoDB.',
#                 'error': str(e)
#             })
#         }

# {
#   "id": "123",
#   "data": "Sample data"
# }
