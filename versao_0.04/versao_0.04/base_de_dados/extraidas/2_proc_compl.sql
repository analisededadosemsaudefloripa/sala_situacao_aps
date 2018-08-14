spool /home/plan/ShinyApps/aps/producao/base_de_dados/extraidas/proc_compl/proc_compl.csv
set sqlformat csv  
set feedback off  

SELECT DISTRITO       ,UNIDADE       ,AREA       ,EXTRACT(YEAR FROM DIA_CONSULTA) AS ANO       ,EXTRACT(MONTH FROM DIA_CONSULTA) AS MES       ,COUNT(DISTINCT(CASE WHEN (PROC IN ('0401020177','90101')) THEN CONSULTA END)) AS CANTOPLASTIA       ,COUNT(DISTINCT(CASE WHEN (PROC IN ('0401010074')) THEN CONSULTA END)) AS EXERESE_CISTO       ,COUNT(DISTINCT(CASE WHEN (PROC IN ('0301040028')) THEN CONSULTA END)) AS DIU       ,COUNT(DISTINCT(CASE WHEN (PROC IN ('0404010270')) THEN CONSULTA END)) AS RETIRADA_CERUME       ,COUNT(DISTINCT(CASE WHEN (PROC IN ('0401010066')) THEN CONSULTA END)) AS SUTURA       ,COUNT(DISTINCT(CASE WHEN (PROC IN ('0414020120')) THEN CONSULTA END)) AS EXO_DESCIDUO       ,COUNT(DISTINCT(CASE WHEN (PROC IN ('0201010526')) THEN CONSULTA END)) AS BIOPSIA_BOCA       ,COUNT(DISTINCT(CASE WHEN (PROC IN ('0307030024')) THEN CONSULTA END)) AS RASPAGEM_SUB       ,COUNT(DISTINCT(CASE WHEN (PROC IN ('0307040143')) THEN CONSULTA END)) AS ADAPT_PROTESE    FROM ((  SELECT REG.NM_REGIAO AS DISTRITO       ,UNI.NM_UNIDADE AS UNIDADE       ,LGR.CD_AREA AS AREA       ,CON.CD_CONSULTA AS CONSULTA       ,CON.CD_PROCEDIMENTO AS PROC       ,CON.DT_AGENDA AS DIA_CONSULTA                   FROM VIA_CONSULTA CON LEFT JOIN VIP_USUARIO USU ON CON.CD_USUARIO = USU.CD_USUARIO LEFT JOIN VSG_LOGRADOURO LGR ON GET_LOGRADOURO( USU.nm_logradouro, USU.cd_tipo_logradouro, USU.nu_logradouro_casa, USU.cd_bairro ) = LGR.CD_LOGRADOURO LEFT JOIN VSC_UNIDADE UNI ON LGR.CD_UNIDADE = UNI.CD_UNIDADE LEFT JOIN VSG_REGIAO REG ON UNI.CD_REGIAO = REG.CD_REGIAO LEFT JOIN VSC_UNIDADE UNI2 ON TRUNC(CON.CD_CONSULTA / 10000000) = UNI2.CD_UNIDADE_INTERNO LEFT JOIN VIC_PROFISSIONAL PRO ON CON.CD_PROFISSIONAL = PRO.CD_PROFISSIONAL  WHERE (CON.dt_agenda >= TRUNC(ADD_MONTHS(SYSDATE,-3),'MONTH') AND CON.dt_agenda < TRUNC(SYSDATE,'MONTH')) AND UNI.NM_UNIDADE LIKE 'CS%' AND UNI2.NM_UNIDADE LIKE 'CS%' AND PRO.CD_ESPECIALIDADE IN ('5','152','165','6','83') )  UNION ALL (  SELECT REG.NM_REGIAO AS DISTRITO       ,UNI.NM_UNIDADE AS UNIDADE       ,LGR.CD_AREA AS AREA       ,CON.CD_CONSULTA AS CONSULTA       ,OUC.CD_PROCEDIMENTO AS PROC       ,CON.DT_AGENDA AS DIA_CONSULTA                   FROM VIA_CONSULTA CON LEFT JOIN VIP_OUTRA_CONSULTA OUC ON CON.CD_CONSULTA = OUC.CD_CONSULTA LEFT JOIN VIP_USUARIO USU ON CON.CD_USUARIO = USU.CD_USUARIO LEFT JOIN VSG_LOGRADOURO LGR ON GET_LOGRADOURO( USU.nm_logradouro, USU.cd_tipo_logradouro, USU.nu_logradouro_casa, USU.cd_bairro ) = LGR.CD_LOGRADOURO LEFT JOIN VSC_UNIDADE UNI ON LGR.CD_UNIDADE = UNI.CD_UNIDADE LEFT JOIN VSG_REGIAO REG ON UNI.CD_REGIAO = REG.CD_REGIAO LEFT JOIN VSC_UNIDADE UNI2 ON TRUNC(CON.CD_CONSULTA / 10000000) = UNI2.CD_UNIDADE_INTERNO LEFT JOIN VIC_PROFISSIONAL PRO ON CON.CD_PROFISSIONAL = PRO.CD_PROFISSIONAL  WHERE (CON.dt_agenda >= TRUNC(ADD_MONTHS(SYSDATE,-3),'MONTH') AND CON.dt_agenda < TRUNC(SYSDATE,'MONTH')) AND UNI.NM_UNIDADE LIKE 'CS%' AND UNI2.NM_UNIDADE LIKE 'CS%' AND PRO.CD_ESPECIALIDADE IN ('5','152','165','6','83') ) UNION ALL (  SELECT REG.NM_REGIAO AS DISTRITO       ,UNI.NM_UNIDADE AS UNIDADE       ,LGR.CD_AREA AS AREA       ,CON.CD_CONSULTA AS CONSULTA       ,PMT.CD_PROCEDIMENTO_BPA AS PROC       ,CON.DT_AGENDA AS DIA_CONSULTA                   FROM VIA_CONSULTA CON LEFT JOIN VIP_PROCEDIMENTO PMT ON CON.CD_CONSULTA = PMT.CD_CONSULTA LEFT JOIN VIP_USUARIO USU ON CON.CD_USUARIO = USU.CD_USUARIO LEFT JOIN VSG_LOGRADOURO LGR ON GET_LOGRADOURO( USU.nm_logradouro, USU.cd_tipo_logradouro, USU.nu_logradouro_casa, USU.cd_bairro ) = LGR.CD_LOGRADOURO LEFT JOIN VSC_UNIDADE UNI ON LGR.CD_UNIDADE = UNI.CD_UNIDADE LEFT JOIN VSG_REGIAO REG ON UNI.CD_REGIAO = REG.CD_REGIAO LEFT JOIN VSC_UNIDADE UNI2 ON TRUNC(CON.CD_CONSULTA / 10000000) = UNI2.CD_UNIDADE_INTERNO LEFT JOIN VIC_PROFISSIONAL PRO ON CON.CD_PROFISSIONAL = PRO.CD_PROFISSIONAL  WHERE (CON.dt_agenda >= TRUNC(ADD_MONTHS(SYSDATE,-3),'MONTH') AND CON.dt_agenda < TRUNC(SYSDATE,'MONTH')) AND UNI.NM_UNIDADE LIKE 'CS%' AND UNI2.NM_UNIDADE LIKE 'CS%' AND PRO.CD_ESPECIALIDADE IN ('5','152','165','6','83')  ))     GROUP BY DISTRITO       ,UNIDADE       ,AREA       ,EXTRACT(YEAR FROM DIA_CONSULTA)        ,EXTRACT(MONTH FROM DIA_CONSULTA)   ORDER BY DISTRITO       ,UNIDADE       ,AREA       ,EXTRACT(YEAR FROM DIA_CONSULTA)        ,EXTRACT(MONTH FROM DIA_CONSULTA)    ;

spool off 

exit 
 
EOF
