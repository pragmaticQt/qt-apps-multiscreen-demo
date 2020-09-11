QT = core gui quick qml serialbus

SOURCES += \
    $$files(src/*.cpp)

HEADERS += \
    $$files(src/*.h)

# Separate each type of resource into its own .qrc file for efficiency
#qml.files = $$files(*.qml)
#qml.prefix = /qml
#RESOURCES += qml

#images.files = $$files(*.png)
#images.prefix = /images
#RESOURCES += images

#RESOURCES += route.txt
RESOURCES += carui.qrc

DEFINES += MAIN_QML_FILE_NAME=\\\"qrc:/qml/CarUI.qml\\\" DEFAULT_ROUTE_FILE=\\\":/route.txt\\\"

TEMPLATE = app
TARGET = carui

target.path = /data/user/qt/$$TARGET
INSTALLS += target

DISTFILES += \
    qml/CarUI.qml \
    qml/Button.qml \
    qml/Slide.qml \
    qml/Blinks.qml \
    qml/Car.qml \
    qml/Gear.qml \
    qml/GearAutomatic.qml \
    qml/ButtonHolder.qml \
    qml/SlideHolder.qml \
    qml/ViewChange.qml
