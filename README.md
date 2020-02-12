# mv_image_to_subdir

Execute following procedure automatically.

* **(1) Load image file**

* **(2) Create the subdirectory having the name "YYYY-MM-DD" format on the same directory where the image file exists.**

  - Then, following rule is applied.
    - If the image file includes the date format "YYYY-MM-DD" at the beginning of its name, follows it.
    - If above condition is not satisfied, `exif:DateTime` is used instead.
    - If above one is also unsatsfied, modified date of the file is used finally.

* **(3) Move the image file to the subdirectory**

## Usage

~~~~~bash
$ mv_image_to_subdir /path/to/image.jpg
~~~~~
=> `image.jpg` is moved to `/path/to/YYYY-MM-DD/image.jpg`

## Installation

~~~~~
$ sudo apt install imagemagick
~~~~~

## Dependency

* ImageMagick
