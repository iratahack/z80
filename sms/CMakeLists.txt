cmake_minimum_required(VERSION 3.16)

# Set the z88dk target for this build
set(ZCCTARGET sms)
# Use the z88dk provided tool configuration from the snap install
set(CMAKE_TOOLCHAIN_FILE /snap/z88dk/current/share/z88dk/cmake/Toolchain-zcc.cmake)

project(Hello C)

add_link_options(-m -create-app -L${PROJECT_SOURCE_DIR})
add_compile_options(-compiler=sdcc --fsigned-char)

add_executable(${PROJECT_NAME} main.c)
add_dependencies(${PROJECT_NAME} SMSlib)

target_link_options(${PROJECT_NAME} PRIVATE -L${PROJECT_BINARY_DIR}/SMSlib -llibSMSlib)
add_subdirectory(SMSlib)
#target_link_libraries(${PROJECT_NAME} PRIVATE SMSlib)
    
add_custom_target(run gearsystem.exe ${PROJECT_NAME}.sms DEPENDS ${PROJECT_NAME})

add_custom_target(dis z88dk-dis -x ${PROJECT_NAME}.map ${PROJECT_NAME}.sms DEPENDS ${PROJECT_NAME})


set_target_properties(${PROJECT_NAME} PROPERTIES ADDITIONAL_CLEAN_FILES
    "${PROJECT_NAME}.sms;${PROJECT_NAME}_BSS.bin;${PROJECT_NAME}.map;${PROJECT_NAME}_DATA.bin;"
)
