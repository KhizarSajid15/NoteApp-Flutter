import 'package:xor_encryption/xor_encryption.dart';

class EncryptionService {
  final String encryptionKey;

  EncryptionService({required this.encryptionKey});

  String encrypt(String data) {
    return XorCipher().encryptData(data, encryptionKey);
  }
}

class DecryptionService {
  final String encryptionKey;

  DecryptionService({required this.encryptionKey});

  String decrypt(String encryptedData) {
    return XorCipher().encryptData(encryptedData, encryptionKey);
  }
}

/*void main() {
  final String encryptionKey = XorCipher().getSecretKey(20);

  final EncryptionService encryptionService =
      EncryptionService(encryptionKey: encryptionKey);
  final DecryptionService decryptionService =
      DecryptionService(encryptionKey: encryptionKey);

  final String originalText = 'Hello, XOR Encryption!';

  final String encryptedText = encryptionService.encrypt(originalText);
  final String decryptedText = decryptionService.decrypt(encryptedText);

  print('Original Text: $originalText');
  print('Encrypted Text: $encryptedText');
  print('Decrypted Text: $decryptedText');
}*/
