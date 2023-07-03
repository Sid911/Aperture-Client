import 'dart:convert';
import 'package:crypto/crypto.dart';

String createSHA256Hash(String input) {
  final bytes = utf8.encode(input); // Convert the input string to bytes
  final digest = sha256.convert(bytes); // Generate the SHA-256 hash
  final hash = digest.toString(); // Get the hexadecimal string representation of the hash
  return hash;
}