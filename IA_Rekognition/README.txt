El proyecto desplegado con Terraform sube imágenes a S3, 
lo que genera un evento PUT que activa una función Lambda. 
Esta función utiliza AWS Rekognition para analizar las imágenes y 
la librería Pillow para agregar cuadros delimitadores y etiquetas. 
Finalmente, la imagen procesada se guarda nuevamente en S3.