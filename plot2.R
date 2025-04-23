if (!file.exists("household_power_consumption.txt")) {
  url <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, destfile = "power_data.zip")
  unzip("power_data.zip")
}

install.packages("sqldf")
library(sqldf)

# Read filtered data (only 1/2/2007 and 2/2/2007)
data <- read.csv.sql("household_power_consumption.txt",
                     sql = "SELECT * FROM file WHERE Date IN ('1/2/2007', '2/2/2007')",
                     sep = ";",
                     header = TRUE)
# Replace '?' strings manually with NA
data[data == "?"] <- NA

cols_to_convert <- names(data)[3:9]
data[cols_to_convert] <- lapply(data[cols_to_convert], function(x) as.numeric(as.character(x)))

data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
data$datetime <- as.POSIXct(paste(data$Date, data$Time), format = "%Y-%m-%d %H:%M:%S")

png("plot2.png", width = 480, height = 480)

plot(data$datetime, data$Global_active_power, ylab="Global Active Power(kilowatts)", type = "l")

dev.off()
