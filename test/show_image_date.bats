#!/usr/bin/env bats
readonly TARGET_COMMAND="../bin/show_image_date"

@test "show_image_date filename" {
  ENABLE_DEBUG=0 run "$TARGET_COMMAND" "data/2019-02-02 13.13.13.png"
  [ "$status" -eq 0 ]
  [ "${lines[$((${#line[@]} - 1))]}" = "2019-02-02" ]
}

@test "show_image_date file does not exist" {
  ENABLE_DEBUG=0 run "$TARGET_COMMAND" "data/2019-02-02 hogehoge.png"
  [ "$status" -eq 1 ]
}


@test "show_image_date stat" {
  ENABLE_DEBUG=0 run "$TARGET_COMMAND" "data/dummy.jpg"
  [ "$status" -eq 0 ]
  [ "${lines[$((${#line[@]} - 1))]}" = "2020-02-12" ]
}

@test "show_image_date stat vs filename" {
  ENABLE_DEBUG=0 run "$TARGET_COMMAND" "data/2019-05-24 19.13.46.jpg"
  [ "$status" -eq 0 ]
  [ "${lines[$((${#line[@]} - 1))]}" = "2019-05-24" ]
}

@test "show_image_date png" {
  ENABLE_DEBUG=0 run "$TARGET_COMMAND" "data/dummy.png"
  [ "$status" -eq 0 ]
  local last_line="${lines[$((${#line[@]} - 1))]}"
  echo "$last_line"
  [ "$last_line" = "2020-02-12" ]
}

@test "show_image_date exif" {
  ENABLE_DEBUG=0 run "$TARGET_COMMAND" "data/dummy_exif.jpg"
  [ "$status" -eq 0 ]
  local last_line="${lines[$((${#line[@]} - 1))]}"
  [ "${last_line}" = "2019-01-01" ]
}

@test "show_image_date orig exif" {
  ENABLE_DEBUG=0 run "$TARGET_COMMAND" "data/dummy_exif.tiff"
  [ "$status" -eq 0 ]
  local last_line="${lines[$((${#line[@]} - 1))]}"
  [ "${last_line}" = "2021-12-05" ]
}

@test "show_image_date stat vs exif vs filename" {
  ENABLE_DEBUG=0 run "$TARGET_COMMAND" "data/2019-02-02 13.13.13.jpg"
  [ "$status" -eq 0 ]
  [ "${lines[$((${#line[@]} - 1))]}" = "2019-02-02" ]
}
