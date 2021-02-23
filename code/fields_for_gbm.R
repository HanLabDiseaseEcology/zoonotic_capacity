rm = dput(df_model$rm_fields)[[1]]
keep = names(DF)
for (a in 1:length(rm)){
  keep = setdiff(keep, rm[a])
}
DF = DF[,keep]

label_col_ind = which(names(DF)==df_model$label)
x_col = seq(1:dim(DF)[2])
x_col = setdiff(x_col, label_col_ind)
id_field_col = which(names(DF)==id_field)
x_col = setdiff(x_col, id_field_col)
vars = colnames(DF)[x_col]
vars = setdiff(vars, id_field)#remove species,this seems redundant

exit_fields(vars, rm)

DF = binary_factor(DF)


