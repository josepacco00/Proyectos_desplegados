import json
import boto3
from PIL import Image, ImageDraw
import io
import logging
import os
from collections import defaultdict
import uuid
from datetime import datetime
from botocore.client import Config
from urllib.parse import urlparse, urlunparse

# Configurar logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# s3_client = boto3.client('s3', config=Config(signature_version='s3v4'))
#s3_client = boto3.client('s3')
s3_client = boto3.client('s3', region_name='us-east-2', endpoint_url='https://s3.us-east-2.amazonaws.com')
rekognition_client = boto3.client('rekognition')
dynamodb = boto3.resource('dynamodb')

# Obtener el nombre de la tabla de DynamoDB del entorno
TABLE_NAME = os.environ['TABLE_NAME']
table = dynamodb.Table(TABLE_NAME)

# Definir una lista de colores para usar
COLORS = [
    (255, 0, 0),    # Rojo
    (0, 0, 255),    # Azul
    (255, 0, 255),  # Magenta
    (128, 0, 0),    # Marrón
    (0, 128, 0),    # Verde oscuro
    (0, 0, 128),    # Azul marino
]

def get_file_extension(file_name):
    return os.path.splitext(file_name)[1].lower()

def get_pil_format(file_extension):
    format_mapping = {
        '.jpg': 'JPEG',
        '.jpeg': 'JPEG',
        '.png': 'PNG',
        '.gif': 'GIF',
        '.bmp': 'BMP',
        '.tiff': 'TIFF'
    }
    return format_mapping.get(file_extension, 'JPEG')  # Default to JPEG if unknown

import boto3
from botocore.config import Config
from urllib.parse import urlparse, urlunparse

def generate_presigned_url(bucket, key, expiration=3600):
    try:
        response = s3_client.generate_presigned_url('get_object',
                                                    Params={'Bucket': bucket,
                                                            'Key': key},
                                                    ExpiresIn=expiration)
        return response
    except Exception as e:
        logger.error(f"Error generating presigned URL: {str(e)}")
        return None



def lambda_handler(event, context):
    logger.info("Iniciando procesamiento de imagen")
    
    # Obtener información del bucket y la key del objeto
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
    # Verificar si la imagen proviene de la carpeta /recognition
    if key.startswith('recognition/'):
        return
    
    try:
        # Descargar la imagen de S3
        response = s3_client.get_object(Bucket=bucket, Key=key)
        image_content = response['Body'].read()
        
        # Detectar etiquetas con Rekognition
        rekognition_response = rekognition_client.detect_labels(
            Image={'Bytes': image_content},
            MaxLabels=10,
            MinConfidence=70
        )
        
        # Abrir la imagen con Pillow
        image = Image.open(io.BytesIO(image_content))
        
        # Obtener el formato de la imagen
        file_extension = get_file_extension(key)
        pil_format = get_pil_format(file_extension)
        
        # Crear una nueva imagen con un canal alfa si no lo tiene
        if image.mode != 'RGBA':
            new_image = Image.new('RGBA', image.size, (255, 255, 255, 0))
            new_image.paste(image, (0, 0))
            image = new_image
        
        # Crear una capa transparente para dibujar
        overlay = Image.new('RGBA', image.size, (255, 255, 255, 0))
        draw = ImageDraw.Draw(overlay)
        
        # Crear un mapa de colores para cada etiqueta única
        color_map = {}
        color_index = 0
        
        # Dibujar cuadros delimitadores en la capa transparente
        labels_with_confidence = {}
        for label in rekognition_response['Labels']:
            label_name = label['Name']
            if label_name not in color_map:
                color_map[label_name] = COLORS[color_index % len(COLORS)]
                color_index += 1
            
            color = color_map[label_name]
            
            # Guardar la etiqueta y su nivel de confianza
            labels_with_confidence[label_name] = label['Confidence']
            
            for instance in label.get('Instances', []):
                box = instance['BoundingBox']
                left = image.width * box['Left']
                top = image.height * box['Top']
                width = image.width * box['Width']
                height = image.height * box['Height']
                
                draw.rectangle([left, top, left + width, top + height], outline=color, width=2)
                draw.text((left, top), label_name, fill=color)
        
        logger.info(f"Procesadas {len(color_map)} etiquetas únicas")
        
        # Combinar la imagen original con la capa de anotaciones
        combined = Image.alpha_composite(image, overlay)
        
        # Guardar la imagen modificada en el formato original
        buffer = io.BytesIO()
        if pil_format == 'JPEG':
            combined = combined.convert('RGB')
        combined.save(buffer, format=pil_format, quality=95)
        buffer.seek(0)
        
        # Subir la imagen modificada a S3
        new_key = f"recognition/{os.path.basename(key)}"
        s3_client.put_object(Bucket=bucket, Key=new_key, Body=buffer)
        
        # Generar URL presignada
        presigned_url = generate_presigned_url(bucket, new_key)
        
        if presigned_url is None:
            raise Exception("Failed to generate presigned URL")
        
        # Generar ID aleatorio de 5 dígitos
        image_id = str(uuid.uuid4().int)[:5]
        
        # Obtener fecha y hora de procesamiento
        processing_time = datetime.now().isoformat()
        
        # Preparar item para DynamoDB
        item = {
            'ImageID': image_id,
            'ProcessingTime': processing_time,
            'Labels': json.dumps(labels_with_confidence),
            'ProcessingStatus': 'SUCCESS',
            'PresignedURL': presigned_url
        }
        
        # Guardar en DynamoDB
        table.put_item(Item=item)
        
        logger.info(f"Imagen procesada y guardada como {new_key}")
        logger.info(f"Información guardada en DynamoDB con ID {image_id}")
        logger.info(f"ImageID: {image_id}")
        
        return {
            'statusCode': 200,
            'body': json.dumps(f'Imagen procesada exitosamente: {new_key}')
        }
    except Exception as e:
        logger.error(f"Error al procesar la imagen: {str(e)}")
        
        # En caso de error, guardar información en DynamoDB
        error_item = {
            'ImageID': str(uuid.uuid4().int)[:5],
            'ProcessingTime': datetime.now().isoformat(),
            'ProcessingStatus': 'ERROR',
            'ErrorMessage': str(e)
        }
        table.put_item(Item=error_item)
        
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error al procesar la imagen: {str(e)}')
        }