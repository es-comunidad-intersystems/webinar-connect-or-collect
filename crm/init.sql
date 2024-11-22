USE crm;
CREATE TABLE clientes(
    IDCliente VARCHAR(30) UNIQUE,
    Nombre VARCHAR(50),
    Apellidos  VARCHAR(50),
    Genero VARCHAR(1),
    FechaNamcimiento DATE,
    DireccionPais VARCHAR(20),
    DireccionCuidad VARCHAR(20),
    DireccionRegion VARCHAR(20),
    DireccionCodigoPostal VARCHAR(10)
);

LOAD DATA INFILE '/var/lib/mysql_files/clientes.csv'
  INTO TABLE clientes
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS;

CREATE USER crmuser identified by 'unsecure' password expire never;
GRANT All on * to crmuser;