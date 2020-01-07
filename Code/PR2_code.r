# Cargamos las librerias necesarias


library(VIM)
library(nortest)

## Importación del dataset

country_data <- read.csv ("../Data/initial_dataset.csv", header = TRUE, dec=",")


# Comprobamos el tipo de variables
sapply(country_data, function(x) class(x))

# Eliminamos variables superfluas
country_data <- country_data[,-(5:6)]
country_data <- country_data[, -(10:14)]

# Reemplazamos GDP por el producto de otros dos atributos
country_data$GDP <- as.integer((country_data$GDP....per.capita. * country_data$Population)/ 1000000)
country_data <- country_data[, -(7)]


# Sustitución de los valores nulos

country_data$GDP....per.capita.[224]<- 2500

suppressWarnings (suppressMessages (library(VIM)))
country_data$Literacy_rate <- kNN(country_data)$Literacy_rate

country_data$Birthrate[182] <- 9.2
country_data$Birthrate[222] <- 5.5
country_data$Birthrate[182] <- 28.9

country_data$Deathrate[48] <- 8.6
country_data$Deathrate[182] <- 13.2
country_data$Deathrate[222] <- 5.5
country_data$Deathrate[224] <- 11.49

country_data$Unemployment_rate <- kNN(country_data)$Unemployment_rate

country_data$Net.migration[48] <- -2.2
country_data$Net.migration[222] <- -4.6
country_data$Net.migration[224] <- 5.4


country_data$Infant.mortality[48] <- 12.6
country_data$Infant.mortality[222] <- 4.3
country_data$Infant.mortality[224] <- 50.5


## Reducción de la dimensionalidad

# Reemplazamos tres atributos por una variable categórica 

country_data$Main_sector <- ifelse ((country_data$Agriculture > country_data$Industry) & (country_data$Agriculture > country_data$Service), "Primario", 
ifelse((country_data$Industry > country_data$Agriculture) & (country_data$Industry > country_data$Service), "Secundario",
ifelse((country_data$Service > country_data$Agriculture) & (country_data$Service > country_data$Industry), "Terciario", "Desconocido")))

# Rellenamos valores nulos de forma manual

country_data$Main_sector[4] <- "Primario"
country_data$Main_sector[5] <- "Terciario"
country_data$Main_sector[79] <- "Terciario"
country_data$Main_sector[81] <- "Secundario"
country_data$Main_sector[84] <- "Terciario"
country_data$Main_sector[135] <- "Primario"
country_data$Main_sector[139] <- "Terciario"
country_data$Main_sector[141] <- "Terciario"
country_data$Main_sector[145] <- "Terciario"
country_data$Main_sector[154] <- "Secundario"
country_data$Main_sector[172] <- "Primario"
country_data$Main_sector[175] <- "Terciario"
country_data$Main_sector[178] <- "Terciario"
country_data$Main_sector[209] <- "Terciario"
country_data$Main_sector[222] <- "Primario"
country_data$Main_sector[224] <- "Primario"


# Eliminamos las tres variables 

country_data <- country_data[, -(10:12)]

# Eliminamos un último atributo redundante

country_data <- country_data[, -(6)]

# Renombramos las columnas del dataframe

colnames (country_data) <- c("Country", "Region", "Population", "Area", "Net_migration", "GDP_per_capita", "Literacy_rate", "Birthrate", "Deathrate", "Unemployment_rate", "Infant_mortality", "GDP", "Main_sector")


## Hallamos valores extremos mediante boxplot.stats()

boxplot.stats(country_data$Net_migration)$out
boxplot.stats(country_data$GDP_per_capita)$out
boxplot.stats(country_data$Literacy_rate)$out
boxplot.stats(country_data$Birthrate)$out
boxplot.stats(country_data$Deathrate)$out
boxplot.stats(country_data$Unemployment_rate)$out
boxplot.stats(country_data$Infant_mortality)$out


# Usamos boxplots para examinar en profundidas los valores extremos

boxplot(country_data$GDP_per_capita ~ country_data$Region, data = country_data, main = "PIB per cápita por zona", xlab = "Región", 
ylab= "PIB per cápita")
boxplot(country_data$Literacy_rate ~ country_data$Region, data = country_data, main = "Tasa de alfabetización por zona", xlab = "Región", ylab= "Tasa de alfabetización")
boxplot(country_data$Deathrate ~ country_data$Region, data = country_data, main = "Tasa de mortalidad por zona", xlab = "Región", ylab= "Tasa de mortalidad")
boxplot(country_data$Unemployment_rate ~ country_data$Region, data = country_data, main = "Tasa de desempleo por zona", xlab = "Región", ylab= "Tasa de desempleo")
boxplot(country_data$Literacy_rate ~ country_data$Region, data = country_data, main = "Tasa de alfabetización por zona", xlab = "Región", ylab= "Tasa de alfabetización")
boxplot(country_data$Infant_mortality ~ country_data$Region, data = country_data, main = "Tasa de mortalidad por zona", xlab = "Región", ylab= "Tasa de mortalidad infantil")
boxplot(country_data$Net_migration ~ country_data$Region, data = country_data, main = "Tasa migratoria por zona", xlab = "Región", ylab= "Tasa migratoria")


# Reemplazamos algunos de los outliers, que son erroneos

country_data$Unemployment_rate[227] <- 4.2
country_data$Unemployment_rate[32] <- 3.4
country_data$Unemployment_rate[56] <- 13.0
country_data$Unemployment_rate[181] <- 8.0
country_data$Net.migration[224] <- -3.5

## Exportación de los datos pre-procesados

write.csv(country_data, "country_data.csv")


## Selección de los grupos a analizar

# Por zona

country_data.asia <- country_data[country_data$Region == "ASIA (EX.NEAR EAST)",]
country_data.africa_norte <- country_data[country_data$Region == "NORTHERN AFRICA",]
country_data.oceania <- country_data[country_data$Region == "OCEANIA",]
country_data.europa <- country_data[country_data$Region == "WESTERN EUROPE",]
country_data.africa <- country_data[country_data$Region == "SUB-SAHARAN AFRICA",]
country_data.sudamerica <- country_data[country_data$Region == "LATIN AMER. & CARIB",]
country_data.medio_oriente <- country_data[country_data$Region == "NEAR EAST",]
country_data.norteamerica <- country_data[country_data$Region == "NORTHERN AMERICA",]
country_data.europa_este <- country_data[country_data$Region == "EASTERN EUROPE" | country_data$Region == "C.W. OF IND. STATES" | country_data$Region == "BALTICS",]

# Por PIB

country_data.PIB_pc_alto <- country_data[country_data$GDP_per_capita > 9660,]
country_data.PIB_pc_bajo <- country_data[country_data$GDP_per_capita < 9660,]
country_data.PIB_alto <- country_data[country_data$GDP > 20000,]
country_data.PIB_bajo <- country_data[country_data$GDP < 20000,]

# Comprobación de la normalidad

alpha = 0.5
col.names = colnames(country_data)
for (i in 1:ncol(country_data)){
    if (i == 1) cat("Variables que no siguen una distribución normal:\n")
    if(is.integer(country_data[,i]) | is.numeric (country_data[,i])) {
        p_val = ad.test(country_data[,i])$p.value
        if (p_val < alpha) {
            cat(col.names[i])
            
        if (i < ncol(country_data) - 1) cat(",")
        if (i %% 3 == 0) cat("\n")
        }
     }
 }

# Comprobación de la homocedasticidad

fligner.test (Net_migration ~ Region, data = country_data)
fligner.test (GDP_per_capita ~ Region, data = country_data)
fligner.test (Literacy_rate ~ Region, data = country_data)
fligner.test (Birthrate ~ Region, data = country_data)
fligner.test (Deathrate ~ Region, data = country_data)
fligner.test (Unemployment_rate ~ Region, data = country_data)
fligner.test (Infant_mortality ~ Region, data = country_data)

fligner.test (Net_migration ~ Region, data = country_data.europa_este)


## PRUEBAS ESTADÍSTICAS

# Test de Wicoxon

country_data$GDP_category <- ifelse ((country_data$GDP > 20000), "Alto",
ifelse((country_data$GDP < 20000), "Bajo", "Desconocido"))
country_data$GDP_pc_category <- ifelse ((country_data$GDP_per_capita > 9660), "Alto", 
ifelse ((country_data$GDP_per_Capita < 9660), "Bajo", "Desconocido"))

wilcox.test (Net_migration ~ GDP_category, data = country_data)
wilcox.test (Net_migration) ~ GDP_pc_category, data = coountry_data)

# Hallar la correlación de cada variable

## EUROPA DEL ESTE

# Creamos una matriz que muestre el nivel de correlación de cada variable con la tasa de migración
matrix_eureste <- matrix (nc = 2, nr = 0)
colnames (matrix_eureste) <- c("estimate", "p-value")

# Calculamos el coeficiente de correlación para cada variable cualitativa con respecto a la tase de migración 
for (i in 1:(ncol(country_data.europa_este) - 1)) {
    if (is.integer (country_data.europa_este[,i]) | is.numeric (country_data.europa_este[,i])) {
        spearman_test = cor.test (country_data.europa_este[,i], country_data.europa_este[,5], method = "spearman")
        corr_coef = spearman_test$estimate
        p_val = spearman_test$p.value     
		
		
pair = matrix(ncol = 2, nrow = 1)
pair[1][1] = corr_coef
pair[2][1] = p_val
matrix_eureste <- rbind(matrix_eureste, pair)
rownames (matrix_eureste) [nrow(matrix_eureste)] <- colnames (country_data.europa_este) [i]
    }
}

# Representamos la tabla de correlación

print (matrix_eureste)

# Representamos el modelo de regresión

plot (country_data.europa_este$GDP, country_data.europa_este$Net_migration, xlab = "PIB", ylab = "Tasa de inmigración")
abline (lm (country_data.europa_este$Net_migration ~ country_data.europa_este$GDP), col = "red")


## SUDAMERICA

matrix_sud <- matrix (nc = 2, nr = 0)
colnames (matrix_sud) <- c("estimate", "p-value")


for (i in 1:(ncol(country_data.sudamerica) - 1)) {
    if (is.integer (country_data.sudamerica[,i]) | is.numeric (country_data.sudamerica[,i])) {
        spearman_test = cor.test (country_data.sudamerica[,i], country_data.sudamerica[,5], method = "spearman")
        corr_coef = spearman_test$estimate
        p_val = spearman_test$p.value  
        
        
pair = matrix(ncol = 2, nrow = 1)
pair[1][1] = corr_coef
pair[2][1] = p_val
matrix_sud <- rbind(matrix_sud, pair)
rownames (matrix_sud) [nrow(matrix_sud)] <- colnames (country_data.sudamerica) [i]
    }
}

print (matrix_sud)

plot (country_data.sudamerica$Net_migration, country_data.sudamerica$Deathrate, xlab = "Tasa de migración", ylab = "Tasa de mortalidad")
abline (lm (country_data.sudamerica$Deathrate ~ country_data.sudamerica$Net_migration), col = "red")


## ÁFRICA

matrix_africa <- matrix (nc = 2, nr = 0)
colnames (matrix_africa) <- c("estimate", "p-value")


for (i in 1:(ncol(country_data.africa) - 1)) {
    if (is.integer (country_data.africa[,i]) | is.numeric (country_data.africa[,i])) {
        spearman_test = cor.test (country_data.africa[,i], country_data.africa[,5], method = "spearman")
        corr_coef = spearman_test$estimate
        p_val = spearman_test$p.value  
pair = matrix(ncol = 2, nrow = 1)
pair[1][1] = corr_coef
pair[2][1] = p_val
matrix_africa <- rbind(matrix_africa, pair)
rownames (matrix_africa) [nrow(matrix_africa)] <- colnames (country_data.africa) [i]
    }
}


print (matrix_africa)


plot (country_data.africa$Net_migration, country_data.africa$Literacy_rate, xlab = "Tasa de migración", ylab = "Tasa de alfabetización")
abline (lm (country_data.africa$Literacy_rate ~ country_data.africa$Net_migration), col = "red")


## Creación de los modelos de regresión para predecir un valor

## EUROPA

# Renombramos las variables para faciliar el proceso
 
# Variable a predecir

tasa_migracion = country_data.europa_este$Net_migration

# Variables cuantitativas con mayor coeficiente de correlación con respecto a la tasa migratoria

 PIB_per_capita = country_data.europa_este$GDP_per_capita 
 PIB = country_data.europa_este$GDP
 mortalidad_infantil = country_data.europa_este$Infant_mortality
 tasa_desempleo = country_data.europa_este$Unemployment_rate
 tasa_nacimientos = country_data.europa_este$Birthrate
 tasa_alfabetizacion = country_data.europa_este$Literacy_rate
 tasa_mortalidad = country_data.europa_este$Deathrate
 
 # Regresos cualitativos
 
 sector_economico = country_data.europa_este$Main_sector
 
 
# Creamos tres modelos para seleccionar el que tenga mayor coeficiente de determinación

modelo1_eureste <- lm(tasa_migracion ~ PIB + PIB_per_capita + mortalidad_infantil + tasa_desempleo + tasa_nacimientos + tasa_alfabetizacion + tasa_mortalidad + sector_economico, data = country_data.europa_este)
modelo2_eureste <- lm(tasa_migracion ~ PIB + PIB_per_capita + mortalidad_infantil + tasa_nacimientos + tasa_mortalidad, data = country_data.europa_este)
modelo3_eureste <- lm(tasa_migracion ~ PIB + PIB_per_capita + mortalidad_infantil, data = country_data.europa_este)


# Representamos los coeficientes de determinación de cada modelo para ver cuál es el mejor

tabla.coeficientes <- matrix(c(1, summary(modelo1_eureste)$r.squared, 
                    2, summary(modelo2_eureste)$r.squared, 
                    3, summary(modelo3_eureste)$r.squared), 
                    ncol = 2, byrow = TRUE)
 
colnames(tabla.coeficientes) <- c("Modelo", "coeficiente")

tabla.coeficientes


## SUDAMERICA

# Renombramos las variables para faciliar el proceso
 
# Variable a predecir

tasa_migracion = country_data.sudamerica$Net_migration

# Variables cuantitativas con mayor coeficiente de correlación con respecto a la tasa migratoria
 
 PIB_per_capita = country_data.sudamerica$GDP_per_capita
 PIB = country_data.sudamerica$GDP
 mortalidad_infantil = country_data.sudamerica$Infant_mortality
 tasa_desempleo = country_data.sudamerica$Unemployment_rate
 tasa_nacimientos = country_data.sudamerica$Birthrate
 tasa_alfabetizacion = country_data.sudamerica$Literacy_rate
 tasa_mortalidad = country_data.sudamerica$Deathrate
 
 # Regresos cualitativos
 
 sector_economico = country_data.sudamerica$Main_sector
 
# Creamos tres modelos para seleccionar el que tenga mayor coeficiente de determinación

modelo1_sud <- lm(tasa_migracion ~ PIB + PIB_per_capita + mortalidad_infantil + tasa_desempleo + tasa_nacimientos +tasa_alfabetizacion + tasa_mortalidad + sector_economico, data = country_data.sudamerica)
modelo2_sud <- lm(tasa_migracion ~ PIB + PIB_per_capita + mortalidad_infantil + tasa_nacimientos + tasa_mortalidad + sector_economico, data = country_data.sudamerica)
modelo3_sud <- lm(tasa_migracion ~ PIB + PIB_per_capita + mortalidad_infantil, data = country_data.sudamerica)

# Representamos los coeficientes de determinación de cada modelo para ver cuál es el mejor

tabla.coeficientes <- matrix(c(1, summary(modelo1_sud)$r.squared, 
                    2, summary(modelo2_sud)$r.squared, 
                    3, summary(modelo3_sud)$r.squared), 
                    ncol = 2, byrow = TRUE)
 
colnames(tabla.coeficientes) <- c("Modelo", "coeficiente")

tabla.coeficientes
 
 
## ÁFRICA

# Renombramos las variables para faciliar el proceso
 
# Variable a predecir

 tasa_migracion = country_data.africa$Net_migration
 
# Variables cuantitativas con mayor coeficiente de correlación con respecto a la tasa migratoria

PIB = country_data.africa$GDP
PIB_per_capita = country_data.africa$GDP_per_capita
mortalidad_infantil = country_data.africa$Infant_mortality
tasa_desempleo = country_data.africa$Unemployment_rate
tasa_nacimientos = country_data.africa$Birthrate
tasa_alfabetizacion = country_data.africa$Literacy_rate
tasa_mortalidad = country_data.africa$Deathrate

# Regresos cualitativos

sector_economico = country_data.africa$Main_sector

# Creamos tres modelos para seleccionar el que tenga mayor coeficiente de determinación

modelo1_afr <- lm(tasa_migracion ~ PIB + PIB_per_capita + mortalidad_infantil + tasa_desempleo + tasa_nacimientos +tasa_alfabetizacion + tasa_mortalidad + sector_economico, data = country_data.africa)
modelo2_afr <- lm(tasa_migracion ~ PIB + PIB_per_capita + mortalidad_infantil + tasa_nacimientos + tasa_mortalidad + sector_economico, data = country_data.africa)
modelo3_afr <- lm(tasa_migracion ~ PIB + PIB_per_capita + mortalidad_infantil, data = country_data.africa)

# Representamos los coeficientes de determinación de cada modelo para ver cuál es el mejor

tabla.coeficientes <- matrix(c(1, summary(modelo1_afr)$r.squared, 
                     2, summary(modelo2_afr)$r.squared, 
                      3, summary(modelo3_afr)$r.squared), 
                      ncol = 2, byrow = TRUE)
colnames(tabla.coeficientes) <- c("Modelo", "coeficiente")

tabla.coeficientes

# Representación gráfica del modelo de cada región

plot (modelo1_eureste)
plot (modelo1_sud)
plot (modelo1_afr)


## Realizamos predicciones utilizando los modelos creados

albania_new <- data.frame(PIB = 130400, PIB_per_capita = 4538, mortalidad_infantil= 7.8, tasa_desempleo = 13.8, tasa_nacimientos = 13.2, tasa_alfabetizacion = 97.6, tasa_mortalidad = 6.9, sector_economico = "Terciario")
predict (modelo1_eureste, albania_new)

ecuador_new <- data.frame(PIB = 189750, PIB_per_capita = 11500, mortalidad_infantil= 15.9, tasa_desempleo = 4.6, tasa_nacimientos = 17.6, tasa_alfabetizacion = 96.1, tasa_mortalidad = 5.1, sector_economico = "Secundario")
predict (modelo1_sud, ecuador_new)

nigeria_new <- data.frame(PIB = 119992, PIB_per_capita = 910, mortalidad_infantil= 98.0, tasa_desempleo = 12.5, tasa_nacimientos = 40.43, tasa_alfabetizacion = 68.0, tasa_mortalidad = 16.94, sector_economico = "Secundario")
predict (modelo1_afr, nigeria_new)