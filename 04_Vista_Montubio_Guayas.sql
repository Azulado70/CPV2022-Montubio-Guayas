USE CensoDB2022;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
    EXEC('CREATE SCHEMA silver');
GO

CREATE OR ALTER VIEW silver.Montubio_Guayas AS
SELECT
    CANTON,
    PARROQ,
    CASE AUR WHEN 1 THEN 'Urbano' WHEN 2 THEN 'Rural' ELSE 'ND' END AS Area,
    CASE P02 WHEN 1 THEN 'Hombre' WHEN 2 THEN 'Mujer' ELSE 'ND' END AS Sexo,
    CASE ETAEDAD
        WHEN 1 THEN 'Nino (0-11)'
        WHEN 2 THEN 'Adolescente (12-17)'
        WHEN 3 THEN 'Joven (18-29)'
        WHEN 4 THEN 'Adulto (30-64)'
        WHEN 5 THEN 'Adulto Mayor (65+)'
        ELSE 'ND' END AS Grupo_Edad,
    CASE P17R
        WHEN 1  THEN 'Ninguno'
        WHEN 2  THEN 'CDI/Guarderia'
        WHEN 3  THEN 'Inicial/Preescolar'
        WHEN 4  THEN 'Alfabetizacion'
        WHEN 5  THEN 'Educacion Basica'
        WHEN 6  THEN 'Bachillerato'
        WHEN 7  THEN 'Post-bachillerato'
        WHEN 8  THEN 'Tecnico/Tecnologico'
        WHEN 9  THEN 'Superior'
        WHEN 10 THEN 'Maestria/Especializacion'
        WHEN 11 THEN 'PhD/Doctorado'
        ELSE 'ND' END AS Nivel_Educacion,
    CASE ANALF    WHEN 1 THEN 'Alfabeto'   WHEN 2 THEN 'Analfabeto' ELSE 'ND' END AS Analfabetismo,
    CASE P15      WHEN 1 THEN 'Si'         WHEN 2 THEN 'No'         ELSE 'ND' END AS Asiste_Educacion,
    CASE P2101    WHEN 1 THEN 'Si'         WHEN 2 THEN 'No'         ELSE 'ND' END AS Usa_Celular,
    CASE P2102    WHEN 1 THEN 'Si'         WHEN 2 THEN 'No'         ELSE 'ND' END AS Usa_Internet,
    CASE P2103    WHEN 1 THEN 'Si'         WHEN 2 THEN 'No'         ELSE 'ND' END AS Usa_Computador,
    CASE P2104    WHEN 1 THEN 'Si'         WHEN 2 THEN 'No'         ELSE 'ND' END AS Usa_Tablet,
    CASE P08
        WHEN 1 THEN 'Misma ciudad/parroquia'
        WHEN 2 THEN 'Otro lugar del pais'
        WHEN 3 THEN 'Otro pais'
        ELSE 'ND' END AS Lugar_Nacimiento,
    CASE P09
        WHEN 1 THEN 'Misma ciudad/parroquia'
        WHEN 2 THEN 'Otro lugar del pais'
        WHEN 3 THEN 'Otro pais'
        WHEN 4 THEN 'No habia nacido'
        ELSE 'ND' END AS Residencia_Hace_5_Anos,
    CASE CONDACT1
        WHEN 1 THEN 'Menor de 5 anos'
        WHEN 2 THEN 'Ocupado'
        WHEN 3 THEN 'Desocupado'
        WHEN 4 THEN 'Fuera fuerza laboral'
        ELSE 'ND' END AS Condicion_Actividad,
    CASE P29
        WHEN 1 THEN 'Empleado privado'
        WHEN 2 THEN 'Empleado publico'
        WHEN 3 THEN 'Jornalero/peon'
        WHEN 4 THEN 'Empleado domestico'
        WHEN 5 THEN 'Patrono'
        WHEN 6 THEN 'Cuenta propia'
        WHEN 7 THEN 'Socio'
        WHEN 8 THEN 'Familiar no remunerado'
        ELSE 'ND' END AS Categoria_Ocupacion
FROM bronze.CPV_Poblacion_2022
WHERE I01 = '09'
  AND P11R = 3;
GO