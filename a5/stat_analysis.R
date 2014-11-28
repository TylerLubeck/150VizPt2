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

do_analysis <- function(data, mp, indx) {
    std <- sd(data)
    mn <- mean(data)
    count <- length(data)
    error <- qt(0.95,df=count-1)*std/sqrt(count)
    left <- mn - error
    right <- mn + error
    
    segments(mp[indx], left, mp[indx], right, lwd=2)
    segments(mp[indx] - 0.1, left, mp[indx] + 0.1, left, lwd=2)
    segments(mp[indx] - 0.1, right, mp[indx] + 0.1, right, lwd=2)
    
    # s_test <- shapiro.test(data$Error)
    # print(s_test)
    # if (s_test$p < .05) {
    #     print("Not normally dist")
    #     print("Doing Kruskall-Wallis test")
    #     k_test <- kruskal.test(Error ~ ReportPerc, data=data)
    #     print(k_test)
    # }
}

means <- c()
means <- c(means, mean(diff_colors$Error))
means <- c(means, mean(same_colors$Error))
means <- c(means, mean(marked_with_color$Error))
means <- c(means, mean(white$Error))

ns = c("Different Colors", "Same Colors", "Marked with Color", "White")

mp <- barplot(means, axes=FALSE, axisnames=FALSE, ylim=c(0, 3),
              main="Error Analysis (Figure 1)",
              xlab="Graph Type", ylab="User Error")

do_analysis(diff_colors$Error, mp, 1)
do_analysis(same_colors$Error, mp, 2)
do_analysis(marked_with_color$Error, mp, 3)
do_analysis(white$Error, mp, 4)

axis(1, labels=ns, at=mp)
axis(2, at=seq(0, 3, by=0.5))
box()
