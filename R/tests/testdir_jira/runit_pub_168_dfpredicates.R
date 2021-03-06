#
# test filtering via factors
#


setwd(normalizePath(dirname(R.utils::commandArgs(asValues=TRUE)$"f")))
source('../findNSourceUtils.R')



factorfilter <- function(conn){
  Log.info('uploading ddply testing dataset')
  df.h <- h2o.importFile(conn, normalizePath(locate('smalldata/jira/pub-180.csv')))

  Log.info('printing from h2o')
  Log.info( head(df.h) )

  Log.info('subsetting via factor')
  df.h.1 <- df.h[ df.h$colgroup == 'a', ]
  expect_that( dim(df.h.1), equals(c(3,4) ))


  df.h.2 <- df.h[ df.h[,2] == "group2", ]
  expect_that( dim(df.h.2), equals(c(2, 4) ))

  df.h.3 <- df.h[ df.h[,2] == 'group1' & df.h$colgroup == 'c', ]
  expect_that( dim(df.h.3), equals( c(1,4) ))

  Log.info('localizing')
  df.1 <- as.data.frame(df.h.1)
  df.2 <- as.data.frame(df.h.2)
  df.3 <- as.data.frame(df.h.3)


  Log.info('testing')
  expect_that( dim(df.1), equals(c(3, 4) ))
  checkTrue( unique( df.1[,1] ) == 'a' && unique(df.1[,2]) == 'group1')
  checkTrue(all( df.1[,3] == c(1,2,1) ))
  checkTrue(all( df.1[,4] == c(2,3,2) ))


  expect_that( dim(df.2), equals(c(2, 4) ))

  expect_that( unique( df.2[,1] ), equals(factor('c')))
  expect_that(unique(df.2[,2]), equals(factor('group2')))
  checkTrue(all( df.2[,3] == c(5,5) ))
  checkTrue(all( df.2[,4] == c(6,6) ))
  expect_that( dim(df.3), equals( c(1, 4) ))

  expect_that( df.3[1,1], equals( factor('c')))
  expect_that(df.3[1,2],  equals(factor('group1' )))
  expect_that( df.3[1,3], equals(5 ))
  expect_that( df.3[1,4], equals(6 ))

  testEnd()
}

if(F){
  # R code that does the same as above
  data <- read.csv(locate('smalldata/jira/pub-180.csv'), header=T)

  data[ data$colgroup == 'a', ]
  data[ data[,2] == 'group2', ]
  data[ data[,2] == 'group1' & data$colgroup == 'c', ]
}


doTest('factor filtering', factorfilter)
