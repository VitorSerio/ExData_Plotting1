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

#### Coercing the Time column into 'period' class
my_data <- my_data[, Time := hms(Time)]

#### Merging the Date and Time columns into one, called DateTime
my_data[, DateTime := ymd_hms(my_data$Date + my_data$Time)]

#### Plotting
## Opens the png device, reduces the marging (for there will be no title nor label on the
## x axis), then plots an empty scatterplot of the Sub_metering_1/2/3 per DateTime and adds
## lines conecting the values
## Note: Sub_metering_1 is used to create the empty initial plot, for it has the highest
## values and will, therefore, be the best to scale the y-axis
## At the end, adds a legend
png("plot3.png")
with(my_data, plot(DateTime, Sub_metering_1,
                   ylab = "Energy sub metering",
                   xlab = "",
                   type = "n"))
with(my_data, lines(DateTime, Sub_metering_1))
with(my_data, lines(DateTime, Sub_metering_2, col = "red"))
with(my_data, lines(DateTime, Sub_metering_3, col = "blue"))
legend("topright",
       lty = c(1 , 1, 1),
       col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()