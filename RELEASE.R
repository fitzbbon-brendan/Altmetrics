
# Re-Build the README
devtools::build_readme()


# Update the MB Quarters csv file via piggyback
# - Download the file by hand if necessary, and store
piggyback::pb_release_create(repo = "alex-koiter/mbquartR", tag = "data-backup")
piggyback::pb_upload("DATA_TO_UPLOAD/mb_quarters.csv", repo = "alex-koiter/mbquartR")
