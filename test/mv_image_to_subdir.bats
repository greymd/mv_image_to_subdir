#!/usr/bin/env bats
readonly TARGET_COMMAND="../bin/mv_image_to_subdir"

@test "mv_image_to_subdir filename" {
  ENABLE_DRY_RUN=1 run "$TARGET_COMMAND" "data/2019-02-02 13.13.13.png"
  [ "$status" -eq 0 ]
  [ "${lines[$((${#line[@]} - 2))]}" = 'mkdir "data/2019-02-02"' ]
  [ "${lines[$((${#line[@]} - 1))]}" = 'mv "data/2019-02-02 13.13.13.png" "data/2019-02-02"' ]
}

@test "mv_image_to_subdir exif" {
  ENABLE_DRY_RUN=1 run "$TARGET_COMMAND" "data/dummy_exif.jpg"
  [ "$status" -eq 0 ]
  [ "${lines[$((${#line[@]} - 2))]}" = 'mkdir "data/2019-01-01"' ]
  [ "${lines[$((${#line[@]} - 1))]}" = 'mv "data/dummy_exif.jpg" "data/2019-01-01"' ]
}

@test "mv_image_to_subdir stat" {
  ENABLE_DRY_RUN=1 run "$TARGET_COMMAND" "data/dummy.jpg"
  [ "$status" -eq 0 ]
  [ "${lines[$((${#line[@]} - 2))]}" = 'mkdir "data/2020-02-12"' ]
  [ "${lines[$((${#line[@]} - 1))]}" = 'mv "data/dummy.jpg" "data/2020-02-12"' ]
}

@test "mv_image_to_subdir exif and stat" {
  run sh -c "ENABLE_DRY_RUN=1 $TARGET_COMMAND data/dummy_exif.jpg data/dummy.jpg 2>/dev/null"
  [ "$status" -eq 0 ]
  echo "${lines[@]}"
  [ "${lines[$((${#line[@]} - 4))]}" = 'mkdir "data/2019-01-01"' ]
  [ "${lines[$((${#line[@]} - 3))]}" = 'mv "data/dummy_exif.jpg" "data/2019-01-01"' ]
  [ "${lines[$((${#line[@]} - 2))]}" = 'mkdir "data/2020-02-12"' ]
  [ "${lines[$((${#line[@]} - 1))]}" = 'mv "data/dummy.jpg" "data/2020-02-12"' ]
}
