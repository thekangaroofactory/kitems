
.onAttach <- function(libname, pkgname){

  if(Sys.getenv("R_KITEMS_PATH") == "")
    packageStartupMessage("Set R_KITEMS_PATH environment variable to where the _kitems.yml file is.")

}
