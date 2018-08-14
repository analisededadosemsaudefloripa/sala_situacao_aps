spool /home/plan/ShinyApps/aps/producao/base_de_dados/extraidas/demanda_consulta/demanda_consulta.csv
set sqlformat csv  
set feedback off  

SELECT DISTRITO       ,UNIDADE       ,AREA       ,EXTRACT(YEAR FROM DIA_CONSULTA_2) AS ANO       ,EXTRACT(MONTH FROM DIA_CONSULTA_2) AS MES       ,COUNT(DISTINCT(CASE WHEN ESPECIALIDADE IN ('152','165','5') THEN CONSULTA END)) AS CONS_MED       ,COUNT(DISTINCT(CASE WHEN (DIA_CONSULTA > DIA_AGENDOU) AND ESPECIALIDADE IN ('152','165','5') THEN CONSULTA END)) AS AGENDADA_MED       ,COUNT(DISTINCT(CASE WHEN (DIA_CONSULTA = DIA_AGENDOU OR DIA_AGENDOU IS NULL OR DIA_CONSULTA < DIA_AGENDOU) AND ESPECIALIDADE IN ('152','165','5') THEN CONSULTA END)) AS ESPONTANEA_MED       ,COUNT(DISTINCT(CASE WHEN ESPECIALIDADE IN ('2') THEN CONSULTA END)) AS CONS_ENF       ,COUNT(DISTINCT(CASE WHEN (DIA_CONSULTA > DIA_AGENDOU) AND ESPECIALIDADE IN ('2') THEN CONSULTA END)) AS AGENDADA_ENF       ,COUNT(DISTINCT(CASE WHEN (DIA_CONSULTA = DIA_AGENDOU OR DIA_AGENDOU IS NULL OR DIA_CONSULTA < DIA_AGENDOU) AND ESPECIALIDADE IN ('2') THEN CONSULTA END)) AS ESPONTANEA_ENF       ,COUNT(DISTINCT(CASE WHEN ESPECIALIDADE IN ('83','6') THEN CONSULTA END)) AS CONS_ODO       ,COUNT(DISTINCT(CASE WHEN (DIA_CONSULTA > DIA_AGENDOU) AND ESPECIALIDADE IN ('83','6') THEN CONSULTA END)) AS AGENDADA_ODO       ,COUNT(DISTINCT(CASE WHEN (DIA_CONSULTA = DIA_AGENDOU OR DIA_AGENDOU IS NULL OR DIA_CONSULTA < DIA_AGENDOU) AND ESPECIALIDADE IN ('83','6') THEN CONSULTA END)) AS ESPONTANEA_ODO     FROM (  SELECT REG.NM_REGIAO AS DISTRITO       ,UNI.NM_UNIDADE AS UNIDADE       ,LGR.CD_AREA AS AREA       ,PRO.CD_ESPECIALIDADE AS ESPECIALIDADE       ,CON.CD_CONSULTA AS CONSULTA       ,CON.CD_USUARIO AS USUARIO       ,OUC.CD_PROCEDIMENTO AS PROC2       ,TO_CHAR(TO_DATE(CON.DT_INICIO, 'dd/mm/RRRR'),'DD/MM/YYYY') AS DIA_CONSULTA       ,TO_DATE(CON.DT_INICIO, 'dd/mm/RRRR') AS DIA_CONSULTA_2       ,TO_CHAR(TO_DATE(AGE.DT_PROFISSIONAL_AGENDOU, 'dd/mm/RRRR'),'DD/MM/YYYY') AS DIA_AGENDOU       ,UNI2.NM_UNIDADE AS UNIDADE_ATENDEU                                   FROM VIA_CONSULTA CON LEFT JOIN VIC_PROFISSIONAL PRO ON CON.CD_PROFISSIONAL = PRO.CD_PROFISSIONAL LEFT JOIN VIP_OUTRA_CONSULTA OUC ON CON.CD_CONSULTA = OUC.CD_CONSULTA LEFT JOIN VIP_PROCEDIMENTO PMT ON CON.CD_CONSULTA = PMT.CD_CONSULTA LEFT JOIN VIP_USUARIO USU ON CON.CD_USUARIO = USU.CD_USUARIO LEFT JOIN VIA_AGENDA AGE ON CON.CD_CONSULTA = AGE.CD_CONSULTA LEFT JOIN VSG_LOGRADOURO LGR ON GET_LOGRADOURO( USU.nm_logradouro, USU.cd_tipo_logradouro, USU.nu_logradouro_casa, USU.cd_bairro ) = LGR.CD_LOGRADOURO LEFT JOIN VSC_UNIDADE UNI ON LGR.CD_UNIDADE = UNI.CD_UNIDADE LEFT JOIN VSG_REGIAO REG ON UNI.CD_REGIAO = REG.CD_REGIAO LEFT JOIN VSC_UNIDADE UNI2 ON TRUNC(CON.CD_CONSULTA / 10000000) = UNI2.CD_UNIDADE_INTERNO  WHERE (CON.DT_INICIO >= TRUNC(ADD_MONTHS(SYSDATE,-4),'MONTH') AND CON.DT_INICIO < TRUNC(SYSDATE,'MONTH')) AND UNI.NM_UNIDADE LIKE 'CS%' AND UNI2.NM_UNIDADE LIKE 'CS%' AND (CON.CD_PROCEDIMENTO NOT IN ('908080','90079','90078','90159') OR OUC.CD_PROCEDIMENTO NOT IN ('908080','90079','90078','90159') OR PMT.CD_PROCEDIMENTO_BPA NOT IN ('908080','90079','90078','90159')) ) T  WHERE T.UNIDADE_ATENDEU LIKE 'CS%'  GROUP BY DISTRITO, UNIDADE, AREA,EXTRACT(YEAR FROM DIA_CONSULTA_2),EXTRACT(MONTH FROM DIA_CONSULTA_2)  ORDER BY DISTRITO, UNIDADE, AREA,EXTRACT(YEAR FROM DIA_CONSULTA_2),EXTRACT(MONTH FROM DIA_CONSULTA_2)  ;  

spool off 

exit 
 
EOF
