#!/usr/bin/env bats
source ./assertions
readonly TARGET_COMMAND="../bin/mv_image_to_subdir"
readonly THIS_DIR="$(cd ../bin/ && pwd)"

setup () {
  touch -d 2020-02-12 data/dummy.jpg
  touch -d 2020-02-12 data/dummy.png
  touch -d 2021-07-03 data/dummy2.jpg
}

# @test "mv_image_to_subdir filename" {
#   ENABLE_DRY_RUN=1 run "$TARGET_COMMAND" "data/2019-02-02 13.13.13.png"
#   assert_equal 0 "$status"
#   assert_equal "mkdir 'data/2019-02-02'" "${lines[2]}"
#   assert_equal "$THIS_DIR/mv_avoid_duplicate 'data/2019-02-02 13.13.13.png' 'data/2019-02-02'" "${lines[3]}"
#   assert_equal "touch -m 'data/2019-02-02'" "${lines[4]}"
# }
# 
# @test "mv_image_to_subdir exif" {
#   ENABLE_DRY_RUN=1 run "$TARGET_COMMAND" "data/dummy_exif.jpg"
#   assert_equal 0 "$status"
#   assert_equal "mkdir 'data/2019-01-01'" "${lines[4]}"
#   assert_equal "$THIS_DIR/mv_avoid_duplicate 'data/dummy_exif.jpg' 'data/2019-01-01'" "${lines[5]}"
#   assert_equal "touch -m 'data/2019-01-01'" "${lines[6]}"
# }
# 
# @test "mv_image_to_subdir stat" {
#   ENABLE_DRY_RUN=1 run "$TARGET_COMMAND" "data/dummy.jpg"
#   assert_equal 0 "$status"
#   assert_equal "mkdir 'data/2020-02-12'" "${lines[-3]}"
#   assert_equal "$THIS_DIR/mv_avoid_duplicate 'data/dummy.jpg' 'data/2020-02-12'" "${lines[-2]}"
#   assert_equal "touch -m 'data/2020-02-12'" "${lines[-1]}"
# }
# 
# @test "mv_image_to_subdir exif and stat" {
#   run sh -c "ENABLE_DRY_RUN=1 $TARGET_COMMAND data/dummy_exif.jpg data/dummy.jpg 2>/dev/null"
#   assert_equal 0 "$status"
#   assert_equal "mkdir 'data/2019-01-01'" "${lines[0]}"
#   assert_equal "$THIS_DIR/mv_avoid_duplicate 'data/dummy_exif.jpg' 'data/2019-01-01'" "${lines[1]}"
#   assert_equal "touch -m 'data/2019-01-01'" "${lines[2]}"
#   assert_equal "mkdir 'data/2020-02-12'" "${lines[3]}"
#   assert_equal "$THIS_DIR/mv_avoid_duplicate 'data/dummy.jpg' 'data/2020-02-12'" "${lines[4]}"
#   assert_equal "touch -m 'data/2020-02-12'" "${lines[5]}"
# }

@test "mv_image_to_subdir mv duplicated file" {
  cp data/dummy2.jpg data/dummy2.jpg.bak
  run "$TARGET_COMMAND" "data/dummy2.jpg"
  assert_equal 0 "$status"
  ls data/2021-07-03/dummy2.jpg
  assert_equal 0 "$status"
  ls data/2021-07-03/dummy2-001.jpg
  assert_equal 0 "$status"
  mv data/dummy2.jpg.bak data/dummy2.jpg
  rm -f data/2021-07-03/dummy2-001.jpg
}
