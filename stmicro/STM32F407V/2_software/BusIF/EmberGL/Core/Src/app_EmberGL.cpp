#define TARGET_APP 2

#if TARGET_APP == 0
#include "./egl/00_hello_rect/app.cpp"
#elif TARGET_APP == 1
#include "./egl/01_textured_rects/app.cpp"
#elif TARGET_APP == 2
#include "./egl/02_roto_monkey/app.cpp"
#elif TARGET_APP == 3
#include "./egl/03_multi_dispatch/app.cpp"
#elif TARGET_APP == 4
#include "./egl/04_texture_cube/app.cpp"
#elif TARGET_APP == 5
#include "./egl/05_speedometer/app.cpp"
#elif TARGET_APP == 6
#include "./egl/06_lit_monkey/app.cpp"
#elif TARGET_APP == 7
#include "./egl/07_cluster_culling/app.cpp"
#endif
