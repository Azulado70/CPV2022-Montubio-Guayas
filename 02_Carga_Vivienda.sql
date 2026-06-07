USE CensoDB2022;
GO

IF OBJECT_ID('bronze.CPV_Vivienda_2022', 'U') IS NOT NULL
    DROP TABLE bronze.CPV_Vivienda_2022;
GO

CREATE TABLE bronze.CPV_Vivienda_2022 (
    I01      CHAR(2),   -- Provincia
    I02      CHAR(2),   -- Cantón
    I03      CHAR(2),   -- Parroquia
    I04      CHAR(3),   -- Zona
    I05      CHAR(3),   -- Sector
    I10      CHAR(4),   -- Nro vivienda
    D01      TINYINT,   -- Tipo de vía
    V01      TINYINT,   -- Tipo de vivienda
    V0201    TINYINT,   -- Condición ocupación particular
    V0202    TINYINT,   -- Condición ocupación colectiva
    V03      TINYINT,   -- Material techo
    V04      TINYINT,   -- Estado techo
    V05      TINYINT,   -- Material paredes
    V06      TINYINT,   -- Estado paredes
    V07      TINYINT,   -- Material piso
    V08      TINYINT,   -- Estado piso
    V09      TINYINT,   -- Agua por tubería
    V10      TINYINT,   -- Fuente agua
    V11      TINYINT,   -- Servicio higiénico
    V12      TINYINT,   -- Energía eléctrica red pública
    V13      TINYINT,   -- Otra fuente energía
    V14      TINYINT,   -- Eliminación basura
    V15      TINYINT,   -- Nro cuartos
    V16      TINYINT,   -- Gasto alimentación compartido
    V17      TINYINT,   -- Nro hogares
    AUR      TINYINT,   -- Área urbana/rural
    CANTON   CHAR(4),   -- Cantón (derivada)
    PARROQ   CHAR(6),   -- Parroquia (derivada)
    ID_VIV   CHAR(16),  -- ID vivienda
    TOTFALL  TINYINT,   -- Total fallecidos
    TOTEMI   TINYINT,   -- Total emigrantes
    TOTPER   SMALLINT,  -- Total personas
    V0201R   TINYINT,   -- Condición ocupación recodificada
    V15R     TINYINT,   -- Nro cuartos recodificada
    IMP_VOPA TINYINT    -- Registro imputado
);
GO

BULK INSERT bronze.CPV_Vivienda_2022
FROM 'C:\Temp\CPV_Vivienda_2022_Nacional.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR   = '\n',
    FIRSTROW        = 2,
    CODEPAGE        = '65001',
    TABLOCK
);
GO

SELECT TOP 5 * FROM bronze.CPV_Vivienda_2022;
SELECT COUNT(*) AS Total_Registros FROM bronze.CPV_Vivienda_2022;
GO