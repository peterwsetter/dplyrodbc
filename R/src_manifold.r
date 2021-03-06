#' Title
#'
#' @param mapfile 
#'
#' @export
#'
odbcConnectManifold <- function (mapfile)

{

  full.path <- function(filename) {

    fn <- chartr("\\", "/", filename)

    is.abs <- length(grep("^[A-Za-z]:|/", fn)) > 0

    chartr("/", "\\", if (!is.abs)

      file.path(getwd(), filename)

      else filename)

  }

  con <- if (missing(mapfile))

    "Driver={Manifold Project Driver (*.map)};Dbq="

  else {

    fp <- full.path(mapfile)

    paste("Driver={Manifold Project Driver (*.map)};DBQ=",

          fp, ";DefaultDir=", dirname(fp), ";Unicode=False;Ansi=False;OpenGIS=False;DSN=Default", ";", sep = "")

  }

  RODBC::odbcDriverConnect(con)

}



#' @export
src_manifold <- function(dbname = NULL, host = NULL, port = NULL, user = NULL,
                         password = NULL, ...) {
  
  con <-    dbConnect(RODBCDBI::ODBC(), dbname, manifold = TRUE)
  
  src_sql("manifold", con)
}


#' @export
src_desc.src_manifold <- function(con) {
  info <- dbGetInfo(con$con)
  host <- if (info$host == "") "localhost" else info$host
  
  paste0("manifold ", info$serverVersion, " [", info$user, "@",
         host, ":", info$port, "/", info$dbname, "]")
}

#' @export
db_list_tables.src_manifold <- function(con) {
  dbListTables(con$con)
}
#' @export
db_has_table.src_manifold <- function(con, table) {
  dbExistsTable(con$con, table)
}
#' @export
tbl.src_manifold <- function(src, from, ...) {
  tbl_sql("manifold", src = src, from = from, ...)
}


#' @export
src_translate_env.src_manifold <- function(x) {
  sql_variant(
    base_scalar,
    sql_translator(.parent = base_agg,
                   n = function() sql("count(*)"))
  )}



