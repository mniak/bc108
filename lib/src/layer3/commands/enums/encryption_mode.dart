enum EncryptionMode {
  /// Master Key / Working DES (8 bytes)
  MasterKeyDes,

  ///  Master Key / Working 3DES (16 bytes)
  MasterKey3Des,

  /// DUKPT DES
  DukptDes,

  /// DUKPT 3DES
  Dukpt3Des,
}

extension EncryptionModeIntExtension on int {
  EncryptionMode get asEncryptionMode {
    switch (this) {
      case 1:
        return EncryptionMode.MasterKey3Des;
      case 2:
        return EncryptionMode.DukptDes;
      case 3:
        return EncryptionMode.Dukpt3Des;

      case 0:
      default:
        return EncryptionMode.MasterKeyDes;
    }
  }
}

extension EncryptionModeExtension on EncryptionMode {
  int get value {
    switch (this) {
      case EncryptionMode.MasterKey3Des:
        return 1;
      case EncryptionMode.DukptDes:
        return 2;
      case EncryptionMode.Dukpt3Des:
        return 3;

      case EncryptionMode.MasterKeyDes:
      default:
        return 0;
    }
  }
}
