USE CensoDB2022;
GO

IF OBJECT_ID('bronze.CPV_Poblacion_2022', 'U') IS NOT NULL
    DROP TABLE bronze.CPV_Poblacion_2022;
GO

CREATE TABLE bronze.CPV_Poblacion_2022 (
    I01      CHAR(2),   -- Provincia
    I02      CHAR(2),   -- Cantón
    I03      CHAR(2),   -- Parroquia
    I04      CHAR(3),   -- Zona
    I05      CHAR(3),   -- Sector
    I10      CHAR(4),   -- Nro vivienda
    INH      CHAR(2),   -- Nro hogar
    P00      CHAR(4),   -- Nro persona
    P01      TINYINT,   -- Parentesco
    P02      TINYINT,   -- Sexo al nacer
    P03      SMALLINT,  -- Años cumplidos
    P05      TINYINT,   -- Inscrito Registro Civil
    P0601    TINYINT,   -- Tiene cédula
    P0602    TINYINT,   -- Otro documento
    P0701    TINYINT,   -- Dificultad caminar
    P0702    TINYINT,   -- Dificultad bañarse
    P0703    TINYINT,   -- Dificultad hablar
    P0704    TINYINT,   -- Dificultad oír
    P0705    TINYINT,   -- Dificultad ver
    P0706    TINYINT,   -- Dificultad recordar
    P08      TINYINT,   -- Dónde nació
    P08P     CHAR(2),   -- Provincia nacimiento
    P08C     CHAR(4),   -- Cantón nacimiento
    P08Q     CHAR(6),   -- Ciudad/parroquia nacimiento
    P0803A   CHAR(4),   -- Año llegó al Ecuador
    P09      TINYINT,   -- Hace 5 años dónde vivía
    P09P     CHAR(2),   -- Provincia hace 5 años
    P09C     CHAR(4),   -- Cantón hace 5 años
    P09Q     CHAR(6),   -- Ciudad/parroquia hace 5 años
    P1001    TINYINT,   -- Habla idioma indígena
    P1002    TINYINT,   -- Habla castellano
    P1003    TINYINT,   -- Habla idioma extranjero
    P1004    TINYINT,   -- Lengua de señas
    P1005    TINYINT,   -- No habla
    P1001I   CHAR(2),   -- Idioma indígena específico
    P11R     TINYINT,   -- Autoidentificación étnica
    P1108    TINYINT,   -- Otra identificación cultural
    P12      CHAR(2),   -- Nacionalidad pueblo indígena
    P13      TINYINT,   -- Papá/mamá habla indígena
    P15      TINYINT,   -- Asiste educación formal
    P16      TINYINT,   -- Tipo establecimiento enseñanza
    P17R     TINYINT,   -- Nivel instrucción recodificado
    P18R     TINYINT,   -- Grado más alto aprobado
    P19      TINYINT,   -- Sabe leer y escribir
    P20      TINYINT,   -- Obtuvo título
    P2101    TINYINT,   -- Usó celular últimos 3 meses
    P2102    TINYINT,   -- Usó internet últimos 3 meses
    P2103    TINYINT,   -- Usó computador últimos 3 meses
    P2104    TINYINT,   -- Usó tablet últimos 3 meses
    P22      TINYINT,   -- Situación laboral semana pasada
    P23      TINYINT,   -- Trabajo agrícola
    P24      TINYINT,   -- Destino producción agrícola
    P25      TINYINT,   -- Buscó trabajo últimas 4 semanas
    P26      TINYINT,   -- Razón no trabajó
    P27      CHAR(4),   -- Ocupación CIUO
    P28      CHAR(4),   -- Actividad económica CIIU
    P29      TINYINT,   -- Categoría ocupación
    P30      TINYINT,   -- Aporta seguro
    P31      TINYINT,   -- Estado conyugal
    P3201    TINYINT,   -- Nro hijas nacidas vivas
    P3202    TINYINT,   -- Nro hijos nacidos vivos
    P3203    TINYINT,   -- Total hijos nacidos vivos
    P3301    TINYINT,   -- Nro hijas vivas actualmente
    P3302    TINYINT,   -- Nro hijos vivos actualmente
    P3303    TINYINT,   -- Total hijos vivos actualmente
    P34      TINYINT,   -- Edad primer hijo nacido vivo
    P3501    TINYINT,   -- Día último hijo nacido vivo
    P3502    TINYINT,   -- Mes último hijo nacido vivo
    P3503    CHAR(4),   -- Año último hijo nacido vivo
    AUR      TINYINT,   -- Área urbana/rural
    CANTON   CHAR(4),   -- Cantón (derivada)
    PARROQ   CHAR(6),   -- Parroquia (derivada)
    ID_VIV   CHAR(16),  -- ID vivienda
    ID_HOG   CHAR(18),  -- ID hogar
    ID_PER   CHAR(22),  -- ID persona
    GEDAD    TINYINT,   -- Grupos edad quinquenales
    GRANEDAD TINYINT,   -- Grandes grupos edad
    ETAEDAD  TINYINT,   -- Grupos edad etapas de vida
    DFUNC    TINYINT,   -- Dificultad funcional permanente
    P10R     TINYINT,   -- Idioma recodificado
    ANALF    TINYINT,   -- Condición analfabetismo
    CONDACT  TINYINT,   -- Condición actividad agregada
    CONDACT1 TINYINT,   -- Condición actividad desagregada
    GRUPO1   CHAR(2),   -- Grupo ocupación nivel 1
    RAMA1    CHAR(2),   -- Rama actividad nivel 1
    IMP_VOPA TINYINT    -- Registro imputado
);
GO

BULK INSERT bronze.CPV_Poblacion_2022
FROM 'C:\Temp\CPV_Poblacion_2022_Nacional.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR   = '\n',
    FIRSTROW        = 2,
    CODEPAGE        = '65001',
    TABLOCK
);
GO

SELECT TOP 5 * FROM bronze.CPV_Poblacion_2022;
SELECT COUNT(*) AS Total_Registros FROM bronze.CPV_Poblacion_2022;
GO