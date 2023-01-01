


my_txt_ex2 <- readLines("occurence.csv")

row_total = length(my_txt_ex2)
poland_data = c()

i = 0
for (line in my_txt_ex2) {
 
  
  data =  unlist(strsplit(line,split=","))
  #reading header data
  if (i == 0){
    poland_data <- append(poland_data, line)
  }
  
  else if ( data[23] == "PL"){
    poland_data <- append(poland_data, line)
  }
  i = i + 1
  if ( i %% 100000 == 0)
    print(paste0(i , " / " , row_total ))
  
}


file_conn = file("occurence_poland.csv")
writeLines(poland_data, file_conn)
close(file_conn)
