# Análisis del Pueblo Montubio — Provincia del Guayas
## VIII Censo de Población y Vivienda 2022 (INEC Ecuador)

### Descripción
Este repositorio contiene los scripts SQL utilizados para el análisis
de la exclusión laboral femenina, brecha digital y migración del pueblo
montubio en la provincia del Guayas, basado en los microdatos del
Censo de Población y Vivienda 2022 del INEC.

**Muestra:** 368.848 personas autoidentificadas como montubias en Guayas
**Registros totales procesados:** 28.744.089

### Requisitos
- Microsoft SQL Server 2017 o superior
- SQL Server Management Studio (SSMS)
- Archivos CSV del INEC (descargar en: https://www.ecuadorencifras.gob.ec)

### Estructura del proyecto
| Script | Descripción | Registros |
|--------|-------------|-----------|
| `01_Carga_Hogar.sql` | Carga tabla Hogar | 5.193.548 |
| `02_Carga_Vivienda.sql` | Carga tabla Vivienda | 6.611.555 |
| `03_Carga_Poblacion.sql` | Carga tabla Población | 16.938.986 |
| `04_Vista_Montubio_Guayas.sql` | Vista silver con filtros | — |
| `05_Analisis_Montubio.sql` | Consultas analíticas principales | — |

### Instrucciones para el revisor
1. Crear base de datos: `CREATE DATABASE CensoDB2022`
2. Descargar los 3 CSV del INEC y colocarlos en `C:\Temp\`
3. Ejecutar los scripts en orden (01 → 05)
4. Para análisis completo usar: `00_Script_Completo_Revisor.sql`

### Hallazgos principales
- **78.3%** de mujeres montubias rurales fuera del mercado laboral
- Brecha digital: solo **28.6%** accede a internet en zona rural
- La educación superior eleva la ocupación femenina de **7.7% a 83.4%**

### Autor
- **Usuario GitHub:** Azulado70
- **Fuente de datos:** INEC — CPV 2022
- **Fecha:** Junio 2026
