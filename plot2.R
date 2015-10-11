library(data.table)

# Read in the file.
# The instructions suggest that the data file should not be in the repo
# so I have it stored in the parent directory.
# Types are corrected.
# The data frame is restricted to the dates in-scope for this project
# using the subset function from the data.table package.
elmdf <- as.data.frame(
  subset(
    data.table(
      within(
        read.csv2("../household_power_consumption.txt",
                  na.strings="?",
                  dec=".",
                  colClasses=c("character", "ITime", "double", "double", "double", "double", "double", "double", "double")),
        {Date <- as.Date(Date, format="%d/%m/%Y")
         DateTimeNum <- as.numeric(Date) + (as.numeric(Time) / 86400)
        })),
    between(Date, as.Date("2007-02-01"), as.Date("2007-02-02"))))

udate <- unique(elmdf$Date)
udate <- c(udate, udate[length(udate)] + 1)

plot(elmdf$DateTimeNum, elmdf$Global_active_power, xlab="", xaxt="n", ylab="Global Active Power (kilowatts)", type="l")
axis.Date(1, at=udate)

