#!/bin/bash
#Conexão do sqlplus com base do INFO
##Setando encoding
export NLS_LANG=.UTF8

#Conectando a base, baixando, escrevendo csv e saindo do sqlplus
/home/plan/scripts/sqlcl/dbtools/bin/sql "SMSSYS/teste@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=172.17.49.12)(PORT=1521))(CONNECT_DATA=(SID=SMS999)))" @/home/plan/ShinyApps/aps/producao/base_de_dados/extraidas/2_citopatologico_pop.sql
