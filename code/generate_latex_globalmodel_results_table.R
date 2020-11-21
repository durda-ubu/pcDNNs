rm(list=ls())

library(stringr)



get.lasso.performance <- function(x) {
        result = x[,c("test.cor","test.mse")]
        return(round(result, digits=3))
}


get.dnn.performance <- function(x) {
        x = split(x, x$pred.type)[["wavg"]]
        result = x[,c("test.cor","test.mse")]
        return(round(result, digits=3))
}




setwd("../results/no2-meteo dataset/spocu/")

models.order = c("lasso","fcDNN","pcDNN")
pcDNNs.order = c("station","all")

tabla = data.frame(N=numeric(0), type=numeric(0), model=character(0), pcor=numeric(0), mse=numeric(0), stringsAsFactors = F)
directorios = list.dirs(getwd(), full.names = F, recursive = F)
for (dir in directorios) {
        dsize = str_sub(dir, 2)
        modelos = intersect(models.order, list.dirs(paste0(getwd(),"/",dir), full.names = F, recursive = F))
        for (model in modelos) {
                if (model == "lasso") {
                        results.csv  = read.csv(file=paste0(getwd(),"/",dir,"/",model,"/",model,"_global_model.csv"), header=T, sep=",", stringsAsFactors = F)
                        results.perf = get.lasso.performance(results.csv)
                        tabla[nrow(tabla)+1,] = c(dsize, 0, "Lasso", results.perf)
                } else if (model == "fcDNN") {
                        results.csv  = read.csv(file=paste0(getwd(),"/",dir,"/",model,"/",model,"_global_model.csv"), header=T, sep=",", stringsAsFactors = F)
                        results.perf = get.dnn.performance(results.csv)
                        tabla[nrow(tabla)+1,] = c(dsize, 1, "fc-DNN", results.perf)
                } else {
                        hypothesis = intersect(pcDNNs.order, list.dirs(paste0(getwd(),"/",dir,"/",model), full.names = F, recursive = F))
                        for (hypo in hypothesis) {
                                results.csv  = read.csv(file=paste0(getwd(),"/",dir,"/",model,"/","/",hypo,"/",model,"_global_model.csv"), header=T, sep=",", stringsAsFactors = F)
                                results.perf = get.dnn.performance(results.csv)
                                tabla[nrow(tabla)+1,] = c(dsize, 1, paste0("pc-DNN-", hypo), results.perf)
                        }
                }
        }
}


tabla = tabla[order(tabla$N, tabla$type),]
for (i in 1: nrow(tabla)) {
        cat(tabla[i,1], "&", tabla[i,3], "&", tabla[i,4], "&", tabla[i,5], "\\\\\n")
}

