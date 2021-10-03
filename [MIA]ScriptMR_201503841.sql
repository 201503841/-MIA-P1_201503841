-- Para DROPear la base de datos 
DROP TABLE PAIS CASCADE;

DROP TABLE CLASIFICACION CASCADE;

DROP TABLE CATEGORIA CASCADE;

DROP TABLE ACTOR CASCADE;

DROP TABLE IDIOMA CASCADE;

DROP TABLE CIUDAD CASCADE;

DROP TABLE TIENDA CASCADE;

DROP TABLE EMPLEADO CASCADE;

DROP TABLE CLIENTE CASCADE;

DROP TABLE PELICULA CASCADE;

DROP TABLE RENTA CASCADE;

DROP TABLE INVENTARIO CASCADE;

DROP TABLE CATEGORIA_PELICULA CASCADE;

DROP TABLE ACTOR_PELICULA CASCADE;

DROP TABLE lenguaje_pelicula CASCADE;

CREATE TABLE Pais(
    id_pais INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Clasificacion(
    id_clasificacion SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(4) NOT NULL
);

CREATE TABLE Categoria(
    id_categoria INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL
);

CREATE TABLE Actor(
    id_actor INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL
);

CREATE TABLE Idioma(
    id_idioma INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL
);

CREATE TABLE Ciudad(
    id_ciudad INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    codigo_postal VARCHAR(5),
    pais_id_pais INTEGER REFERENCES Pais NOT NULL
);

CREATE TABLE Tienda(
    id_tienda INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    direccion VARCHAR(100) NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    ciudad_id_ciudad INTEGER REFERENCES Ciudad NOT NULL
);

CREATE TABLE Empleado(
    id_empleado INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(65) NOT NULL,
    estado CHAR(1) NOT NULL,
    username VARCHAR(30) NOT NULL,
    contrasena VARCHAR(256) NOT NULL,
    es_encargado CHAR(1),
    ciudad_id_ciudad INTEGER REFERENCES Ciudad NOT NULL,
    tienda_id_tienda INTEGER REFERENCES Tienda NOT NULL
);

CREATE TABLE Cliente(
    id_cliente INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    direccion VARCHAR(100) NULL,
    correo_electronico VARCHAR(65) NOT NULL,
    fecha_registro DATE NOT NULL,
    estado CHAR(1) NOT NULL,
    ciudad_id_ciudad INTEGER REFERENCES Ciudad NOT NULL,
    tienda_favorita INTEGER REFERENCES Tienda NOT NULL
);

CREATE TABLE Pelicula(
    id_pelicula INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    titulo VARCHAR(60) NOT NULL,
    descripcion VARCHAR(200) NULL,
    ano_lanzamiento VARCHAR(4) NOT NULL,
    duracion SMALLINT NOT NULL,
    dias_renta SMALLINT NULL,
    costo_renta DECIMAL(4, 2) NOT NULL,
    costo_dano DECIMAL(4, 2) NOT NULL,
    clasificacion_id_clasificacion SMALLINT REFERENCES Clasificacion NOT NULL
);

CREATE TABLE Renta(
    id_renta INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha_renta DATE NOT NULL,
    fecha_retorno DATE NULL,
    monto DECIMAL(6, 2) NULL,
    fecha_pago DATE NULL,
    cliente_id_cliente INTEGER REFERENCES Cliente NOT NULL,
    empleado_id_empleado INTEGER REFERENCES Empleado NOT NULL,
    pelicula_id_pelicula INTEGER REFERENCES Pelicula NOT NULL
);

CREATE TABLE Inventario(
    id_inventario INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    disponible CHAR(1) NOT NULL,
    cantidad SMALLINT NULL,
    tienda_id_tienda INTEGER REFERENCES Tienda NOT NULL,
    pelicula_id_pelicula INTEGER REFERENCES Pelicula NOT NULL
);

CREATE TABLE Categoria_Pelicula(
    id_categoria INTEGER REFERENCES Categoria,
    id_pelicula INTEGER REFERENCES Pelicula,
    PRIMARY KEY(id_categoria, id_pelicula)
);

CREATE TABLE Actor_Pelicula(
    id_actor INTEGER REFERENCES Actor,
    id_pelicula INTEGER REFERENCES Pelicula,
    PRIMARY KEY(id_actor, id_pelicula)
);

CREATE TABLE lenguaje_pelicula(
    id_idioma INTEGER REFERENCES Idioma,
    id_pelicula INTEGER REFERENCES Pelicula,
    es_original CHAR(1) NULL,
    PRIMARY KEY(id_idioma, id_pelicula)
);