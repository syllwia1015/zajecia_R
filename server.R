library(tidyverse)
library(shiny)
library(DT)
library(ranger)
library(caTools)
shinyServer (
  function(input,output){
    load("../Cw05_2021_06_26/ofertyV.RData")
    names(ofertyV)<-gsub("ść","sc",names(ofertyV))
    names(ofertyV)<-gsub("ó","o",names(ofertyV))
    
    dataAuta<-reactive({
      
      d<-ofertyV%>%#%>%filter(marka==input$marka)%>%
        select(cena,Rok_produkcji,Przebieg,Moc,Pojemnosc_skokowa,Model_pojazdu)%>%arrange(Model_pojazdu)%>%
        na.omit()%>%droplevels()
    })
    
    output$marka<-renderUI(
      {
        selectInput(inputId = "marka", label = "marka:",c("Volkswagen") ) }
    )
    
    output$model<-renderUI(
      {
        
        unikalneModele<- ( ofertyV%>%select(Model_pojazdu)%>%unique() )
        selectInput(inputId = "model", label = "Model:",choices = unikalneModele,selected = unikalneModele[1] )
      }
    )
    
    output$autaTable<-DT::renderDataTable({
      datatable(dataAuta(),rownames = FALSE,options= list (
        pageLength = 10, scrollX=TRUE, lengthMenu = list(seq(10,100,10),as.character(seq(10,100,10))),
        filter = "none"))
    })
    
    
    train<-reactive({
      set.seed(123)
      sample<-sample.split(Y=dataAuta(),SplitRatio = .75)
      subset(dataAuta(),sample==TRUE)
    })
    
    test<-reactive({
      set.seed(123)
      sample<-sample.split(Y=dataAuta(),SplitRatio = .75)
      subset(dataAuta(),sample==FALSE)
    })
    
    regrRF<-reactive({
      if(file.exists("modelRF.RData")){
        if(!exists("modelRF"))
          load(file="modelRF.RData")
        modelRF
      }else{
        modelRF<-ranger(cena~.,data =train() )
        save(modelRF,file="modelRF.RData")
        modelRF
      }
    })
    
    wynik<-eventReactive( input$wycena,{
      model1<-input$model
      model1 <- factor(model1, levels = levels( dataAuta()$Model_pojazdu))
      row1<-data.frame(cena=as.numeric(0),Rok_produkcji=as.integer(input$rok),
                       Przebieg=as.numeric(input$przebieg),
                       Pojemnosc_skokowa=as.integer(input$pojemnosc),
                       Moc=as.integer(input$moc),
                       Model_pojazdu=as.factor(model1)
      )
      predicts<-predict(regrRF(),row1)
      #print(predicts)
      predicts$predictions
      
    }
    )
    
    output$wynik<-renderPrint(wynik())
  }
  
)