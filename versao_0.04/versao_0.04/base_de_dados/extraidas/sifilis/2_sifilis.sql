spool C:\2_sifilis_novo.csv
set sqlformat csv
set FEEDBACK OFF
set ECHO OFF


SELECT DISTRITO
      ,UNIDADE
      ,AREA
      ,ANO
      ,MES
      ,COUNT(DISTINCT(USUARIO)) PESSOAS_SIFILIS
      ,COUNT(DISTINCT(CASE WHEN TTO > 0 THEN USUARIO END)) AS PESSOAS_TTO
      
 
FROM( 
      
SELECT DISTRITO
      ,UNIDADE
      ,AREA
      ,EXTRACT(YEAR FROM DATA_NOTIF) AS ANO
      ,EXTRACT(MONTH FROM DATA_NOTIF) AS MES
      ,USUARIO
      ,COUNT(CASE WHEN PROC1 = '90019' OR PROC2 = '90019' OR PROC3 = '90019' THEN USUARIO END) AS TTO
  
  

FROM (

SELECT REG.NM_REGIAO AS DISTRITO
      ,UNI.NM_UNIDADE AS UNIDADE
      ,LGR.CD_AREA AS AREA
      ,CON.CD_CONSULTA AS CONSULTA
      ,CON.CD_USUARIO AS USUARIO
      ,CON.DT_AGENDA AS DIA_CONSULTA
      ,NOF.CD_CID AS CID_NOTIF
      ,NOF.DT_NOTIFICACAO AS DATA_NOTIF
      ,CON.CD_PROCEDIMENTO AS PROC1
      ,OUC.CD_PROCEDIMENTO AS PROC2
      ,PMT.CD_PROCEDIMENTO_BPA AS PROC3

            
      
FROM VIP_NOTIFICA_FICHA NOF
LEFT JOIN VIA_CONSULTA CON ON CON.CD_USUARIO = NOF.CD_USUARIO
LEFT JOIN VIP_OUTRA_CONSULTA OUC ON CON.CD_CONSULTA = OUC.CD_CONSULTA
LEFT JOIN VIP_PROCEDIMENTO PMT ON CON.CD_CONSULTA = PMT.CD_CONSULTA
LEFT JOIN VIP_USUARIO USU ON CON.CD_USUARIO = USU.CD_USUARIO
LEFT JOIN VSG_LOGRADOURO LGR ON GET_LOGRADOURO( USU.nm_logradouro, USU.cd_tipo_logradouro, USU.nu_logradouro_casa, USU.cd_bairro ) = LGR.CD_LOGRADOURO
LEFT JOIN VSC_UNIDADE UNI ON LGR.CD_UNIDADE = UNI.CD_UNIDADE
LEFT JOIN VSG_REGIAO REG ON UNI.CD_REGIAO = REG.CD_REGIAO
LEFT JOIN VSC_UNIDADE UNI2 ON TRUNC(CON.CD_CONSULTA / 10000000) = UNI2.CD_UNIDADE_INTERNO




WHERE (NOF.DT_NOTIFICACAO BETWEEN TO_DATE('01/01/2013 00:00:00', 'DD/MM/YYYY HH24:MI:SS') AND TO_DATE('31/03/2018 23:59:59', 'DD/MM/YYYY HH24:MI:SS'))
AND (NOF.CD_CID BETWEEN 'A50' AND 'A539' OR NOF.CD_CID = 'O981')
AND TO_DATE(CON.DT_INICIO,'DD/MM/YYYY') >= TO_DATE(NOF.DT_NOTIFICACAO,'DD/MM/YYYY')
AND UNI.NM_UNIDADE LIKE 'CS%'
AND UNI2.NM_UNIDADE LIKE 'CS%'

ORDER BY CON.CD_USUARIO

)

GROUP BY DISTRITO
      ,UNIDADE
      ,AREA
      ,EXTRACT(YEAR FROM DATA_NOTIF) 
      ,EXTRACT(MONTH FROM DATA_NOTIF)
      ,USUARIO

)

GROUP BY DISTRITO
      ,UNIDADE
      ,AREA
      ,ANO
      ,MES



;SPOOL OFF