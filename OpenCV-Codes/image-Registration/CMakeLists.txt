cmake_minimum_required(VERSION 2.8)
project( image-Registration )
find_package( OpenCV REQUIRED )
include_directories(%{OpenCV_INCLUDE_DIRS})

add_executable( stitching_detailed stitching_detailed.cpp )
target_link_libraries( image-Registration ${OpenCV_LIBS} )
