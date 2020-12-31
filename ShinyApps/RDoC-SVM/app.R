library(shiny)
library(RCurl)
library(XLConnect)
library(ggplot2)
library(Hmisc)
library(e1071)
library(DescTools)
library(reshape2)
library(shiny)
ui <- fluidPage(
  fluidPage(
    titlePanel("Upload File For EF Profile Classification"),
    sidebarLayout(
      sidebarPanel(
        fileInput('file1', 'Choose CSV File',
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
        textOutput('instruction1'),
        tags$br(),
        textOutput('instruction2'),
        tags$br(),
        textOutput('instruction3'),
        tags$hr(),
        downloadButton('downloadData', 'Download')
      ),
      mainPanel(
        plotOutput('graph'),
        textOutput('inputexample'),
        
        tableOutput('contentdisp'),
        tags$hr(),
        textOutput('classresults'),
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
  
  library(RCurl)
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



################ Import all data so that we can plot on the shiny app
all_data<-csv.get(source.dropbox("https://www.dropbox.com/s/oekarj5pq9sm8a8/RDOC_clustering_results_etc.csv?dl=0"),allow='_')
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

disp_data=all_data[1:2,c('Subject_ID',rdoc_var)]
# plot profile to make sure
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
sdstats=apply(sx.use[,1:12], 1, function(x) sd(x))
######################
################################################################################################################################

server <- function(input, output) {
  
  getData <- reactive({
    
    inFile <- input$file1
    
    if (is.null(input$file1))
      return(NULL)
    
    df <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                   quote=input$quote)
    ###################
    test_data_sheet=df
    ###################
    #
    ###############################################################################################
    # START MY CODE FOR WHAT THE INPUT FILE SHOULD DO!!
    ###############################################################################################
    # all_data<-csv.get(source.dropbox("https://www.dropbox.com/s/ecouu9vqn3x1j3j/RDOC_clustering_results_etc.csv"),allow='_')
    # rdoc_var=c("ADHD_R_Hyper",                            
    #            "ADHD_R_Inatt",
    #            "BRIEF_Inhibit",
    #            "BRIEF_Shift",
    #            "BRIEF_Emo_Con",
    #            "BRIEF_Initiate",
    #            "BRIEF_Work_Mem",
    #            "BRIEF_Plan_Org",
    #            "BRIEF_Org_Mat",
    #            "BRIEF_Monitor",
    #            "CBCL_Extern",
    #            "CBCL_Intern")
    test_data<-test_data_sheet[,rdoc_var]
    test_data_sheet=test_data_sheet[complete.cases(test_data),]
    test_data<-test_data_sheet[,rdoc_var]
    
    # # plot profile to make sure
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
    #                 width=.2)+ ggtitle('Base CNHS/KKI 1014 sample EF profiles')+theme(axis.text.x = element_text(angle = 50, hjust = 1,color='Black'))+theme(text=element_text(size=10))+labs(x='',y='Z Score') 
    # for (i in c(seq(1,length(p)))) {plot1<-plot1+annotate("text",x = starframe$time[i], y=1.5, label = starframe$label[i],size=2)}
    # plot1
    # #ggsave("EFprofiles_z_allsubs.pdf", width = 20, height = 20, units = "cm")
    # #
    # sx.use=cbind(all_data[,rdoc_var],all_data[,c("Subject_ID","DSM_GROUPS","EF_GROUPS")])
    # sx.use.long=melt(sx.use, id.vars=c("Subject_ID","EF_GROUPS","DSM_GROUPS"))
    # cluster.stats <- summarySE(sx.use.long, measurevar="value", groupvars=c("EF_GROUPS","variable"))
    # # cluster.stats$variable <- factor(cluster.stats$variable, levels = cluster.stats$variable, ordered = TRUE)
    # # test significant differences in each scale
    # anovaresult<-t(sapply(sx.use[seq(1,length(names(sx.use))-3)], function(x)
    #   unlist(summary(aov(x~sx.use$EF_GROUPS))[[1]][c("F value","Pr(>F)")])))
    # p<-anovaresult[,3]
    # mystars <- ifelse(p < .001, "***", ifelse(p < .01, "** ", ifelse(p < .05, "* ", " ")))
    # starframe<-data.frame(time=c(seq(1,length(p),1)),value=c(replicate(length(p),(max(cluster.stats[1:length(p),4])+max(cluster.stats[1:length(p),6])))),label=c(mystars))
    # starframe$time=c(seq(1,length(p),1))
    # plot1<-ggplot(cluster.stats, aes(x=factor(variable), y=value, colour=EF_GROUPS,pch=EF_GROUPS)) + 
    #   geom_line(aes(group=EF_GROUPS)) +geom_point(cex=2)+
    #   geom_errorbar(aes(ymin=value-se, ymax=value+se),
    #                 width=.2)+ ggtitle('Base CNHS/KKI 1014 sample EF profiles')+theme(axis.text.x = element_text(angle = 50, hjust = 1,color='Black'))+theme(text=element_text(size=10))+labs(x='',y='T Score') 
    # for (i in c(seq(1,length(p)))) {plot1<-plot1+annotate("text",x = starframe$time[i], y=70, label = starframe$label[i],size=2)}
    # #print(plot1)
    #ggsave("EFprofiles_T_allsubs.pdf", width = 20, height = 20, units = "cm")
    
    #### AUC quartile ####
    #EF_GROUPS	Median	qt.0%	qt.25%	qt.50%	qt.75%	qt.100%	Mean
    quartilelist=c('Median',	'qt.0%',	'qt.25%',	'qt.50%','qt.75%',	'qt.100%',	'Mean')
    AUC_FLEX_EMOT=c(   565.5,	 400,	485.5,	565.5,	702.625,	911.5,	593.33)
    AUC_INHIBIT=c(   614.25,	 381.5,	441.9,	614.25,	738.75,	898,	600.55)
    AUC_METACOG=c(  629,	 412,	522.37,	629,	701.625,	842,	618.6)
    auctable=data.frame()
    a=rbind(AUC_FLEX_EMOT,AUC_INHIBIT,AUC_METACOG)
    auctable=as.data.frame(a)
    names(auctable)=quartilelist
    auctable$EFGROUPS=c('FLEX_EMOT','INHIBIT','METACOG')
    
    #### SVM part ####
    #### load SVM on the full sample ####
    load(source.dropbox('https://www.dropbox.com/s/5xoptwaslvicr9w/svm_splihalf_final.rda?dl=0'))
    #pred <- predict(svm_model,test_data, probability=TRUE)
    pred <- predict(svm_model,test_data)
    
    table(pred)
    #### test on the new data ####
    
    head(attr(pred,'probabilities'))
    test_data_sheet$SVM_class=pred
    # test_data_sheet$svmprob_INHIBIT=attr(pred,"probabilities")[,'INHIBIT']
    # test_data_sheet$svmprob_FLEX_EMOT=attr(pred,"probabilities")[,'FLEX_EMOT']
    # test_data_sheet$svmprob_METACOG=attr(pred,"probabilities")[,'METACOG']
    # 
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
    if (test_data_sheet$AUC[i]<=qtsel$`qt.25%`){test_data_sheet$AUCquartile[i]='0-25%'} else {if (test_data_sheet$AUC[i]<qtsel$`qt.50%`){test_data_sheet$AUCquartile[i]='25-50%'} else {if (test_data_sheet$AUC[i]<=qtsel$`qt.75%`){test_data_sheet$AUCquartile[i]='50-75%'} else {if (test_data_sheet$AUC[i]<=qtsel$`qt.100%`){test_data_sheet$AUCquartile[i]='75-100%'} else {test_data_sheet$AUCquartile[i]='>100%'}}}}
    ProfileSD=sd(reg_data$y)
    test_data_sheet$SpecialNotes[i]=''
    if (ProfileSD<min(sdstats)) {test_data_sheet$SpecialNotes[i]='EF profile classification might not clinically informative since its standard deviation is lower than population minimum '}
    #EFplots(cluster.stats,y,as.character(test_data_sheet$SVM_class[i]))

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
  
  # output$contents_example <- renderTable(
  #   
  #   dispData
  #   
  # )
  output$inputexample<- renderText(c('Example of Input CSV file'))
  output$classresults<- renderText(c('Classification Results'))
  output$instruction1<- renderText(c("The plot to the right shows the 3 executive function (EF) profiles with T-scores plotted on the y axis from the combined CNHS/GU and KKI sample (N=1014, of which 465 are typically developing kids)."))
  output$instruction2<- renderText(c("Please upload a .csv file of the T-scores for the 12 domains with the following case-sensitive labels to compute EF profile subgroup membership: Subject_ID, ADHD_R_Hyper, ADHD_R_Inatt, BRIEF_Inhibit, BRIEF_Shift, BRIEF_Emo_Con, BRIEF_Initiate, BRIEF_Work_Mem, BRIEF_Plan_Org, BRIEF_Org_Mat, BRIEF_Monitor, CBCL_Extern, CBCL_Intern. In addition to the data uploaded, the output file will include the following columns: SVM_class (subject's EF Profile group based on highest classification probability), svmprob_INHIBIT (classification probability for subgroup defined by disinhibition), svmprob_FLEX_EMOT (classification probability for subgroup defined by inflexibility and emotion dysregulation), svmprob_METACOG (classification probability for subgroup defined by inattention, working memory and planning deficits), AUC (area under the curve of the subject's EF profile), AUCquartile (quartile of the AUC distribution of the EF subgroup that subject belongs to), SpecialNotes (cautionary notes about classification results)."))
  output$instruction3<- renderText(c("PLEASE NOTE: the SVM is based on sample age of 8-14 years. The SVM is based on BRIEF-4 subdomain T-scores. The ADHD-RS scores must be transformed to T-scores. If there is low variability across the 12 domain scores for a subject (i.e. standard deviation < 2, which is below the N=1014 sample minimum SD [range=2.2 - 28.8]), the subgroup classification is not interpretable. This will be flagged in the SpecialNotes column in the output file."))
  
  output$contentdisp<-renderTable(disp_data,digits=0)
  output$graph <- renderPlot({ 
    plot1<-ggplot(cluster.stats, aes(x=factor(variable), y=value, colour=EF_GROUPS,pch=EF_GROUPS)) + 
      geom_line(aes(group=EF_GROUPS)) +geom_point(cex=2)+
      geom_errorbar(aes(ymin=value-se, ymax=value+se),
                    width=.2)+ ggtitle('EF profiles for CNHS/KKI 1014 sample (Age range 8-14y/o)')+theme(axis.text.x = element_text(angle = 50, hjust = 1,color='Black'))+theme(text=element_text(size=10))+labs(x='',y='T Score') 
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
