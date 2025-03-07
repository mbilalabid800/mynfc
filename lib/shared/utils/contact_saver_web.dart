// contact_saver_web.dart
import 'dart:convert';
import 'dart:html' as html;

Future<void> saveContact({
  required String fullName,
  required String phoneNumber,
  required String email,
}) async {
  try {
    final vCardData = '''
BEGIN:VCARD
VERSION:3.0
FN:$fullName
TEL:$phoneNumber
EMAIL:$email
END:VCARD
''';

    final bytes = utf8.encode(vCardData);
    final blob = html.Blob([bytes], 'text/vcard');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement()
      ..href = url
      ..download = '${fullName.replaceAll(' ', '_')}.vcf'
      ..style.display = 'none';

    html.document.body?.append(anchor);
    anchor.click();

    await Future.delayed(const Duration(milliseconds: 500));
    anchor.remove();
    html.Url.revokeObjectUrl(url);
  } catch (e) {
    throw Exception('Web contact save failed: $e');
  }
}
