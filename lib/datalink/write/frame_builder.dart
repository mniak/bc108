import '../utils/crc.dart';
import '../utils/bytes.dart';
import '../utils/bytes_builder.dart';
import 'command.dart';

class FrameBuilder {
  Checksum _checksumAlgorithm;
  FrameBuilder(this._checksumAlgorithm);

  Iterable<int> build(Command command) {
    final payloadWithEtb =
        BytesBuilder().addString(command.payload).addByte2(Byte.ETB).build();
    final checksum = _checksumAlgorithm.compute(payloadWithEtb);
    final result = BytesBuilder()
        .addByte2(Byte.SYN)
        .addBytes(payloadWithEtb)
        .addBytes(checksum)
        .build();
    return result;
  }
}
