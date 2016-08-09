#### Save the resulted matrix as a Gephi output
## Category names
library(igraph)
library(rgexf)

catsmrf <- c("Diet",
          "Supplements",
          "Supplements",
          "Supplements",
          "Supplements",
          "Supplements",
          "Smoking",
          "Smoking",
          "Alcohol",
          "Physical Activity",
          "Physical Activity",
          "Physical Activity",
          "Sleep",
          "Sleep",
          "Sleep",
          "Psychological Status",
          "Physical Measures",
          "Blood Pressure",
          "Blood Pressure",
          "Blood Pressure",
          "Diagnosis",
          "Social",
          "Social",
          "Hearing",
          "Hearing",
          "Hearing",
          "Cognitive Measures",
          "Cognitive Measures",
          "Cognitive Measures",
          "Cognitive Measures",
          "Demographics",
          "Demographics",
          "Demographics",
          "Demographics",
          "Demographics",
          "Inflammation",
          "Inflammation",
          "Cholesterol",
          "Cholesterol",
          "MRI Confound",
          "Diagnosis")


catsidp <- c("dMRI TBSS",
             "dMRI TBSS",
             "rfMRI Con 25 Edge",
             "rfMRI Con 100 Edge",
             "rfMRI Con 25 Edge",
             "rfMRI Con 25 Edge",
             "rfMRI Con 25 Edge",
             "dMRI TBSS",
             "dMRI TBSS",
             "rfMRI Con 25 Edge",
             "dMRI Probtrack",
             "rfMRI Con 25 Edge",
             "dMRI TBSS",
             "rfMRI Con 25 Edge",
             "dMRI Probtrack",
             "dMRI Probtrack",
             "dMRI TBSS",
             "SWI",
             "T1 SIENAX",
             "dMRI TBSS",
             "dMRI Probtrack",
             "rfMRI Amp 100",
             "rfMRI Con 25 Edge",
             "rfMRI Con 25 Edge",
             "dMRI TBSS")


cats1 <- c(catsmrf1,catsidp1)

V79h.usAttrs <- list(names = as.character(V79h.usn$names),
                     short.names = as.character(V79h.usn$short.names),
                     category = cats1[V79h.u2$indx] )

gexf.from.adj(adjm = V79h.us,attributes = V79h.usAttrs, undirected = T,
              directory = "/home/fs0/zhesha/ukbb/tetrad/",
              filename = "V79tetradGES.gexf")

V79h.dsAttrs <- list(names = as.character(V79h.dsn$names),
                     short.names = as.character(V79h.dsn$short.names),
                     category = cats1[V79h.d2$indx] )

gexf.from.adj(adjm = V79h.ds,attributes = V79h.dsAttrs, undirected = F,
              directory = "/home/fs0/zhesha/ukbb/tetrad/",
              filename = "V79tetradPCL.gexf")
