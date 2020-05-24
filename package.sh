#!/usr/bin/env bash
set -ue
THIS_DIR=$(
  cd "$(dirname "${BASH_SOURCE:-$0}")" && pwd
)
readonly THIS_DIR
{
  cd "${THIS_DIR}"
  tar zcvf mv_image_to_subdir.tar.gz bin .tar2package.yml
  docker run -i greymd/tar2rpm:1.0.1 < mv_image_to_subdir.tar.gz > pkg/mv_image_to_subdir.rpm.tmp
  mv pkg/mv_image_to_subdir.rpm{.tmp,}
  docker run -i greymd/tar2deb:1.0.1 < mv_image_to_subdir.tar.gz > pkg/mv_image_to_subdir.deb.tmp
  mv pkg/mv_image_to_subdir.deb{.tmp,}
  rm mv_image_to_subdir.tar.gz
}
