import 'dart:convert' show utf8, base64;

EncodingDecodingDemo() {
  final StringToEncode = 'https://dartpad.dartlang.org/';

  final EncodedString = base64.encode(utf8.encode(StringToEncode));
  print('base64: $EncodedString');

  final DecodedString = utf8.decode(base64.decode(EncodedString));
  print(DecodedString);
  print(StringToEncode == DecodedString);
  return EncodedString;

}

String Encode(String StringToEncode){
  final EncodedString = base64.encode(utf8.encode(StringToEncode));
  print(EncodedString);
  return EncodedString;
}

String Decode(String StringToDecode){
  final DecodedString = utf8.decode(base64.decode(StringToDecode));
  print(DecodedString);
  return DecodedString;
}