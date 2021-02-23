load("input/df_model.Rdata")
output_name = df_model$output_name
rm = c("eta", "max_depth", "n.trees", "eval_train", "eval_test", "boot", "bootstrap_run")
keep = setdiff(names(I),rm)
I = I[,keep]

data_long <- gather(I, key = "var", value = "value", c(2:dim(I)[2]), factor_key=TRUE)

data_long_sum <- data_long %>% group_by(var) %>%
  summarize(mean_importance = mean(value))

print(data_long_sum)

data_long_sum_nonzero = subset(data_long_sum, mean_importance > 0)

data_long_nonzero = subset(data_long, var %in% data_long_sum_nonzero$var)

plot <- ggplot(data = data_long_nonzero, aes(x = reorder(var, -value), y = value))+
  geom_boxplot()+
  theme(panel.background = element_blank(), panel.border = element_rect(fill = NA, color = "black", size = 1), axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.2), panel.grid.major.y = element_line(color = "grey80"), panel.grid.major.x = element_line(color = "transparent"))+
  xlab("variable")+
  ylab("importance")

plot
ggsave(filename = paste0("figure/importance", output_name, ".jpg"), plot = plot, height = 8, width = 8)

write.csv(data_long_sum, file = paste0("output/importance", output_name, ".csv"), row.names = FALSE)