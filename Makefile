# MXMLC=mxmlc
MXMLC=./bin/fcsh.py
COMPC=compc

SRC_DIR:=src
NAME=clisp
APP_NAME:=Main.as

APP_WIDTH:=640
APP_HEIGHT:=480

BG_COLOR:=0xffffff

DEST_DIR:=dest
DEST_NAME:=clisp.swf
DEST_LIB_NAME:=${NAME}.swc

TEST_LIBS:=lib/flexunit-uilistener.swc:lib/flexunit4.swc:lib/minimal-ui.swc
APP_LIBS:=lib/minimal-ui.swc

TEST_DIR:=test

TEST_APP_NAME:=TestRunner.mxml
TEST_RUNNER_SRC:=${TEST_DIR}/TestSuite.as
TEST_CASES_SRC:=
TEST_APP:=test.swf

TEST_WIDTH:=1024
TEST_HEIGHT:=800

DEBUG:=false

.PHONY: clean

all: test app

app: ${DEST_DIR}/${DEST_NAME}

test: ${DEST_DIR}/${TEST_APP}

lib: ${DEST_DIR}/${DEST_LIB_NAME}


${DEST_DIR}/${DEST_NAME}: $(shell find $(SRC_DIR) -iname *.as)
	${MXMLC} -source-path ${SRC_DIR} \
           --keep-as3-metadata=Macros,Function \
           --output ${DEST_DIR}/${DEST_NAME} \
           --default-size ${APP_WIDTH} ${APP_HEIGHT} \
           --default-background-color ${BG_COLOR} \
           --library-path+=${APP_LIBS} \
           --debug=${DEBUG} \
           ${SRC_DIR}/${APP_NAME}

${DEST_DIR}/${DEST_LIB_NAME}: ${SRC_DIR}/${APP_NAME} Makefile
	${COMPC} -source-path ${SRC_DIR} \
           --keep-as3-metadata=Macros,Function \
           -include-sources ${SRC_DIR}/com/clisp/ \
           --output ${DEST_DIR}/${DEST_LIB_NAME}

${DEST_DIR}/${TEST_APP}: ${TEST_DIR}/${TEST_APP_NAME} ${TEST_RUNNER_SRC} ${TEST_CASES_SRC}
	${MXMLC} -source-path ${SRC_DIR} ${CLASSPATH_DIR} \
           --output ${DEST_DIR}/${TEST_APP} \
           --default-size ${TEST_WIDTH} ${TEST_HEIGHT} \
           --default-background-color ${BG_COLOR} \
           --debug=${DEBUG} \
           --library-path+=${TEST_LIBS}:${APP_LIBS} \
           ${TEST_DIR}/${TEST_APP_NAME}

clean:
	-rm ${DEST_DIR}/*

include ../.html/html.mk
