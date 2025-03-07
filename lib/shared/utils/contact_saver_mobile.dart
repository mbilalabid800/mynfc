import 'package:flutter_contacts/flutter_contacts.dart';

Future<void> saveContact({
  required String fullName,
  required String phoneNumber,
  required String email,
}) async {
  try {
    final Contact newContact = Contact(
      name: Name(first: fullName),
      phones: [Phone(phoneNumber)],
      emails: [Email(email)],
    );

    await FlutterContacts.insertContact(newContact);
  } catch (e) {
    print("Error saving contact: $e");
  }
}
