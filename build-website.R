#!/usr/local/bin/Rscript

# script to rebuild website files

# pkgdown works from your tree, not from installed versions.
# But rmarkdown::render works with installed versions.
# So:
# check this includes the new version:

pkgdown:::pkg_timeline("huxtable")

#   (otherwise, it'll be marked as 'unreleased' in the news page)
# checkout the version that you want on the web
# ** Install the package and restart **
# create a branch if there isn't one (git checkout -b website-x.y.z)
# update index.Rhtml appropriately
# run this script;
# commit any changes and push to github;
# checkout master;
# merge in the new branch (git merge website-x.y.z)
# push to github

for (f in list.files("docs", pattern = "*.Rmd", full.names = TRUE)) {
  message("Rendering ", f)
  rmarkdown::render(f, output_format = "html_document")
  rmarkdown::render(f, output_format = "pdf_document")
}

setwd('docs')
knitr::knit("index.Rhtml", "index.html")
setwd('..')

pkgdown::build_reference_index()
pkgdown::build_reference(lazy = FALSE)
pkgdown::build_news()
message("Now commit and push to github. Don't forget to reinstall the dev version!")
