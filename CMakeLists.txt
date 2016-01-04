cmake_minimum_required(VERSION 2.8.3)
project(genproto)
find_package(catkin REQUIRED COMPONENTS genmsg)

catkin_package(
  CATKIN_DEPENDS genmsg
  CFG_EXTRAS genproto-extras.cmake
)

add_subdirectory(scripts)

file(WRITE ${CATKIN_DEVEL_PREFIX}/${GENMSG_LANGS_DESTINATION}/genproto "protobuf")
install(FILES ${CATKIN_DEVEL_PREFIX}/${GENMSG_LANGS_DESTINATION}/genproto
  DESTINATION ${GENMSG_LANGS_DESTINATION})

catkin_python_setup()
