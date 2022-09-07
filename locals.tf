locals {
  resource_suffixes = {
    hub   = "${var.project}-${var.environment}-${var.location.code}-hub"
    spoke = "${var.project}-${var.environment}-${var.location.code}-spoke"
  }
  global_resource_suffix = "${var.project}-${var.environment}"
}
