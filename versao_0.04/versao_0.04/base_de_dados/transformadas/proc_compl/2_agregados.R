setwd("~/ShinyApps/aps/producao")
#Tabela de contagem por áreas
library(readr)
library(tidyverse)
library(data.table)
library(zoo)


#Dimensão integralidade
#PREPARANDO A BASE
proc_compl <- read_csv("base_de_dados/transformadas/proc_compl/proc_compl_ajustada_utf8.csv")
proc_compl$DATA <- as.yearmon(paste(proc_compl$ANO, proc_compl$MES), "%Y %m") #converntendo em formato date
proc_compl$AREA <- as.character(proc_compl$AREA)

#Transformando ano e mês em trimestre
proc_compl$TRIMESTRE <- as.yearqtr(proc_compl$DATA, format = "%d-%b-%y")
proc_compl$TRIMESTRE <- as.character(proc_compl$TRIMESTRE)


proc_compl<-proc_compl[,-c(3,4,15)]

############################################################
#Equipes
############################################################
#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
proc_compl_med<-proc_compl[,c(1:7,12,13)]
proc_compl_med<-aggregate(proc_compl_med[,3:7], by = list(proc_compl_med$DISTRITO, proc_compl_med$UNIDADE,proc_compl_med$AREA, proc_compl_med$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(proc_compl_med)[1:4] <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE")


#Transformando em Tidy
proc_compl_med <- melt(proc_compl_med, id.var = c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE"))
colnames(proc_compl_med)[5:6] <- c("TIPO", "VALOR")
proc_compl_med$ESPECIALIDADE <- "Médico"

#data.frame só com os percentuais
proc_compl_odo <- proc_compl[,c(1,2,8:13)]
proc_compl_odo<-aggregate(proc_compl_odo[,3:6], by = list(proc_compl_odo$DISTRITO, proc_compl_odo$UNIDADE,proc_compl_odo$AREA, proc_compl_odo$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(proc_compl_odo)[1:4] <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE")

#Transformando em Tidy
proc_compl_odo <- melt(proc_compl_odo, id.var = c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE"))
colnames(proc_compl_odo)[5:6] <- c("TIPO", "VALOR")
proc_compl_odo$ESPECIALIDADE <- "Odontólogo"


#Unindo as duas tabelas
proc_compl_esf<-rbind(proc_compl_med,proc_compl_odo)



############################################################
#CS
############################################################

#Contar por área e TRIMESTRE 
proc_compl_cs<-aggregate(proc_compl_esf$VALOR, by = list(proc_compl_esf$DISTRITO, proc_compl_esf$UNIDADE, proc_compl_esf$TRIMESTRE, proc_compl_esf$TIPO, proc_compl_esf$ESPECIALIDADE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(proc_compl_cs) <- c("DISTRITO", "UNIDADE", "TRIMESTRE", "TIPO", "ESPECIALIDADE", "VALOR")



############################################################
#Distrito
############################################################

#Contar por área e TRIMESTRE 
proc_compl_distrito<-aggregate(proc_compl_esf$VALOR, by = list(proc_compl_esf$DISTRITO, proc_compl_esf$TRIMESTRE, proc_compl_esf$TIPO, proc_compl_esf$ESPECIALIDADE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(proc_compl_distrito) <- c("DISTRITO", "TRIMESTRE", "TIPO", "ESPECIALIDADE", "VALOR")

############################################################
#Florianópolis
############################################################

#Contar por área e TRIMESTRE 
proc_compl_florianopolis<-aggregate(proc_compl_esf$VALOR, by = list(proc_compl_esf$TRIMESTRE, proc_compl_esf$TIPO, proc_compl_esf$ESPECIALIDADE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(proc_compl_florianopolis) <- c("TRIMESTRE", "TIPO", "ESPECIALIDADE", "VALOR")


#Lendo as bases antigas
proc_compl_esf_old <- read_csv("base_de_dados/transformadas/proc_compl/proc_compl_esf.csv", 
                               col_types = cols(VALOR = col_double()))
proc_compl_cs_old <- read_csv("base_de_dados/transformadas/proc_compl/proc_compl_cs.csv", 
                              col_types = cols(VALOR = col_double()))
proc_compl_distrito_old <- read_csv("base_de_dados/transformadas/proc_compl/proc_compl_distrito.csv", 
                                    col_types = cols(VALOR = col_double()))
proc_compl_florianopolis_old <- read_csv("base_de_dados/transformadas/proc_compl/proc_compl_florianopolis.csv", 
                                         col_types = cols(VALOR = col_double()))

#Salvando as bases antigas como old
write.csv(proc_compl_esf_old, "base_de_dados/transformadas/proc_compl/proc_compl_esf_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(proc_compl_cs_old, "base_de_dados/transformadas/proc_compl/proc_compl_cs_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(proc_compl_distrito_old, "base_de_dados/transformadas/proc_compl/proc_compl_distrito_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(proc_compl_florianopolis_old, "base_de_dados/transformadas/proc_compl/proc_compl_florianopolis_old.csv", fileEncoding = "UTF-8", row.names = F)


#Fazendo rbind das bases antigas com as novas
proc_compl_esf_new <- rbind(proc_compl_esf, proc_compl_esf_old) 
proc_compl_cs_new <- rbind( proc_compl_cs, proc_compl_cs_old) 
proc_compl_distrito_new <- rbind(proc_compl_distrito, proc_compl_distrito_old) 
proc_compl_florianopolis_new <- rbind(proc_compl_florianopolis,proc_compl_florianopolis_old) 


#Escrever bases atualizadas
write.csv(proc_compl_esf_new, "base_de_dados/transformadas/proc_compl/proc_compl_esf.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(proc_compl_cs_new, "base_de_dados/transformadas/proc_compl/proc_compl_cs.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(proc_compl_distrito_new, "base_de_dados/transformadas/proc_compl/proc_compl_distrito.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(proc_compl_florianopolis_new, "base_de_dados/transformadas/proc_compl/proc_compl_florianopolis.csv", fileEncoding = "UTF-8", row.names = F)



