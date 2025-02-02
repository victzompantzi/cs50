# Importación de la librería para la conexión a la base de datos
import pymysql
# Creación de la clase principal
class DataBase:
    # Creación del método principal
    def __init__(self):
        # Atributo
        self.connection = pymysql.connect(
            host = "localhost", # Ubicación de la base de datos
            user = "root", # Nombre del usuario
            password = "12345678",
            db = "proveedores" # Nombre de la base de datos
        )
        # Cursor
        self.cursor = self.connection.cursor()
        # Mensaje de salida para verificación de conexión
        print("Conexion establecida exitosamente");
# Instancia
DataBase = DataBase();
