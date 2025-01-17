class ValidationService {
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return null;
    }
    final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailPattern.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validateName(String name, String fieldName) {
    final trimmedName = name.trim();
    final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (trimmedName.isEmpty) {
      return '$fieldName cannot be empty';
    } else if (trimmedName.length < 2) {
      return '$fieldName must be at least 2 characters';
    } else if (trimmedName.length > 20) {
      return '$fieldName must not exceed 20 characters';
    } else if (!regex.hasMatch(trimmedName)) {
      return 'Only letters are allowed in $fieldName';
    }
    return null;
  }

  static String? validateContact(String contact) {
    final regex = RegExp(r'^[0-9]+$');
    if (contact.startsWith(' ')) {
      return 'Contact cannot start with a space';
    } else if (contact.isEmpty) {
      return 'Contact cannot be empty';
    } else if (!regex.hasMatch(contact)) {
      return 'Contact must be numbers only';
    }
    return null;
  }

  static String? validateWebsite(String websiteLink) {
    final regex = RegExp(
        r'^(www\.)[a-zA-Z0-9\-]+\.[a-zA-Z]{2,10}(\/[a-zA-Z0-9\-_\/]*)?$');
    if (!regex.hasMatch(websiteLink)) {
      return 'Please enter a valid website URL';
    }
    return null;
  }

  static String? validateCity(String city) {
    final trimmedCity = city.trim();
    final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (trimmedCity.isEmpty) {
      return 'City name cannot be empty';
    } else if (trimmedCity.length < 2) {
      return 'City name must be at least 2 characters';
    } else if (trimmedCity.length > 20) {
      return 'City name must not exceed 20 characters';
    } else if (!regex.hasMatch(trimmedCity)) {
      return 'Only letters are allowed';
    }
    return null;
  }
}
