# Can Controller Simulation

![Alt text](demo.gif?raw=true "demo")

## virtualcan
https://doc.qt.io/qt-5.12/qtserialbus-virtualcan-overview.html

## J1339
```C
// J1939 PGNs
#define PGN_65268 0xFEF4 // Tire Condition - TIRE
#define PGN_64933 0xFDA5 // Door Control 2 - DC2
#define PGN_64972 0xFDCC // Light Control
#define PGN_61445 0xF005 // Electronic Transmission Controller 2 - ETC2
#define PGN_65265 0xFEF1 // Cruise Control/Vehicle Speed - CCVS
#define PGN_65267 0xFEF3 // vehicle position - VP
#define PGN_65256 0xFEE8 // vehicle direction/speed
#define PGN_65262 0xFEEE // Engine Temperature 1 - ET1
#define PGN_65263 0xFEEF // Engine Fluid Level/Pressure 1 - EFL/P1
#define PGN_65271 0xFEF7 // Vehicle Electrical Power - VEP
#define PGN_65276 0xFEFC // Dash Display - DD
#define PGN_61444 0xF004 // Electronic Engine Controller 1 - EEC1
#define PGN_60928 0xEE00 // Address Calimed - ACL

// door defines
#define DOOR_INIT 0xF33CCFF1FCFFFF0F
#define OPEN_DOOR_1 0x400000000000000
#define OPEN_DOOR_2 0x1000000000000
#define OPEN_DOOR_3 0x40000000000000
#define OPEN_DOOR_4 0x100000000000
#define OPEN_DOOR_5 0x400000000
#define OPEN_DOOR_6 0x1000000

// light defines
#define LIGHT_INIT Q_UINT64_C(0x0)
#define HEAD_LIGHT Q_UINT64_C(0x0200000000000000)
#define PARK_LIGHT Q_UINT64_C(0x0100000000000000)
#define LIGHT_ERROR Q_UINT64_C(0x0400000000000000)
#define LEFT_TURN_SIGNAL Q_UINT64_C(0x0010000000000000)
#define RIGHT_TURN_SIGNAL Q_UINT64_C(0x0020000000000000)
#define HAZARD_SIGNAL Q_UINT64_C(0x0004000000000000)

// Current gear
#define GEAR_PARK 0xFB
#define GEAR_REVERSE 0x7C
#define GEAR_NEUTRAL 0x7D
// #define GEAR_1 0x7E
// #define GEAR_2 0x7F
// #define GEAR_3 0x80
// #define GEAR_4 0x81
// #define GEAR_5 0x82
// #define GEAR_6 0x83

## Received CAN messages examples

| Timestamp  | Flag | CAN-ID | DLC | Data |
| --- | --- | --- | --- | --- |
| 1599902046.5460 | --- | 0000F005 | [8] | 00 00 00 7E 00 00 00 00 |
| 1599902046.5470 | --- | 0000FEF1 | [8] | 00 00 00 00 00 00 00 00 |
```
