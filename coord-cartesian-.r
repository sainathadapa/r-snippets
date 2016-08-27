# Selectively use expand parameter for coord_cartesian

library(ggplot2)

coord_cartesian_sp <- function(xlim = NULL, ylim = NULL, expand = TRUE) {
  ggproto(NULL, CoordCartesianSp,
    limits = list(x = xlim, y = ylim),
    expand = expand
  )
}


CoordCartesianSp <- ggproto("CoordCartesian", Coord,
  is_linear = function() TRUE,
  distance = function(x, y, scale_details) {
    max_dist <- dist_euclidean(scale_details$x.range, scale_details$y.range)
    dist_euclidean(x, y) / max_dist
  },
  transform = function(data, scale_details) {
    rescale_x <- function(data) scales:::rescale(data, from = scale_details$x.range)
    rescale_y <- function(data) scales:::rescale(data, from = scale_details$y.range)

    data <- transform_position(data, rescale_x, rescale_y)
    transform_position(data, scales:::squish_infinite, scales:::squish_infinite)
  },
  train = function(self, scale_details) {
    train_cartesian <- function(scale_details, limits, name) {
      if ((length(self$expand) == 4) || self$expand) {
        expand <- ggplot2:::expand_default(scale_details)
      } else {
        expand <- c(0, 0)
      }

      if (is.null(limits)) {
        range <- scale_details$dimension(expand)
      } else {
        range <- range(scale_details$transform(limits))
        range <- expand_range(range, expand[1], expand[2])
      }

      if (length(self$expand) == 4) {
        non_expanded_range <- limits
        if (is.null(limits)) non_expanded_range <- scale_details$dimension(c(0, 0))

        left_expand  <- ifelse(name == 'x', self$expand[1], self$expand[3])
        right_expand <- ifelse(name == 'x', self$expand[2], self$expand[4])

        range <- ifelse(c(left_expand, right_expand), range, non_expanded_range)
      }

      out <- scale_details$break_info(range)
      names(out) <- paste(name, names(out), sep = ".")
      out
    }

    c(
      train_cartesian(scale_details$x, self$limits$x, "x"),
      train_cartesian(scale_details$y, self$limits$y, "y")
    )
  }
)

# p <- ggplot(mtcars, aes(disp, wt)) + geom_point() + geom_smooth()
# p
# p + coord_cartesian_sp(expand = c(T, F, F, T))
