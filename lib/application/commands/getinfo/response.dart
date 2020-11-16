import 'package:bc108/application/fields/alphanumeric.dart';
import 'package:bc108/application/fields/composite.dart';

class GetInfo00Response {
  String manufacturer;
  String modelAndHardwareVersion;
  bool supportsContactless;
  String softwareVersion;
  String specificationVersion;
  String baseApplicationVersion;
  String serialNumber;

  static final _field = new CompositeField([
    AlphanumericField(20),
    AlphanumericField(19),
    AlphanumericField(1),
    AlphanumericField(20),
    AlphanumericField(4),
    AlphanumericField(16),
    AlphanumericField(20),
  ]);

  GetInfo00Response.parse(String text) {
    final parsed = _field.parse(text);

    manufacturer = parsed.data[0];
    modelAndHardwareVersion = parsed.data[1];
    supportsContactless = parsed.data[2] == "C";
    softwareVersion = parsed.data[3];
    specificationVersion = parsed.data[4];
    baseApplicationVersion = parsed.data[5];
    serialNumber = parsed.data[6];
  }
}
