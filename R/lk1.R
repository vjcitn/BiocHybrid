#' Check GO.db
#' @import GO.db
#' @export
checkGO = function() {
 db = GO.db::GO.db()
 str(db)
}
