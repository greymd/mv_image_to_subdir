#!/usr/bin/env bats
source ./assertions
readonly TARGET_COMMAND="../bin/mv_image_to_subdir"

setup () {
  touch -d 2020-02-12 data/dummy.jpg
  touch -d 2020-02-12 data/dummy.png
}

@test "mv_image_to_subdir filename" {
  ENABLE_DRY_RUN=1 run "$TARGET_COMMAND" "data/2019-02-02 13.13.13.png"
  assert_equal "$status" 0
  assert_equal "${lines[2]}" 'mkdir "data/2019-02-02"'
  assert_equal "${lines[3]}" 'mv "data/2019-02-02 13.13.13.png" "data/2019-02-02"'
  assert_equal "${lines[4]}" 'touch -m "data/2019-02-02"'
}

@test "mv_image_to_subdir exif" {
  ENABLE_DRY_RUN=1 run "$TARGET_COMMAND" "data/dummy_exif.jpg"
  assert_equal "$status" 0
  assert_equal "${lines[4]}" 'mkdir "data/2019-01-01"'
  assert_equal "${lines[5]}" 'mv "data/dummy_exif.jpg" "data/2019-01-01"'
  assert_equal "${lines[6]}" 'touch -m "data/2019-01-01"'
}

@test "mv_image_to_subdir stat" {
  ENABLE_DRY_RUN=1 run "$TARGET_COMMAND" "data/dummy.jpg"
  assert_equal "$status" 0
  assert_equal "${lines[6]}" 'mkdir "data/2020-02-12"'
  assert_equal "${lines[7]}" 'mv "data/dummy.jpg" "data/2020-02-12"'
  assert_equal "${lines[8]}" 'touch -m "data/2020-02-12"'
}

@test "mv_image_to_subdir exif and stat" {
  run sh -c "ENABLE_DRY_RUN=1 $TARGET_COMMAND data/dummy_exif.jpg data/dummy.jpg 2>/dev/null"
  assert_equal "$status" 0
  assert_equal "${lines[0]}" 'mkdir "data/2019-01-01"'
  assert_equal "${lines[1]}" 'mv "data/dummy_exif.jpg" "data/2019-01-01"'
  assert_equal "${lines[2]}" 'touch -m "data/2019-01-01"'
  assert_equal "${lines[3]}" 'mkdir "data/2020-02-12"'
  assert_equal "${lines[4]}" 'mv "data/dummy.jpg" "data/2020-02-12"'
  assert_equal "${lines[5]}" 'touch -m "data/2020-02-12"'
}
