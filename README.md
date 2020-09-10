# Demo - Mapbox route replay
 
![Alt text](demo.gif?raw=true "demo")

# Usage

## NMEA data saved in route.txt and looks like

$GPGGA,070953,5232.08,N,1317.6,E,1,07,1.3,50.6,M,39.2,M,,*78
$GPRMC,070953,A,5232.08,N,1317.6,E,4.8,200.0,030308,11.2,W,A*39
$GPGGA,070954,5232.08,N,1317.6,E,1,07,1.3,50.6,M,39.2,M,,*7f
$GPRMC,070954,A,5232.08,N,1317.6,E,12.6,200.0,030308,11.2,W,A*07
$GPGGA,070955,5232.08,N,1317.6,E,1,07,1.3,50.6,M,39.2,M,,*7e
$GPRMC,070955,A,5232.08,N,1317.6,E,15.6,211.0,030308,11.2,W,A*01
$GPGGA,070956,5232.08,N,1317.59,E,1,07,1.3,50.6,M,39.2,M,,*47
$GPRMC,070956,A,5232.08,N,1317.59,E,14.7,270.0,030308,11.2,W,A*3f
$GPGGA,070957,5232.07,N,1317.59,E,1,07,1.3,50.6,M,39.2,M,,*49
$GPRMC,070957,A,5232.07,N,1317.59,E,23.6,180.0,030308,11.2,W,A*38
...

## Code in QML
 Load data
 
    PositionSource {
        id: positionSource
        nmeaSource: "route.txt"
        ...
    }
    
 Start/Stop
 
    onNavigationStartedChanged: {
        if (navigationStarted) {

            positionSource.start()

        } else {

            positionSource.stop()

        }
    }
    
 Read position (positionSource.position.coordinate)
 
        MapQuickItem {
            id: positionQuickItem
            z: 3
            coordinate: root.navigationStarted && positionSource.position.latitudeValid
                        ? positionSource.position.coordinate
                        : startCoordinate
            anchorPoint.x: positionImage.width / 2
            anchorPoint.y: positionImage.height / 2
            sourceItem: Image {
                id: positionImage
                source: root.mapState === "enterCar"
                        ? Style.symbol("search") : Style.symbol("NavRoundmarker")
            }
            Behavior on coordinate {
                enabled: true
                CoordinateAnimation { duration: 1500 }
            }
        }


[![Mapbox route replay](http://img.youtube.com/vi/xG4lQsejCRk/0.jpg)](http://www.youtube.com/watch?v=xG4lQsejCRk "Mapbox route replay")

