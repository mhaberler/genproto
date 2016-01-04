@[if DEVELSPACE]@
# bin and template dir variables in develspace
set(GENPROTO_BIN "@(CMAKE_CURRENT_SOURCE_DIR)/scripts/gen_proto.py")
set(GENPROTO_TEMPLATE_DIR "@(CMAKE_CURRENT_SOURCE_DIR)/scripts")
@[else]@
# bin and template dir variables in installspace
set(GENPROTO_BIN "${genproto_DIR}/../../../@(CATKIN_PACKAGE_BIN_DESTINATION)/gen_proto.py")
set(GENPROTO_TEMPLATE_DIR "${genproto_DIR}/..")
@[end if]@

# Generate .msg->.proto for protoc
# The generated .proto files should be added ALL_GEN_OUTPUT_FILES_proto
macro(_generate_msg_proto ARG_PKG ARG_MSG ARG_IFLAGS ARG_MSG_DEPS ARG_GEN_OUTPUT_DIR)
  file(MAKE_DIRECTORY ${ARG_GEN_OUTPUT_DIR})

  #Create input and output filenames
  get_filename_component(MSG_NAME ${ARG_MSG} NAME)
  get_filename_component(MSG_SHORT_NAME ${ARG_MSG} NAME_WE)

  set(MSG_GENERATED_NAME ${MSG_SHORT_NAME}.proto)
  set(GEN_OUTPUT_FILE ${ARG_GEN_OUTPUT_DIR}/${MSG_GENERATED_NAME})

  assert(CATKIN_ENV)
  add_custom_command(OUTPUT ${GEN_OUTPUT_FILE}
    DEPENDS ${GENPROTO_BIN} ${ARG_MSG} ${ARG_MSG_DEPS} "${GENPROTO_TEMPLATE_DIR}/msg.proto.template" ${ARGN}
    COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENPROTO_BIN} ${ARG_MSG}
    ${ARG_IFLAGS}
    -p ${ARG_PKG}
    -o ${ARG_GEN_OUTPUT_DIR}
    -e ${GENPROTO_TEMPLATE_DIR}
    COMMENT "Generating Protobuf from ${ARG_PKG}/${MSG_NAME}"
    )
  list(APPEND ALL_GEN_OUTPUT_FILES_proto ${GEN_OUTPUT_FILE})

  genproto_append_include_dirs()
endmacro()

#genproto uses the same program to generate srv and msg files, so call the same macro
macro(_generate_srv_proto ARG_PKG ARG_SRV ARG_IFLAGS ARG_MSG_DEPS ARG_GEN_OUTPUT_DIR)
  _generate_msg_proto(${ARG_PKG} ${ARG_SRV} "${ARG_IFLAGS}" "${ARG_MSG_DEPS}" ${ARG_GEN_OUTPUT_DIR} "${GENPROTO_TEMPLATE_DIR}/srv.proto.template")
endmacro()

macro(_generate_module_proto)
  # the macros, they do nothing
endmacro()

set(genproto_INSTALL_DIR include)

macro(genproto_append_include_dirs)
  if(NOT genproto_APPENDED_INCLUDE_DIRS)
    # make sure we can find generated messages and that they overlay all other includes
    include_directories(BEFORE ${CATKIN_DEVEL_PREFIX}/${genproto_INSTALL_DIR})
    # pass the include directory to catkin_package()
    list(APPEND ${PROJECT_NAME}_INCLUDE_DIRS ${CATKIN_DEVEL_PREFIX}/${genproto_INSTALL_DIR})
    set(genproto_APPENDED_INCLUDE_DIRS TRUE)
  endif()
endmacro()
