project(Glad)

file(GLOB_RECURSE GLAD_SOURCES src/*.c
                 src/*.h
                 include/glad/*.h
                 include/KHR/*.h)
add_library(glad STATIC src/glad.c include/glad/glad.h include/KHR/khrplatform.h)
target_include_directories(glad PUBLIC include)