import 'package:pinpad/receiver.dart';

void main() {
  // print('Available ports:');
  // var i = 0;
  // for (final name in SerialPort.availablePorts) {
  //   final sp = SerialPort(name);
  //   print('${++i}) $name');
  //   print('\tDescription: ${sp.description}');
  //   print('\tManufacturer: ${sp.manufacturer}');
  //   print('\tSerial Number: ${sp.serialNumber}');
  //   print('\tProduct ID: 0x${sp.productId.toRadixString(16)}');
  //   print('\tVendor ID: 0x${sp.vendorId.toRadixString(16)}');
  //   sp.dispose();
  // }
  final transformer = ReaderTransformer();
}
