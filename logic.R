library(readr)
library(dplyr)
library(ggplot2)
library(readxl)
library(forecast)
############################### CARGA DE DATOS ##################################################
supermarket <- read_csv("supermarket_Sales.csv") #ON SALES DASHBOARD

# Convertir la columna "Date" a formato de fecha
supermarket$Date <- as.Date(supermarket$Date)

# Ordenar el dataframe por la columna "Date" y establecerla como índice
supermarket <- supermarket[order(supermarket$Date), ]

# Calcular la columna "Revenue"
supermarket$Revenue <- supermarket$`Unit price` * supermarket$Quantity

# Renombrar la columna "Gross income"
colnames(supermarket)[colnames(supermarket) == "Gross income"] <- "Income after costs and taxes"
################################################################################################


stores <- read_excel("Datawarehouse.xlsx", 
                     sheet = "stores") 
sales <- read_excel("Datawarehouse.xlsx", 
                    sheet = "sales")
features <- read_excel("Datawarehouse.xlsx", 
                       sheet = "features")

sales_stores <- merge(sales, stores, by = "Store")

features$Fuel_Price <- as.numeric(features$Fuel_Price)

features_stores <- merge(features, stores, by = "Store")

stores$Size <- as.numeric(stores$Size)
stores$Type <- as.factor(stores$Type)
sales$Date <- as.Date(sales$Date)


################################ KPIS PARA FEATURES##############################################
# Calculate mean size by type
mean_size_by_type <- stores %>%
  group_by(Type) %>%
  summarise(mean_size = mean(Size))


kpi1 <- ggplot(mean_size_by_type, aes(x = Type, y = mean_size)) +
  geom_col(fill = "skyblue") +
  labs(title = "Mean Size of Stores by Type",
       y = "Mean Size",
       x = "Store Type") +
  theme_minimal()
plot(kpi1)
# Calculate mean temperature by type

features_stores$Temperature <- as.numeric(features_stores$Temperature)

mean_temperature_by_type <- features_stores %>%
  group_by(Type) %>%
  summarise(mean_temperature = mean(Temperature))

kpi2 <- ggplot(mean_temperature_by_type, aes(x = Type, y = mean_temperature)) +
  geom_col(fill = "skyblue") +
  labs(title = "Mean Temperature of Stores by Type",
       y = "Mean Temperature",
       x = "Store Type") +
  theme_minimal()
# Calculate mean fuel price by type


mean_fuel_price_by_type <- features_stores %>%
  group_by(Type) %>%
  summarise(mean_fuel_price = mean(Fuel_Price))

kpi3 <- ggplot(mean_fuel_price_by_type, aes(x = Type, y = mean_fuel_price)) +
  geom_col(fill = "skyblue") +
  labs(title = "Mean Fuel Price of Stores by Type",
       y = "Mean Fuel Price",
       x = "Store Type") +
  theme_minimal()
# Unemployment rate by type

features_stores$Unemployment <- as.numeric(features_stores$Unemployment)

mean_unemployment_by_type <- features_stores %>%
  group_by(Type) %>%
  summarise(mean_unemployment = mean(Unemployment))

kpi4 <- ggplot(mean_unemployment_by_type, aes(x = Type, y = mean_unemployment)) +
  geom_col(fill = "skyblue") +
  labs(title = "Mean Unemployment Rate of Stores by Type",
       y = "Mean Unemployment Rate",
       x = "Store Type") +
  theme_minimal()
# CPI by type

features_stores$CPI <- as.numeric(features_stores$CPI)

mean_cpi_by_type <- features_stores %>%
  group_by(Type) %>%
  summarise(mean_cpi = mean(CPI))

kpi5 <- ggplot(mean_cpi_by_type, aes(x = Type, y = mean_cpi)) +
  geom_col(fill = "skyblue") +
  labs(title = "Mean CPI of Stores by Type",
       y = "Mean CPI",
       x = "Store Type") +
  theme_minimal()

################################################################################



################################# KPIS PARA SALES ############################################
head(sales_stores)


#Sales by the time


sales_stores$Date <- as.Date(sales_stores$Date, format = "%d/%m/%Y")
sales_stores$Weekly_Sales <- as.numeric(sales_stores$Weekly_Sales)


# Ahora, crea el gráfico de líneas
kpi6 <- ggplot(sales_stores, aes(x = Date, y = Weekly_Sales)) +
  geom_line() +
  scale_x_date(date_labels = "%b %Y", date_breaks = "1 month") +
  labs(x = "Date", y = "Weekly Sales", title = "Weekly Sales Over Time") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8)) +
  theme(panel.grid.major = element_line(color = "#eceff1"), panel.grid.minor = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 12))


#
# Convert store_sales$Date to proper date format
sales_stores$Date <- as.Date(sales_stores$Date, format = "%d/%m/%Y")

# Group by month and year and calculate total sales_stores per month
sales_by_month <- sales_stores %>% 
  mutate(month_year = paste0(format(Date, "%b-%y"))) %>% # Combine month and year into one string
  group_by(month_year) %>% 
  summarize(total_sales = sum(Weekly_Sales))

# Set up chart elements
chart_title <- "Weekly Sales by Month"
x_label <- "Month"
y_label <- "Total Weekly Sales"

# Plot weekly sales_stores by month
kpi7 <- ggplot(data = sales_by_month, aes(x = factor(month_year), y = total_sales)) +
  geom_line(aes(group = 1)) +
  scale_x_discrete(breaks = unique(fct_reorder(factor(sales_by_month$month_year), match(sales_by_month$month_year, rev(unique(sales_by_month$month_year))))), 
                   limits = rev(levels(fct_reorder(factor(sales_by_month$month_year), match(sales_by_month$month_year, rev(unique(sales_by_month$month_year))))))) +
  labs(title = chart_title, x = x_label, y = y_label) +
  theme_bw() +
  theme(panel.grid.major = element_line(), panel.grid.minor = element_blank())
#






holidays_per_month <- sales_stores %>%
  filter(IsHoliday == TRUE) %>%
  mutate(Month = format(as.Date(Date),"%Y-%m")) %>%
  group_by(Month) %>%
  summarise(Avg_Holidays_Sales = mean(Weekly_Sales))

head(holidays_per_month)


kpi8 <- ggplot(data = holidays_per_month, aes(x = Month, y = Avg_Holidays_Sales)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Holiday Sales Per Month",
       subtitle = "(Based on Days Marked As Holidays)",
       x = "Month",
       y = "Average Weekly Sales During Holidays") +
  theme_bw()


head(sales_stores)

###############################################################################################
