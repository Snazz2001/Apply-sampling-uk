setwd('C:/My Projects/Zheng - Apply sampling algorithm to UK - RAD - 359/');
samplesuk<-read.csv("sampleuk1.csv",header=TRUE,sep=",",na.strings="NULL",stringsAsFactors=FALSE);
colnames(samplesuk)[1]<-'ProposalID';
samplesuk$DateOfBirth<-as.Date(as.character(samplesuk$DateOfBirth),format="%Y%m%d");
samplesuk$DateOfBirth<-as.Date(samplesuk$DateOfBirth);
samplesuk$ApplicationDate<-as.Date(samplesuk$ApplicationDate);
samplesuk$DateOfBirth[which(samplesuk$DateOfBirth=="1771-06-26")]<-"1971-06-26";
samplesuk$DateOfBirth[which(samplesuk$DateOfBirth=="1860-05-30")]<-"1960-05-30";
samplesuk$DateOfBirth[which(samplesuk$DateOfBirth=="1870-04-19")]<-"1970-04-19";
samplesuk$DateOfBirth[which(samplesuk$DateOfBirth=="1870-08-14")]<-"1970-08-14";
samplesuk$DateOfBirth[which(samplesuk$DateOfBirth=="1890-02-21")]<-"1990-02-21";

samplesuk$County<-gsub(",","",samplesuk$County);
samplesuk$Town<-gsub(",","",samplesuk$Town);
samplesuk$GrossIncome<-gsub(",","",samplesuk$GrossIncome);

county<-table(samplesuk$County);
county1<-as.data.frame(county);
colnames(county1)<-c("county","Freq");
county1$county<-tolower(county1$county);
counames<-unique(county1$county);
write.csv(counames,file="counames.csv");

town<-table(samplesuk$Town);
town1<-as.data.frame(town);
colnames(town1)<-"Town";
town1$Town<-tolower(town1$Town);
townnames<-unique(town1$Town);

library(ggplot2);
qplot(GrossIncome,age,data=samplesuk)+facet_grid(.~rejected);
qplot(age,data=samplesuk,geom="histogram",binwidth=10)+facet_grid(rejected~.);
ggplot(samplesuk,aes(age))+geom_histogram()+geom_density();
qplot(age,data=samplesuk,geom="density")+facet_grid(rejected~.);
qplot(MixedScore,data=samplesuk,geom="density")+facet_grid(rejected~.);
qplot(MixedScore,..count../sum(..count..),data=samplesuk,geom="histogram")+facet_grid(rejected~.);

samplesuk$County<-gsub(",","",samplesuk$County);
samplesuk$Town<-gsub(",","",samplesuk$Town);
samplesuk$GrossIncome<-gsub(",","",samplesuk$GrossIncome);
samplesuk$GrossIncome<-as.numeric(samplesuk$GrossIncome)
write.csv(samplesuk[1:5000,],file="train5000.csv");
write.csv(samplesuk[5001:10000,],file="train10000.csv");

train5000<-read.csv("train10000.csv",header=TRUE,sep=",",na.strings="NA",stringsAsFactors=FALSE);

train5000$selected<-train5000$GrossIncome<100000&train5000$rejected==-1&train5000$value>1;
train5000$selected<-train5000$selected|train5000$rejected==1;
histogram(~GrossIncome|as.factor(rejected),data=train5000[which(train5000$GrossIncome<100000),]);#orignal histogram for customer less than 100000

train5000$selected<-train5000$age<80&train5000$rejected==-1&train5000$value>1;
train5000$selected<-train5000$selected|train5000$rejected==1;
histogram(~age,data=train5000[train5000$selected,]);

samplesuk$days<-Sys.Date()-samplesuk$DateOfBirth;
samplesuk<-(samplesuk[,-4]);
samplesuk$age<-samplesuk$days/365;
samplesuk$age<-as.numeric(samplesuk$age);
samplesuk$age<-ceiling(samplesuk$age);
samplesuk$rejected<-ifelse(samplesuk$Outcome=="Declined",1,ifelse(samplesuk$Outcome=="Accepted",-1,0));

with(samplesuk,max(ApplicationDate));
train<-samplesuk[which(samplesuk$ApplicationDate<="2012-02-29"),];
test<-samplesuk[which(samplesuk$ApplicationDate>"2012-02-29"),];


train5000<-read.csv("train5000.csv",header=TRUE,sep=",",na.strings="NA",stringsAsFactors=FALSE);
train5000<-read.csv("train10000noprior.csv",header=TRUE,sep=",",na.strings="NA",stringsAsFactors=FALSE);
train5000<-read.csv("train700000.csv",header=TRUE,sep=",",na.strings="NA",stringsAsFactors=FALSE);
train5000$DateOfBirth<-as.Date(train5000$DateOfBirth);
train5000$ApplicationDate<-as.Date(train5000$ApplicationDate);
train5000$MixedScore<-as.numeric(train5000$MixedScore);
train5000$MixedScore<-ifelse(is.na(train5000$MixedScore),-1,train5000$MixedScore);

#train5000$scoreband<-ifelse(train5000$MixedScore<0,0,ifelse(train5000$MixedScore<100,1,ifelse(train5000$MixedScore<200,2,ifelse(train5000$MixedScore<300,3,ifelse(train5000$MixedScore<400,4,ifelse(train5000$MixedScore<500,5,ifelse(train5000$MixedScore<600,6,ifelse(train5000$MixedScore<700,7,ifelse(train5000$MixedScore<800,8,ifelse(train5000$MixedScore<900,9,10))))))))));
train5000$scoreband<-ifelse(train5000$MixedScore<300,0,ifelse(train5000$MixedScore<500,1,ifelse(train5000$MixedScore<550,2,ifelse(train5000$MixedScore<600,3,ifelse(train5000$MixedScore<650,4,ifelse(train5000$MixedScore<700,5,ifelse(train5000$MixedScore<750,6,ifelse(train5000$MixedScore<800,7,ifelse(train5000$MixedScore<850,8,ifelse(train5000$MixedScore<900,9,ifelse(train5000$MixedScore<950,10,11)))))))))));
train5000$ageband<-ifelse(train5000$age<19,1,ifelse(train5000$age<23,2,ifelse(train5000$age<26,3,ifelse(train5000$age<29,4,ifelse(train5000$age<32,5,ifelse(train5000$age<36,6,7))))));
train5000$incomeband<-ifelse(train5000$GrossIncome<=9600,1,ifelse(train5000$GrossIncome<=19140,2,3));
train5000$dependentband<-ifelse(train5000$NumberOfDependants==0,1,ifelse(train5000$NumberOfDependants==1,2,ifelse(train5000$NumberOfDependants==2,3,4)));

histogram(~MixedScore|as.factor(rejected),data=train5000);
histogram(~MixedScore,data=train5000[which(train5000$rejected==1&train5000$value>3),]);
histogram(~MixedScore,data=train5000[which(train5000$rejected==1&train5000$score>800),]);

table(train5000$ageband[which(train5000$rejected==-1)]);
table(train5000$ageband[which(train5000$rejected==1)]);
table(train5000$ageband[which(train5000$rejected==1&train5000$value2>3)]);
table(train5000$ageband[which(train5000$rejected==1&train5000$score>800)]);

table(train5000$scoreband[which(train5000$rejected==-1)]);
table(train5000$scoreband[which(train5000$rejected==1)]);
table(train5000$scoreband[which(train5000$rejected==1&train5000$value>3)]);
table(train5000$scoreband[which(train5000$rejected==1&train5000$score>800)]);

train5000$label<-ifelse(train5000$votes==3&train5000$rejected==1,1,0);

train5000$label<-ifelse(train5000$score>650&train5000$rejected==1,1,0);#for have prior knowledge
train5000$label<-ifelse(train5000$score>850&train5000$rejected==1,1,0);#for no prior knowledge
train50002<-train5000[which(train5000$label==1|train5000$rejected==-1),];

ggplot(train50002,aes(GrossIncome,MixedScore,color=as.factor(label)))+geom_point(position="jitter");
ggplot(train50002,aes(age,MixedScore,color=as.factor(label)))+geom_point(position="jitter");
ggplot(train50002,aes(NumberOfDependants,EmployerIndustry,color=as.factor(label)))+geom_point(position="jitter")

ggplot(train5000,aes(GrossIncome,MixedScore,color=as.factor(train5000$label)))+geom_point()
ggplot(train5000,aes(age,MixedScore,color=as.factor(train5000$label)))+geom_point()
traingoodadd<-train5000[train5000$rejected==-1|(train5000$votes==3&train5000$rejected==1),]
traingoodadd$label<-ifelse(traingoodadd$votes==3&traingoodadd$rejected==1,1,0)
ggplot(traingoodadd,aes(age,MixedScore,color=as.factor(traingoodadd$label)))+geom_point()
ggplot(traingoodadd,aes(age,GrossIncome,color=as.factor(traingoodadd$label)))+geom_point()
ggplot(traingoodadd,aes(age,GrossIncome,color=as.factor(traingoodadd$label)))+geom_point(position="jitter")
ggplot(traingoodadd,aes(NumberOfDependants,MixedScore,color=as.factor(traingoodadd$label)))+geom_point(position="jitter")
ggplot(traingoodadd,aes(NumberOfDependants,EmployerIndustry,color=as.factor(traingoodadd$label)))+geom_point(position="jitter")

ggplot(traingoodadd,aes(NumberOfDependants,MixedScore,color=as.factor(traingoodadd$label)))+geom_point(position="jitter")
ggplot(traingoodadd,aes(age,GrossIncome,color=as.factor(traingoodadd$label)))+geom_point(position="jitter")
table(train5000$scoreband[which(train5000$rejected==1&train5000$votes>2)])

qplot(ApplicationDate,score,data=train5000[which(train5000$rejected==1),],geom="boxplot",group=ApplicationDate)

