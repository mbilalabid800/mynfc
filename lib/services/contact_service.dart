// lib/services/contact_service.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as mobile;
import 'package:universal_html/html.dart' as web;

class ContactService {
  static Future<void> saveContact({
    required String fullName,
    required String phoneNumber,
    required String email,
  }) async {
    if (kIsWeb) {
      await _saveContactWeb(fullName, phoneNumber, email);
    } else {
      await _saveContactMobile(fullName, phoneNumber, email);
    }
  }

  static Future<void> _saveContactWeb(
    String fullName,
    String phoneNumber,
    String email,
  ) async {
    try {
      final vCard = '''
BEGIN:VCARD
VERSION:3.0
FN:$fullName
TEL:$phoneNumber
EMAIL:$email
END:VCARD''';

      final bytes = utf8.encode(vCard);
      final blob = web.Blob([bytes], 'text/vcard');
      final url = web.Url.createObjectUrlFromBlob(blob);
      final anchor = web.AnchorElement()
        ..href = url
        ..download = '${fullName.replaceAll(' ', '_')}.vcf'
        ..style.display = 'none';

      web.document.body?.append(anchor);
      anchor.click();
      await Future.delayed(const Duration(milliseconds: 500));
      anchor.remove();
      web.Url.revokeObjectUrl(url);
    } catch (e) {
      throw Exception('Web contact save failed: $e');
    }
  }

  static Future<void> _saveContactMobile(
    String fullName,
    String phoneNumber,
    String email,
  ) async {
    try {
      final contact = mobile.Contact()
        ..name = mobile.Name(first: fullName)
        ..phones = [mobile.Phone(phoneNumber)]
        ..emails = [mobile.Email(email)];

      await contact.insert();
    } on Exception catch (e) {
      throw Exception('Mobile contact save failed: $e');
    }
  }
}
