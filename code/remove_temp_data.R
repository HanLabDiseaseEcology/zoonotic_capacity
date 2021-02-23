##remove objects that are temporary and need to be remade
list_files = list.files("output/")

output_remove_list = "hyper_grid.Rdata"

ind = which(list_files == output_remove_list)
if (length(ind)>0){
  file.remove(paste0("output/", output_remove_list))
}
a = 2
list_files = list.files("input/")

input_remove_list =c("output_name.Rdata", "df_model.Rdata", "DF_predict.Rdata", "DF_tmp.Rdata") 
for (a in 1:length(input_remove_list)){
  
  ind = which(list_files == input_remove_list[a])
  if (length(ind)>0){
    file.remove(paste0("input/", input_remove_list[a]))
  }

}

list_files = list.files()

inds = which(str_detect(list_files, "observedhist"))
if (length(inds)>0){
  for (a in 1:length(inds)){
    file.remove(list_files[inds[a]])
  }
}


list_files = list.files()

inds = which(str_detect(list_files, "nullhist"))
if (length(inds)>0){
  for (a in 1:length(inds)){
    file.remove(list_files[inds[a]])
  }
}

