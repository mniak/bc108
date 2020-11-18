bc108
===============
Dart implementation of the _'Biblioteca Compartilhada'_ v1.08 specification.

## Usage
```dart
import 'package:bc108/bc108.dart';

Stream<int> stream = ...;
Sink<int> sink = ...;

final pinpad = Pinpad.fromStreamAndSink(stream, sink);

final dr = await _pinpad.display(DisplayRequest("Hello" /* first line */, "World!" /* second line */));
print("📺 Command Status: ${dr.status}");

final tr = await _pinpad.getTimestamp(GetTimestampRequest(3 /* acquirer 3 */));
print("🕐 Command Status: ${tr.status}");
print("🕐 The timestamp is ${tr.data.timestamp}");
```

## Commands
- ❌ `open` _(not applicable)_
- ❌ `close` _(not applicable)_
- ✅ `display` 
- ⬜ `displayEx`
- ⬜ `startGetKey` / `getKey`
- ⬜ `startGetPIN` / `getPIN`
- ⬜ `startRemoveCard` / `removeCard`
- ⬜ `startGenericCmd` / `genericCmd`
- ⬜ `startCheckEvent` / `checkEvent`
- ⬜ `startGetCard` / `getCard` / `resumeGetCard`
- ⬜ `startGoOnChip` / `goOnChip`
- ⬜ `finishChip`
- ⬜ `chipDirect`
- ⬜ `changeParameter`
- ⏹ `getInfo` _(general information only)_
- ⬜ `encryptBuffer`
- ✅ `tableLoadInit`
- ✅ `tableLoadRec`
- ✅ `tableLoadEnd`
- ⬜ `getDUKPT`
- ⬜ `getTimeStamp`
- ⬜ `defineWKPAN`

