#### UI Side of shinyCutoffs ----
library(shiny)

ui <- fluidPage(
  titlePanel("Generate Cutoff Values for SEM Fit-Indices"),
  
  sidebarLayout(
    sidebarPanel(width = 2,
      actionButton("run", "Run Simulation"),
      helpText("Running the simulation may take a few minutes. Make sure you have set all options you want to set."),
      p(),
      textOutput("sanity"),
      textOutput("running")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Model",
          includeMarkdown("model_text.md"),
          fluidRow(
            column(6,
              textAreaInput("model", "Lavaan Input", cols = 80, rows = 15, resize = 'both'),
            ),
            column(6,
              imageOutput("path")
            ),
          ),
          fluidRow(
            column(4,
              textOutput("var_names_head"),
              tableOutput("var_names")
            )
          ),
          h1("Example Model Generator"),
          fluidRow(
            column(3,
              numericInput("n_lv", "No. of latent variables", 1)),
            column(3,
              numericInput("n_ov", "No. of indicators", 3)),
            column(3,
              selectInput("mod_type", "Latent model type", 
                choices = list("All correlations" = 1, "No correlations" = 2), 
                selected = 1)),
            column(3, 
              checkboxInput("mod_simple", "Simplified model syntax",
                value = TRUE))
          ),
          fluidRow(
            column(12, 
              actionButton("example", "Generate Model"),
              align = "center")
          ),
        ),
        tabPanel("Options",
          includeMarkdown("options_text.md"),
          fluidRow(
            shinyjs::useShinyjs(),
            h2("Data"),
            column(4,
              fileInput("data", "Select a dataset (.rds files only)", accept = c(".rds")),
              actionButton("upload", "Upload data"),
              helpText('If no dataset is selected, please provide population values to the model.')
            ),
            column(4,
              numericInput("n_obs", "No. of observations", 0)),
            column(4,
              checkboxInput("skew", "Use empirical skewness and kurtosis.", value = FALSE),
              checkboxInput("missing", "Use empirical degree of missingness.", value = FALSE))
          ),
          fluidRow(
            h2("Fit Inidices"),
            column(8, checkboxGroupInput("fit_indices", NULL,
              inline = TRUE,
              choiceNames = c("Chi-Square", "CFI", "TLI", "SRMR", "RMSEA", "AIC", "BIC"),
              choiceValues = c("chisq", "cfi", "tli", "srmr", "rmsea", "aic", "bic"),
              selected = c("chisq", "cfi", "tli", "srmr", "rmsea"))
            ),
            column(4,
              numericInput("alpha_level", "Type-I Error", .05)
            )
          ),
          fluidRow(
            h2("Estimation"),
            column(3,
              numericInput("n_rep", "No. of replications", 1000)
            ),
            column(3,
              numericInput("n_cores", "No. of cores", 1)
            )
          )
        ), 
        tabPanel("Output",
          shinyjs::useShinyjs(),
          tableOutput("summy")
        )
      )
    )
  )
)