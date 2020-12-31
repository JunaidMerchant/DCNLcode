library(shiny)
ui <- fluidPage(
  fluidPage(
    titlePanel("Upload ADHD File"),
    sidebarLayout(
      sidebarPanel(
        img(src='DCNL_Logo.png', align = "left"),
        fileInput('file1', 'Choose CSV File',
                  accept=c('text/csv', 
                           'text/comma-separated-values,text/plain', 
                           '.csv')),
        downloadButton('downloadData', 'Download'),
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
                     '"')
      ),
      mainPanel(
        textOutput('instruction1'),
        tags$br(),
        textOutput('instruction2'),
        tags$br(),
        textOutput('instruction3'),
        tags$br(),
        textOutput('inputexample'),
        tableOutput('contentdisp'),
        tags$br(),
        textOutput('outputlabel'),
        tableOutput('contents')
      )
    )
  )
)

server <- function(input, output) {
  
  getData <- reactive({
    
    inFile <- input$file1
    
    if (is.null(input$file1))
      return(NULL)
    
    df <- read.csv(inFile$datapath, header=input$header, sep=input$sep,
                   quote=input$quote)
    Raw=df
    # Get just the Item data for I1-I9 and H1-H9
    Items=Raw[3:length(rownames(Raw)),charmatch("participant_id",names(Raw)):charmatch("adhdscale_item18",names(Raw))]
    adhd_date=as.character.Date(Raw[3:length(rownames(Raw)),charmatch("EndDate",names(Raw))])
    for (i in 1:length(adhd_date)){
      adhd_date[i]=substr(adhd_date[i],1,10)
    }
    row.names(Items)<-1:nrow(Items)
    #
    # Create matrix and change item responses from words to numeric
    ItemNum=Items
    ItemNum[,4:length(colnames(ItemNum))]=NA
    #
    # Assign 0 for never/rarely, 1 for sometimes, 2 for often, 3 for very often
    ItemNum[Items=="Never or Rarely"]=0
    ItemNum[Items=="Sometimes"]=1
    ItemNum[Items=="Often"]=2
    ItemNum[Items=="Very Often"]=3
    #
    # Define the mean and standard deviation IA scores for each age and gender group
    M_8to10_IAmean=5.74; M_11to13_IAmean=6.41;
    F_8to10_IAmean=4.79; F_11to13_IAmean=4.65;
    M_8to10_IAsd=5.4; M_11to13_IAsd=6.13;
    F_8to10_IAsd=5.24; F_11to13_IAsd=5.26;
    #
    # Define the mean and standard deviation HI scores for each age and gender group
    M_8to10_HImean=4.48; M_11to13_HImean=3.63;
    F_8to10_HImean=3.38; F_11to13_HImean=2.8;
    M_8to10_HIsd=5.58; M_11to13_HIsd=4.73;
    F_8to10_HIsd=4.23; F_11to13_HIsd=4.02;
    #
    # Define the mean and standard deviation Total scores for each age and gender group
    M_8to10_Totalmean=10.21; M_11to13_Totalmean=10.05;
    F_8to10_Totalmean=8.17; F_11to13_Totalmean=7.45;
    M_8to10_Totalsd=10.20; M_11to13_Totalsd=9.82;
    F_8to10_Totalsd=8.65; F_11to13_Totalsd=8.28;
    #
    # Create vectors for getting percentiles
    Percentile_Girls=c('99+', 99, 98, 97, 96, 95, 94, 93, 92, 91, 90, 89, 88, 87, 86, 85, 84, 80, 75, 50, 25, 10, 1)
    HI_5to7_Girls=c(27, 25, 20, 17, 16, 15, 14, 13, 12, 12, 11, 10, 9, 9, 8, 8, 8, 7, 6, 3, 1, 0, 0)
    HI_8to10_Girls=c(26, 23, 21, 15, 13, 11, 10, 9, 9, 9, 9, 8, 8, 8, 7, 7, 7, 6, 5, 2, 0, 0, 0)
    HI_11to13_Girls=c(22, 16, 15, 14, 13, 12, 12, 11, 9, 9, 8, 8, 7, 7, 7, 6, 6, 5, 4, 1, 0, 0, 0)
    HI_14to17_Girls=c(20, 19, 12, 11, 9, 9, 8, 8, 7, 6, 6, 6, 5, 5, 5, 4, 4, 3, 3, 1, 0, 0, 0)
    IA_5to7_Girls=c(26, 23, 21, 18, 17, 16, 15, 14, 13, 13, 12, 12, 12, 12, 11, 10, 10, 9, 8, 3, 1, 0, 0)
    IA_8to10_Girls=c(27, 26, 22, 18, 17, 16, 15, 14, 13, 13, 12, 12, 11, 11, 11, 10, 10, 9, 8, 3, 1, 0, 0)
    IA_11to13_Girls=c(27, 25, 21, 20, 19, 17, 15, 15, 13, 13, 12, 12, 11, 11, 10, 10, 10, 9, 8, 3, 1, 0, 0)
    IA_14to17_Girls=c(25, 23, 19, 18, 18, 18, 17, 17, 15, 14, 14, 13, 13, 12, 12, 11, 11, 9, 7, 3, 0, 0, 0)
    Total_5to7_Girls=c(50, 45, 43, 35, 32, 29, 27, 25, 24, 22, 21, 21, 20, 18, 18, 18, 17, 15, 13, 7, 3, 0, 0)
    Total_8to10_Girls=c(53, 47, 37, 36, 30, 28, 25, 21, 21, 20, 20, 18, 18, 17, 17, 16, 16, 14, 12, 6, 2, 0, 0)
    Total_11to13_Girls=c(38, 35, 32, 29, 29, 27, 24, 23, 22, 21, 20, 19, 18, 18, 18, 17, 16, 13, 11, 5, 1, 0, 0)
    Total_14to17_Girls=c(42, 36, 32, 28, 25, 24, 23, 21, 20, 20, 19, 18, 18, 17, 16, 15, 15, 12, 10, 4, 1, 0, 0)
    #
    Percentile_Boys=c('99+', 99, 98, 97, 96, 95, 94, 93, 92, 91, 90, 89, 88, 87, 86, 85, 84, 80, 75, 50, 25, 10, 1)
    HI_5to7_Boys=c(27, 24, 19, 18, 17, 17, 17, 17, 16, 15, 15, 13, 13, 12, 12, 10, 10, 9, 8, 5, 2, 0, 0)
    HI_8to10_Boys=c(27, 26, 20, 20, 19, 18, 17, 16, 16, 15, 14, 13, 11, 10, 10, 9, 9, 8, 7, 3, 1, 0, 0)
    HI_11to13_Boys=c(26, 22, 19, 18, 17, 15, 14, 13, 12, 11, 10, 10, 9, 9, 9, 9, 9, 7, 6, 2, 0, 0, 0)
    HI_14to17_Boys=c(21, 16, 15, 13, 12, 10, 9, 9, 9, 8, 8, 7, 7, 6, 5, 5, 5, 4, 3, 1, 0, 0, 0)
    IA_5to7_Boys=c(27, 25, 23, 22, 21, 18, 17, 17, 16, 15, 14, 14, 12, 11, 11, 10, 10, 9, 9, 5, 2, 0, 0)
    IA_8to10_Boys=c(27, 27, 25, 21, 20, 17, 16, 16, 16, 15, 14, 12, 12, 12, 11, 11, 11, 9, 9, 4, 2, 0, 0)
    IA_11to13_Boys=c(27, 27, 27, 25, 22, 21, 21, 19, 18, 18, 17, 16, 15, 15, 15, 14, 13, 12, 10, 6, 1, 0, 0)
    IA_14to17_Boys=c(27, 26, 25, 21, 20, 19, 18, 18, 17, 16, 16, 15, 14, 13, 12, 11, 11, 10, 9, 4, 1, 0, 0)
    Total_5to7_Boys=c(50, 45, 41, 38, 38, 35, 32, 31, 29, 27, 27, 26, 25, 24, 22, 20, 20, 18, 16, 10, 4, 0, 0)
    Total_8to10_Boys=c(53, 49, 44, 38, 36, 35, 33, 31, 30, 29, 28, 25, 24, 22, 21, 19, 19, 17, 14, 8, 3, 1, 0)
    Total_11to13_Boys=c(52, 47, 43, 38, 36, 34, 31, 30, 28, 26, 25, 24, 23, 22, 22, 21, 21, 19, 17, 8, 2, 0, 0)
    Total_14to17_Boys=c(47, 39, 37, 34, 30, 27, 26, 25, 25, 22, 21, 20, 19, 18, 18, 17, 16, 14, 11, 5, 2, 0, 0)
    #
    #
    # Create columns for count, raw, and t-scores for HI and IA
    ItemNum$ICount<-NA; ItemNum$IRaw<-NA; ItemNum$HCount<-NA; ItemNum$HRaw<-NA; 
    ItemNum$TotalCount<-NA; ItemNum$TotalRaw<-NA;
    ItemNum$adhd_ia_tscore<-NA; ItemNum$adhd_hi_tscore<-NA; ItemNum$adhd_total_tscore<-NA
    ItemNum$IA_Percentile<-NA; ItemNum$HI_Percentile<-NA; ItemNum$Total_Percentile<-NA; ItemNum$Notes<-""; 
    #
    # Create function to calculate percentiles
    GetPercentile <- function(Value,List,PercList) {
      if(sum(List==Value)==0){
        Indx=1:length(List)
        Subtracted=(List-Value)
        num1=min(Subtracted[Subtracted>0])
        num2=max(Subtracted[Subtracted<0])
        Perc1=PercList[Indx[tail(which(Subtracted==num1),n=1)]]
        Perc2=PercList[Indx[head(which(Subtracted==num2),n=1)]]
        Percs=sort(c(Perc1,Perc2))
        Percentile=paste(Percs[1],"-",Percs[2])
      } 
      #
      if(sum(List==Value)>1){
        Percentile=tail(PercList[which(List==Value)],n=1)
      }
      #
      if(sum(List==Value)==1){
        Percentile=PercList[which(List==Value)]
      }
      #
      return(Percentile)
    }
    
    # Loop through matrix to add symptom count, raw scores, and t-scores for HI and IA
    for (i in 1:length(ItemNum[,1])){
      # Get just the H items and just the I items, create logical vectors for missing data, and items with a score of 2 or more.
      Hs<-ItemNum[i,13:21]
      Is<-ItemNum[i,4:12]
      Iempty=is.na(Is)
      Hempty=is.na(Hs)
      I2=Is>1
      H2=Hs>1
      # Add in a note if there is a subscale missing 3 or more items
      if(sum(Hempty)>2){ItemNum$Notes[i]="NOTE! HI Subscale is missing 3 or more items!"}
      if(sum(Iempty)>2){ItemNum$Notes[i]="NOTE! IA Subscale is missing 3 or more items!"}
      if(sum(Iempty)>2 & sum(Hempty)>2){ItemNum$Notes[i]="NOTE! Both Subscales are missing 3 or more items!"}
      # Do calculations for I
      ItemNum$ICount[i]<-sum(I2[!Iempty])
      ItemNum$IRaw[i]<-sum(Is[!Iempty])
      #
      # Do calculations for H 
      ItemNum$HCount[i]<-sum(H2[!Hempty])
      ItemNum$HRaw[i]<-sum(Hs[!Hempty])
      #
      # Do calculations for Total
      ItemNum$TotalCount[i]<-ItemNum$ICount[i]+ItemNum$HCount[i]
      ItemNum$TotalRaw[i]<-ItemNum$IRaw[i]+ItemNum$HRaw[i]
      #
      #
      # Now calculate t-scores for IA and HI
      # First test for Males under 11
      if((ItemNum$Gender[i]=="Male") & (11>as.numeric(ItemNum$Age[i]))) {
        ItemNum$adhd_ia_tscore[i]<-(((ItemNum$IRaw[i]-M_8to10_IAmean)/M_8to10_IAsd)*10)+50
        ItemNum$adhd_hi_tscore[i]<-(((ItemNum$HRaw[i]-M_8to10_HImean)/M_8to10_HIsd)*10)+50
        ItemNum$adhd_total_tscore[i]<-(((ItemNum$TotalRaw[i]-M_8to10_Totalmean)/M_8to10_Totalsd)*10)+50
        #
        ItemNum$IA_Percentile[i]<-GetPercentile(ItemNum$IRaw[i],IA_8to10_Boys,Percentile_Boys)
        ItemNum$HI_Percentile[i]<-GetPercentile(ItemNum$HRaw[i],HI_8to10_Boys,Percentile_Boys)
        ItemNum$Total_Percentile[i]<-GetPercentile(ItemNum$TotalRaw[i],Total_8to10_Boys,Percentile_Boys)
      }
      # test for males over 10
      if((ItemNum$Gender[i]=="Male") & (10<as.numeric(ItemNum$Age[i]))) {
        ItemNum$adhd_ia_tscore[i]<-(((ItemNum$IRaw[i]-M_11to13_IAmean)/M_11to13_IAsd)*10)+50
        ItemNum$adhd_hi_tscore[i]<-(((ItemNum$HRaw[i]-M_11to13_HImean)/M_11to13_HIsd)*10)+50
        ItemNum$adhd_total_tscore[i]<-(((ItemNum$TotalRaw[i]-M_11to13_Totalmean)/M_11to13_Totalsd)*10)+50
        #
        ItemNum$IA_Percentile[i]<-GetPercentile(ItemNum$IRaw[i],IA_11to13_Boys,Percentile_Boys)
        ItemNum$HI_Percentile[i]<-GetPercentile(ItemNum$HRaw[i],HI_11to13_Boys,Percentile_Boys)
        ItemNum$Total_Percentile[i]<-GetPercentile(ItemNum$TotalRaw[i],Total_11to13_Boys,Percentile_Boys)
      }
      # test for females under 11
      if((ItemNum$Gender[i]=="Female") & (11>as.numeric(ItemNum$Age[i]))) {
        ItemNum$adhd_ia_tscore[i]<-(((ItemNum$IRaw[i]-F_8to10_IAmean)/F_8to10_IAsd)*10)+50
        ItemNum$adhd_hi_tscore[i]<-(((ItemNum$HRaw[i]-F_8to10_HImean)/F_8to10_HIsd)*10)+50
        ItemNum$adhd_total_tscore[i]<-(((ItemNum$TotalRaw[i]-F_8to10_Totalmean)/F_8to10_Totalsd)*10)+50
        #
        ItemNum$IA_Percentile[i]<-GetPercentile(ItemNum$IRaw[i],IA_8to10_Girls,Percentile_Girls)
        ItemNum$HI_Percentile[i]<-GetPercentile(ItemNum$HRaw[i],HI_8to10_Girls,Percentile_Girls)
        ItemNum$Total_Percentile[i]<-GetPercentile(ItemNum$TotalRaw[i],Total_8to10_Girls,Percentile_Girls)
      }
      # test for females over 10
      if((ItemNum$Gender[i]=="Female") & (10<as.numeric(ItemNum$Age[i]))) {
        ItemNum$adhd_ia_tscore[i]<-(((ItemNum$IRaw[i]-F_11to13_IAmean)/F_11to13_IAsd)*10)+50
        ItemNum$adhd_hi_tscore[i]<-(((ItemNum$HRaw[i]-F_11to13_HImean)/F_11to13_HIsd)*10)+50
        ItemNum$adhd_total_tscore[i]<-(((ItemNum$TotalRaw[i]-F_11to13_Totalmean)/F_11to13_Totalsd)*10)+50
        #
        ItemNum$IA_Percentile[i]<-GetPercentile(ItemNum$IRaw[i],IA_11to13_Girls,Percentile_Girls)
        ItemNum$HI_Percentile[i]<-GetPercentile(ItemNum$HRaw[i],HI_11to13_Girls,Percentile_Girls)
        ItemNum$Total_Percentile[i]<-GetPercentile(ItemNum$TotalRaw[i],Total_11to13_Girls,Percentile_Girls)
      }
    }
    remove(Hs,Is)
    #
    # Change names of columns to match REDCap naming convention
    colnames(ItemNum)[2]<-"adhd_age"
    colnames(ItemNum)[4:12]<-c("adhdscale_item1", "adhdscale_item2", "adhdscale_item3", "adhdscale_item4", "adhdscale_item5", "adhdscale_item6", "adhdscale_item7", "adhdscale_item8", "adhdscale_item9")
    colnames(ItemNum)[13:21]<-c("adhdscale_item10", "adhdscale_item11", "adhdscale_item12", "adhdscale_item13", "adhdscale_item14", "adhdscale_item15", "adhdscale_item16", "adhdscale_item17", "adhdscale_item18")
    colnames(ItemNum)[22:27]<-c("adhdscale_inatt_sc", "adhd_inatt_raw", "adhdscale_hi_sc", "adhd_hi_raw", "TotalCount", "adhd_total_raw")
    colnames(ItemNum)[31:34]<-c("adhd_inatten_per", "adhd_hi_per", "adhd_total_per", "adhd_notes")
    participant_id=ItemNum$participant_id
    df=cbind(participant_id,adhd_date,ItemNum[,c(charmatch("adhdscale_item1",names(ItemNum)):charmatch("adhdscale_inatt_sc",names(ItemNum)),charmatch("adhdscale_hi_sc",names(ItemNum)),charmatch("adhd_inatt_raw",names(ItemNum)),charmatch("adhd_hi_raw",names(ItemNum)),charmatch("adhd_total_raw",names(ItemNum)),charmatch("adhd_ia_tscore",names(ItemNum)),charmatch("adhd_hi_tscore",names(ItemNum)),charmatch("adhd_total_tscore",names(ItemNum)),charmatch("adhd_inatten_per",names(ItemNum)),charmatch("adhd_hi_per",names(ItemNum)),charmatch("adhd_total_per",names(ItemNum)),charmatch("adhd_notes",names(ItemNum)))])
    
  })
  
  
  output$contents <- renderTable(
    
    getData()
    
  )
  # Where the example input data starts
  output$inputexample<- renderText(c('Example of input .csv file'))
  output$outputlabel<-renderText(c('Output data:'))
  output$instruction1<- renderText(c("Please upload a .csv file with subject id, age, gender, and item-level raw data for the ADHD-RS with the following, case-sensitive labels: participant_id, Age, Gender, adhdscale_item1 through adhdscale_item18 (see example below)."))
  output$instruction2<- renderText(c("In addition to the raw data, the output file will include the following columns: adhdscale_inatt_sc (number of IA items over 2), adhdscale_hi_sc (number of HI items over 2), adhd_inatt_raw (sum of IA items), adhd_hi_raw (sum of HI items), adhd_total_raw (total raw score), adhd_inatten_per, adhd_hi_per, adhd_total_per (percentiles for IA, HI, and Total), adhd_notes (any special notes), adhd_ia_tscore, adhd_hi_tscore, & adhd_total_tscore (t-scores for IA, HI, and total)."))
  output$instruction3<- renderText(c("NOTE: This is based on the ADHD-RS version 5 parent report, and only works for children between 8 to 13 years old. It is intended for the RDOC study that is in collaboration with DCNL at Georgetown and Children's National Autism group. This was designed to take data from Qualtrics ADHD scale, score, then upload to REDCap, or use for RDOC_SVM app. Please send your questions to Junaid Merchant: merchantjs@gmail.com"))
  

  participant_id=c("subject1","subject2","subject3"); Age=c(8,10,13); Gender=c("Male", "Female", "Male"); adhdscale_item1=c(1,2,3); adhdscale_item2=c(2,2,3); adhdscale_item3=c(1,2,1); adhdscale_item4=c(1,1,3); adhdscale_item5=c(3,1,3); 
  adhdscale_item6=c(1,2,3); adhdscale_item7=c(1,1,3); adhdscale_item8=c(1,2,2); adhdscale_item9=c(2,2,2); adhdscale_item10=c(3,2,3); adhdscale_item11=c(3,3,3); adhdscale_item12=c(1,2,1); adhdscale_item13=c(3,2,3); adhdscale_item14=c(1,2,3); adhdscale_item15=c(1,1,3); 
  adhdscale_item16=c(3,2,1); adhdscale_item17=c(3,2,3); adhdscale_item18=c(1,1,1); 
  disp_data=data.frame(participant_id, Age, Gender, adhdscale_item1, adhdscale_item2, adhdscale_item3, adhdscale_item4, adhdscale_item5, adhdscale_item6, adhdscale_item7, adhdscale_item8, adhdscale_item9, adhdscale_item10, adhdscale_item11, adhdscale_item12, adhdscale_item13, adhdscale_item14, adhdscale_item15, adhdscale_item16, adhdscale_item17, adhdscale_item18)
  output$contentdisp<-renderTable(disp_data)
  output$downloadData <- downloadHandler(
    
    filename = function() { 
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    
    content = function(file) {
      
      write.csv(getData(), file)
      
    })
  
}


shinyApp(ui, server)
