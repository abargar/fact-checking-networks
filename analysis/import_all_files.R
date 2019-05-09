# Load all libraries (or install if necessary)

library(ggplot2)
library (ggthemes)
library(dplyr)


# Import all files
# path to folder that holds multiple .csv files
folder <- "/Users/p/Documents/Research/Collaborations/Elias/Data/timeline_feature_vectors_all/"      


# create list of all .csv files in folder
file_list <- list.files(path=folder, pattern="*.csv") 


# read in each .csv file in file_list and create a data frame with the same name as the .csv file
for (i in 1:length(file_list)){
  
  assign(file_list[i], 
         
         read.csv(paste(folder, file_list[i], sep=''))
)}

#Merge into one single dataframe
total <- rbind(ABCFactCheck.csv,AfricaCheck.csv, agencialupa.csv, aosfatos.csv,APFactCheck.csv,
               boomlive_in.csv, Check_Your_Fact.csv,Chequeado.csv, ClimateFdbk.csv,Colcheck.csv,
               correctiv_org.csv,decodeurs.csv,DemagogCZ.csv,dogrulukpayicom.csv,ElSabuesoAP.csv,
               FactCheck_GEO.csv,factcheckdotorg.csv,FactCheckIndia.csv,FactCheckNI.csv,faktisk_no.csv,
               FaktografHR.csv,FerretScot.csv,istinomer.csv,Istinomjer.csv,KallxoLive.csv,lasillavacia.csv,
               LeadStoriesCom.csv,nieuwscheckers.csv,NUnl.csv, ObjetivoLaSexta.csv, PagellaPolitica.csv,
               rapplerdotcom.csv, SouthAsiaCheck.csv, teyitorg.csv, thejournal_ie.csv, thewhistleIL.csv,
               TirtoID.csv, TjekDet.csv, verafiles.csv, voxukraine.csv)


#Preprocess data

#Mean RT Counts

org_screen_names<-c("ABCFactCheck","AfricaCheck","agencialupa","aosfatos","APFactCheck",
                    "boomlive_in", "Check_Your_Fact","Chequeado","ClimateFdbk" ,"Colcheck",
                    "correctiv_org", "decodeurs","DemagogCZ", "dogrulukpayicom","ElSabuesoAP",
                    "FactCheck_GEO","factcheckdotorg","FactCheckIndia","FactCheckNI","faktisk_no",
                    "FaktografHR","FerretScot","istinomer","Istinomjer","KallxoLive","lasillavacia",
                    "LeadStoriesCom","nieuwscheckers","NUnl","ObjetivoLaSexta", "PagellaPolitica",
                    "rapplerdotcom", "SouthAsiaCheck","teyitorg","thejournal_ie", "thewhistleIL",
                    "TirtoID","TjekDet","verafiles", "voxukraine")

# Get mean RT count per Organization

options(scipen=999)
mean_rtcounts <-total%>%
  filter(screen_name %in%org_screen_names )%>%
  group_by(screen_name)%>%
  summarise(mean_rtcount = mean(retweet_count))
mean_rtcounts

#Arrange in descending order
mean_rtcounts <-total%>%
  filter(screen_name %in%org_screen_names )%>%
  group_by(screen_name)%>%
  summarise(mean_rtcount = mean(retweet_count))%>%
  arrange(desc(mean_rtcount))
mean_rtcounts

# Get mean favourite counts

mean_favcounts <-total%>%
  filter(screen_name %in%org_screen_names)%>%
  group_by(screen_name)%>%
  summarise(mean_favcount = mean(favorite_count))
mean_favcounts

# Get mean follower counts

mean_follcounts <-total%>%
  filter(screen_name %in%org_screen_names)%>%
  group_by(screen_name)%>%
  summarise(mean_follcount = mean(followers_count))
mean_follcounts

##############################################################
### Preliminary Plots

#Plot of mean retweet count per organization 

p1<-mean_rtcounts%>%
  arrange(desc(mean_rtcount))%>%
  ggplot()+
  geom_col(aes(x=reorder(screen_name,-mean_rtcount),y = mean_rtcount),fill="navyblue")+
  theme(axis.text.x=element_text(angle=90, hjust=1))+
  labs(x = "Organization Screen Name", y="Mean RT Count")+
  ggtitle("Mean RT Count per Organization")

mean_rtcounts

#Plot of mean favorite count per organization 

p2<-mean_favcounts%>%
  arrange(desc(mean_favcount))%>%
  ggplot()+
  geom_col(aes(x=reorder(screen_name,-mean_favcount),y = mean_favcount),fill="maroon4")+
  theme(axis.text.x=element_text(angle=90, hjust=1))+
  labs(x = "Organization Screen Name", y="Mean Fav Count")+
  ggtitle("Mean Fav Count per Organization")
p2

#Plot of mean followers per organization

p3<-mean_follcounts%>%
  arrange(desc(mean_follcount))%>%
  ggplot()+
  geom_col(aes(x=reorder(screen_name,-mean_follcount),y = mean_follcount),fill="springgreen4")+
  theme(axis.text.x=element_text(angle=90, hjust=1))+
  labs(x = "Organization Screen Name", y="Mean Followers Count")+
  ggtitle("Mean Follower Count per Organization")
p3

# Plot of number of unique tweets per Organization

unique_tweets<-orgs_only %>%
  group_by(screen_name) %>%
  summarise(n_distinct(ID))%>%
  
p4<-
 

#Histogram of RT count per Organization

orgs_only <-total%>%
  filter(screen_name %in%org_screen_names)%>%
  group_by(screen_name)

ggplot(orgs_only) + geom_histogram(aes(x = retweet_count))+
                                     facet_wrap(~screen_name)

#Individual histograms of RT counts

ggplot(ABCFactCheck.csv) + geom_histogram(aes(x = retweet_count))
ggplot(Chequeado.csv) + geom_histogram(aes(x = retweet_count), bins =10)




ggplot(AfricaCheck.csv, aes(retweeted, has_url)) +   
  geom_bar(aes(fill = has_url), position = "dodge", stat="identity")


# Retweets by has_url by organization

# General
ggplot(data=orgs_only)+
  geom_bar(x = retweet_count, y=has_url)+
  facet_wrap(~screen_name)

## Per Organization. CAUTION:Scales are different (I guess according to the number of total retweets the org has. Does n of tweets also influence this?)
# ABCFactCheck
ggplot(ABCFactCheck.csv, aes(has_url,retweet_count)) +   
  geom_bar(aes(fill=has_url), position = "dodge", stat="identity")+
  labs(x = "Has URL", y="Retweet Count")+
  ggtitle("ABCFactCheck Retweet Count per Feature: Has URL")


# AfricaCheck

ggplot(AfricaCheck.csv, aes(has_url,retweet_count)) +   
  geom_bar(aes(fill=has_url), position = "dodge", stat="identity")+
  labs(x = "Has URL", y="Retweet Count")+
  ggtitle("AfricaCheck Retweet Count per Feature: Has URL")







#Histogram of FAV count per Organization

ggplot(orgs_only) + geom_histogram(aes(x = favorite_count))+
  facet_wrap(~screen_name)





# Create a group-means data set


rtcount_summary <- subset1 %>% # the names of the new data frame and the data frame to be summarised
  group_by(screen_name) %>%   # the grouping variable
  summarise(mean_rtcount = mean(retweet_count),  # calculates the mean of each group
            sd_rtcount = sd(retweet_count), # calculates the standard deviation of each group
            n_rtcount = n(),  # calculates the sample size per group
            SE_retcount = sd(retweet_count)/sqrt(n())) # calculates the standard error of each group

rt_mean_plot <- ggplot(rtcount_summary, aes(screen_name, mean_rtcount)) + 
  geom_col() 
  
rtcount_means<-subset1 %>%
  group_by(screen_name)%>%
  summarise(mean_rtcount = mean(retweet_count))

ABCFactCheck_rtcount_means<-ABCFactCheck.csv %>%
  filter(screen_name == "ABCFactCheck")%>%
  group_by(screen_name)%>%
  summarise(mean_rtcount = mean(retweet_count))

ggplot()


ggplot(data = total) +
  geom_bar(mapping = aes(x = retweeted))+
  facet_wrap(~total$screen_name)

ggplot(data = subset1) +
  geom_bar(mapping = aes(x = retweeted))+
  
  facet_wrap(~screen_name)






  

ggplot(data = ABCFactCheck.csv) +
  geom_bar(mapping = aes(x = retweeted))
  theme_fivethirtyeight()+
  theme(axis.title = element_text(), axis.title.x = element_text(), axis.text=element_text(size=12),
        legend.position=c(0,0.029), legend.justification=c(0, 2.5), legend.direction="horizontal") +
  labs(caption = "ABCFactCheck") 




