get_filename_component(DIRECTORY_PATH ${CMAKE_CURRENT_LIST_DIR} ABSOLUTE)
string(REPLACE "/" "_" DIRECTORY_NAME ${DIRECTORY_PATH})

macro(HSLEE_APP "NAME")
	set("APP" ${DIRECTORY_NAME}_${NAME})
	add_executable(
		${APP}
			${NAME}.cpp
	)
	target_link_libraries(
		${APP} PRIVATE
			hslee::invest
	)
	target_compile_options(
		${APP} PRIVATE
			-Wall
			-pedantic
			-std=c++20
	)
	set_target_properties(
		${APP} PROPERTIES
			OUTPUT_NAME ${NAME}
			DEBUG_POSTFIX d
	)
endmacro()

HSLEE_APP(test)
