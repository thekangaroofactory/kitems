

# ------------------------------------------------------------------------------
# Environment
# ------------------------------------------------------------------------------

# -- Define path list
path_list <- list(project = "./",
                  script = "./R",
                  resource = "./resource",
                  data = "./data")


# ------------------------------------------------------------------------------
# Source code
# ------------------------------------------------------------------------------

# -- Source scripts
cat("Source code from:", path_list$script, " \n")
for (nm in list.files(path_list$script, full.names = TRUE, recursive = TRUE, include.dirs = FALSE))
{
  source(nm, encoding = 'UTF-8')
}
rm(nm)

