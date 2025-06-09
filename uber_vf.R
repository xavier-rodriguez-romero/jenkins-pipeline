# -------------------- Step 1: Load Data --------------------
cat("Step 1: Reading 'uber.csv' file...\n")
uber_data <- read.csv("uber.csv", stringsAsFactors = FALSE)
print(head(uber_data))

# -------------------- Step 2: Clean and Parse Timestamps --------------------
cat("Step 2: Cleaning and parsing timestamps...\n")
uber_data$Request.timestamp <- gsub("/", "-", uber_data$Request.timestamp)
uber_data$Drop.timestamp <- gsub("/", "-", uber_data$Drop.timestamp)

uber_data$Request.timestamp <- strptime(uber_data$Request.timestamp, format = "%d-%m-%Y %H:%M:%S")
na_req <- is.na(uber_data$Request.timestamp)
uber_data$Request.timestamp[na_req] <- strptime(uber_data$Request.timestamp[na_req], format = "%d-%m-%Y %H:%M")

uber_data$Drop.timestamp <- strptime(uber_data$Drop.timestamp, format = "%d-%m-%Y %H:%M:%S")
na_drop <- is.na(uber_data$Drop.timestamp)
uber_data$Drop.timestamp[na_drop] <- strptime(uber_data$Drop.timestamp[na_drop], format = "%d-%m-%Y %H:%M")

# -------------------- Step 3: Extract Date-Time Components --------------------
cat("Step 3: Extracting hour from request and drop times...\n")
uber_data$req_hour <- as.numeric(format(uber_data$Request.timestamp, "%H"))
uber_data$drop_hour <- as.numeric(format(uber_data$Drop.timestamp, "%H"))

# -------------------- Step 4: Calculate Journey Duration --------------------
cat("Step 4: Calculating journey durations in minutes...\n")
uber_data$journey_mins <- as.numeric(difftime(uber_data$Drop.timestamp, uber_data$Request.timestamp, units = "mins"))
print(head(uber_data$journey_mins))

# -------------------- Step 5: Flag Peak Hours --------------------
cat("Step 5: Creating peak hour flag...\n")
uber_data$is_peakhour <- ifelse(uber_data$req_hour >= 5 & uber_data$req_hour <= 10, "peakhour_morning",
                                ifelse(uber_data$req_hour >= 17 & uber_data$req_hour <= 22, "peakhour_evening", "Not_peakhour"))
print(table(uber_data$is_peakhour))

# -------------------- Step 6: Check Repetitions and Unique Values --------------------
cat("Step 6: Checking repetitions and unique values...\n")
reps <- sapply(uber_data, function(col) sum(duplicated(col)))
uniques <- sapply(uber_data, function(col) length(unique(col)))
print(reps)
print(uniques)

# -------------------- Step 7: Plot Histogram of Status --------------------
cat("Step 7: Plotting histogram of Status...\n")
png("plot1_status.png")
barplot(table(uber_data$Status), col = "steelblue", main = "Trip Status", xlab = "Status")
dev.off()

# -------------------- Step 8: Stacked Barplot of Status by Pickup.point --------------------
cat("Step 8: Plotting stacked bar: Status by Pickup Point...\n")
png("plot2_status_by_pickup.png")
pickup_status_table <- table(uber_data$Pickup.point, uber_data$Status)
barplot(pickup_status_table, beside = FALSE, col = c("lightblue", "orange"), legend = rownames(pickup_status_table), main = "Status by Pickup Point", xlab = "Pickup Point")
dev.off()

# -------------------- Step 9: Stacked Barplot of Status by Hour --------------------
cat("Step 9: Plotting status by request hour...\n")
png("plot3_status_by_hour.png")
hour_status_table <- table(uber_data$req_hour, uber_data$Status)
barplot(t(hour_status_table), beside = FALSE, col = c("red", "green", "blue"), legend = colnames(hour_status_table), main = "Status by Hour", xlab = "Hour")
dev.off()

# -------------------- Step 10: Stacked Barplot of Pickup Point by Hour --------------------
cat("Step 10: Plotting pickup point by hour...\n")
png("plot4_pickup_by_hour.png")
hour_pickup_table <- table(uber_data$req_hour, uber_data$Pickup.point)
barplot(t(hour_pickup_table), beside = FALSE, col = c("purple", "cyan"), legend = colnames(hour_pickup_table), main = "Pickup by Hour", xlab = "Hour")
dev.off()

# -------------------- Step 11: Boxplot of Journey Duration --------------------
cat("Step 11: Plotting boxplot of journey duration...\n")
png("plot5_duration_boxplot.png", width = 900, height = 500)
uber_data$hour_pickup_group <- paste(uber_data$req_hour, uber_data$Pickup.point, sep = "_")
boxplot(journey_mins ~ hour_pickup_group, data = uber_data,
        main = "Journey Duration by Hour and Pickup Point", xlab = "Hour_Pickup", ylab = "Duration (mins)",
        las = 2, cex.axis = 0.7, col = "lightgreen")
dev.off()
