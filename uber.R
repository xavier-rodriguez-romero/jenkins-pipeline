# -------------------- Step 1: Load Libraries --------------------
cat("Step 1: Loading libraries...\n")
suppressMessages(library(dplyr))
suppressMessages(library(ggplot2))
suppressMessages(library(lubridate))

# -------------------- Step 2: Load Data --------------------
cat("Step 2: Reading 'uber.csv' file...\n")
uber_data <- read.csv("uber.csv", stringsAsFactors = FALSE)
print(head(uber_data))

# -------------------- Step 3: Parse Timestamps --------------------
cat("Step 3: Parsing timestamp columns...\n")
uber_data$Request.timestamp <- parse_date_time(gsub("/", "-", uber_data$Request.timestamp), 
                                               orders = c("d-m-Y H:M:S", "d-m-Y H:M"))
uber_data$Drop.timestamp <- parse_date_time(gsub("/", "-", uber_data$Drop.timestamp), 
                                            orders = c("d-m-Y H:M:S", "d-m-Y H:M"))

# -------------------- Step 4: Extract Date-Time Components --------------------
cat("Step 4: Extracting components from request and drop times...\n")
uber_data <- uber_data %>%
        mutate(
                req_day = day(Request.timestamp),
                req_month = month(Request.timestamp),
                req_year = year(Request.timestamp),
                req_hour = hour(Request.timestamp),
                req_minute = minute(Request.timestamp),
                drop_hour = hour(Drop.timestamp),
                drop_minute = minute(Drop.timestamp)
        )
print(head(uber_data[, c("req_day", "req_hour", "drop_hour")]))

# -------------------- Step 5: Compute Journey Duration --------------------
cat("Step 5: Calculating journey durations in minutes...\n")
uber_data <- uber_data %>%
        mutate(journey_mins = as.numeric(difftime(Drop.timestamp, Request.timestamp, units = "mins")))
print(head(uber_data$journey_mins))

# -------------------- Step 6: Flag Peak Hours --------------------
cat("Step 6: Creating peak hour flag...\n")
uber_data <- uber_data %>%
        mutate(is_peakhour = case_when(
                req_hour >= 5 & req_hour <= 10 ~ "peakhour_morning",
                req_hour >= 17 & req_hour <= 22 ~ "peakhour_evening",
                TRUE ~ "Not_peakhour"
        ))
print(table(uber_data$is_peakhour))

# -------------------- Step 7: Check Repetitions and Unique Values --------------------
cat("Step 7: Summarizing duplicates and unique values...\n")
dup_summary <- sapply(uber_data, function(x) sum(duplicated(x)))
unique_summary <- sapply(uber_data, function(x) length(unique(x)))
print(dup_summary)
print(unique_summary)

# -------------------- Step 8: Histogram of Status --------------------
cat("Step 8: Creating histogram of trip status...\n")
ggplot(uber_data, aes(x = Status)) +
        geom_bar(fill = "steelblue") +
        labs(title = "Trip Status Distribution", subtitle = "Frequency of each trip status", x = "Trip Status")

# -------------------- Step 9: Stacked Histogram of Status by Pickup --------------------
cat("Step 9: Plotting stacked bar: Status by Pickup Point...\n")
ggplot(uber_data, aes(x = Pickup.point, fill = Status)) +
        geom_bar(position = "stack") +
        labs(title = "Trip Status by Pickup Point", subtitle = "Stacked histogram", x = "Pickup Point") +
        theme(text = element_text(size = 9, face = "bold"))

# -------------------- Step 10: Stacked Bar of Status by Hour --------------------
cat("Step 10: Plotting bar: Status by Request Hour...\n")
uber_data$req_hour <- hour(uber_data$Request.timestamp)
ggplot(uber_data, aes(x = req_hour, fill = Status)) +
        geom_bar(position = "stack") +
        labs(title = "Cab Demand During the Day", subtitle = "By Status per Hour", x = "Hour of Day") +
        theme(text = element_text(size = 9, face = "bold"))

# -------------------- Step 11: Stacked Bar of Pickup Point by Hour --------------------
cat("Step 11: Plotting bar: Pickup Point by Hour with annotation...\n")
ggplot(uber_data, aes(x = req_hour, fill = Pickup.point)) +
        geom_bar(position = "stack") +
        labs(title = "Cab Demand by Pickup Point", subtitle = "By Hour of Day", x = "Hour") +
        annotate("text", x = 11, y = 500, label = "High demand here", color = "blue") +
        theme(text = element_text(size = 9, face = "bold"))

# -------------------- Step 12: Boxplot of Journey Duration --------------------
cat("Step 12: Plotting boxplot of journey duration...\n")
ggplot(uber_data, aes(x = factor(req_hour), y = journey_mins)) +
        geom_boxplot(aes(fill = Pickup.point)) +
        labs(title = "Journey Duration Pattern by Hour", subtitle = "Weekday duration (minutes)", x = "Hour", y = "Duration (mins)") +
        theme(text = element_text(size = 9, face = "bold"))

