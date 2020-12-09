## [0.1.4]
- Bug fixes
- Make TLV raw data visible
- Locking mechanism to avoid race conditions
- Command `removeCard`
- Command `finishChip`

## [0.1.4] - Go on Chip
Implement command `goOnChip`

## [0.1.3] - Get Card
Implements commands `getCard` and `resumeGetCard`

## [0.1.2] - Features
- Blocking Command infrastructure
- Command `getKey`
- Command `open`
- Command `close`

## [0.1.1] - General improvements
- Pinpad now requires an `Stream<int>` instead of `Stream<ReaderEvent>`
- Documentation fixes

## [0.1.0] - Initial implementation

## Release Notes
- Basic communication
  - Retries
- Command `display`
- Command `getInfo00` _(for general information)_ 
- Command `tableLoadInit`
- Command `tableLoadRec`
- Command `tableLoadEnd`
- Command `getTimestamp`