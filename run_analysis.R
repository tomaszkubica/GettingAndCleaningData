###preparation of TEST DATA

##reading data sets into environment
features<-read.table("./features.txt")

subject_test<-read.table("./test/subject_test.txt")
x_test<-read.table("./test/x_test.txt")
y_test<-read.table("./test/y_test.txt")


##reading test inertial signals files
inertial_sig_test_path<-"./test/Inertial Signals"
list_data<-list.files(inertial_sig_test_path,full.names=TRUE) #list files in directory with path
list_names<-list.files(inertial_sig_test_path)               #list name of files in directory 

for(i in 1:length(list_data)) { #for every file create dataframe 
  name<-list_names[i] #read name of the file
  w<-read.table(list_data[i]) # read file into w
  
  #naming all variables in dataframe
  varname<-substr(name,1,nchar(name)-8)  #substring of filename to exclude "_test.txt"
  for (j in 1:128){                #for every variable change name
    names(w)[j]<-paste(varname,"read_",j,sep="")  #assign name to variables in currently processed file, example of name: body_acc_y_read_1
  }
  
  #rename dataset to follow file name
  dfname<-substr(name,1,nchar(name)-4)   #substring of filename to exclude ".txt"
  assign(dfname,w)     #read file and name it with dfname
}



##modify particular data sets

#x_test
#apply features names to set x_test
names(x_test)<-features[,2]


#subject_test
#name subject in subject_test dataframe as subject_ID
names(subject_test)=c("subject_ID")


#y_test
#name activity number in y_test dataframe as activity_ID
names(y_test)=c("activity_ID")
#add activity label to y_test
y_test$activity[y_test$activity_ID==1] <-"WALKING"
y_test$activity[y_test$activity_ID==2] <-"WALKING_UPSTAIRS"
y_test$activity[y_test$activity_ID==3] <-"WALKING_DOWNSTAIRS"
y_test$activity[y_test$activity_ID==4] <-"SITTING"
y_test$activity[y_test$activity_ID==5] <-"STANDING"
y_test$activity[y_test$activity_ID==6] <-"LAYING"

#binding sets

test<-cbind(
  subject_test,
  y_test,
  x_test,
  body_acc_x_test,
  body_acc_y_test,
  body_acc_z_test,
  total_acc_x_test,
  total_acc_y_test,
  total_acc_z_test,
  body_gyro_x_test,
  body_gyro_y_test,
  body_gyro_z_test
)

###preparation of TRAIN DATA

##reading data sets into environment
features<-read.table("./features.txt")

subject_train<-read.table("./train/subject_train.txt")
x_train<-read.table("./train/x_train.txt")
y_train<-read.table("./train/y_train.txt")

##reading train inertial signals files
inertial_sig_train_path<-"./train/Inertial Signals"
list_data<-list.files(inertial_sig_train_path,full.names=TRUE) #list files in directory with path
list_names<-list.files(inertial_sig_train_path)               #list name of files in directory 

for(i in 1:length(list_data)) { #for every file create dataframe 
  name<-list_names[i] #read name of the file
  w<-read.table(list_data[i]) # read file into w
  
  #naming all variables in dataframe
  varname<-substr(name,1,nchar(name)-9)  #substring of filename to exclude "_train.txt"
  for (j in 1:128){                #for every variable change name
    names(w)[j]<-paste(varname,"read_",j,sep="")  #assign name to variables in currently processed file, example of name: body_acc_y_read_1
  }
  
  #rename dataset to follow file name
  dfname<-substr(name,1,nchar(name)-4)   #substring of filename to exclude ".txt"
  assign(dfname,w)     #read file and name it with dfname
}


##modify particular data sets

#x_train
#apply features names to set x_train
names(x_train)<-features[,2]


#subject_train
#name subject in subject_train dataframe as subject_ID
names(subject_train)=c("subject_ID")


#y_train
#name activity number in y_train dataframe as activity_ID
names(y_train)=c("activity_ID")
#add activity label to y_train
y_train$activity[y_train$activity_ID==1] <-"WALKING"
y_train$activity[y_train$activity_ID==2] <-"WALKING_UPSTAIRS"
y_train$activity[y_train$activity_ID==3] <-"WALKING_DOWNSTAIRS"
y_train$activity[y_train$activity_ID==4] <-"SITTING"
y_train$activity[y_train$activity_ID==5] <-"STANDING"
y_train$activity[y_train$activity_ID==6] <-"LAYING"

#binding sets

train<-cbind(
  subject_train,
  y_train,
  x_train,
  body_acc_x_train,
  body_acc_y_train,
  body_acc_z_train,
  total_acc_x_train,
  total_acc_y_train,
  total_acc_z_train,
  body_gyro_x_train,
  body_gyro_y_train,
  body_gyro_z_train
)


###binding both sets:train and test

final<-rbind(test,train)

###left only:subject_id, activity and mean and dev characteristics
a<-names(final) #get all the names of the data frame
q<-grep(pattern = "subject_ID|activity|mean\\(|std\\(",a,ignore.case = TRUE) #find expected variables names
final2<-final[a[q]] #select only expected variables

###calculate average of each variable for each activity and each subject
final3 <- aggregate( activity_ID~ subject_ID+activity, data = final2, FUN= "mean" ) # create data frame to add calculated means, mean of activity_ID will be later omitted

for (i in 4:69) #calculate average of variables one by one and add it to  data frame "final3"
{
  b <- aggregate(final2[,i] ~ subject_ID+activity, data = final2, FUN= "mean") #create summary data frame with average of variable
  final3<-cbind(final3,b[,3]) #add calculated average
  names(final3)[i]<-names(final2)[i] # rename average as in final2
}


###tuning of the names of variables
x<-names(final3) #collect names of variables
x<-gsub(pattern = "\\-", x,replacement = "_") #remove dash
x<-gsub(pattern = "\\(\\)", x,replacement = "")#remove brackets
names(final3)<-x #assign new names to data set

###displaying output
final3
View(final3)

#writing final output for a submission
#write.table(final3,"final3.txt",row.name=FALSE)