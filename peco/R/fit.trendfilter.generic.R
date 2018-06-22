#' @title fitting trendfilter
#'
#' @param yy log2cpm gene expression vector
#'
#' @export
fit.trendfilter.generic <- function(yy, pos.yy=c(1:length(yy)), polyorder=2) {
  library(genlasso)

  yy.rep <- rep(yy,3)
  #  theta.nonzero.rep <- rep(theta.nonzero,3)
  pos.rep <- rep(pos.yy,3)
  include <- rep(c(FALSE, TRUE, FALSE), each = length(yy))

  # trendfilter
  fit.trend <- trendfilter(yy.rep,
                           ord=polyorder, approx = F, maxsteps = 1000)
  cv.trend <- cv.trendfilter(fit.trend)
  which.lambda <- cv.trend$i.1se
  yy.trend.pred <- predict(fit.trend, lambda=cv.trend$lambda.1se,
                           df=fit.trend$df[which.lambda])$fit
  trend.yy <- yy.trend.pred
  pve <- 1-var(yy-trend.yy)/var(yy)

  # trend.mad.pred <- mad(yy.nonzero.rep[include]-yy.trend.pred[include], constant = 1)
  # trend.mad.constant <- mad(yy.nonzero.rep[include]-mean(yy.nonzero.rep[include]), constant = 1)
  # trend.mad.ratio <- trend.mad.pred/trend.mad.constant

  return(list(trend.yy=trend.yy[which(include)]
              #trend.pos=pos.rep,
#              include=include
              #trend.mad.ratio=trend.mad.ratio,
              #lambda=cv.trend$lambda.1se,
              #trend.pve=pve
              ))
}

# fit.trendfilter.generic <- function(yy, pos.yy=c(1:length(yy)), polyorder=2) {
#   library(genlasso)
#
#   yy.rep <- rep(yy,3)
#   #  theta.nonzero.rep <- rep(theta.nonzero,3)
#   pos.rep <- rep(pos.yy,3)
#   include <- rep(c(FALSE, TRUE, FALSE), each = length(yy))
#
#   # trendfilter
#   fit.trend <- trendfilter(yy.rep,
#                            ord=polyorder, approx = F, maxsteps = 1000)
#   cv.trend <- cv.trendfilter(fit.trend)
#   which.lambda <- cv.trend$i.1se
#   yy.trend.pred <- predict(fit.trend, lambda=cv.trend$lambda.1se,
#                            df=fit.trend$df[which.lambda])$fit
#   trend.yy <- yy.trend.pred[include]
#   pve <- 1-var(yy-trend.yy)/var(yy)
#
#   # trend.mad.pred <- mad(yy.nonzero.rep[include]-yy.trend.pred[include], constant = 1)
#   # trend.mad.constant <- mad(yy.nonzero.rep[include]-mean(yy.nonzero.rep[include]), constant = 1)
#   # trend.mad.ratio <- trend.mad.pred/trend.mad.constant
#
#   return(list(trend.yy=trend.yy,
#               trend.pos=pos.rep[include],
#               #trend.mad.ratio=trend.mad.ratio,
#               lambda=cv.trend$lambda.1se,
#               trend.pve=pve))
# }