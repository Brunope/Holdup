TARGET = qpoker
TEMPLATE = app
#CONFIG -= app_bundle

QMAKE_CXX = clang++
QMAKE_CXXFLAGS += -std=c++11 -g

OBJECTS_DIR=./obj
MOC_DIR=./moc

QT += core gui qml quick widgets

QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.10
ICON = img/chip.icns

# bye compiler warnings
DEFINES += QT_DEPRECATED_WARNINGS

# link the core game static library
PRE_TARGETDEPS += "poker.a"

LIBS += poker.a ../obj/Sleeper.o $$files(../obj/*Agent.o)
INCLUDEPATH += "../core/inc" "../agents/inc"

poker_core.target = "poker.a"
poker_core.commands = "cp ../core/poker.a ."
poker_core.depends = FORCE

qpoker.depends = poker_core

# do the thing
SOURCES += "Main.cc" "QEventListener.cc" "QGameDriver.cc" "QPlayer.cc" \
 "QGameView.cc" "QHumanAgent.cc"

HEADERS += "QEventListener.h" "QGameDriver.h" "QPlayer.h" "QGameView.h" \
 "QCard.h" "QHumanAgent.h"

RESOURCES += qml.qrc
QML += Main.qml Player.qml Card.qml Board.qml PlayerRing.qml ChatBox.qml \
ActionInterface.qml Pot.qml

QMAKE_EXTRA_TARGETS += poker_core

# do i need this?
DISTFILES += \
Main.qml Player.qml Card.qml Board.qml PlayerRing.qml ChatBox.qml \
ActionInterface.qml Pot.qml background.png back.png

