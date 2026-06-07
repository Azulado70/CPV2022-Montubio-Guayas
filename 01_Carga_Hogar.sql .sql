BULK INSERT bronze.CPV_Hogar_2022
FROM 'C:\Temp\CPV_Hogar_2022_Nacional.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR   = '\n',
    FIRSTROW        = 2,
    CODEPAGE        = '65001',
    TABLOCK
);
GO

SELECT TOP 5 * FROM bronze.CPV_Hogar_2022;
SELECT COUNT(*) AS Total_Filas FROM bronze.CPV_Hogar_2022;
GO