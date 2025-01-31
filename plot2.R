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
        Date <- as.Date(Date, format="%d/%m/%Y"))),
    between(Date, as.Date("2007-02-01"), as.Date("2007-02-02"))))

# Combine Date and Time to produce the number of days since the epoch
# at which the measurement was taken.
elmdf$DateTimeNum <- as.numeric(elmdf$Date) + (as.numeric(elmdf$Time) / 86400)

# For labeling the x axis of the plot we need a unique list of days.
# Get the unique list in the data
udate <- unique(elmdf$Date)
# Add one more day so that we get the required day after the last data point
udate <- c(udate, udate[length(udate)] + 1)

# Generate plot2
png("plot2.png")

# First I generate a line plot with no x axis labeling
plot(elmdf$DateTimeNum, elmdf$Global_active_power, xlab="", xaxt="n", ylab="Global Active Power (kilowatts)", type="l")
# Now I add the x axis using the unique list of dates from above as the labels
axis.Date(1, at=udate)

dev.off()
