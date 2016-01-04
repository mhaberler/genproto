install(
  FILES msg.proto.template srv.proto.template
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})

catkin_install_python(
  PROGRAMS gen_proto.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})
