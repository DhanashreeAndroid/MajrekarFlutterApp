// import 'dart:convert';
// import 'dart:developer';
// import 'dart:typed_data';
// import 'package:basic_utils/basic_utils.dart';
// // import 'package:pointycastle/export.dart' as pc;
// import 'package:encrypt/encrypt.dart' as Encrypt;
// // import 'package:pointycastle/api.dart' as pc;
// import 'package:pointycastle/export.dart';

// class FundUtilities{

//   String stringKey = 'zXHRvSGXffzJXzcSAyGUP+mSzAVWX/2LejfwKsDdGp8=';
//   String stringIV = 'y4hFqDhEZYlE+36P9uwkTg==';
//   String publicKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtRHv5tDCWWS107YhDUE2qU97e4z0qF/Rl4qrIpd3nyfCGwQNs9vy/W7Nmb1ZIgR0XKlBU4TaiXlPaQ+GbabuJHbQIl8hQZzi8bII+AOB/1Goevyebs2dmBddEdI3n7lJbSIRbg9RDLzYloV+5P4lkA3JAl7USUnrQBqHkmN+MZ+PBbfeVEHTOlFW9pULx7mb9DB1Ea6IIObU/VcaKYZhcOL1xcjr9pU4/Eck+AHFGuZaUtiqxFQPxVEFtQMKGKKyRyXVEUZONhkjI3CY04sb7jnMCk4Ua2AbqpLQxjXOJxhsuLyoYvVNfJb4iQKv25S7H7I74sxT6h2rAXb68yDQBQIDAQAB";

//   String GetEncryptedDataUsingAES(String data){
//     final key = Encrypt.Key.fromBase64(stringKey);
//     final iv = Encrypt.IV.fromBase64(stringIV);
//     print("Encrypting Request Body Using AES (CBC) PKCS7");
//     print(data);
//     final encrypter = Encrypt.Encrypter(Encrypt.AES(key, mode: Encrypt.AESMode.cbc,padding:'PKCS7' ));
//     final encrypted = encrypter.encrypt(data, iv: iv);
//     final decrypted = encrypter.decrypt(encrypted, iv: iv);
//     String encryptedData  = encrypted.base64;
//     log("Encrypted Requested Body : "+encryptedData);
//     log("Decrypted Requested Body Format (IGNORE) : "+decrypted);
//     return encryptedData;
//   }

//   Map<String,String> GetEncryptedKeyAndIV(){

//     print("INITIATING RSA (PKCS1) Encryption using public key"+publicKey);

//     /// After a lot of research on how to convert the public key [String] to [RSA PUBLIC KEY]
//     /// We would have to use PEM Cert Type and the convert it from a PEM to an RSA PUBLIC KEY through basic_utils
//     var pem =
//         '-----BEGIN RSA PUBLIC KEY-----\n$publicKey\n-----END RSA PUBLIC KEY-----';
//     var public = CryptoUtils.rsaPublicKeyFromPem(pem);

//     /// Initalizing Cipher
//     var cipher = PKCS1Encoding(RSAEngine());
//     cipher.init(true, PublicKeyParameter<RSAPublicKey>(public));

//     /// Converting into a [Unit8List] from List<int>
//     /// Then Encoding into Base64
//     Uint8List encodedKey = cipher.process(Uint8List.fromList(utf8.encode(stringKey)));
//     Uint8List encodedIV = cipher.process(Uint8List.fromList(utf8.encode(stringIV)));

//     String encodedKeyInString = base64Encode(encodedKey);
//     String encodedIVInString = base64Encode(encodedIV);

//     log("RSA Encrypted Key : "+encodedKeyInString);
//     log("RSA Encrypted IV : "+encodedIVInString);

//     Map<String,String> encryptedKeyAndIV = {"KEY":encodedKeyInString,"IV":encodedIVInString};
//     /*print("base64EncodedText");
//     print(base64EncodedText);*/

//     return encryptedKeyAndIV;
//   }

// }

// import 'package:crypto/crypto.dart' as crypto;
// import 'package:ekyc/keyencrypt.dart';
// import 'package:encrypt/encrypt.dart' as enc;
// import 'package:convert/convert.dart';
// import 'dart:typed_data';
// import 'dart:convert';

// String encrypt(String string) {
//   // 6863297981513709
//
//   final enc.Key key = enc.Key.fromUtf8("1989234487890280"); // Valid AES key
//   final enc.IV iv = enc.IV.fromUtf8('1989234487890280');      // IV_LENGTH = 16
//                 // Cryptom().text(key.toString());
//   final dataPadded = pad(Uint8List.fromList(utf8.encode(string)), 16);
//   final enc.Encrypter encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc, padding: null));
//   final encryptedJson = encrypter.encryptBytes(dataPadded, iv: iv);
//
//   crypto.Hmac hmacSha256 = crypto.Hmac(crypto.sha256, key.bytes);
//   crypto.Digest sha256Result = hmacSha256.convert(utf8.encode(iv.base64 + encryptedJson.base64));
//
//   final encryptedText = "{\"value\":\""+encryptedJson.base64+"\",\"iv\":\""+iv.base64+"\",\"mac\":\""+sha256Result.toString()+"\"}";
//      print("hee  $encryptedText");
//                 var decryptext  =           encrypter.decrypt64(encryptedJson.base64 ,iv: iv);
//             print("decrpt  $decryptext");
//
//   return base64.encode(utf8.encode(encryptedText));
//
// }
//
// Uint8List pad(Uint8List plaintext, int blockSize){
//   int padLength = (blockSize - (plaintext.lengthInBytes % blockSize)) % blockSize;
//   if (padLength != 0) {
//     BytesBuilder bb = BytesBuilder();
//     Uint8List padding = Uint8List(padLength);
//     bb.add(plaintext);
//     bb.add(padding);
//     return bb.toBytes();
//   }
//   else {
//     return plaintext;
//   }
// }

import 'dart:io';

import 'package:encrypt/encrypt.dart' as enc;
 import 'dart:typed_data';
 import 'dart:convert';
 import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:majrekar_app/CommonWidget/snackBars.dart';
 import 'package:pointycastle/export.dart';
import 'package:pointycastle/export.dart' as point;
import 'package:unique_identifier/unique_identifier.dart';

RSAPublicKey getPublicKeyFromBase64EncodedKey(String b64) {
  final pem =
      '-----BEGIN RSA PUBLIC KEY-----\n$b64\n-----END RSA PUBLIC KEY-----';
  return CryptoUtils.rsaPublicKeyFromPem(pem);
}

String encrypts(String plainText) {
  final plainBytes = utf8.encode(plainText) as Uint8List;
    print(" plain bytes ${plainBytes}");
  const javaEncoded =
      'MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAJiToNIgNYyrEvKIgkT6Wmu0fiZ6vvAuhDTidBI+iCcagX7HUAdfnxwkUIwtUIlNObPOVNjX+kfWGWDttbsfJGkCAwEAAQ==';

  final public = getPublicKeyFromBase64EncodedKey(javaEncoded);
  final cipher =  point.OAEPEncoding.withSHA1(point.RSAEngine())
    ..init(true, PublicKeyParameter<RSAPublicKey>(public));
  final cipherBytes = cipher.process(plainBytes);
  return base64Encode(cipherBytes);
}

enc.Encrypted encryptWithAES(String plainText) {
  const key = '6950537507048446';
  final cipherKey =  enc.Key.fromUtf8(key);
  final encryptService = enc.Encrypter(enc.AES(cipherKey, mode: enc.AESMode.cbc));
  final initVector = enc.IV.fromUtf8(key.substring(0, 16));

  enc.Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
  return encryptedData;
}

Future alertDailog(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,

          // title: Text('Welcome'),
          content: Container(
            height: 100,
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      color: white,
                      backgroundColor: puprle,
                    ),
                  ),
                ),
              ],
            ),
          ));
    },
  );
}

Future<String?> getDeviceIdentifier() async {
  String? deviceIdentifier = "unknown";
  try {
    deviceIdentifier = await UniqueIdentifier.serial;
  } on PlatformException {
    deviceIdentifier = 'unknown';
  }
  return deviceIdentifier;
}
