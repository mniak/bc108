import '../utils/crc.dart';
import '../utils/bytes.dart';
import '../utils/bytes_builder.dart';

class FrameBuilder {
  Checksum _checksumAlgorithm;
  FrameBuilder({Checksum checksumAlgorithm}) {
    this._checksumAlgorithm = checksumAlgorithm ?? CRC16();
  }

  Iterable<int> build(String payload) {
    final payloadWithEtb =
        BytesBuilder().addString(payload).addByte2(Byte.ETB).build();
    final checksum = _checksumAlgorithm.compute(payloadWithEtb);
    final result = BytesBuilder()
        .addByte2(Byte.SYN)
        .addBytes(payloadWithEtb)
        .addBytes(checksum)
        .build();
    return result;
  }
}