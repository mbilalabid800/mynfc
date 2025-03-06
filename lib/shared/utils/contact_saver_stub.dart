import 'contact_saver_stub.dart'
    if (dart.library.html) 'contact_saver_web.dart'
    if (dart.library.io) 'contact_saver_mobile.dart';

void saveContact({
  required String fullName,
  required String phoneNumber,
  required String email,
}) {}
