[![codecov.io](https://codecov.io/github/mniak/bc108/coverage.svg?branch=master)](https://codecov.io/github/mniak/bc108?branch=master)

  
`bc108`
===============
Dart implementation of the specification _'Biblioteca Compartilhada v1.08a'_.

> **Disclaimer:** this library does not care about the the physical layer of the communication.
> In other words, you should be able to open a stream to the pinpad by yourself either by bluetooth, serial port, tcp/udp sockets or any other communication port.

## Usage
```dart
import 'package:bc108/bc108.dart';

// Connect to your pinpad and acquire a stream and a sink of int (byte)
Stream<int> stream = ...;
Sink<int> sink = ...;

final pinpad = Pinpad.fromStreamAndSink(stream, sink);

final dr = await pinpad.display(DisplayRequest("Hello" /* first line */, "World!" /* second line */));
print("📺 Command Status: ${dr.status}");

final tr = await pinpad.getTimestamp(GetTimestampRequest(3 /* acquirer 3 */));
print("🕐 Command Status: ${tr.status}");
print("🕐 The timestamp is ${tr.data.timestamp}");
```

## Commands
- ✅ `open`
- ✅ `close`
- ✅ `display`
- ⬜ `displayEx`
- ✅ `getKey`
- ⬜ `startGetPIN` / `getPIN`
- ⬜ `startRemoveCard` / `removeCard`
- ⬜ `startGenericCmd` / `genericCmd`
- ⬜ `startCheckEvent` / `checkEvent`
- ⬜ `startGetCard` / `getCard` / `resumeGetCard`
- ⬜ `startGoOnChip` / `goOnChip`
- ⬜ `finishChip`
- ⬜ `chipDirect`
- ⬜ `changeParameter`
- ✅ `getInfo00`
- ⬜ `getInfo`
- ⬜ `encryptBuffer`
- ✅ `tableLoadInit`
- ✅ `tableLoadRec`
- ✅ `tableLoadEnd`
- ⬜ `getDUKPT`
- ⬜ `getTimeStamp`
- ⬜ `defineWKPAN`

