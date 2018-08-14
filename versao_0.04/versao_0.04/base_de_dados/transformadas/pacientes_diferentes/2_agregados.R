setwd("~/ShinyApps/aps/producao")
#Tabela de contagem por áreas
library(readr)
library(tidyverse)
library(data.table)
library(zoo)
pc <- read_csv("base_de_dados/transformadas/pacientes_diferentes/pacientes_diferentes_ajustada_utf8.csv", 
                     col_types = cols(DATA = col_character()))
pc$MES <- ifelse((nchar(pc$MES) < 2), paste0("0",pc$MES), pc$MES)
pc$DATA <- paste0(pc$ANO,"-","01","-",pc$MES)
pc$DATA <- as.Date(pc$DATA, "%Y-%d-%m") #converntendo em formato date

pc$AREA <- as.character(pc$AREA)

#Transformando mês em trimestre
pc$TRIMESTRE <- as.yearqtr(pc$DATA, format = "%d-%b-%y")
pc$TRIMESTRE <- as.character(pc$TRIMESTRE)



pc <- pc[,-c(4,5,8)] #retirando a coluna de ano, mes, data



#produzindo base de dado com pacientes diferentes (sem consultas repetidas) por especialidade
pc_medico <- pc %>% subset(ESPECIALIDADE == "Médico")
pc_medico <- aggregate(pc_medico$VALOR, by = list(pc_medico$DISTRITO, pc_medico$UNIDADE, pc_medico$AREA, pc_medico$TRIMESTRE), FUN = sum) #Unindo as consultas de um mesmo paciente em uma área e trimestre
names(pc_medico) <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE", "VALOR")
pc_medico$ESPECIALIDADE <- "Médico"
pc_enfermeiro <- pc %>% subset(ESPECIALIDADE == "Enfermeiro")
pc_enfermeiro <- aggregate(pc_enfermeiro$VALOR, by = list(pc_enfermeiro$DISTRITO,pc_enfermeiro$UNIDADE, pc_enfermeiro$AREA, pc_enfermeiro$TRIMESTRE), FUN = sum) #Unindo as consultas de um mesmo paciente em uma área e trimestre
names(pc_enfermeiro) <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE", "VALOR")
pc_enfermeiro$ESPECIALIDADE <- "Enfermeiro"
pc_odontologo <- pc %>% subset(ESPECIALIDADE == "Odontólogo")
pc_odontologo <- aggregate(pc_odontologo$VALOR, by = list(pc_odontologo$DISTRITO, pc_odontologo$UNIDADE, pc_odontologo$AREA, pc_odontologo$TRIMESTRE), FUN = sum) #Unindo as consultas de um mesmo paciente em uma área e trimestre
names(pc_odontologo) <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE", "VALOR")
pc_odontologo$ESPECIALIDADE <- "Odontólogo"
pc_medico_enfermeiro <- pc %>% subset(ESPECIALIDADE == "Médico" | ESPECIALIDADE == "Enfermeiro")
pc_medico_enfermeiro <- aggregate(pc_medico_enfermeiro$VALOR, by = list(pc_medico_enfermeiro$DISTRITO, pc_medico_enfermeiro$UNIDADE, pc_medico_enfermeiro$AREA, pc_medico_enfermeiro$TRIMESTRE), FUN = sum) #Unindo as consultas de um mesmo paciente em uma área e trimestre
names(pc_medico_enfermeiro) <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE", "VALOR")
pc_medico_enfermeiro$ESPECIALIDADE <- "Médico e Enfermeiro"
pc_total <- pc #Não é a soma de todos, pois tem que tirar os pacientes repetidos no trimestre
pc_total <- aggregate(pc_total$VALOR, by = list(pc_total$DISTRITO, pc_total$UNIDADE, pc_total$AREA, pc_total$TRIMESTRE), FUN = sum) #Unindo as consultas de um mesmo paciente em uma área e trimestre
names(pc_total) <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE", "VALOR")
pc_total$ESPECIALIDADE <- "Total"

#agregando em um banco de dados com pacientes diferentes por especialidade, trimestre e area
pc_diferente <- as.data.frame(rbind(pc_medico, pc_enfermeiro, pc_odontologo, pc_medico_enfermeiro, pc_total))
pc_diferente$AREACS <- paste(pc_diferente$UNIDADE, pc_diferente$AREA)
pc_diferente <- pc_diferente[,-3]
areas <- read_csv("base_de_dados/extraidas/areas.csv")
pc_diferente<-left_join(pc_diferente,areas,by = "AREACS")
pc_diferente <- select(pc_diferente, -AREACS)

pc_esf <- pc_diferente

#Contar pacientes por centro de saúde e data
pc_cs <- aggregate(pc_esf$VALOR, by = list(pc_esf$DISTRITO, pc_esf$UNIDADE, pc_esf$TRIMESTRE, pc_esf$ESPECIALIDADE), FUN = sum)
names(pc_cs) <- c("DISTRITO", "UNIDADE", "TRIMESTRE", "ESPECIALIDADE", "VALOR")


#Contar pacientes por distrito e data
pc_distrito<- aggregate(pc_esf$VALOR, by = list(pc_esf$DISTRITO, pc_esf$TRIMESTRE, pc_esf$ESPECIALIDADE), FUN = sum)
names(pc_distrito) <- c("DISTRITO", "TRIMESTRE", "ESPECIALIDADE", "VALOR")


#Contar pacientes em toda Florianópolis por especialidade e data
pc_florianopolis<- aggregate(pc_esf$VALOR, by = list(pc_esf$TRIMESTRE, pc_esf$ESPECIALIDADE), FUN = sum)
names(pc_florianopolis) <- c("TRIMESTRE", "ESPECIALIDADE", "VALOR")

#Lendo as bases antigas
pc_esf_old <- read_csv("base_de_dados/transformadas/pacientes_diferentes/pc_esf.csv", 
                       col_types = cols(VALOR = col_double()))
pc_cs_old <- read_csv("base_de_dados/transformadas/pacientes_diferentes/pc_cs.csv", 
                      col_types = cols(VALOR = col_double()))
pc_distrito_old <- read_csv("base_de_dados/transformadas/pacientes_diferentes/pc_distrito.csv", 
                            col_types = cols(VALOR = col_double()))
pc_florianopolis_old <- read_csv("base_de_dados/transformadas/pacientes_diferentes/pc_florianopolis.csv", 
                                 col_types = cols(VALOR = col_double()))

#Salvando as bases antigas como old
write.csv(pc_esf_old, "base_de_dados/transformadas/pacientes_diferentes/pc_esf_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(pc_cs_old, "base_de_dados/transformadas/pacientes_diferentes/pc_cs_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(pc_distrito_old, "base_de_dados/transformadas/pacientes_diferentes/pc_distrito_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(pc_florianopolis_old, "base_de_dados/transformadas/pacientes_diferentes/pc_florianopolis_old.csv", fileEncoding = "UTF-8", row.names = F)


#Fazendo rbind das bases antigas com as novas
pc_esf_new <- rbind(pc_esf, pc_esf_old) 
pc_cs_new <- rbind( pc_cs, pc_cs_old) 
pc_distrito_new <- rbind(pc_distrito, pc_distrito_old) 
pc_florianopolis_new <- rbind(pc_florianopolis,pc_florianopolis_old) 


#Escrever bases atualizadas
write.csv(pc_esf_new, "base_de_dados/transformadas/pacientes_diferentes/pc_esf.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(pc_cs_new, "base_de_dados/transformadas/pacientes_diferentes/pc_cs.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(pc_distrito_new, "base_de_dados/transformadas/pacientes_diferentes/pc_distrito.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(pc_florianopolis_new, "base_de_dados/transformadas/pacientes_diferentes/pc_florianopolis.csv", fileEncoding = "UTF-8", row.names = F)




