setwd("~/ShinyApps/aps/producao")
#Tabela de contagem por áreas
library(readr)
library(tidyverse)
library(data.table)
library(zoo)


#PREPARANDO A BASE
citopatologico <- read_csv("base_de_dados/transformadas/citopatologico/citopatologico_ajustada_utf8.csv")
citopatologico$DATA <- as.yearmon(paste(citopatologico$ANO, citopatologico$MES), "%Y %m") #converntendo em formato date
citopatologico$AREA <- as.character(citopatologico$AREA)

#Transformando ano e mês em trimestre
citopatologico$TRIMESTRE <- as.yearqtr(citopatologico$DATA, format = "%d-%b-%y")
citopatologico$TRIMESTRE <- as.character(citopatologico$TRIMESTRE)
citopatologico <- subset(citopatologico, citopatologico$TRIMESTRE != "2018 Q3")

#A população tirada da base é a população de mulheres entre 25 e 64anos diferentes atendidas por trimestre. Como elas devem fazer
#o exame a cada 3 anos, 1/3 dela deve fazer em cada um dos trimestres. Assim, dividiu-se a população por 3.
citopatologico$PESSOAS <- citopatologico$PESSOAS/3




############################################################
#Equipes
############################################################
citopatologico_esf<-citopatologico[,c(1,2,5,6,7,9)]
citopatologico_esf<-aggregate(citopatologico_esf[,c(3,4)], by = list(citopatologico_esf$DISTRITO, citopatologico_esf$UNIDADE,citopatologico_esf$AREA, citopatologico_esf$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(citopatologico_esf) <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE", "CITOPATO", "PESSOAS")
#Calculando a percentagem
citopatologico_esf$VALOR <- citopatologico_esf$CITOPATO/citopatologico_esf$PESSOAS*100
#Tirando cito e pessoas
citopatologico_esf<- citopatologico_esf[-c(5,6)]


############################################################
#CS
############################################################
citopatologico_cs<-citopatologico[,c(1,2,5,6,9)]
citopatologico_cs<-aggregate(citopatologico_cs[,c(3,4)], by = list(citopatologico_cs$DISTRITO, citopatologico_cs$UNIDADE, citopatologico_cs$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(citopatologico_cs) <- c("DISTRITO", "UNIDADE", "TRIMESTRE", "CITOPATO", "PESSOAS")
#Calculando a percentagem
citopatologico_cs$VALOR <- citopatologico_cs$CITOPATO/citopatologico_cs$PESSOAS*100
#Tirando cito e pessoas
citopatologico_cs<- citopatologico_cs[-c(4,5)]

############################################################
#Distrito
############################################################
citopatologico_distrito<-citopatologico[,c(1,5,6,9)]
citopatologico_distrito<-aggregate(citopatologico_distrito[,c(2,3)], by = list(citopatologico_distrito$DISTRITO, citopatologico_distrito$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(citopatologico_distrito) <- c("DISTRITO", "TRIMESTRE", "CITOPATO", "PESSOAS")
#Calculando a percentagem
citopatologico_distrito$VALOR <- citopatologico_distrito$CITOPATO/citopatologico_distrito$PESSOAS*100
#Tirando cito e pessoas
citopatologico_distrito<- citopatologico_distrito[-c(3,4)]

############################################################
#Florianópolis
############################################################
citopatologico_florianopolis<-citopatologico[,c(5,6,9)]
citopatologico_florianopolis<-aggregate(citopatologico_florianopolis[,c(1,2)], by = list( citopatologico_florianopolis$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(citopatologico_florianopolis) <- c("TRIMESTRE", "CITOPATO", "PESSOAS")
#Calculando a percentagem
citopatologico_florianopolis$VALOR <- citopatologico_florianopolis$CITOPATO/citopatologico_florianopolis$PESSOAS*100
#Tirando cito e pessoas
citopatologico_florianopolis<- citopatologico_florianopolis[-c(2,3)]

#Lendo as bases antigas
citopatologico_esf_old <- read_csv("base_de_dados/transformadas/citopatologico/citopatologico_esf.csv", 
                                   col_types = cols(VALOR = col_double()))
citopatologico_cs_old <- read_csv("base_de_dados/transformadas/citopatologico/citopatologico_cs.csv", 
                                  col_types = cols(VALOR = col_double()))
citopatologico_distrito_old <- read_csv("base_de_dados/transformadas/citopatologico/citopatologico_distrito.csv", 
                                        col_types = cols(VALOR = col_double()))
citopatologico_florianopolis_old <- read_csv("base_de_dados/transformadas/citopatologico/citopatologico_florianopolis.csv", 
                                             col_types = cols(VALOR = col_double()))

#Salvando as bases antigas como old
write.csv(citopatologico_esf_old, "base_de_dados/transformadas/citopatologico/citopatologico_esf_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(citopatologico_cs_old, "base_de_dados/transformadas/citopatologico/citopatologico_cs_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(citopatologico_distrito_old, "base_de_dados/transformadas/citopatologico/citopatologico_distrito_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(citopatologico_florianopolis_old, "base_de_dados/transformadas/citopatologico/citopatologico_florianopolis_old.csv", fileEncoding = "UTF-8", row.names = F)


#Fazendo rbind das bases antigas com as novas
citopatologico_esf_new <- rbind(citopatologico_esf, citopatologico_esf_old) 
citopatologico_cs_new <- rbind( citopatologico_cs, citopatologico_cs_old) 
citopatologico_distrito_new <- rbind(citopatologico_distrito, citopatologico_distrito_old) 
citopatologico_florianopolis_new <- rbind(citopatologico_florianopolis,citopatologico_florianopolis_old) 


#Escrever bases atualizadas
write.csv(citopatologico_esf_new, "base_de_dados/transformadas/citopatologico/citopatologico_esf.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(citopatologico_cs_new, "base_de_dados/transformadas/citopatologico/citopatologico_cs.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(citopatologico_distrito_new, "base_de_dados/transformadas/citopatologico/citopatologico_distrito.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(citopatologico_florianopolis_new, "base_de_dados/transformadas/citopatologico/citopatologico_florianopolis.csv", fileEncoding = "UTF-8", row.names = F)

                   

