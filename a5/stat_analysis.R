library(XLConnect)
library(ggplot2)

wk <- loadWorkbook('Master.xlsx')
print(wk)
diff_colors = readWorksheet(wk, sheet=1)
same_colors = readWorksheet(wk, sheet=3)
marked_with_color = readWorksheet(wk, sheet=4)
white = readWorksheet(wk, sheet=5)

diff_colors_shapiro = shapiro.test(diff_colors$Error)
same_colors_shapiro = shapiro.test(same_colors$Error)
marked_color_shapiro = shapiro.test(marked_with_color$Error)
white_shapiro = shapiro.test(white$Error)

#Takes in the data, 'data', to add to the graph 'mp' at index 'indx'
add_error_bars <- function(data, mp, indx) {
    std <- sd(data$Error)
    mn <- mean(data$Error)
    count <- length(data$Error)
    error <- qt(0.95,df=count-1)*std/sqrt(count)
    left <- mn - error
    right <- mn + error
    
    segments(mp[indx], left, mp[indx], right, lwd=2)
    segments(mp[indx] - 0.1, left, mp[indx] + 0.1, left, lwd=2)
    segments(mp[indx] - 0.1, right, mp[indx] + 0.1, right, lwd=2)
    
}

do_analysis <- function(data1, data2) {
    num_things = min(length(data1), length(data2))
    print("Not normally dist")
    print("Doing Kruskall-Wallis test")
    k_test <- kruskal.test(data1[1:num_things] ~ data2[1:num_things])
    print(k_test)
    return(k_test$p)
}

means <- c()
means <- c(means, mean(diff_colors$Error))
means <- c(means, mean(same_colors$Error))
means <- c(means, mean(marked_with_color$Error))
means <- c(means, mean(white$Error))

ns = c("Different Colors", "Same Colors", "Marked with Color", "White")
print(ns)
print(means)

print(diff_colors_shapiro)
print(same_colors_shapiro)
print(marked_color_shapiro)
print(white_shapiro)

mp <- barplot(means, axes=FALSE, axisnames=FALSE, ylim=c(0, 3),
              main="Error Analysis (Figure 1)",
              xlab="Graph Type", ylab="User Error")

axis(1, labels=ns, at=mp)
axis(2, at=seq(0, 3, by=0.5))
box()

add_error_bars(diff_colors, mp, 1)
add_error_bars(same_colors, mp, 2)
add_error_bars(marked_with_color, mp, 3)
add_error_bars(white, mp, 4)

#Diff Colors
print("diff_colors by same_colors")
do_analysis(diff_colors$Error, same_colors$Error)

print("diff_colors by marked_with_color")
do_analysis(diff_colors$Error, marked_with_color$Error)

print("diff_colors by white")
do_analysis(diff_colors$Error, white$Error)


#Same Colors
print("same_colors by marked_with_color")
do_analysis(same_colors$Error, marked_with_color$Error)

print("same_colors by white")
do_analysis(same_colors$Error, white$Error)

#Marked Colors
print("marked_with_color by white")
do_analysis(marked_with_color$Error, white$Error)

new_p_value = 0.05 / 3
print("new critical value")

prob = 1 - (1 - 0.05)^3
print(prob)


print(sprintf("There is a %f%% chance of a good result", prob * 100))
print(sprintf("New P-Value to use is %f", new_p_value))

