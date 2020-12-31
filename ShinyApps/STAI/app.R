library(shiny)
ui <- fluidPage(
  fluidPage(
    titlePanel("Upload STAI File"),
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
    # Get just the Item data 
    Items=Raw[3:length(rownames(Raw)),charmatch("ID",names(Raw)):charmatch("C.2.Q20",names(Raw))]
    row.names(Items)<-1:nrow(Items)
    #
    # Create matrix and change item responses from words to numeric
    ItemNum=Items
    ItemNum[,4:length(colnames(ItemNum))]=NA
    Emptys=ItemNum
    #
    # First for trait anxiety
    ItemNum[Items=="Hardly-ever"]=1
    ItemNum[Items=="Sometimes"]=2
    ItemNum[Items=="Often"]=3
    #
    # Now for state anxiety
    for(c in 4:23){
      for(r in 1:nrow(Items)){
        if(!Items[r,c]=='' & !is.na(pmatch('Very',Items[r,c]))){
          ItemNum[r,c]=1
        }
        #
        if(!Items[r,c]=='' & !is.na(pmatch('Not',Items[r,c]))){
          ItemNum[r,c]=3
        }
        #
        if(!Items[r,c]=='' & is.na(pmatch('Very',Items[r,c])) & is.na(pmatch('Not',Items[r,c]))){
          ItemNum[r,c]=2
        }
        #
      }
    }
    remove(r,c)
    #
    # Now recode the reverse coded items
    ReverseItems=c(2,4,5,7,9,11,15,16,18,19)+3
    for(c in ReverseItems){
      for(r in 1:nrow(Items)){
        if(!Items[r,c]=='' & !is.na(pmatch('Very',Items[r,c]))){
          ItemNum[r,c]=3
        }    
        if(!Items[r,c]=='' & !is.na(pmatch('Not',Items[r,c]))){
          ItemNum[r,c]=1
        }
      }
    }
    remove(r,c)
    #
    # Create columns for state and trait raw scores
    StateRaw=matrix(NA, nrow=length(ItemNum[,1]), ncol=1)
    TraitRaw=matrix(NA, nrow=length(ItemNum[,1]), ncol=1)
    ItemNum=cbind(ItemNum,StateRaw,TraitRaw)
    
    #
    # Now sum to get raw scores
    for(r in 1:nrow(Items)){
      if(sum(is.na(ItemNum[r,4:23]))==0){ItemNum$StateRaw[r]=sum(ItemNum[r,4:23])}
      if(sum(is.na(ItemNum[r,24:43]))==0){ItemNum$TraitRaw[r]=sum(ItemNum[r,24:43])}
    }
    StateRaw=ItemNum$StateRaw
    TraitRaw=ItemNum$TraitRaw
    remove(r)
    # rename variables and finish the dataframe
    participant_id=ItemNum$ID
    
    df=cbind(participant_id,ItemNum[,charmatch("C.1.Q1",names(ItemNum)):charmatch("C.1.Q20",names(ItemNum))],StateRaw,ItemNum[,charmatch("C.2.Q1",names(ItemNum)):charmatch("C.2.Q20",names(ItemNum))],TraitRaw)
    colnames(df)[2:43]=c("stai_c1_1", "stai_c1_2", "stai_c1_3", "stai_c1_4", "stai_c1_5", "stai_c1_6", "stai_c1_7", "stai_c1_8", "stai_c1_9", "stai_c1_10", "stai_c1_11", "stai_c1_12", "stai_c1_13", "stai_c1_14", "stai_c1_15", "stai_c1_16", "stai_c1_17", "stai_c1_18", "stai_c1_19", "stai_c1_20", "rdoc_stai_c1_total", "stai_c2_1", "stai_c2_2", "stai_c2_3", "stai_c2_4", "stai_c2_5", "stai_c2_6", "stai_c2_7", "stai_c2_8", "stai_c2_9", "stai_c2_10", "stai_c2_11", "stai_c2_12", "stai_c2_13", "stai_c2_14", "stai_c2_15", "stai_c2_16", "stai_c2_17", "stai_c2_18", "stai_c2_19", "stai_c2_20", "rdoc_stai_c2_total")
    df=df
  })
  
  
  output$contents <- renderTable(
    
    getData()
    
  )
  # Where the example input data starts
  output$inputexample<- renderText(c('Example of input .csv file'))
  output$outputlabel<-renderText(c('Output data:'))
  output$instruction1<- renderText(c("Please upload a .csv file with subject id, age, gender, and item-level raw data for the STAI with the following, case-sensitive labels: ID, Age, Gender, C-1.Q1 through C-2.Q20 (see example below)."))
  output$instruction2<- renderText(c("In addition to the raw data, the output file will include the following columns: rdoc_stai_c1_total (state anxiety raw score) & rdoc_stai_c2_total (trait anxiety raw score)."))
  output$instruction3<- renderText(c("NOTE: This is based on the STAI parent report, and only works for children between 8 to 13 years old. It is intended for the RDOC study that is in collaboration with DCNL at Georgetown and Children's National Autism group. This was designed to take data from Qualtrics STAI scale, score, then upload to REDCap. Please send your questions to Junaid Merchant: merchantjs@gmail.com"))
  
  
  ID=c("subject1","subject2","subject3"); Age=c(8,10,13); Gender=c("Male", "Female", "Male"); C.1.Q1=c("Very calm","Calm","Not calm"); etc=c("...","...","..."); C.2.Q20=c("Sometimes","Hardly-ever","Often"); 
   
  disp_data=data.frame(ID,Age,Gender,C.1.Q1,etc,C.2.Q20)
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