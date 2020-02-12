#!/usr/bin/env bats
readonly TARGET_COMMAND="../bin/mv_image_to_subdir"

@test "mv_image_to_subdir" {
  ENABLE_DRY_RUN=1 run "$TARGET_COMMAND" "/path/to/2010-01-11 hogehoge.jpg"
  [ "$status" -eq 0 ]
  [ "${lines[$((${#line[@]} - 2))]}" = 'mkdir "/path/to/2010-01-11"' ]
  [ "${lines[$((${#line[@]} - 1))]}" = 'mv "/path/to/2010-01-11 hogehoge.jpg" "/path/to/2010-01-11"' ]
}

