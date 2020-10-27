library utils;

enum Byte {
  ACK,
  SYN,
  NAK,
  ETB,
  CAN,
}

extension ByteConverter on Byte {
  int toInt() {
    switch (this) {
      case Byte.ACK:
        return 0x06;
      case Byte.SYN:
        return 0x16;
      case Byte.NAK:
        return 0x15;
      case Byte.ETB:
        return 0x17;
      case Byte.CAN:
        return 0x18;
      default:
        return 0;
    }
  }
}
