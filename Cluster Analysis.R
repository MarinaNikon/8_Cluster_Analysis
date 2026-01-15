#Cluster Analysis Assignment
#Marina Nikon

#BACKGROUND:
#Marketing team of ABC Bank is running a campaign for credit card on the 
#existing customers. Marketing team wants to understand the segments of the 
#customers to target based on the Minimum and Maximum Balances, Monthly 
#Income, age of the customer, association of the customer with bank (in years).


#Install the packages if required and call for the corresponding library
install.packages("factoextra")  
library(dplyr) #for pipe operator %>%
library(purrr) # to apply the wss 
library(ggplot2) # for plots
#library(factoextra) #for elbow method

#QUESTIONS:
#  1. Import Customer data in R.
# Load the data
CustomerData<-read.csv("Customer_data.csv", header = TRUE)
head(CustomerData) # View first 6 rows
dim(CustomerData) # Check the dimension of the dataset
summary(CustomerData) #Summarizing data and checking for missing values
str(CustomerData) # Check the structure of the dataset
anyNA(CustomerData) # Check for missing values
CustomerData <- na.omit(CustomerData)
#Observations:
#There are no missing values


# 2. Subset the data excluding Customer id and City.
CustomerData_cl<-subset(CustomerData,select=-c(Cust_Id, City))
head(CustomerData_cl)


# 3. Scale the variables.
CustomerData_sorted<-scale(CustomerData_cl)%>%as.data.frame()
head(CustomerData_sorted)


# 4. Run kmeans on the scaled variable with 3 clusters.
set.seed(123)
CL<-kmeans(CustomerData_sorted,3)

#Cluster size(No. of customers in each cluster)
CL$size
#27016 27052 26013


#Add cluster membership to the data
CustomerData$Cluster<- CL$cluster
head(CustomerData)


# 5. Obtain mean of original variables for each cluster.
allmean <- aggregate(cbind(age, MonthlyIncome, MinBa, MaxBal, Age.with.Bank)~Cluster,data=CustomerData,FUN=mean)
allmean=allmean %>% map(round,2) %>% as.data.frame() #round off values to two decimal places
allmean


# 6. Interpret the clusters.
#Observations:
#  Cluster   age MonthlyIncome   MinBal   MaxBal Age.with.Bank
#1       1 37.45      42471.37 15995.79 30039.13           3.5
#2       2 27.01      12499.41  3744.16 12547.47           1.0
#3       3 54.97      82430.55 39981.62 54980.39           6.5

#Cluster number 3 is made up of platinum customers who have 
#greater Monthly Income, as well as greater Minimum and Maximum Balance;
#also, customers in this segment are older and have been 
#conducting business with the company for a longer period of time.

#The customers in Cluster 2 include young customers with low income and
#savings. They have been in business with company for just one  year.

##The customer in Cluster 1 are of middle-age with stable income and moderate savings.


#Visualizing the Clusters
#Average age in Each Cluster
ggplot(allmean, aes(x = Cluster, y = age)) +
  geom_bar(stat = "identity", fill = "deepskyblue") +
  geom_text(aes(label = age), vjust = -0.5, color = "black", size = 3) + 
  labs(title = "Average age in Each Cluster", x = "Cluster", y = "Age")


#Average Monthly Income in Each Cluster
ggplot(allmean, aes(x = Cluster, y = MonthlyIncome)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  geom_text(aes(label = MonthlyIncome), vjust = -0.5, color = "black", size = 3) + 
  labs(title = "Average Monthly Income in Each Cluster", x = "Cluster", y = "Monthly Income")


#Average Minimum Balance in Each Cluster
ggplot(allmean, aes(x = Cluster, y = MinBal)) +
  geom_bar(stat = "identity", fill = "greenyellow") +
  geom_text(aes(label = MinBal), vjust = -0.5, color = "black", size = 3) + 
  labs(title = "Average Minimum Balance in Each Cluster", x = "Cluster", y = "Minimum Balance")

#Average Maximum Balance in Each Cluster
ggplot(allmean, aes(x = Cluster, y = MaxBal)) +
  geom_bar(stat = "identity", fill = "aquamarine") +
  geom_text(aes(label = MaxBal), vjust = -0.5, color = "black", size = 3) + 
  labs(title = "Average Maximum Balance in Each Cluster", x = "Cluster", y = "Maximum Balance")

#Average Age with Bank in Each Cluster
ggplot(allmean, aes(x = Cluster, y = Age.with.Bank)) +
  geom_bar(stat = "identity", fill = "springgreen2") +
  geom_text(aes(label = Age.with.Bank), vjust = -0.5, color = "black", size = 3) + 
  labs(title = "Average Age with Bank/nin Each Cluster", x = "Cluster", y = "Age with Bank")


# 7. Obtain plot of WSS (Within Sum of Squares) to check number of clusters.
set.seed(123)

#Function to calculate WSS for different values of k
wss <- function(k) {
  kmeans(CustomerData_sorted, k,iter.max = 1000)$tot.withinss
}

#Define range of k values (1 to 15)
k.values <- 1:15

#Compute WSS for each k
wss_values <- map_dbl(k.values, wss)

#Plot WSS to find the "elbow"
plot(k.values, wss_values,
     type = "b", pch = 19, frame = FALSE,
     xlab = "Number of clusters K",
     ylab = "Total within-clusters sum of squares",
     main = "Elbow Method for Optimal K")

#Observations:
# Using elbow method, K=4 clusters suit better





