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

# Generate plot4
png("plot4.png")

# Set up trellising
par(mfcol=c(2, 2), mar=c(4, 4, 1, 1))
with(elmdf, {
  # Create the global active power plot in upper left panel
  # First I generate a line plot with no x axis labeling
  plot(DateTimeNum, Global_active_power, xlab="", xaxt="n", ylab="Global Active Power", type="l")
  # Now I add the x axis using the unique list of dates from above as the labels
  axis.Date(1, at=udate)
  # Create the sub metering plot in the lower left panel
  # First I generate a line plot for Sub_metering_1 with no x axis labeling
  plot(DateTimeNum, Sub_metering_1, xlab="", xaxt="n", ylab="Energy sub metering", type="l")
  # Next I add he line plot for Sub_metering_2 with no x axis labeling and no y axis title
  lines(DateTimeNum, Sub_metering_2, xlab="", xaxt="n", ylab="", type="l", col="darkorange2")
  # Next I add he line plot for Sub_metering_3 with no x axis labeling and no y axis title
  lines(DateTimeNum, Sub_metering_3, xlab="", xaxt="n", ylab="", type="l", col="blue")
  # Now I add the x axis using the unique list of dates from above as the labels
  axis.Date(1, at=udate)
  # Now I add the legend
  legend("topright",
         col=c("black", "darkorange2", "blue"),
         legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
         lwd=1,
         bty="n")
  # Create the voltage plot in upper left panel
  # First I generate a line plot with no x axis tick labeling
  plot(DateTimeNum, Voltage, xlab="datetime", xaxt="n", type="l")
  # Now I add the x axis tick labels using the unique list of dates from above as the labels
  axis.Date(1, at=udate)
  # Create the Global_reactive_power plot in upper left panel
  # First I generate a line plot with no x axis tick labeling
  plot(DateTimeNum, Global_reactive_power, xlab="datetime", xaxt="n", type="l")
  # Now I add the x axis tick labels using the unique list of dates from above as the labels
  axis.Date(1, at=udate)
})

dev.off()
