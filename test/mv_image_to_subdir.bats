#!/usr/bin/env bats
source ./assertions
readonly TARGET_COMMAND="../bin/mv_image_to_subdir"

setup () {
  touch -d 2020-02-12 data/dummy.jpg
  touch -d 2020-02-12 data/dummy.png
}

@test "mv_image_to_subdir filename" {
  ENABLE_DRY_RUN=1 run "$TARGET_COMMAND" "data/2019-02-02 13.13.13.png"
  assert_equal 0 "$status"
  assert_equal 'mkdir "data/2019-02-02"' "${lines[2]}"
  assert_equal 'mv "data/2019-02-02 13.13.13.png" "data/2019-02-02"' "${lines[3]}"
  assert_equal 'touch -m "data/2019-02-02"' "${lines[4]}"
}

@test "mv_image_to_subdir exif" {
  ENABLE_DRY_RUN=1 run "$TARGET_COMMAND" "data/dummy_exif.jpg"
  assert_equal 0 "$status"
  assert_equal 'mkdir "data/2019-01-01"' "${lines[4]}"
  assert_equal 'mv "data/dummy_exif.jpg" "data/2019-01-01"' "${lines[5]}"
  assert_equal 'touch -m "data/2019-01-01"' "${lines[6]}"
}

@test "mv_image_to_subdir stat" {
  ENABLE_DRY_RUN=1 run "$TARGET_COMMAND" "data/dummy.jpg"
  assert_equal 0 "$status"
  assert_equal 'mkdir "data/2020-02-12"' "${lines[6]}"
  assert_equal 'mv "data/dummy.jpg" "data/2020-02-12"' "${lines[7]}"
  assert_equal 'touch -m "data/2020-02-12"' "${lines[8]}"
}

@test "mv_image_to_subdir exif and stat" {
  run sh -c "ENABLE_DRY_RUN=1 $TARGET_COMMAND data/dummy_exif.jpg data/dummy.jpg 2>/dev/null"
  assert_equal 0 "$status"
  assert_equal 'mkdir "data/2019-01-01"' "${lines[0]}"
  assert_equal 'mv "data/dummy_exif.jpg" "data/2019-01-01"' "${lines[1]}"
  assert_equal 'touch -m "data/2019-01-01"' "${lines[2]}"
  assert_equal 'mkdir "data/2020-02-12"' "${lines[3]}"
  assert_equal 'mv "data/dummy.jpg" "data/2020-02-12"' "${lines[4]}"
  assert_equal 'touch -m "data/2020-02-12"' "${lines[5]}"
}
