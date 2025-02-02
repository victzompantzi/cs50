CREATE DATABASE tienda_informatica;

USE tienda_informatica;

CREATE TABLE fabricante (
    codigo INT(10) PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE producto (
    codigo INT(10) PRIMARY KEY,
    nombre VARCHAR(100),
    precio DOUBLE,
    codigo_fabricante INT(10),
    FOREIGN KEY (codigo_fabricante) REFERENCES fabricante (codigo)
);

INSERT INTO fabricante VALUES (1,"Asus");
INSERT INTO fabricante VALUES (2,"Lenovo");
INSERT INTO fabricante VALUES (3,"Hewlett-Packard");
INSERT INTO fabricante VALUES (4,"Samsung");
INSERT INTO fabricante VALUES (5,"Seagate");
INSERT INTO fabricante VALUES (6,"Crucial");
INSERT INTO fabricante VALUES (7,"Gigabyte");
INSERT INTO fabricante VALUES (8,"Huawei");
INSERT INTO fabricante VALUES (9,"Xiaomi");

INSERT INTO producto VALUES (1,"Disco Duro SATA3 1TB",86.99,5);
INSERT INTO producto VALUES (2,"Memoria RAM DDR4 8GB",120, 6);
INSERT INTO producto VALUES (3,"Disco SSD 1TB",150.99,4);
INSERT INTO producto VALUES (4,"GeForce GTX 1050 Ti",185, 7);
INSERT INTO producto VALUES (5,"GeForce GTX 1080 Xtreme",755,6);
INSERT INTO producto VALUES (6,"Monitor 24 LED Full HD",202,1);
INSERT INTO producto VALUES (7,"Monitor 27 LED Full HD",245.99,1);
INSERT INTO producto VALUES (8,"Portatil Yoga 520",559,2);
INSERT INTO producto VALUES (9,"Portatil Ideapad 320",444, 2);
INSERT INTO producto VALUES (10,"Impresora HP Deskjet 3720",59.99,3);
INSERT INTO producto VALUES (11,"Impresora HP Laserjet Pro M26nw",180,3);

/* 1. Calcula el número total de productos que hay en la tabla productos. */
SELECT COUNT(*) FROM producto;

/* 2. Muestra el número total de productos que tiene cada uno de los fabricantes. El listado también debe incluir los fabricantes que no tienen ningún producto. El resultado mostrará dos columnas, una con el nombre del fabricante y otra con el número de productos que tiene. Ordene el resultado descendentemente por el número de productos. */
SELECT f.nombre, COUNT(p.codigo_fabricante) AS total_productos FROM fabricante AS f LEFT JOIN producto AS p ON f.codigo = p.codigo_fabricante GROUP BY f.nombre;

/* 3. Muestra el precio máximo, precio mínimo y precio medio de los productos de cada uno de los fabricantes. El resultado mostrará el nombre del fabricante junto con los datos que se solicitan. */
SELECT f.nombre AS nombre_fabricante, MAX(p.precio) AS precio_maximo, MIN(p.precio) AS precio_minimo, AVG(p.precio) AS precio_medio FROM fabricante f JOIN producto p ON f.codigo = p.codigo_fabricante GROUP BY f.nombre;

/* 4. Muestra el nombre de cada fabricante, junto con el precio máximo, precio mínimo, precio medio y el número total de productos de los fabricantes que tienen un precio medio superior a 200€. Es necesario mostrar el nombre del fabricante. */
SELECT
    f.nombre AS nombre_fabricante,
    MAX(p.precio) AS precio_maximo,
    MIN(p.precio) AS precio_minimo,
    AVG(p.precio) AS precio_medio,
    COUNT(CASE WHEN p.precio > 200 THEN 1 END) AS mayorque_200
FROM
    fabricante f
LEFT JOIN
    producto p ON f.codigo = p.codigo_fabricante
GROUP BY
    f.nombre;

-- SELECT
--     f.nombre,
--     MAX(p.precio) AS PRECIO_MAXIMO,
--     MIN(p.precio) AS PRECIO_MINIMO,
--     AVG(p.precio) AS PRECIO_MEDIO,
--     COUNT(p.codigo) AS NUMERO_DE_PRODUCTOS
-- FROM
--     fabricante AS f
-- LEFT JOIN
--     producto AS P ON f.codigo = p.codigo_fabricante
-- GROUP BY
--     f.nombre
-- HAVING
--     AVG(P.PRECIO) > 200;

/* Base de Datos Entre Semana G0424
8. Disparadores
Víctor Hugo Tzompantzi Cruz
1627RC037
15/07/2024 */

CREATE DATABASE test;

USE test;

CREATE TABLE alumnos (
    id INT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(50),
    apellido1 VARCHAR(50),
    apellido2 VARCHAR(50),
    nota DECIMAL
);

DELIMITER $$
CREATE TRIGGER
    trigger_check_nota_before_insert
    BEFORE INSERT
    ON alumnos
    FOR EACH ROW
    BEGIN
        IF NEW.nota > 10 THEN
            SET NEW.nota = 10;
        ELSEIF NEW.nota < 0 THEN
            SET NEW.nota = 0;
        END IF;
    END; $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER
    trigger_check_nota_before_update
    BEFORE UPDATE
    ON alumnos
    FOR EACH ROW
    BEGIN
        IF NEW.nota > 10 THEN
            SET NEW.nota = 10;
        ELSEIF NEW.nota < 0 THEN
            SET NEW.nota = 0;
        END IF;
    END; $$
DELIMITER ;

INSERT INTO alumnos VALUES (1,"Junito","Pérez","Cruz",11);
SELECT * FROM alumnos;
-- +----+--------+-----------+-----------+------+
-- | id | nombre | apellido1 | apellido2 | nota |
-- +----+--------+-----------+-----------+------+
-- |  1 | Junito | Pérez     | Cruz      |   10 |
-- +----+--------+-----------+-----------+------+
UPDATE alumnos SET nota = -80 WHERE id = 1;
SELECT * FROM alumnos;
-- +----+--------+-----------+-----------+------+
-- | id | nombre | apellido1 | apellido2 | nota |
-- +----+--------+-----------+-----------+------+
-- |  1 | Junito | Pérez     | Cruz      |    0 |
-- +----+--------+-----------+-----------+------+
UPDATE alumnos SET nota = 90 WHERE id = 1;
SELECT * FROM alumnos;
-- +----+--------+-----------+-----------+------+
-- | id | nombre | apellido1 | apellido2 | nota |
-- +----+--------+-----------+-----------+------+
-- |  1 | Junito | Pérez     | Cruz      |   10 |
-- +----+--------+-----------+-----------+------+

/* Base de Datos Entre Semana G0424
9. Operaciones en una Base de Datos
Víctor Hugo Tzompantzi Cruz
1627RC037
15/07/2024 */

-- Lista el nombre de todos los productos que hay en la tabla producto.
SELECT
    NOMBRE
FROM
    PRODUCTO;
-- +---------------------------------+
-- | NOMBRE                          |
-- +---------------------------------+
-- | Disco Duro SATA3 1TB            |
-- | Memoria RAM DDR4 8GB            |
-- | Disco SSD 1TB                   |
-- | GeForce GTX 1050 Ti             |
-- | GeForce GTX 1080 Xtreme         |
-- | Monitor 24 LED Full HD          |
-- | Monitor 27 LED Full HD          |
-- | Portatil Yoga 520               |
-- | Portatil Ideapad 320            |
-- | Impresora HP Deskjet 3720       |
-- | Impresora HP Laserjet Pro M26nw |
-- +---------------------------------+

-- Lista los nombres y los precios de todos los productos de la tabla producto.
SELECT
    NOMBRE, PRECIO
FROM
    PRODUCTO;
-- +---------------------------------+--------+
-- | NOMBRE                          | PRECIO |
-- +---------------------------------+--------+
-- | Disco Duro SATA3 1TB            |  86.99 |
-- | Memoria RAM DDR4 8GB            |    120 |
-- | Disco SSD 1TB                   | 150.99 |
-- | GeForce GTX 1050 Ti             |    185 |
-- | GeForce GTX 1080 Xtreme         |    755 |
-- | Monitor 24 LED Full HD          |    202 |
-- | Monitor 27 LED Full HD          | 245.99 |
-- | Portatil Yoga 520               |    559 |
-- | Portatil Ideapad 320            |    444 |
-- | Impresora HP Deskjet 3720       |  59.99 |
-- | Impresora HP Laserjet Pro M26nw |    180 |
-- +---------------------------------+--------+

-- Lista todas las columnas de la tabla producto.
SELECT
    *
FROM
    PRODUCTO;
-- +--------+---------------------------------+--------+-------------------+
-- | codigo | nombre                          | precio | codigo_fabricante |
-- +--------+---------------------------------+--------+-------------------+
-- |      1 | Disco Duro SATA3 1TB            |  86.99 |                 5 |
-- |      2 | Memoria RAM DDR4 8GB            |    120 |                 6 |
-- |      3 | Disco SSD 1TB                   | 150.99 |                 4 |
-- |      4 | GeForce GTX 1050 Ti             |    185 |                 7 |
-- |      5 | GeForce GTX 1080 Xtreme         |    755 |                 6 |
-- |      6 | Monitor 24 LED Full HD          |    202 |                 1 |
-- |      7 | Monitor 27 LED Full HD          | 245.99 |                 1 |
-- |      8 | Portatil Yoga 520               |    559 |                 2 |
-- |      9 | Portatil Ideapad 320            |    444 |                 2 |
-- |     10 | Impresora HP Deskjet 3720       |  59.99 |                 3 |
-- |     11 | Impresora HP Laserjet Pro M26nw |    180 |                 3 |
-- +--------+---------------------------------+--------+-------------------+

-- Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos de la base de datos.
SELECT
    P.NOMBRE AS NOMBRE_PRODUCTO, P.PRECIO, F.NOMBRE AS NOMBRE_FABRICANTE
FROM
    PRODUCTO AS P
JOIN
    FABRICANTE AS F
ON
    P.CODIGO_FABRICANTE = F.CODIGO;
-- +---------------------------------+--------+-------------------+
-- | NOMBRE_PRODUCTO                 | PRECIO | NOMBRE_FABRICANTE |
-- +---------------------------------+--------+-------------------+
-- | Disco Duro SATA3 1TB            |  86.99 | Seagate           |
-- | Memoria RAM DDR4 8GB            |    120 | Crucial           |
-- | Disco SSD 1TB                   | 150.99 | Samsung           |
-- | GeForce GTX 1050 Ti             |    185 | Gigabyte          |
-- | GeForce GTX 1080 Xtreme         |    755 | Crucial           |
-- | Monitor 24 LED Full HD          |    202 | Asus              |
-- | Monitor 27 LED Full HD          | 245.99 | Asus              |
-- | Portatil Yoga 520               |    559 | Lenovo            |
-- | Portatil Ideapad 320            |    444 | Lenovo            |
-- | Impresora HP Deskjet 3720       |  59.99 | Hewlett-Packard   |
-- | Impresora HP Laserjet Pro M26nw |    180 | Hewlett-Packard   |
-- +---------------------------------+--------+-------------------+

-- Subconsultas (En la cláusula WHERE)
-- Devuelve todos los productos del fabricante Lenovo. (Sin utilizar INNER JOIN).
SELECT
    *
FROM
    PRODUCTO AS P
WHERE
    P.CODIGO_FABRICANTE IN (SELECT CODIGO FROM FABRICANTE WHERE NOMBRE = "Lenovo");
-- +--------+----------------------+--------+-------------------+
-- | codigo | nombre               | precio | codigo_fabricante |
-- +--------+----------------------+--------+-------------------+
-- |      8 | Portatil Yoga 520    |    559 |                 2 |
-- |      9 | Portatil Ideapad 320 |    444 |                 2 |
-- +--------+----------------------+--------+-------------------+

-- Devuelve todos los datos de los productos que tienen el mismo precio que el producto más caro del fabricante Lenovo. (Sin utilizar INNER JOIN).
SELECT
    *
FROM
    PRODUCTO
WHERE
    PRECIO = (SELECT MAX(PRECIO) FROM PRODUCTO WHERE CODIGO_FABRICANTE = (SELECT CODIGO FROM FABRICANTE WHERE NOMBRE = "Lenovo"));
-- +--------+-------------------+--------+-------------------+
-- | codigo | nombre            | precio | codigo_fabricante |
-- +--------+-------------------+--------+-------------------+
-- |      8 | Portatil Yoga 520 |    559 |                 2 |
-- +--------+-------------------+--------+-------------------+
-- Lista el nombre del producto más caro del fabricante Lenovo.
SELECT
    NOMBRE, PRECIO
FROM
    PRODUCTO
WHERE
    CODIGO_FABRICANTE = (SELECT CODIGO FROM FABRICANTE WHERE NOMBRE = "Lenovo")
ORDER BY
    PRECIO DESC
LIMIT 1;
-- +-------------------+--------+
-- | NOMBRE            | PRECIO |
-- +-------------------+--------+
-- | Portatil Yoga 520 |    559 |
-- +-------------------+--------+

/* Base de Datos Entre Semana G0424
10. Proyecto Final
Víctor Hugo Tzompantzi Cruz
1627RC037
16/07/2024 */

CREATE DATABASE proveedores;

USE proveedores;

CREATE TABLE proveedor (
    id_proveedor INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    ciudad VARCHAR(100),
    provincia VARCHAR(100)
);

CREATE TABLE categoria (
    id_categoria INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE pieza (
    id_pieza INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    color VARCHAR(50),
    precio DECIMAL(5,2) NOT NULL,
    id_categoria INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_categoria)
    REFERENCES categoria (id_categoria)
);

CREATE TABLE control (
    id_control INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE,
    fecha DATE NOT NULL,
    cantidad INT UNSIGNED NOT NULL,
    id_pieza INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_pieza)
    REFERENCES pieza(id_pieza),
    id_proveedor INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_proveedor)
    REFERENCES proveedor(id_proveedor)
);

INSERT INTO proveedor VALUES (1,"Joel Cruz","Camino de la Soledad 3000","CDMX","Gustavo A. Madero");
INSERT INTO proveedor VALUES (2,"Lucius Malfoy","Camino de la Magia 4000","CDMX","Azcapotzalco");
INSERT INTO proveedor VALUES (3,"Mufasa Reynaldo","Camino de la Nostalgia 5000","CDMX","Miguel Hidalgo");

INSERT INTO categoria VALUES (1,"motherboard");
INSERT INTO categoria VALUES (2,"procesador");
INSERT INTO categoria VALUES (3,"ram");
INSERT INTO categoria VALUES (4,"ssd");
INSERT INTO categoria VALUES (5,"psu");
INSERT INTO categoria VALUES (6,"gpu");
INSERT INTO categoria VALUES (7,"case");
INSERT INTO categoria VALUES (8,"monitor");
INSERT INTO categoria VALUES (9,"keyboard");
INSERT INTO categoria VALUES (10,"hdd");
INSERT INTO categoria VALUES (11,"laptop");
INSERT INTO categoria VALUES (12,"printer");

INSERT INTO pieza VALUES (01,"Disco Duro SATA3 1TB","",86.99,10);
INSERT INTO pieza VALUES (02,"Memoria RAM DDR4 8GB","",120,3);
INSERT INTO pieza VALUES (03,"Disco SSD 1TB","",150.99,4);
INSERT INTO pieza VALUES (04,"GeForce GTX 1050 Ti","",185,6);
INSERT INTO pieza VALUES (05,"GeForce GTX 1080 Xtreme","",755,6);
INSERT INTO pieza VALUES (06,"Monitor 24 LED Full HD","negro",202,8);
INSERT INTO pieza VALUES (07,"Monitor 27 LED Full HD","negro",245.99,8);
INSERT INTO pieza VALUES (08,"Portatil Yoga 520","plateado",559,11);
INSERT INTO pieza VALUES (09,"Portatil Ideapad 320","rosa",444,11);
INSERT INTO pieza VALUES (010,"Impresora HP Deskjet 3720","blanco",59.99,12);
INSERT INTO pieza VALUES (011,"Impresora HP Laserjet Pro M26nw","negro",180,12);

INSERT INTO control VALUES (01,"2024-07-01",2,01,1);
INSERT INTO control VALUES (02,"2024-07-02",31,01,2);
INSERT INTO control VALUES (03,"2024-07-03",4,04,2);
INSERT INTO control VALUES (04,"2024-07-04",18,07,3);
INSERT INTO control VALUES (05,"2024-07-05",2,09,3);
INSERT INTO control VALUES (06,"2024-07-05",6,010,3);
INSERT INTO control VALUES (07,"2024-07-05",23,011,1);
INSERT INTO control VALUES (08,"2024-07-06",45,03,1);
INSERT INTO control VALUES (09,"2024-07-06",99,05,2);
INSERT INTO control VALUES (010,"2024-07-07",15,02,2);

SELECT
    c.id_control AS num_operacion, c.fecha AS fecha, c.id_pieza AS id_pieza, c.cantidad AS cantidad, pz.nombre AS nombre_pieza, pz.precio AS precio, cat.nombre AS categoria, c.id_proveedor AS id_proveedor, p.nombre AS nombre_proveedor, p.direccion AS direccion, p.ciudad AS ciudad, p.provincia AS provincia
FROM
    control AS c
JOIN
    proveedor AS p
    ON p.id_proveedor = c.id_proveedor
JOIN
    pieza AS pz
    ON pz.id_pieza = c.id_pieza
JOIN
    categoria AS cat
    ON cat.id_categoria = pz.id_categoria
ORDER BY
    c.fecha;
