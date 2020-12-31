library(shiny)
library(bitops)
library(RCurl)
library(XLConnect)
library(ggplot2)
library(Hmisc)
library(e1071)
library(DescTools)
library(reshape2)
ui <- fluidPage(
  fluidPage(
    titlePanel("Upload File For EF Profile Classification"),
    sidebarLayout(
      sidebarPanel(
        fileInput('file1', 'Choose CSV File ',
                  accept=c('text/csv', 
                           'text/comma-separated-values,text/plain', 
                           '.csv')),
        tags$hr(),
        checkboxInput('header', 'Header', TRUE),
        radioButtons('sep', 'Separator',
                     c(Comma=',',
                       Semicolon=';',
                       Tab='\t'),
                     ','),
        radioButtons('quote', 'Quote',
                     c(None='',
                       'Double Quote'='"',
                       'Single Quote'="'"),
                     '"'),
        textOutput('instruction'),
        tags$hr(),
        
        downloadButton('downloadData', 'Download')
      ),
      mainPanel(
        plotOutput('graph1'),
        tableOutput('contents')
      )
    )
  )
)
##########################

################ Create function to source code from dropbox, and source Alaina's functions script################
source.dropbox = function(dropbox.url) {
  
  # Purpose: source an R script from a Dropbox file
  
  # Input: the URL that you get when you share a Dropbox file
  
  # Output: the input to the source() function
  
  # Example of use:
  # source(source.dropbox('https://www.dropbox.com/s/9m4139zbnee59jh/grfpairs.R'))
  
  # Author: George Fisher george@georgefisher.com
  
  # Date : October 30, 2013
  
  # thanks to
  # http://thebiobucket.blogspot.com/2012/05/source-r-script-from-dropbox.html
  
  # note: this goes out over the network so you might want to package several
  # functions into one file
  
  setwd(tempdir())
  
  destfile = "test.txt"
  
  # use regex to get the piece of the Dropbox URL we need
  matches <- regexpr("(/s/.*)", dropbox.url, perl = TRUE, ignore.case = TRUE)
  result <- attr(matches, "capture.start")[, 1]
  attr(result, "match.length") <- attr(matches, "capture.length")[, 1]
  dropbox.tail = regmatches(dropbox.url, result)
  # (my eternal thanks to the RegexBuddy program)
  
  # create the request URL
  dburl = paste("https://dl.dropbox.com", dropbox.tail, sep = "")
  
  x = getBinaryURL(dburl, followlocation = TRUE, ssl.verifypeer = FALSE)
  writeBin(x, destfile, useBytes = TRUE)
  
  
  paste(tempdir(), "/test.txt", sep = "")
}
################
source(source.dropbox("https://www.dropbox.com/s/2zyy8u1uk29bb3u/functions.R"))
######################


######################
################################################################################################################################

server <- function(input, output) {
  
  getData <- reactive({
    all_data<-csv.get(source.dropbox("https://www.dropbox.com/s/ecouu9vqn3x1j3j/RDOC_clustering_results_etc.csv"),allow='_')
    rdoc_var=c("ADHD_R_Hyper",                            
               "ADHD_R_Inatt",
               "BRIEF_Inhibit",
               "BRIEF_Shift",
               "BRIEF_Emo_Con",
               "BRIEF_Initiate",
               "BRIEF_Work_Mem",
               "BRIEF_Plan_Org",
               "BRIEF_Org_Mat",
               "BRIEF_Monitor",
               "CBCL_Extern",
               "CBCL_Intern")
    test_data<-test_data_sheet[,rdoc_var]
    disp_data<-test_data_sheet[1:2,c('Subject_ID',rdoc_var)]
    
    inFile <- input$file1
    
    if (is.null(input$file1))
      return(disp_data)
    
    df <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                   quote=input$quote)
    ###################
    test_data_sheet=df
    ###################
    #
    ###############################################################################################
    # START MY CODE FOR WHAT THE INPUT FILE SHOULD DO!!
    ###############################################################################################
    test_data_sheet=test_data_sheet[complete.cases(test_data),]
    test_data<-test_data_sheet[,rdoc_var]
    
    # plot profile to make sure
    # sx.use=cbind(all_data[,rdoc_var],all_data[,c("Subject_ID","DSM_GROUPS","EF_GROUPS")])
    # sx.use[,1:length(rdoc_var)]<-scale(sx.use[,1:length(rdoc_var)],center=FALSE)
    # sx.use.long=melt(sx.use, id.vars=c("Subject_ID","EF_GROUPS","DSM_GROUPS"))
    # cluster.stats <- summarySE(sx.use.long, measurevar="value", groupvars=c("EF_GROUPS","variable"))
    # # cluster.stats$variable <- factor(cluster.stats$variable, levels = cluster.stats$variable, ordered = TRUE)
    # # # test significant differences in each scale
    # anovaresult<-t(sapply(sx.use[seq(1,length(names(sx.use))-3)], function(x)
    #   unlist(summary(aov(x~sx.use$EF_GROUPS))[[1]][c("F value","Pr(>F)")])))
    # p<-anovaresult[,3]
    # mystars <- ifelse(p < .001, "***", ifelse(p < .01, "** ", ifelse(p < .05, "* ", " ")))
    # starframe<-data.frame(time=c(seq(1,length(p),1)),value=c(replicate(length(p),(max(cluster.stats[1:length(p),4])+max(cluster.stats[1:length(p),6])))),label=c(mystars))
    # starframe$time=c(seq(1,length(p),1))
    # #
    # plot1<-ggplot(cluster.stats, aes(x=factor(variable), y=value, colour=EF_GROUPS,pch=EF_GROUPS)) +
    #   geom_line(aes(group=EF_GROUPS)) +geom_point(cex=2)+
    #   geom_errorbar(aes(ymin=value-se, ymax=value+se),
    #                 width=.2)+ ggtitle('Base CNHS/JHK 1014 sample EF profiles')+theme(axis.text.x = element_text(angle = 50, hjust = 1,color='Black'))+theme(text=element_text(size=10))+labs(x='',y='Z Score')
    # for (i in c(seq(1,length(p)))) {plot1<-plot1+annotate("text",x = starframe$time[i], y=1.5, label = starframe$label[i],size=2)}
    # plot1
    # # #ggsave("EFprofiles_z_allsubs.pdf", width = 20, height = 20, units = "cm")
    # # #
    sx.use=cbind(all_data[,rdoc_var],all_data[,c("Subject_ID","DSM_GROUPS","EF_GROUPS")])
    sx.use.long=melt(sx.use, id.vars=c("Subject_ID","EF_GROUPS","DSM_GROUPS"))
    cluster.stats <- summarySE(sx.use.long, measurevar="value", groupvars=c("EF_GROUPS","variable"))
    # cluster.stats$variable <- factor(cluster.stats$variable, levels = cluster.stats$variable, ordered = TRUE)
    # # test significant differences in each scale
    anovaresult<-t(sapply(sx.use[seq(1,length(names(sx.use))-3)], function(x)
      unlist(summary(aov(x~sx.use$EF_GROUPS))[[1]][c("F value","Pr(>F)")])))
    p<-anovaresult[,3]
    mystars <- ifelse(p < .001, "***", ifelse(p < .01, "** ", ifelse(p < .05, "* ", " ")))
    starframe<-data.frame(time=c(seq(1,length(p),1)),value=c(replicate(length(p),(max(cluster.stats[1:length(p),4])+max(cluster.stats[1:length(p),6])))),label=c(mystars))
    starframe$time=c(seq(1,length(p),1))
    # plot1<-ggplot(cluster.stats, aes(x=factor(variable), y=value, colour=EF_GROUPS,pch=EF_GROUPS)) +
    #   geom_line(aes(group=EF_GROUPS)) +geom_point(cex=2)+
    #   geom_errorbar(aes(ymin=value-se, ymax=value+se),
    #                 width=.2)+ ggtitle('Base CNHS/JHK 1014 sample EF profiles')+theme(axis.text.x = element_text(angle = 50, hjust = 1,color='Black'))+theme(text=element_text(size=10))+labs(x='',y='T Score')
    # for (i in c(seq(1,length(p)))) {plot1<-plot1+annotate("text",x = starframe$time[i], y=70, label = starframe$label[i],size=2)}
    # #print(plot1)
    # #ggsave("EFprofiles_T_allsubs.pdf", width = 20, height = 20, units = "cm")
    # 
    #### AUC Quantile ####
    #EF_GROUPS	Median	qt.0%	qt.25%	qt.50%	qt.75%	qt.100%	Mean
    quantilelist=c('Median',	'qt.0%',	'qt.25%',	'qt.50%','qt.75%',	'qt.100%',	'Mean')
    AUC_FLEX_EMOT=c(565.5,	400,	484.375,	565.5,	707.25,	911.5,	593.502646)
    AUC_INHIBIT=c(620.25,	381.5,	449.5,	620.25,	734.5,	898,	603.704698)
    AUC_METACOG=c(629,	412,	522.375,	629,	701.375,	833,	617.668639)
    auctable=data.frame()
    a=rbind(AUC_FLEX_EMOT,AUC_INHIBIT,AUC_METACOG)
    auctable=as.data.frame(a)
    names(auctable)=quantilelist
    auctable$EFGROUPS=c('FLEX_EMOT','INHIBIT','METACOG')
    
    #### SVM part ####
    #### load SVM on the full sample ####
    load(source.dropbox('https://www.dropbox.com/s/jxnjlxahdv9pbat/RDOC-classifier.rda'))
    pred <- predict(svm_model,test_data, probability=TRUE)
    table(pred)
    #### test on the new data ####
    
    head(attr(pred,'probabilities'))
    test_data_sheet$SVM_class=pred
    test_data_sheet$svmprob_INHIBIT=attr(pred,"probabilities")[,'INHIBIT']
    test_data_sheet$svmprob_FLEX_EMOT=attr(pred,"probabilities")[,'FLEX_EMOT']
    test_data_sheet$svmprob_METACOG=attr(pred,"probabilities")[,'METACOG']
    
    #### add AUC and Pearson correlation values ####
    reg_data=cluster.stats[cluster.stats$EF_GROUPS=='METACOG',]
    reg_data$regression_factors1=cluster.stats[cluster.stats$EF_GROUPS=='INHIBIT','value']
    reg_data$regression_factors2=cluster.stats[cluster.stats$EF_GROUPS=='METACOG','value']
    reg_data$regression_factors3=cluster.stats[cluster.stats$EF_GROUPS=='FLEX_EMOT','value']
    
    for (i in seq(1,length(test_data_sheet[,1])))
    {reg_data$y=t(test_data[i,1:12])
    x <- 1:length(reg_data$y)
    y <- as.numeric(reg_data$y)
    # id=order(x)
    test_data_sheet$AUC[i]=AUC(x, y, method = c("trapezoid", "step", "spline"), na.rm = FALSE)
    qtsel=auctable[auctable$EFGROUPS== test_data_sheet$SVM_class[i],]
    if (test_data_sheet$AUC[i]<=qtsel$`qt.25%`){test_data_sheet$AUCQuantile[i]='0-25%'} else {if (test_data_sheet$AUC[i]<qtsel$`qt.50%`){test_data_sheet$AUCQuantile[i]='25-50%'} else {if (test_data_sheet$AUC[i]<=qtsel$`qt.75%`){test_data_sheet$AUCQuantile[i]='50-75%'} else {if (test_data_sheet$AUC[i]<=qtsel$`qt.100%`){test_data_sheet$AUCQuantile[i]='75-100%'} else {test_data_sheet$AUCQuantile[i]='>100%'}}}}
    # p=EFplots(cluster.stats,y,as.character(test_data_sheet$SVM_class[i]))
    # p=p+ggtitle(paste(test_data_sheet[i,1],' EF overlaid on  CNHS/JHK 1014 sample profiles'))
    # print(p)
    }
    
    ###############################################################################################
    # END MY CODE FOR WHAT THE INPUT FILE SHOULD DO!!
    ###############################################################################################
    
    ###################
    df=test_data_sheet
    ###################
    
  })
  
  
output$contents <- renderTable(
    
    getData()
    
  )
output$instruction<- renderText(c('The plot to the right is the 3 EF profiles (N=1014), below that is the input csv example file to upload in order to compute their EF profile membership with probabilities as well as their AUC and quantiles. The csv file to upload must contains at least these variable names: Subject_ID, ADHD_R_Hyper,                            
                                                                                                                                                                                                                                                                                                                       ADHD_R_Inatt,
                                                                                                                                                                                                                                                                                                                         BRIEF_Inhibit,
                                                                                                                                                                                                                                                                                                                         BRIEF_Shift,
                                                                                                                                                                                                                                                                                                                         BRIEF_Emo_Con,
                                                                                                                                                                                                                                                                                                                         BRIEF_Initiate,
                                                                                                                                                                                                                                                                                                                         BRIEF_Work_Mem,
                                                                                                                                                                                                                                                                                                                         BRIEF_Plan_Org,
                                                                                                                                                                                                                                                                                                                         BRIEF_Org_Mat,
                                                                                                                                                                                                                                                                                                                         BRIEF_Monitor,
                                                                                                                                                                                                                                                                                                                         CBCL_Extern,
                                                                                                                                                                                                                                                                                                                         CBCL_Intern.'))

  
output$graph1 <- renderPlot({ 
    getData()
    plot1<-ggplot(cluster.stats, aes(x=factor(variable), y=value, colour=EF_GROUPS,pch=EF_GROUPS)) + 
      geom_line(aes(group=EF_GROUPS)) +geom_point(cex=2)+
      geom_errorbar(aes(ymin=value-se, ymax=value+se),
                    width=.2)+ ggtitle('  EF profiles for CNHS/JHK 1014 sample')+theme(axis.text.x = element_text(angle = 50, hjust = 1,color='Black'))+theme(text=element_text(size=10))+labs(x='',y='T Score') 
    for (i in c(seq(1,length(p)))) {plot1<-plot1+annotate("text",x = starframe$time[i], y=70, label = starframe$label[i],size=2)}
    plot1
 
    })
  
  output$downloadData <- downloadHandler(
    
    filename = function() { 
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    
    content = function(file) {
      
      write.csv(getData(), file,row.names = FALSE)
      
    })
  
} 


shinyApp(ui, server)
