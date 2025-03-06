import 'dart:convert';
import 'dart:html' as html;

void saveContactWeb({
  required String fullName,
  required String phoneNumber,
  required String email,
}) {
  // 🔹 Create vCard format
  final String vCardData = '''
BEGIN:VCARD
VERSION:3.0
FN:$fullName
TEL:$phoneNumber
EMAIL:$email
END:VCARD
''';

  // 🔹 Convert to bytes
  final List<int> bytes = utf8.encode(vCardData);
  final html.Blob blob = html.Blob([bytes]);

  // 🔹 Create a download link
  final String url = html.Url.createObjectUrlFromBlob(blob);
  final html.AnchorElement anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "$fullName.vcf") // 🔹 File name
    ..style.display = "none"; // 🔹 Hide the element

  html.document.body?.append(anchor); // 🔹 Add to the page
  anchor.click(); // 🔹 Trigger download

  // 🔹 Cleanup
  anchor.remove(); // ✅ Properly remove the element
  html.Url.revokeObjectUrl(url);
}
