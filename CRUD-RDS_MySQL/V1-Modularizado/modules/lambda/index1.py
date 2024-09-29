import os
import json
import pymysql

def lambda_handler(event, context):
    try:
        # Conexión a la base de datos MySQL
        conn = pymysql.connect(
            host=os.environ['DB_HOST'].split(':')[0],
            user=os.environ['DB_USERNAME'],
            passwd=os.environ['DB_PASSWORD'],
            db=os.environ['DB_NAME'],
            connect_timeout=5
        )
        
        with conn.cursor() as cur:
            # Crear la tabla users
            create_table_query = """
            CREATE TABLE IF NOT EXISTS users (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name_user VARCHAR(100) NOT NULL,
                email VARCHAR(100) NOT NULL,
                age INT,
                city VARCHAR(100)
            )
            """
            cur.execute(create_table_query)
            conn.commit()  # Confirmar los cambios en la BD
            
            # Consultar el esquema de la tabla creada
            cur.execute("DESCRIBE users")
            table_description = cur.fetchall()  # Obtener el resultado de la consulta
        
        conn.close()
        
        # Formatear el resultado para mostrarlo como texto en la respuesta
        schema_details = "\n".join([f"{column[0]} {column[1]}" for column in table_description])
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json'
            },
            'body': json.dumps({
                'message': 'Tabla "users" creada exitosamente.',
                'schema': schema_details
            })
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json'
            },
            'body': json.dumps({
                'error': f'Error al crear la tabla: {str(e)}'
            })
        }