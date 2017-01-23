#### Checking if files are present
## If there is no household_power_consumption.txt file present, verifies if there is a 
## exdata_data_household_power_consumption.zip. If there isn't, tries to download the file. Then, the zip file
## is unzipped.
if (!file.exists("household_power_consumption.txt")) {
    zip_file <- "exdata_data_household_power_consumption.zip"
    if (!file.exists(zip_file)) {
        fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileurl, zip_file, method = "auto")
    }
    unzip(zip_file)
    rm("fileurl", "zip_file")
}

#### Loading of the used libraries.
## Verifies if data.table and lubridate are installed and, if not, installs them, then loads them
if (!("data.table" %in% installed.packages())) {install.packages("data.table")}
if (!("lubridate" %in% installed.packages())) {install.packages("lubridate")}
library(data.table)
library(lubridate)

#### Reading the file and coercing the Date column into 'date' class, then subsetting it 
my_data <- fread("household_power_consumption.txt", na.strings = "?")
my_data <- my_data[, Date := dmy(Date)]

#### Subsetting the data for the dates 01-02-2007 and 02-02-2007 (dd-mm-yyyy)
my_data <- my_data[Date %in% dmy(c("01-02-2007", "02-02-2007"))]

#### Plotting
## Opens the png device, then plots a histogram of the Global_active_power variable and closes the device
png("plot1.png")
hist(my_data$Global_active_power,
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     col = "red")
dev.off()