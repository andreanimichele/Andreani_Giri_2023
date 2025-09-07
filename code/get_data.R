

rm(list = ls())                     # Remove all objects from the environment

# Import required packages
if (!require("data.table"))  {install.packages("data.table");  library('data.table')}
if (!require("writexl"))    {install.packages("writexl");    library('writexl')}
if (!require("lubridate")) {install.packages("lubridate"); library('lubridate')}

# Smart File Downloader with Retry Logic
smart_download <- function(url, destfile, mode = "wb", overwrite = FALSE, retries = 3, quiet = TRUE) {
  if (file.exists(destfile) && !overwrite) {
    return(invisible(TRUE))  # Skip if file exists and no overwrite
  }
  
  attempt <- 1
  success <- FALSE
  while (attempt <= retries && !success) {
    try({
      suppressMessages(
        suppressWarnings(
          invisible(download.file(url, destfile, mode = mode, quiet = quiet))
        )
      )
      if (file.exists(destfile) && file.info(destfile)$size > 0) {
        success <- TRUE
      }
    }, silent = TRUE)
    if (!success) {
      attempt <- attempt + 1
      Sys.sleep(1)  # brief pause before retry
    }
  }
  if (!success) {
    message(sprintf("Failed to download file after %d attempt(s): %s", retries, destfile))
  }
  invisible(success)
}


# Function to calculate YoY growth for all numeric columns
calc_yoy <- function(dt, date_col = "observation_date", lag_periods = 12, by = NULL) {
  # Work on a copy
  dt <- copy(as.data.table(dt))
  
  # Ensure date column is Date/IDate
  if (!inherits(dt[[date_col]], c("Date", "IDate"))) {
    # as.IDate is fast and date-only
    dt[[date_col]] <- as.IDate(dt[[date_col]])
  }
  
  # Order by group cols (if any) then date; setorderv expects character column names
  ord_cols <- c(by %||% character(), date_col)
  setorderv(dt, ord_cols)
  
  # Numeric columns (exclude date and group columns)
  drop_cols <- unique(c(date_col, by))
  num_cols <- setdiff(names(dt)[vapply(dt, is.numeric, logical(1))], drop_cols)
  
  # Compute YoY per numeric column (optionally within groups)
  for (col in num_cols) {
    new_col <- paste0(col, "_yoy")
    if (is.null(by)) {
      dt[, (new_col) := {
        den <- shift(get(col), lag_periods)
        fifelse(!is.na(den) & den != 0, (get(col) / den - 1) * 100, NA_real_)
      }]
    } else {
      dt[, (new_col) := {
        den <- shift(get(col), lag_periods)
        fifelse(!is.na(den) & den != 0, (get(col) / den - 1) * 100, NA_real_)
      }, by = by]
    }
  }
  
  dt[]
}

data_path <- "../data"


url_fr <- "https://fred.stlouisfed.org/graph/fredgraph.csv?bgcolor=%23ebf3fb&chart_type=line&drp=0&fo=open%20sans&graph_bgcolor=%23ffffff&height=450&mode=fred&recession_bars=off&txtcolor=%23444444&ts=12&tts=12&width=1320&nt=0&thu=0&trc=0&show_legend=yes&show_axis_titles=yes&show_tooltip=yes&id=FRACPIENGMINMEI&scale=left&cosd=1960-01-01&coed=2025-03-01&line_color=%230073e6&link_values=false&line_style=solid&mark_type=none&mw=3&lw=3&ost=-99999&oet=99999&mma=0&fml=a&fq=Monthly&fam=avg&fgst=lin&fgsnd=2020-02-01&line_index=1&transformation=lin&vintage_date=2025-09-07&revision_date=2025-09-07&nd=1960-01-01"
url_de <- "https://fred.stlouisfed.org/graph/fredgraph.csv?bgcolor=%23ebf3fb&chart_type=line&drp=0&fo=open%20sans&graph_bgcolor=%23ffffff&height=450&mode=fred&recession_bars=off&txtcolor=%23444444&ts=12&tts=12&width=1320&nt=0&thu=0&trc=0&show_legend=yes&show_axis_titles=yes&show_tooltip=yes&id=DEUCPIENGMINMEI&scale=left&cosd=1962-01-01&coed=2025-03-01&line_color=%230073e6&link_values=false&line_style=solid&mark_type=none&mw=3&lw=3&ost=-99999&oet=99999&mma=0&fml=a&fq=Monthly&fam=avg&fgst=lin&fgsnd=2020-02-01&line_index=1&transformation=lin&vintage_date=2025-09-07&revision_date=2025-09-07&nd=1962-01-01"
url_it <- "https://fred.stlouisfed.org/graph/fredgraph.csv?bgcolor=%23ebf3fb&chart_type=line&drp=0&fo=open%20sans&graph_bgcolor=%23ffffff&height=450&mode=fred&recession_bars=off&txtcolor=%23444444&ts=12&tts=12&width=1320&nt=0&thu=0&trc=0&show_legend=yes&show_axis_titles=yes&show_tooltip=yes&id=ITACPIENGMINMEI&scale=left&cosd=1960-01-01&coed=2025-03-01&line_color=%230073e6&link_values=false&line_style=solid&mark_type=none&mw=3&lw=3&ost=-99999&oet=99999&mma=0&fml=a&fq=Monthly&fam=avg&fgst=lin&fgsnd=2020-02-01&line_index=1&transformation=lin&vintage_date=2025-09-07&revision_date=2025-09-07&nd=1960-01-01"
url_jp <- "https://fred.stlouisfed.org/graph/fredgraph.csv?bgcolor=%23e1e9f0&chart_type=line&drp=0&fo=open%20sans&graph_bgcolor=%23ffffff&height=450&mode=fred&recession_bars=off&txtcolor=%23444444&ts=12&tts=12&width=1320&nt=0&thu=0&trc=0&show_legend=yes&show_axis_titles=yes&show_tooltip=yes&id=JPNCPIENGMINMEI&scale=left&cosd=1955-01-01&coed=2021-06-01&line_color=%234572a7&link_values=false&line_style=solid&mark_type=none&mw=3&lw=3&ost=-99999&oet=99999&mma=0&fml=a&fq=Monthly&fam=avg&fgst=lin&fgsnd=2020-02-01&line_index=1&transformation=lin&vintage_date=2025-09-07&revision_date=2025-09-07&nd=1955-01-01"
url_uk <- "https://fred.stlouisfed.org/graph/fredgraph.csv?bgcolor=%23ebf3fb&chart_type=line&drp=0&fo=open%20sans&graph_bgcolor=%23ffffff&height=450&mode=fred&recession_bars=off&txtcolor=%23444444&ts=12&tts=12&width=1320&nt=0&thu=0&trc=0&show_legend=yes&show_axis_titles=yes&show_tooltip=yes&id=GBRCPIENGMINMEI&scale=left&cosd=1970-01-01&coed=2025-03-01&line_color=%230073e6&link_values=false&line_style=solid&mark_type=none&mw=3&lw=3&ost=-99999&oet=99999&mma=0&fml=a&fq=Monthly&fam=avg&fgst=lin&fgsnd=2020-02-01&line_index=1&transformation=lin&vintage_date=2025-09-07&revision_date=2025-09-07&nd=1970-01-01"
url_us <- "https://fred.stlouisfed.org/graph/fredgraph.csv?bgcolor=%23ebf3fb&chart_type=line&drp=0&fo=open%20sans&graph_bgcolor=%23ffffff&height=450&mode=fred&recession_bars=on&txtcolor=%23444444&ts=12&tts=12&width=1320&nt=0&thu=0&trc=0&show_legend=yes&show_axis_titles=yes&show_tooltip=yes&id=USACPIENGMINMEI&scale=left&cosd=1957-01-01&coed=2025-04-01&line_color=%230073e6&link_values=false&line_style=solid&mark_type=none&mw=3&lw=3&ost=-99999&oet=99999&mma=0&fml=a&fq=Monthly&fam=avg&fgst=lin&fgsnd=2020-02-01&line_index=1&transformation=lin&vintage_date=2025-09-07&revision_date=2025-09-07&nd=1957-01-01"

file_fr                          <- tempfile(fileext = ".csv")  # Temporary file paths
file_de                          <- tempfile(fileext = ".csv")
file_it                          <- tempfile(fileext = ".csv")
file_jp                          <- tempfile(fileext = ".csv")
file_uk                          <- tempfile(fileext = ".csv")
file_us                          <- tempfile(fileext = ".csv")

smart_download(url_fr, file_fr)
smart_download(url_de, file_de)
smart_download(url_it, file_it)
smart_download(url_jp, file_jp)
smart_download(url_uk, file_uk)
smart_download(url_us, file_us)

dt_fr                       <- as.data.table(read_csv(file_fr))  # Read Excel files into data.tables
dt_de                       <- as.data.table(read_csv(file_de))
dt_it                       <- as.data.table(read_csv(file_it))
dt_jp                       <- as.data.table(read_csv(file_jp))
dt_uk                       <- as.data.table(read_csv(file_uk))
dt_us                       <- as.data.table(read_csv(file_us))

# Sequential left joins
dt <- dt_fr[dt_de, on = "observation_date"][
  dt_it, on = "observation_date"][
    dt_jp, on = "observation_date"][
      dt_uk, on = "observation_date"][
        dt_us, on = "observation_date"]
dt$observation_date <- as.Date(dt$observation_date)

# Identify target columns
cols <- setdiff(names(dt), "observation_date")

# Apply YoY to each column
for (col in cols) {
  dt[, paste0(col, "_yoy") := (get(col) / data.table::shift(get(col), n = 12) - 1) * 100]
}

# Keep observation_date + all columns ending with "_yoy"
dt_yoy <- dt[, c("observation_date", grep("_yoy$", names(dt), value = TRUE)), with = FALSE]

dt_yoy <- dt_yoy[observation_date >= as.Date("1971-01-01")]

if (!dir.exists(data_path)) {
  dir.create(data_path, recursive = TRUE)
}

write_xlsx(dt_yoy, paste0(data_path,"/data.xlsx"))

