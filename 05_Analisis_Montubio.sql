USE CensoDB2022;
GO

-- ================================================
-- 1. TOTAL POBLACIÓN MONTUBIA POR CANTÓN Y ÁREA
-- ================================================
SELECT CANTON, Area, COUNT(*) AS Total_Personas
FROM silver.Montubio_Guayas
GROUP BY CANTON, Area
ORDER BY Total_Personas DESC;

-- ================================================
-- 2. USO DE TECNOLOGÍA (Urbano vs Rural)
-- ================================================
SELECT
    Area,
    COUNT(*)                                                                         AS Total,
    SUM(CASE WHEN Usa_Celular    = 'Si' THEN 1 ELSE 0 END)                          AS Con_Celular,
    SUM(CASE WHEN Usa_Internet   = 'Si' THEN 1 ELSE 0 END)                          AS Con_Internet,
    SUM(CASE WHEN Usa_Computador = 'Si' THEN 1 ELSE 0 END)                          AS Con_Computador,
    SUM(CASE WHEN Usa_Tablet     = 'Si' THEN 1 ELSE 0 END)                          AS Con_Tablet,
    ROUND(100.0 * SUM(CASE WHEN Usa_Internet   = 'Si' THEN 1 ELSE 0 END) / COUNT(*), 1) AS Pct_Internet,
    ROUND(100.0 * SUM(CASE WHEN Usa_Celular    = 'Si' THEN 1 ELSE 0 END) / COUNT(*), 1) AS Pct_Celular,
    ROUND(100.0 * SUM(CASE WHEN Usa_Computador = 'Si' THEN 1 ELSE 0 END) / COUNT(*), 1) AS Pct_Computador,
    ROUND(100.0 * SUM(CASE WHEN Usa_Tablet     = 'Si' THEN 1 ELSE 0 END) / COUNT(*), 1) AS Pct_Tablet
FROM silver.Montubio_Guayas
GROUP BY Area;

-- ================================================
-- 3. NIVEL EDUCATIVO (Urbano vs Rural)
-- ================================================
SELECT
    Area,
    Nivel_Educacion,
    COUNT(*) AS Total,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY Area), 1) AS Porcentaje
FROM silver.Montubio_Guayas
GROUP BY Area, Nivel_Educacion
ORDER BY Area, Total DESC;

-- ================================================
-- 4. ANALFABETISMO POR CANTÓN Y ÁREA
-- ================================================
SELECT
    CANTON, Area,
    SUM(CASE WHEN Analfabetismo = 'Analfabeto' THEN 1 ELSE 0 END) AS Analfabetos,
    COUNT(*) AS Total,
    ROUND(100.0 * SUM(CASE WHEN Analfabetismo = 'Analfabeto' THEN 1 ELSE 0 END) / COUNT(*), 1) AS Tasa_Analfabetismo
FROM silver.Montubio_Guayas
GROUP BY CANTON, Area
ORDER BY Tasa_Analfabetismo DESC;

-- ================================================
-- 5. MIGRACIÓN (Urbano vs Rural)
-- ================================================
SELECT
    Area,
    Lugar_Nacimiento,
    Residencia_Hace_5_Anos,
    COUNT(*) AS Total,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY Area), 1) AS Porcentaje
FROM silver.Montubio_Guayas
GROUP BY Area, Lugar_Nacimiento, Residencia_Hace_5_Anos
ORDER BY Area, Total DESC;

-- ================================================
-- 6. CONDICIÓN LABORAL POR ÁREA Y SEXO
-- ================================================
SELECT
    Area, Sexo, Condicion_Actividad,
    COUNT(*) AS Total,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY Area, Sexo), 1) AS Porcentaje
FROM silver.Montubio_Guayas
WHERE Grupo_Edad NOT IN ('Nino (0-11)', 'Adolescente (12-17)')
GROUP BY Area, Sexo, Condicion_Actividad
ORDER BY Area, Sexo, Total DESC;
USE CensoDB2022;
GO

-- ================================================
-- CRUCE: EDUCACIÓN vs EMPLEO
-- Pueblo Montubio - Guayas
-- Por Área, Sexo y Cantón
-- ================================================

-- 1. NIVEL EDUCATIVO vs CONDICIÓN LABORAL (Área + Sexo)
SELECT
    Area,
    Sexo,
    Nivel_Educacion,
    Condicion_Actividad,
    COUNT(*)                                                                            AS Total,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY Area, Sexo, Nivel_Educacion), 1)
                                                                                        AS Pct_dentro_nivel
FROM silver.Montubio_Guayas
WHERE Condicion_Actividad NOT IN ('Menor de 5 anos', 'ND')
  AND Nivel_Educacion     <> 'ND'
GROUP BY Area, Sexo, Nivel_Educacion, Condicion_Actividad
ORDER BY Area, Sexo, Total DESC;

-- ================================================
-- 2. TASA DE OCUPACIÓN POR NIVEL EDUCATIVO Y ÁREA
-- ================================================
SELECT
    Area,
    Nivel_Educacion,
    COUNT(*)                                                                             AS Total_PEA,
    SUM(CASE WHEN Condicion_Actividad = 'Ocupado'    THEN 1 ELSE 0 END)                 AS Ocupados,
    SUM(CASE WHEN Condicion_Actividad = 'Desocupado' THEN 1 ELSE 0 END)                 AS Desocupados,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Ocupado'    THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*), 0), 1)                                                      AS Tasa_Ocupacion,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Desocupado' THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*), 0), 1)                                                      AS Tasa_Desocupacion
FROM silver.Montubio_Guayas
WHERE Condicion_Actividad IN ('Ocupado', 'Desocupado')
  AND Nivel_Educacion     <> 'ND'
GROUP BY Area, Nivel_Educacion
ORDER BY Area,
         CASE Nivel_Educacion
             WHEN 'Ninguno'                  THEN 1
             WHEN 'Alfabetizacion'           THEN 2
             WHEN 'Educacion Basica'         THEN 3
             WHEN 'Bachillerato'             THEN 4
             WHEN 'Post-bachillerato'        THEN 5
             WHEN 'Tecnico/Tecnologico'      THEN 6
             WHEN 'Superior'                 THEN 7
             WHEN 'Maestria/Especializacion' THEN 8
             WHEN 'PhD/Doctorado'            THEN 9
             ELSE 10 END;

-- ================================================
-- 3. CATEGORÍA DE OCUPACIÓN POR NIVEL EDUCATIVO Y ÁREA
-- ================================================
SELECT
    Area,
    Nivel_Educacion,
    Categoria_Ocupacion,
    COUNT(*)                                                                             AS Total,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY Area, Nivel_Educacion), 1) AS Porcentaje
FROM silver.Montubio_Guayas
WHERE Condicion_Actividad = 'Ocupado'
  AND Nivel_Educacion     <> 'ND'
  AND Categoria_Ocupacion <> 'ND'
GROUP BY Area, Nivel_Educacion, Categoria_Ocupacion
ORDER BY Area, Nivel_Educacion, Total DESC;

-- ================================================
-- 4. RESUMEN POR CANTÓN: EDUCACIÓN SUPERIOR Y EMPLEO
-- ================================================
SELECT
    CANTON,
    Area,
    COUNT(*)                                                                              AS Total,
    SUM(CASE WHEN Nivel_Educacion IN ('Superior','Maestria/Especializacion','PhD/Doctorado')
             THEN 1 ELSE 0 END)                                                           AS Con_Educacion_Superior,
    SUM(CASE WHEN Condicion_Actividad = 'Ocupado'
             AND Nivel_Educacion IN ('Superior','Maestria/Especializacion','PhD/Doctorado')
             THEN 1 ELSE 0 END)                                                           AS Superiores_Ocupados,
    ROUND(100.0 * SUM(CASE WHEN Nivel_Educacion IN ('Superior','Maestria/Especializacion','PhD/Doctorado')
                           THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 1)                  AS Pct_Superior,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Ocupado'
                           AND Nivel_Educacion IN ('Superior','Maestria/Especializacion','PhD/Doctorado')
                           THEN 1 ELSE 0 END)
          / NULLIF(SUM(CASE WHEN Nivel_Educacion IN ('Superior','Maestria/Especializacion','PhD/Doctorado')
                            THEN 1 ELSE 0 END), 0), 1)                                   AS Pct_Superiores_Ocupados
FROM silver.Montubio_Guayas
WHERE Condicion_Actividad NOT IN ('Menor de 5 anos', 'ND')
GROUP BY CANTON, Area
ORDER BY Pct_Superior DESC;
GO
USE CensoDB2022;
GO

-- ================================================
-- TABLA DE CANTONES DE GUAYAS (código → nombre)
-- ================================================
IF OBJECT_ID('bronze.Cantones_Guayas', 'U') IS NOT NULL
    DROP TABLE bronze.Cantones_Guayas;
GO

CREATE TABLE bronze.Cantones_Guayas (
    Codigo_Canton CHAR(4),
    Nombre_Canton NVARCHAR(100)
);
GO

INSERT INTO bronze.Cantones_Guayas VALUES
('0901', 'Guayaquil'),
('0902', 'Alfredo Baquerizo Moreno'),
('0903', 'Balao'),
('0904', 'Balzar'),
('0905', 'Colimes'),
('0906', 'Daule'),
('0907', 'Durán'),
('0908', 'El Empalme'),
('0909', 'El Triunfo'),
('0910', 'Milagro'),
('0911', 'Naranjal'),
('0912', 'Naranjito'),
('0913', 'Palestina'),
('0914', 'Pedro Carbo'),
('0915', 'Samborondón'),
('0916', 'Santa Lucía'),
('0917', 'Salitre'),
('0918', 'San Jacinto de Yaguachi'),
('0919', 'Playas'),
('0920', 'Simón Bolívar'),
('0921', 'Coronel Marcelino Maridueña'),
('0922', 'Lomas de Sargentillo'),
('0923', 'Nobol'),
('0924', 'General Antonio Elizalde'),
('0925', 'Isidro Ayora'),
('0926', 'Guamani'),
('0927', 'Lorenzo de Garaicoa'),
('0928', 'Santa Elena'),
('0929', 'La Libertad'),
('0930', 'Salinas');
GO

-- ================================================
-- ACTUALIZAR VISTA con nombres de cantones
-- ================================================
CREATE OR ALTER VIEW silver.Montubio_Guayas_v2 AS
SELECT
    c.Nombre_Canton AS Canton,
    m.PARROQ,
    m.Area,
    m.Sexo,
    m.Grupo_Edad,
    m.Nivel_Educacion,
    m.Analfabetismo,
    m.Asiste_Educacion,
    m.Usa_Celular,
    m.Usa_Internet,
    m.Usa_Computador,
    m.Usa_Tablet,
    m.Lugar_Nacimiento,
    m.Residencia_Hace_5_Anos,
    m.Condicion_Actividad,
    m.Categoria_Ocupacion
FROM silver.Montubio_Guayas m
LEFT JOIN bronze.Cantones_Guayas c ON m.CANTON = c.Codigo_Canton;
GO

-- ================================================
-- EXCLUSIÓN LABORAL FEMENINA POR CANTÓN Y ÁREA
-- ================================================
SELECT
    Canton,
    Area,
    COUNT(*)                                                                                AS Total_Mujeres,
    SUM(CASE WHEN Condicion_Actividad = 'Ocupado'              THEN 1 ELSE 0 END)          AS Ocupadas,
    SUM(CASE WHEN Condicion_Actividad = 'Desocupado'           THEN 1 ELSE 0 END)          AS Desocupadas,
    SUM(CASE WHEN Condicion_Actividad = 'Fuera fuerza laboral' THEN 1 ELSE 0 END)          AS Fuera_Mercado,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Ocupado'              THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*),0), 1)                                                          AS Pct_Ocupadas,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Fuera fuerza laboral' THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*),0), 1)                                                          AS Pct_Fuera_Mercado
FROM silver.Montubio_Guayas_v2
WHERE Sexo = 'Mujer'
  AND Condicion_Actividad <> 'Menor de 5 anos'
  AND Grupo_Edad NOT IN ('Nino (0-11)', 'Adolescente (12-17)')
GROUP BY Canton, Area
ORDER BY Pct_Fuera_Mercado DESC;
GO

-- ================================================
-- EXCLUSIÓN FEMENINA POR GRUPO DE EDAD Y ÁREA
-- ================================================
SELECT
    Area,
    Grupo_Edad,
    COUNT(*)                                                                                AS Total_Mujeres,
    SUM(CASE WHEN Condicion_Actividad = 'Ocupado'              THEN 1 ELSE 0 END)          AS Ocupadas,
    SUM(CASE WHEN Condicion_Actividad = 'Fuera fuerza laboral' THEN 1 ELSE 0 END)          AS Fuera_Mercado,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Ocupado'              THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*),0), 1)                                                          AS Pct_Ocupadas,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Fuera fuerza laboral' THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*),0), 1)                                                          AS Pct_Fuera_Mercado
FROM silver.Montubio_Guayas_v2
WHERE Sexo = 'Mujer'
  AND Condicion_Actividad <> 'Menor de 5 anos'
  AND Grupo_Edad NOT IN ('Nino (0-11)', 'Adolescente (12-17)')
GROUP BY Area, Grupo_Edad
ORDER BY Area,
         CASE Grupo_Edad
             WHEN 'Joven (18-29)'      THEN 1
             WHEN 'Adulto (30-64)'     THEN 2
             WHEN 'Adulto Mayor (65+)' THEN 3
         END;
GO

-- ================================================
-- EXCLUSIÓN FEMENINA POR NIVEL EDUCATIVO Y ÁREA
-- ================================================
SELECT
    Area,
    Nivel_Educacion,
    COUNT(*)                                                                                AS Total_Mujeres,
    SUM(CASE WHEN Condicion_Actividad = 'Ocupado'              THEN 1 ELSE 0 END)          AS Ocupadas,
    SUM(CASE WHEN Condicion_Actividad = 'Fuera fuerza laboral' THEN 1 ELSE 0 END)          AS Fuera_Mercado,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Ocupado'              THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*),0), 1)                                                          AS Pct_Ocupadas,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Fuera fuerza laboral' THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*),0), 1)                                                          AS Pct_Fuera_Mercado
FROM silver.Montubio_Guayas_v2
WHERE Sexo = 'Mujer'
  AND Condicion_Actividad <> 'Menor de 5 anos'
  AND Nivel_Educacion <> 'ND'
  AND Grupo_Edad NOT IN ('Nino (0-11)', 'Adolescente (12-17)')
GROUP BY Area, Nivel_Educacion
ORDER BY Area,
         CASE Nivel_Educacion
             WHEN 'Ninguno'                  THEN 1
             WHEN 'Alfabetizacion'           THEN 2
             WHEN 'Educacion Basica'         THEN 3
             WHEN 'Bachillerato'             THEN 4
             WHEN 'Tecnico/Tecnologico'      THEN 5
             WHEN 'Superior'                 THEN 6
             WHEN 'Maestria/Especializacion' THEN 7
             WHEN 'PhD/Doctorado'            THEN 8
         END;
GO
USE CensoDB2022;
GO
USE CensoDB2022;
GO

-- ================================================
-- 1. CONDICIÓN LABORAL FEMENINA POR LUGAR DE NACIMIENTO Y ÁREA
-- ================================================
SELECT
    Area,
    Lugar_Nacimiento,
    COUNT(*)                                                                                AS Total_Mujeres,
    SUM(CASE WHEN Condicion_Actividad = 'Ocupado'              THEN 1 ELSE 0 END)          AS Ocupadas,
    SUM(CASE WHEN Condicion_Actividad = 'Desocupado'           THEN 1 ELSE 0 END)          AS Desocupadas,
    SUM(CASE WHEN Condicion_Actividad = 'Fuera fuerza laboral' THEN 1 ELSE 0 END)          AS Fuera_Mercado,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Ocupado'              THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*),0), 1)                                                          AS Pct_Ocupadas,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Fuera fuerza laboral' THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*),0), 1)                                                          AS Pct_Fuera_Mercado
FROM silver.Montubio_Guayas_v2
WHERE Sexo = 'Mujer'
  AND Condicion_Actividad <> 'Menor de 5 anos'
  AND Grupo_Edad NOT IN ('Nino (0-11)', 'Adolescente (12-17)')
  AND Lugar_Nacimiento <> 'ND'
GROUP BY Area, Lugar_Nacimiento
ORDER BY Area, Pct_Ocupadas DESC;

-- ================================================
-- 2. CONDICIÓN LABORAL FEMENINA POR MOVILIDAD
--    (dónde nació vs dónde vivía hace 5 años)
-- ================================================
SELECT
    Area,
    Lugar_Nacimiento,
    Residencia_Hace_5_Anos,
    COUNT(*)                                                                                AS Total_Mujeres,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Ocupado'              THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*),0), 1)                                                          AS Pct_Ocupadas,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Fuera fuerza laboral' THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*),0), 1)                                                          AS Pct_Fuera_Mercado
FROM silver.Montubio_Guayas_v2
WHERE Sexo = 'Mujer'
  AND Condicion_Actividad <> 'Menor de 5 anos'
  AND Grupo_Edad NOT IN ('Nino (0-11)', 'Adolescente (12-17)')
  AND Lugar_Nacimiento       <> 'ND'
  AND Residencia_Hace_5_Anos <> 'ND'
GROUP BY Area, Lugar_Nacimiento, Residencia_Hace_5_Anos
ORDER BY Area, Pct_Ocupadas DESC;

-- ================================================
-- 3. PERFIL EDUCATIVO DE MUJERES MIGRANTES VS NO MIGRANTES
-- ================================================
SELECT
    Area,
    CASE
        WHEN Lugar_Nacimiento = 'Misma ciudad/parroquia'
         AND Residencia_Hace_5_Anos = 'Misma ciudad/parroquia' THEN 'No migrante'
        WHEN Lugar_Nacimiento = 'Otro lugar del pais'
          OR Residencia_Hace_5_Anos = 'Otro lugar del pais'    THEN 'Migrante interna'
        WHEN Lugar_Nacimiento = 'Otro pais'
          OR Residencia_Hace_5_Anos = 'Otro pais'              THEN 'Migrante internacional'
        ELSE 'Otro'
    END AS Perfil_Migracion,
    Nivel_Educacion,
    COUNT(*)                                                                                AS Total_Mujeres,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Ocupado' THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*),0), 1)                                                          AS Pct_Ocupadas,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Fuera fuerza laboral' THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*),0), 1)                                                          AS Pct_Fuera_Mercado
FROM silver.Montubio_Guayas_v2
WHERE Sexo = 'Mujer'
  AND Condicion_Actividad    <> 'Menor de 5 anos'
  AND Grupo_Edad NOT IN ('Nino (0-11)', 'Adolescente (12-17)')
  AND Nivel_Educacion        <> 'ND'
  AND Lugar_Nacimiento       <> 'ND'
  AND Residencia_Hace_5_Anos <> 'ND'
GROUP BY Area,
         CASE
             WHEN Lugar_Nacimiento = 'Misma ciudad/parroquia'
              AND Residencia_Hace_5_Anos = 'Misma ciudad/parroquia' THEN 'No migrante'
             WHEN Lugar_Nacimiento = 'Otro lugar del pais'
               OR Residencia_Hace_5_Anos = 'Otro lugar del pais'    THEN 'Migrante interna'
             WHEN Lugar_Nacimiento = 'Otro pais'
               OR Residencia_Hace_5_Anos = 'Otro pais'              THEN 'Migrante internacional'
             ELSE 'Otro'
         END,
         Nivel_Educacion
ORDER BY Area, Perfil_Migracion,
         CASE Nivel_Educacion
             WHEN 'Ninguno'                  THEN 1
             WHEN 'Alfabetizacion'           THEN 2
             WHEN 'Educacion Basica'         THEN 3
             WHEN 'Bachillerato'             THEN 4
             WHEN 'Tecnico/Tecnologico'      THEN 5
             WHEN 'Superior'                 THEN 6
             WHEN 'Maestria/Especializacion' THEN 7
             WHEN 'PhD/Doctorado'            THEN 8
         END;

-- ================================================
-- 4. RESUMEN: MIGRANTE vs NO MIGRANTE por CANTÓN
-- ================================================
SELECT
    Canton,
    Area,
    CASE
        WHEN Lugar_Nacimiento = 'Misma ciudad/parroquia'
         AND Residencia_Hace_5_Anos = 'Misma ciudad/parroquia' THEN 'No migrante'
        WHEN Lugar_Nacimiento = 'Otro lugar del pais'
          OR Residencia_Hace_5_Anos = 'Otro lugar del pais'    THEN 'Migrante interna'
        WHEN Lugar_Nacimiento = 'Otro pais'
          OR Residencia_Hace_5_Anos = 'Otro pais'              THEN 'Migrante internacional'
        ELSE 'Otro'
    END AS Perfil_Migracion,
    COUNT(*)                                                                                AS Total_Mujeres,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Ocupado' THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*),0), 1)                                                          AS Pct_Ocupadas,
    ROUND(100.0 * SUM(CASE WHEN Condicion_Actividad = 'Fuera fuerza laboral' THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*),0), 1)                                                          AS Pct_Fuera_Mercado
FROM silver.Montubio_Guayas_v2
WHERE Sexo = 'Mujer'
  AND Condicion_Actividad    <> 'Menor de 5 anos'
  AND Grupo_Edad NOT IN ('Nino (0-11)', 'Adolescente (12-17)')
  AND Lugar_Nacimiento       <> 'ND'
  AND Residencia_Hace_5_Anos <> 'ND'
GROUP BY Canton, Area,
         CASE
             WHEN Lugar_Nacimiento = 'Misma ciudad/parroquia'
              AND Residencia_Hace_5_Anos = 'Misma ciudad/parroquia' THEN 'No migrante'
             WHEN Lugar_Nacimiento = 'Otro lugar del pais'
               OR Residencia_Hace_5_Anos = 'Otro lugar del pais'    THEN 'Migrante interna'
             WHEN Lugar_Nacimiento = 'Otro pais'
               OR Residencia_Hace_5_Anos = 'Otro pais'              THEN 'Migrante internacional'
             ELSE 'Otro'
         END
ORDER BY Canton, Area, Pct_Ocupadas DESC;
GO