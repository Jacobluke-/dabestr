#' Create an Estimation Plot
#'
#' An estimation plot has two key features. \enumerate{ \item{It presents all
#' datapoints as a
#' \href{https://github.com/eclarke/ggbeeswarm#introduction}{swarmplot} or
#' \href{https://CRAN.R-project.org/package=sinaplot}{sinaplot}, which orders
#' each point to display the underlying distribution.} \item{It presents the
#' effect size as a bootstrap 95 percent confidence interval on a separate but
#' aligned axes.} } Estimation plots emerge from estimation statistics, an
#' intuitive framework that avoids the pitfalls of significance testing. It uses
#' familiar statistical concepts: means, mean differences, and error bars. More
#' importantly, it focuses on the effect size of one's experiment/intervention,
#' as opposed to a false dichotomy engendered by \emph{P} values. This function
#' takes the output of the \link[=mean_diff]{effect size} functions and produces
#' an estimation plot.
#'
#'
#' @param x A \code{dabest_effsize} object, generated by one of the
#'   \link[=mean_diff]{effect size} functions currently available in
#'   \code{dabestr}.
#'
#' @param ... Signature for S3 generic function.
#'
#' @param color.column default \code{NULL}. This is a column in the data.frame
#'   passed to the \code{dabest} function. This column will be treated as a
#'   \link{factor} and used to color the datapoints in the rawdata swarmplot.
#'
#' @param palette default "Set1". Accepts any one of the RColorBrewer palettes,
#'   or a vector of colors. Colors can be specified as RGB hexcode or as a named
#'   color. See the "Palettes" section in \link{scale_color_brewer} for more on
#'   palettes. To obtain all 657 named colors in R, enter \code{colors()} at the
#'   console.
#'
#' @param float.contrast default \code{TRUE}.  If \code{idx} in the
#'   \code{dabest} object contains only 2 groups, \code{float.contrast = TRUE}
#'   will plot the effect size and the bootstrap confidence interval in a
#'   horizontally-aligned axes (also known as a
#'   \href{https://bit.ly/2NhqUAb}{Gardner-Altman plot}).
#'
#' @param slopegraph boolean, default \code{TRUE}. If the \code{dabest} object
#'   contains paired comparisons, \code{slopegraph = TRUE} will plot the rawdata
#'   as a \href{http://charliepark.org/slopegraphs/}{Tufte slopegraph}.
#'
#' @param group.summaries "mean_sd", "median_quartiles", or \code{NULL}. Plots
#'   the summary statistics for each group. If 'mean_sd', then the mean and
#'   standard deviation of each group is plotted as a gapped line beside each
#'   group. If 'median_quartiles', then the median and 25th & 75th percentiles
#'   of each group is plotted for each group as a gapped line. If
#'   \code{group.summaries = NULL}, the summaries are not shown.
#'
#' @param rawplot.type default "beeswarm". Accepts either "beeswarm" or
#'   "sinaplot". See \link{geom_quasirandom} and \link{geom_sina} for more
#'   information.
#'
#' @param rawplot.ylim default \code{NULL}. Enter a custom y-limit for the
#'   rawdata plot. Accepts a vector of length 2 (e.g. c(-50, 50)) that will be
#'   passed along to \link{coord_cartesian}.
#'
#' @param rawplot.ylabel default \code{NULL}. Accepts a string that is used to
#'   label the rawdata y-axis. If \code{NULL}, the column name passed to
#'   \code{y} is used.
#'
#' @param rawplot.markersize default 2. This is the size (in points) of the dots
#'   used to plot the individual datapoints. There are 72 points in one inch.
#'   See \href{https://en.wikipedia.org/wiki/Point_(typography)}{this article}
#'   for more info.
#'
#' @param rawplot.groupwidth default 0.3. This is the maximum amount of spread
#'   (in the x-direction) allowed, for each group.
#'
#' @param effsize.ylim default \code{NULL}. Enter a custom y-limit for the
#'   effect size plot. This parameter is ignored if \code{float.contrast =
#'   TRUE}. Accepts a vector of length 2 (e.g. \code{c(-50, 50)}) that will be
#'   passed along to \link{coord_cartesian}.
#'
#' @param effsize.ylabel default \code{NULL}. Accepts a string that is used to
#'   label the effect size y-axis. If \code{NULL}, this axes will be labeled
#'   "(un)paired <effect size>", where \emph{effect size} is the
#'   \link[=mean_diff]{effect size} function used to generate the
#'   \code{dabest_effsize} object currently being plotted.
#'
#' @param effsize.markersize default 4. This is the size (in points) of the dots
#'   used to indicate the effect size.
#'
#' @param theme default \link{theme_classic}. This is the \code{ggplot2} theme
#'   that is used to style various elements of the estimation plot.
#'
#' @param tick.fontsize default 11. This controls the font size (in points) of
#'   all tick labels.
#'
#' @param axes.title.fontsize default 14. This determines the font size (in
#'   points) of the axes titles.
#'
#' @param show.legend boolean, default \code{TRUE}. If \code{FALSE}, the color
#'   legend will not be displayed, even if \code{color.column} is supplied.
#'
#' @param swarmplot.params default \code{NULL}. Supply list of \code{keyword =
#'   value} pairs to \link{geom_quasirandom}.
#'
#' @param sinaplot.params default \code{NULL}. Supply list of \code{keyword =
#'   value} pairs to \code{\link[ggforce:geom_sina]{ggforce::geom_sina()}}.
#'
#' @param slopegraph.params default \code{NULL}. Supply list of \code{keyword =
#'   value} pairs to \code{ggplot2}'s
#'   \code{\link[ggplot2:geom_path]{geom_line()}}.
#'   This controls the appearance of the lines plotted for a paired slopegraph.
#'
#'
#'
#' @return A \code{\link[ggplot2]{ggproto}} object. This object is actually
#'   composed of two \code{ggplot2} objects (one for the rawdata swarmplot or
#'   slopegraph, another for the effect sizes and bootstrapped confidence
#'   intervals). These are arranged in the desired configuration (whether as a
#'   Gardner-Altman plot or a Cumming plot) by the
#'   \code{\link[cowplot]{plot_grid}()} function in the \code{cowplot} package.
#'
#'
#' @examples
#' # Performing unpaired (two independent groups) analysis.
#' # We want to obtain the mean difference between the petal widths
#' # of setosa and versicolor species.
#' unpaired_mean_diff <- dabest(iris, Species, Petal.Width,
#'                              idx = c("setosa", "versicolor"),
#'                              paired = FALSE) %>%
#'                        mean_diff()
#'
#' # Create a Gardner-Altman estimation plot.
#' plot(unpaired_mean_diff)
#'
#'
#' \dontrun{
#' # Comparing versicolor and virginica petal widths to setosa petal width.
#' shared_control_data <- dabeıst(iris, Species, Petal.Width,
#'                               idx = c("setosa", "versicolor", "virginica")) %>%
#'                        mean_diff()
#'
#' # Create a Cumming estimation plot.
#' plot(shared_control_data)
#' }
#'
#' @seealso \itemize{
#'
#'   \item \link[=dabest]{Loading data} for effect size computation.
#'
#'   \item \link[=mean_diff]{Effect size computation} from the loaded data.
#'
#'   }
#'
#'   Run \code{vignette("Using dabestr", package = "dabestr")} in the console to
#'   read more about using parameters to control the plot features.
#'
#'
#'
#' @section References: \href{https://rdcu.be/bHhJ4}{Moving beyond P values:
#'   Data analysis with estimation graphics.} Nature Methods 2019, 1548-7105.
#'   Joses Ho, Tayfun Tumkaya, Sameer Aryal, Hyungwon Choi, Adam Claridge-Chang
#' @importFrom magrittr %>% %<>%
#' @importFrom ggplot2 aes
#' @importFrom rlang as_name enquo quo_is_null
#' @importFrom stats median na.omit sd setNames var
#' @importFrom stringr str_interp
#' @importFrom utils head
#' @export
plot.dabest_effsize <- function(x, ...,
                                color.column        = NULL,
                                palette             = "Set1",
                                float.contrast      = TRUE,
                                slopegraph          = TRUE,
                                group.summaries     = "mean_sd",

                                rawplot.type        = c("swarmplot", "sinaplot"),
                                rawplot.ylim        = NULL,
                                rawplot.ylabel      = NULL,
                                rawplot.markersize  = 2,
                                rawplot.groupwidth  = 0.3,

                                effsize.ylim        = NULL,
                                effsize.ylabel      = NULL,
                                effsize.markersize  = 4,

                                theme               = ggplot2::theme_classic(),
                                tick.fontsize       = 11,
                                axes.title.fontsize = 14,
                                show.legend         = TRUE,

                                swarmplot.params    = NULL,
                                sinaplot.params     = NULL,
                                slopegraph.params   = NULL ){


  #### Check dots are empty ####
  # Added in v0.2.2.
  ellipsis::check_dots_empty()

  #### Check object class ####
  if (class(x)[1] != "dabest_effsize") {
    stop(paste(
      "The object you are plotting is not a `dabest_effsize` class object. ",
      "Please check again! ")
    )
  } else {
    dabest_effsize.object <- x
  }

  #### Extract variables ####

  # Create handles for easy access to the items in `dabest_effsize.object`.
  raw.data           <-  dabest_effsize.object$data
  boot.result        <-  dabest_effsize.object$result
  idx                <-  dabest_effsize.object$idx
  id.col             <-  dabest_effsize.object$id.column
  effect.size        <-  dabest_effsize.object$effect.size
  is.paired          <-  dabest_effsize.object$is.paired
  summary            <-  dabest_effsize.object$summary

  plot.groups.sizes  <-  unlist(lapply(idx, length))
  all.groups         <-  unlist(idx)

  # The variables below should are quosures!
  x_enquo            <-  dabest_effsize.object$x
  y_enquo            <-  dabest_effsize.object$y
  x_quoname          <-  as_name(x_enquo)
  y_quoname          <-  as_name(y_enquo)

  #### Decide if floating or slopegraph. ####
  # float.contrast and slopegraph
  if (isFALSE(is.paired)) slopegraph <- FALSE

  if (effect.size == "cliffs_delta") float.contrast <- FALSE

  if (max(plot.groups.sizes) > 2) {
    float.contrast <- FALSE
    slopegraph     <- FALSE
  }

  if (length(all.groups) > 2) {
    float.contrast <- FALSE
  }



  #### Select data for plotting. ####
  if (length(all.groups)     == 2 &&
      plot.groups.sizes[[1]] == 2) {
    # Not multiplot. Add it to an empty list.
    for.plot <- raw.data

  } else {
    # Reorder the plot data according to idx.
    for.plot <- list()
    for (subplot_groups in idx) {
      subplot  <- dplyr::filter(raw.data, !!x_enquo %in% subplot_groups)
      for.plot[[length(for.plot) + 1]] <- subplot
    }

    for.plot <- dplyr::bind_rows(for.plot)
  }

  # # The next three lines prevent plots with repeated groups
  # # from being produced.
  for.plot[[x_quoname]] <-
    for.plot[[x_quoname]] %>%
    factor(all.groups, ordered = TRUE)


  #### Compute the Ns. ####
  Ns <-
    for.plot %>%
    dplyr::group_by(!!x_enquo) %>%
    dplyr::count()

  Ns$swarmticklabs <-
    do.call(paste, c(Ns[c(x_quoname, "n")],
                     sep = "\nN = "))


  #### Compute stats for Tufte lines. ####
  for.tufte.lines <-
    for.plot %>%
    dplyr::group_by(!!x_enquo) %>%
    dplyr::summarize(mean           = mean(!!y_enquo),
                     median         = median(!!y_enquo),
                     sd             = sd(!!y_enquo),
                     low.quartile   = stats::quantile(!!y_enquo)[2],
                     upper.quartile = stats::quantile(!!y_enquo)[4]) %>%
    dplyr::mutate(low.sd = mean - sd, upper.sd = mean + sd)


  #### Parse keywords. ####
  # color.column
  color.col_enquo    <-  enquo(color.column)
  swarm.dodge        <-  0

  if (quo_is_null(color.col_enquo)) {
    color.col_quoname  <- x_quoname
    groups.for.palette <- all.groups

    color.aes          <- aes(col = !!x_enquo)

  } else {
    color.col_quoname  <- as_name(color.col_enquo)
    groups.for.palette <- unique(for.plot[[color.col_quoname]])
    for.plot[[color.col_quoname]] %<>% as.factor # turn the color column into a factor.

    color.aes          <- aes(col = !!color.col_enquo)
  }


  # rawplot.type
  # If rawplot is not specified, defaults to 'swarmplot'.
  if (length(rawplot.type) > 1) {
    rawplot.type <- rawplot.type[1]
  }


  #### swarmplot/sinaplot params. ####
  if (isFALSE(slopegraph)) {

    if (rawplot.type == 'swarmplot') {
      if (is.null(swarmplot.params)) {
        swarmplot.params <- list(size        = rawplot.markersize,
                                 width       = rawplot.groupwidth,
                                 dodge.width = swarm.dodge,
                                 mapping     = color.aes,
                                 alpha       = 0.95)
      } else if (class(swarmplot.params) != "list") {
        stop("`swarmplot.params` is not a list.")
      } else swarmplot.params[['mapping']] = color.aes

    } else if (rawplot.type == 'sinaplot') {
      swarm.width = 0.3
      if (is.null(sinaplot.params)) {
        sinaplot.params <- list(size = rawplot.markersize,
                                maxwidth = swarm.width,
                                mapping = color.aes)
      } else if (class(sinaplot.params) != "list") {
        stop("`sinaplot.params` is not a list.")
      } else sinaplot.params[['mapping']] = color.aes

    } else stop(paste(rawplot.type, "is not a recognized plot type. ",
                      "Accepted plot types: 'swarmplot' and 'sinaplot'."))
  } else {
    rawplot.type <- "slopegraph"
    if (is.null(slopegraph.params)) {
      # Default slopegraph params.
      slopegraph.params <- list(size = 0.5, alpha = 0.75)

    } else if (class(slopegraph.params) != "list") {
      stop("`swarmplot.params` is not a list.")
      }
  }

  # y-axes labels.
  if (is.null(rawplot.ylabel)) {
    rawplot.ylabel <- str_interp("${y_quoname}\n")
  } else {
    rawplot.ylabel <- str_interp("${rawplot.ylabel}\n")
  }

  # For labelling the y-axis.
  effect.size.ylabeller <- list("mean difference", "median difference",
                                "Cohen's d", "Hedges' g", "Cliff's delta")
  names(effect.size.ylabeller) <- c("mean_diff", "median_diff",
                                    "cohens_d", "hedges_g", "cliffs_delta")

  if (is.null(effsize.ylabel)) {
    if (isTRUE(is.paired)) {
      effsize.ylabel <-
        str_interp("Paired\n${effect.size.ylabeller[[effect.size]]}")
    } else {
      effsize.ylabel <-
        str_interp("Unpaired\n${effect.size.ylabeller[[effect.size]]}")
    }
  } else {
    effsize.ylabel <- str_interp("${effsize.ylabel}\n")
  }




  #### Create themes. ####
  horizontal.line.width = 0.2

  non.floating.theme <-
    theme +
    ggplot2::theme(
      axis.text            =  ggplot2::element_text(size = tick.fontsize),
      axis.title           =  ggplot2::element_text(size = axes.title.fontsize),
      axis.ticks.length    =  ggplot2::unit(7, "points"),
      axis.ticks.x.bottom  =  ggplot2::element_blank(),
      axis.title.x.bottom  =  ggplot2::element_blank()
    )

  floating.theme <-
    non.floating.theme +
    ggplot2::theme(
      axis.title.x.bottom  =  ggplot2::element_blank(),
      axis.ticks.x.bottom  =  ggplot2::element_blank()
    )

  legend.theme <-
    ggplot2::theme(
      legend.title         =  ggplot2::element_text(size = axes.title.fontsize),
      legend.text          =  ggplot2::element_text(size = tick.fontsize))


  non.floating.theme <-  non.floating.theme + legend.theme
  floating.theme     <-  floating.theme + legend.theme


  remove.axes <-
    ggplot2::theme(
      axis.line.x          = ggplot2::element_blank(),
      axis.title.x         = ggplot2::element_blank(),
      axis.ticks.x.bottom  = ggplot2::element_blank()
    )



  #### Set rawdata plot ylims. ####
  if (is.null(rawplot.ylim)) {
    rawplot.ylim <- range(for.plot[[y_quoname]])
  }

  # Equalize the xlims across both plots.
  if (isTRUE(float.contrast)) {
    rawdata.coord_cartesian <-
      ggplot2::coord_cartesian(ylim = rawplot.ylim)

  } else {
    both.xlim <- c(1, length(all.groups) + 0.3)
    rawdata.coord_cartesian <-
      ggplot2::coord_cartesian(xlim = both.xlim, ylim = rawplot.ylim)
  }


  #### Create color palette. ####
  # Added in v0.2.5
  group.count <- length(groups.for.palette)

  #### Check if palette is supported by ggplot2. ####
  if (length(palette) == 1) {
    # Assume it is an intended ggplot2 palette.

    #### Check if in desired ggplot2 palette.
    if (palette %in% rownames(RColorBrewer::brewer.pal.info)) {
      palette.max.colors <- RColorBrewer::brewer.pal.info[palette, "maxcolors"]

      if (group.count <= palette.max.colors) {
        if (group.count < 3) {
          pal <- RColorBrewer::brewer.pal(3, palette)
        } else{
          pal <- RColorBrewer::brewer.pal(group.count, palette)
        }

        custom.pal <- setNames(pal[1:group.count], groups.for.palette)

      } else {
        #### Create palette with correct number of groups. ####
        cat(paste(str_interp("${palette} has colors (${palette.max.colors}) "),
                  str_interp("but ${color.col_quoname} has ${group.count} unique groups. "),
                  "The palette has thus been extended automatically."
                  )
            )


        color.ramp.func <- grDevices::colorRampPalette(RColorBrewer::brewer.pal(group.count, palette))

        custom.pal <- setNames(color.ramp.func(group.count), groups.for.palette)
      }

    } else {
      stop(paste(str_interp("'${palette}' is not a valid ggplot2 palette.\n"),
                 "Please see https://ggplot2.tidyverse.org/reference/scale_brewer.html#palettes\n",
                 "for all acceptable palettes."
                )
          )
    }

  } else {
    # Assume this is a vector of colors.
    if (length(palette) >= group.count) {
      custom.pal <- setNames(palette, groups.for.palette)
    } else {
      stop(paste(str_interp("${length(palette)} colors were supplied,\n"),
                 str_interp("but ${group.count} colors are needed.")
      )
      )
    }
  }


  #### Plot raw data. ####
  # slopegraph.
  if (rawplot.type == "slopegraph") {

    rawdata.plot <-
      ggplot2::ggplot() +
      rawdata.coord_cartesian +
      ggplot2::scale_colour_manual(values = custom.pal) +
      ggplot2::ylab(rawplot.ylabel) +
      ggplot2::scale_x_discrete(labels = Ns$swarmticklabs,
                                limits = all.groups)

    for (subplot_groups in idx) {
      # Assign subplot.
      subplot <- dplyr::filter(raw.data, !!x_enquo %in% subplot_groups)

      subplot[[x_quoname]] <-
        subplot[[x_quoname]] %>%
        factor(subplot_groups, ordered = TRUE)

      slopegraph.params[["data"]] <- subplot

      # Assign aesthetic mappings.
      if (rlang::quo_is_null(color.col_enquo)) {
        slopegraph.aes <- aes(!!x_enquo, !!y_enquo,
                              group = !!id.col)
      } else {
        slopegraph.aes <- ggplot2::aes(!!x_enquo, !!y_enquo,
                              group = !!id.col,
                              col = !!color.col_enquo)
      }

      slopegraph.params[["mapping"]] <- slopegraph.aes

      # Create slopegraph
      rawdata.plot <-
        rawdata.plot +
        do.call(ggplot2::geom_line, slopegraph.params)

      # if (rlang::quo_is_null(color.col_enquo)) {
      #   rawdata.plot <-
      #     rawdata.plot +
      #     ggplot2::geom_line(data = subplot,
      #                        size = slope.line.width,
      #                        alpha = 0.8,
      #                        ggplot2::aes(!!x_enquo, !!y_enquo,
      #                                     group = !!id.col)
      #     )
      # } else {
      #   rawdata.plot <-
      #     rawdata.plot +
      #     ggplot2::geom_line(data = subplot,
      #                        size = slope.line.width,
      #                        alpha = 0.75,
      #                        ggplot2::aes(!!x_enquo, !!y_enquo,
      #                                     group = !!id.col,
      #                                     colour = !!color.col_enquo)
      #                        # colour = factor(!!color.col_enquo))
      #     )
      # }
    }

  } else { # swarmplot.
    rawdata.plot <-
      ggplot2::ggplot(data = for.plot,
                      aes(!!x_enquo, !!y_enquo)) +
      rawdata.coord_cartesian +
      ggplot2::scale_colour_manual(values = custom.pal) +
      ggplot2::ylab(rawplot.ylabel) +
      ggplot2::scale_x_discrete(breaks = all.groups,
                                labels = Ns$swarmticklabs)

    if (rawplot.type == 'swarmplot') {

      rawdata.plot <-
        rawdata.plot +
        do.call(ggbeeswarm::geom_quasirandom, swarmplot.params)

      if (isTRUE(float.contrast)) {
        rawdata.plot <- rawdata.plot + floating.theme
      } else {
        rawdata.plot <- rawdata.plot + non.floating.theme
      }


    } else if (rawplot.type == 'sinaplot') {
      rawdata.plot   <-
        rawdata.plot +
        do.call(ggforce::geom_sina, sinaplot.params)

      if (isTRUE(float.contrast)) {
        rawdata.plot <- rawdata.plot + floating.theme
      } else {
        rawdata.plot <- rawdata.plot + non.floating.theme
      }
    }

    #### Plot group summaries. ####
    if (isFALSE(float.contrast)) {
      line.nudge <- rawplot.groupwidth * 1.25
      if (line.nudge > 0.8) line.nudge <- 0.8
      pos.nudge = ggplot2::position_nudge(x = line.nudge)

      if (!is.null(group.summaries)) {
        accepted.summaries <- c('mean_sd', 'median_quartiles')

        not.in.g.summs <- !(group.summaries %in% accepted.summaries)

        if (not.in.g.summs) {
          err1 <- str_interp("${group.summaries} is not a recognized option.")
          err2 <- "Accepted `group.summaries` are 'mean_sd' or 'median_quartiles'."
          stop(paste(err1, err2))

        } else if (group.summaries == 'mean_sd') {
          rawdata.plot <-
            rawdata.plot +
            suppressWarnings(
              ggplot2::geom_linerange(
                data     = for.tufte.lines,
                size     = 1,
                position = pos.nudge,
                aes(x = !!x_enquo, y = mean,
                    ymin = low.sd,
                    ymax = upper.sd)) ) +
            ggplot2::geom_point(
              data     = for.tufte.lines,
              size     = 0.75,
              position = pos.nudge,
              colour   = "white",
              aes(x = !!x_enquo, y = mean))

        } else if (group.summaries == 'median_quartiles') {
          rawdata.plot <-
            rawdata.plot +
            suppressWarnings(
              ggplot2::geom_linerange(
                data     = for.tufte.lines,
                size     = 1,
                position = pos.nudge,
                aes(x = !!x_enquo, y = median,
                    ymin = low.quartile,
                    ymax = upper.quartile)) ) +
            ggplot2::geom_point(
              data     = for.tufte.lines,
              size     = 0.75,
              position = pos.nudge,
              colour   = "white",
              aes(x = !!x_enquo, y = median))
        }
      }
    }
  }

  # Plot the summary lines for each group if `float.contrast` is TRUE.
  if (isTRUE(float.contrast)) {
    # We take this shortcut:
    # Given this is a Gardner-Altman plot with only 2 groups,
    # we can assume the second column of `summary` has the
    # summary figures for both groups.
    summary_control <- summary[[2]][1]
    summary_test    <- summary[[2]][2]

    rawdata.plot <- rawdata.plot +
      # Plot the summary lines for the control group.
      ggplot2::geom_segment(
        color = "black",
        size  = horizontal.line.width,
        aes(x    = 1,
                     xend = 3,
                     y    = summary_control,
                     yend = summary_control)) +

      # Plot the summary lines for the test group.
      ggplot2::geom_segment(
        color = "black",
        size  = horizontal.line.width,
        aes(x    = 2,
                     xend = 3,
                     y    = summary_test,
                     yend = summary_test))

    # Apply appropriate theme to swarm plot.
    rawdata.plot <- rawdata.plot + floating.theme
  } else {
    rawdata.plot <- rawdata.plot + non.floating.theme
  }



  #### Munge bootstraps. ####
  # Munge bootstraps into tibble for easy plotting with ggplot.
  boots.for.plot <- tibble::as_tibble(data.frame(boot.result$bootstraps))
  colnames(boots.for.plot) <- boot.result$test_group

  if (isFALSE(float.contrast)) {
    # Add the control group as a set of NaNs.
    for (control.column in unique(boot.result$control_group)) {
      oldcols <- colnames(boots.for.plot)
      boots.for.plot <-
        boots.for.plot %>%
        tibble::add_column(placeholder = rep(NaN, nrow(boots.for.plot)))

      colnames(boots.for.plot) <- c(oldcols, control.column)
    }
  }

  boots.for.plot <-
    tidyr::gather(boots.for.plot, !!x_enquo, !!y_enquo)

  # Order the bootstraps so they plot in the correct order.
  boots.for.plot[[x_quoname]] <-
    factor(boots.for.plot[[x_quoname]], all.groups, ordered = TRUE)

  boots.for.plot <-
    dplyr::arrange(boots.for.plot, !!x_enquo)



  #### Set delta plot ylims. ####
  if (is.null(effsize.ylim)) {
    effsize.ylim <- range( na.omit(boots.for.plot[y_quoname]) )
  }



  #### Plot bootstraps. ####
  float.reflines.xstart <- 0.4
  float.reflines.xend   <- 1.6

  if (isTRUE(float.contrast)) {
    es0.trimming        <- 0
    flat.violin.width   <- 1
    flat.violin.adjust  <- 5
    x.start             <- float.reflines.xstart
    x.end               <- float.reflines.xend

  } else {
    es0.trimming        <- 0.5
    flat.violin.width   <- 0.75
    flat.violin.adjust  <- 3
    x.start             <- 0
    x.end               <- length(all.groups) + es0.trimming
  }

  delta.plot <-
    ggplot2::ggplot(boots.for.plot, na.rm = TRUE) +
    geom_flat_violin(
      aes(!!x_enquo, !!y_enquo),
      na.rm  =  TRUE,
      width  =  flat.violin.width,
      adjust =  flat.violin.adjust,
      size   =  0 # width of the line.
    ) +
    # This is the line representing the null effect size.
    ggplot2::geom_segment(
      color  =  "black",
      size   =  horizontal.line.width,
      x      =  x.start,
      xend   =  x.end,
      y      =  0,
      yend   =  0)



  #### Plot effect sizes and CIs. ####

  delta.plot <-
    delta.plot +
    ggplot2::ylab(effsize.ylabel) +
    ggplot2::geom_point(
      data  = boot.result,
      color = "black",
      size  = effsize.markersize,
      aes(test_group, difference)) +
    ggplot2::geom_errorbar(
      data  = boot.result,
      color = "black",
      width = 0,
      size  = 0.75,
      aes(x    = test_group,
                   ymin = bca_ci_low,
                   ymax = bca_ci_high))



  #### Float vs nonfloat delta plots. ####
  if (isTRUE(float.contrast)) {
    # Shift ylims appropriately.
    if (effect.size %in% c("mean_diff", "median_diff")) {
      if (summary_control > 0) {
        new.delta.ylim <- rawplot.ylim - summary_control
      } else {
        new.delta.ylim <- rawplot.ylim + summary_control
      }



    } else if (effect.size %in% c("cohens_d", "hedges_g")) {
      # Added in v0.3.0.
      IDX  <- idx[[1]] # Assume there is only 1 idx group.
      ctrl <- raw.data %>% dplyr::filter(!!x_enquo == IDX[1])
      test <- raw.data %>% dplyr::filter(!!x_enquo == IDX[2])

      ctrl.summary <- summary %>% dplyr::filter(!!x_enquo == IDX[1])

      ctrl <- ctrl[[y_quoname]]
      c    <- na.omit(ctrl)

      test <- test[[y_quoname]]
      t    <- na.omit(test)

      stds <- cohen_d_standardizers(c, t)

      # check if paired, select correct standardizer
      if (isTRUE(is.paired)) {
        std <- stds$pooled
      } else {
        std <- stds$average
      }

      if (effect.size == "hedges_g") {
        # if hedges' g, divide standardizer by hedges' correction to get scale factor.
        hg.corr.factor    <- hedges_correction(ctrl, test)
        ylim.scale.factor <- std / hg.corr.factor
      } else {
        # if cohens' d, standardizer is the scale factor.
        ylim.scale.factor <- std
      }

      # divide rawplot.ylim by the scale factor.
      new.delta.ylim <- (rawplot.ylim - ctrl.summary[[2]])  / ylim.scale.factor
    }


    delta.plot <-
      delta.plot +
      ggplot2::coord_cartesian(ylim = new.delta.ylim) +
      ggplot2::scale_y_continuous(position = "right") +
      # This is the delta-side effect size line,
      # that aligns with the central measure of the test group.
      ggplot2::geom_segment(color = "black",
                            size  = horizontal.line.width,
                            x     = float.reflines.xstart,
                            xend  = float.reflines.xend,
                            y     = boot.result$difference[1],
                            yend  = boot.result$difference[1]) +
      ggplot2::scale_x_discrete(labels =
                                  c(str_interp("${all.groups[2]}\nminus ${all.groups[1]}")) ) +
      floating.theme


  } else {
    # Plot nonfloating deltas.
    # Properly concatenate the delta.plot labels.
    delta.tick.labs  <- vector("list", length(idx))
    i <- 1

    for (subplot_groups in idx) {
      control_group <- subplot_groups[1]
      test_groups   <- subplot_groups[2: length(subplot_groups)]

      labels <- c(" ",
                  paste(test_groups, str_interp("minus\n${control_group}"),
                        sep = "\n"))

      delta.tick.labs[[i]] = labels
      i <- i + 1
    }

    # Equalize the xlims across both plots, and set ylims for deltaplot.
    delta.plot <- delta.plot +
      ggplot2::coord_cartesian(xlim = both.xlim,
                               ylim = effsize.ylim) +
      ggplot2::scale_x_discrete(breaks = all.groups,
                                labels = delta.tick.labs) +
      non.floating.theme
  }



  #### Trim rawdata axes. ####
  rawdata.plot <-  rawdata.plot + remove.axes

  # Get the ylims.
  rawdata.plot.build       <- ggplot2::ggplot_build(rawdata.plot)
  rawdata.plot.build.panel <- rawdata.plot.build$layout$panel_params[[1]]
  rawdata.plot.ylim        <- rawdata.plot.build.panel$y.range

  segment.ypos             <- rawdata.plot.ylim[1]

  rawdata.plot.xlim        <- rawdata.plot.build.panel$x.range
  rawdata.plot.lower.xlim  <- rawdata.plot.xlim[1]


  # Set padding to add.
  start.idx          <- 1
  padding            <- 0.25

  # Re-draw the trimmed axes.
  for (size in plot.groups.sizes) {
    end.idx      <- start.idx + size - 1

    if (isTRUE(float.contrast)) {
      xstart   <- rawdata.plot.lower.xlim
    } else {
      xstart   <- start.idx - padding
    }

    if (isTRUE(slopegraph)) {

      rawdata.plot <- rawdata.plot +
        ggplot2::geom_segment(
          color = 'black',
          # size = segment.thickness,
          ggplot2::aes_(x    = xstart,
                        xend = end.idx + padding,
                        y    = segment.ypos,
                        yend = segment.ypos))

    } else {

      if (isTRUE(float.contrast)) {
        xend   <- end.idx + padding * 1.5
      } else {
        xend   <- end.idx + padding
      }

      rawdata.plot <- rawdata.plot +
        ggplot2::geom_segment(
          color = 'black',
          x    = xstart,
          xend = xend,
          y    = segment.ypos,
          yend = segment.ypos)

    }

    start.idx  <- start.idx + size
  }




  #### Trim deltaplot axes. ####
  delta.plot  <-  delta.plot + remove.axes

  # Get the ylims.
  delta.plot.build         <- ggplot2::ggplot_build(delta.plot)
  delta.plot.build.panel   <- delta.plot.build$layout$panel_params[[1]]
  delta.plot.ylim          <- delta.plot.build.panel$y.range
  segment.ypos             <- delta.plot.ylim[1]
  delta.plot.upper.ylim    <- delta.plot.ylim[2]

  delta.plot.xlim          <- delta.plot.build.panel$x.range
  delta.plot.lower.xlim    <- delta.plot.xlim[1]
  delta.plot.upper.xlim    <- delta.plot.xlim[2]

  # Set padding to add.
  start.idx      <- 1

  # Re-draw the trimmed axes.
  for (size in plot.groups.sizes) {
    end.idx      <- start.idx + size - 1

    if (isTRUE(float.contrast)) {
      xstart     <- delta.plot.lower.xlim
      xend       <- delta.plot.upper.xlim

    } else {
      xstart     <- start.idx - padding
      xend       <- end.idx   + padding
    }

    delta.plot <-
      delta.plot +
      ggplot2::geom_segment(x    = xstart,
                            xend = xend,
                            y    = segment.ypos,
                            yend = segment.ypos
      )

    start.idx  <- start.idx + size
  }



  #### Handle color legend. ####
  if (!quo_is_null(color.col_enquo)) {
    legend <- cowplot::get_legend(rawdata.plot)
  }
  # Remove the legend from the rawplot.
  rawdata.plot <- rawdata.plot + ggplot2::guides(color = "none")



  #### Equalize tick label lengths. ####
  if (isFALSE(float.contrast)) {
    rawplot.yticks.labels    <- get_tick_labels(rawdata.plot, axes="y")
    rawplot.yticks.breaks    <- as.numeric(rawplot.yticks.labels)
    max_rawplot_ticklength   <- max_nchar_ticks(rawplot.yticks.labels)

    deltaplot.yticks.labels  <- get_tick_labels(delta.plot, axes="y")
    deltaplot.yticks.breaks  <- as.numeric(deltaplot.yticks.labels)
    max_deltaplot_ticklength <- max_nchar_ticks(deltaplot.yticks.labels)


    if (max_rawplot_ticklength < max_deltaplot_ticklength) {
      space.diff <- max_deltaplot_ticklength - max_rawplot_ticklength

      suffix.spacing        <- rep(" ", space.diff)

      rawplot.yticks.labels <- paste(str_interp(suffix.spacing),
                                     rawplot.yticks.labels)
      rawdata.plot <-
        rawdata.plot +
        ggplot2::scale_y_continuous(breaks = rawplot.yticks.breaks,
                                    labels = rawplot.yticks.labels)


    } else if (max_rawplot_ticklength > max_deltaplot_ticklength) {
      space.diff = max_rawplot_ticklength - max_deltaplot_ticklength

      suffix.spacing          <- rep(" ", space.diff)

      deltaplot.yticks.labels <- paste(str_interp(suffix.spacing),
                                       deltaplot.yticks.labels)

      delta.plot <- delta.plot +
        ggplot2::scale_y_continuous(breaks = deltaplot.yticks.breaks,
                                    labels = deltaplot.yticks.labels)
    }

  }




  #### Determine layout. ####
  if (isTRUE(float.contrast)) {
    # Side-by-side floating plot layout.
    # plot.margin declares the top, right, bottom, left margins in order.
    rawdata.plot <-
      rawdata.plot +
      ggplot2::theme(
        plot.margin = ggplot2::unit(c(5.5, 0, 5.5, 5.5), "pt")
      )

    delta.plot   <-
      delta.plot +
      ggplot2::theme(
        plot.margin        = ggplot2::unit(c(5.5, 5.5, 5.5, 0), "pt"),
        axis.line.x.bottom = ggplot2::element_blank()
      )

    aligned_spine = 'b'
    nrows <- 1

    if (quo_is_null(color.col_enquo) | isFALSE(show.legend)) {
      plist <- list(rawdata.plot, delta.plot)
      ncols <- 2
      widths <- c(0.7, 0.3)
    } else {
      plist <- list(rawdata.plot, delta.plot, legend)
      ncols <- 3
      widths <- c(0.7, 0.3, 0.2)
    }

  } else {
    # Above-below non-floating plot layout.
    aligned_spine = 'lr'
    nrows <- 2

    # Added in v0.3.0: option to not display the color legend.
    if (quo_is_null(color.col_enquo) | isFALSE(show.legend)) {
      plist <- list(rawdata.plot, delta.plot)
      ncols <- 1
      widths <- c(1)
    } else {
      plist <- list(rawdata.plot, legend, delta.plot)
      ncols <- 2
      widths <- c(0.85, 0.15)
    }
  }


  result <- cowplot::plot_grid(
    plotlist   = plist,
    nrow       = nrows,
    ncol       = ncols,
    rel_widths = widths,
    axis       = aligned_spine)
  return(result)

}
