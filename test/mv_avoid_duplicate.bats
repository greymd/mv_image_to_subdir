#!/usr/bin/env bats
source ./assertions
readonly TARGET_COMMAND="../bin/mv_avoid_duplicate"

teardown() {
  rm -rf data/subdir/*
  rm -rf data/subdir2/*
}

@test "mv_avoid_duplicate file" {
  ENABLE_DEBUG=1 run "$TARGET_COMMAND" "data/2019-02-02 13.13.13.png"
  assert_equal 1 "$status"
}

@test "mv_avoid_duplicate file.ext dir" {
  ENABLE_DEBUG=1 run "$TARGET_COMMAND" "data/2019-02-02 13.13.13.png" "data/subdir"
  assert_equal 0 "$status"
  assert_equal "command mv 'data/2019-02-02 13.13.13.png' 'data/subdir'" "${lines[0]}"
}

@test "mv_avoid_duplicate file dir(name duplicated)" {
  cp "data/dummy.png" "data/subdir/AAA"
  cp "data/dummy.jpg" "data/subdir2/AAA"
  ENABLE_DEBUG=1 run "$TARGET_COMMAND" "data/subdir2/AAA" "data/subdir"
  assert_equal 0 "$status"
  assert_equal "command mv 'data/subdir2/AAA' 'data/subdir/AAA-001'" "${lines[0]}"
}

@test "mv_avoid_duplicate file dir(name & content duplicated)" {
  cp "data/dummy.png" "data/subdir/AAA"
  cp "data/dummy.png" "data/subdir2/AAA"
  ENABLE_DEBUG=1 run "$TARGET_COMMAND" "data/subdir2/AAA" "data/subdir"
  assert_equal 0 "$status"
  assert_equal "command mv 'data/subdir2/AAA' 'data/subdir'" "${lines[0]}"
}

@test "mv_avoid_duplicate file.ext dir(name & content duplicated)" {
  cp "data/2019-02-02 13.13.13.png" "data/subdir"
  ENABLE_DEBUG=1 run "$TARGET_COMMAND" "data/2019-02-02 13.13.13.png" "data/subdir"
  assert_equal 0 "$status"
  assert_equal "command mv 'data/2019-02-02 13.13.13.png' 'data/subdir'" "${lines[0]}"
}

@test "mv_avoid_duplicate file.ext dir(name duplicated)" {
  cp "data/dummy.png" "data/subdir/2019-02-02 13.13.13.png"
  ENABLE_DEBUG=1 run "$TARGET_COMMAND" "data/2019-02-02 13.13.13.png" "data/subdir"
  assert_equal 0 "$status"
  assert_equal "command mv 'data/2019-02-02 13.13.13.png' 'data/subdir/2019-02-02 13.13.13-001.png'" "${lines[0]}"
  cp 'data/2019-02-02 13.13.13.png' 'data/subdir/2019-02-02 13.13.13-001.png'
  ENABLE_DEBUG=1 run "$TARGET_COMMAND" "data/2019-02-02 13.13.13.png" "data/subdir"
  assert_equal "command mv 'data/2019-02-02 13.13.13.png' 'data/subdir/2019-02-02 13.13.13-002.png'" "${lines[0]}"
}

@test "mv_avoid_duplicate file.ext file.ext" {
  cp "data/dummy.png" "data/subdir/AAA"
  cp "data/dummy.png" "data/subdir2/BBB"
  ENABLE_DEBUG=1 run "$TARGET_COMMAND" "data/subdir/AAA" "data/subdir2/BBB"
  assert_equal 0 "$status"
  assert_equal "command mv 'data/subdir/AAA' 'data/subdir2/BBB'" "${lines[0]}"
}

@test "mv_avoid_duplicate file.ext file.ext(name & content duplicated)" {
  cp "data/dummy.png" "data/subdir/AAA"
  cp "data/dummy.png" "data/subdir2/AAA"
  ENABLE_DEBUG=1 run "$TARGET_COMMAND" "data/subdir/AAA" "data/subdir2/AAA"
  assert_equal 0 "$status"
  assert_equal "command mv 'data/subdir/AAA' 'data/subdir2/AAA'" "${lines[0]}"
}

@test "mv_avoid_duplicate file.ext file.ext(name duplicated)" {
  cp "data/dummy.png" "data/subdir/AAA"
  cp "data/dummy.jpg" "data/subdir2/AAA"
  ENABLE_DEBUG=1 run "$TARGET_COMMAND" "data/subdir/AAA" "data/subdir2/AAA"
  assert_equal 0 "$status"
  assert_equal "command mv 'data/subdir/AAA' 'data/subdir2/AAA-001'" "${lines[0]}"
}

@test "mv_avoid_duplicate dir file" {
  cp "data/dummy.jpg" "data/subdir2/AAA"
  ENABLE_DEBUG=1 run "$TARGET_COMMAND" "data/subdir" "data/subdir2/AAA"
  assert_equal 0 "$status"
  assert_equal "command mv 'data/subdir' 'data/subdir2/AAA'" "${lines[0]}"
}

@test "mv_avoid_duplicate dir dir" {
  ENABLE_DEBUG=1 run "$TARGET_COMMAND" "data/subdir/" "data/subdir2/"
  assert_equal 0 "$status"
  assert_equal "command mv 'data/subdir/' 'data/subdir2/'" "${lines[0]}"
}
