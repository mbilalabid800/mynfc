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

  static String? validateFirstName(String firstName, String fieldName) {
    final trimmedName = firstName.trim();
    final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (trimmedName.isEmpty) {
      return '$fieldName cannot be empty';
    } else if (trimmedName.length < 2) {
      return 'Must be at least 2 characters';
    } else if (trimmedName.length > 20) {
      return 'Must not exceed 20 characters';
    } else if (!regex.hasMatch(trimmedName)) {
      return 'Only letters are allowed in $fieldName';
    }
    return null;
  }

  static String? validateLastName(String lastName, String fieldName) {
    final trimmedName = lastName.trim();
    final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (trimmedName.isEmpty) {
      return '$fieldName cannot be empty';
    } else if (trimmedName.length < 2) {
      return 'Must be at least 2 characters';
    } else if (trimmedName.length > 20) {
      return 'Must not exceed 20 characters';
    } else if (!regex.hasMatch(trimmedName)) {
      return 'Only letters are allowed in $fieldName';
    }
    return null;
  }

  static String? validateContact(String contact) {
    if (contact.startsWith(' ')) {
      return 'Contact cannot start with a space';
    } else if (contact.isEmpty) {
      return 'Contact cannot be empty';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(contact)) {
      return 'Contact must contain only numbers';
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
      return 'Must be at least 2 characters';
    } else if (trimmedCity.length > 20) {
      return 'Must not exceed 20 characters';
    } else if (!regex.hasMatch(trimmedCity)) {
      return 'Only letters are allowed';
    }
    return null;
  }

  static String? validateDesignation(String designation) {
    final trimmedDesignation = designation.trim();
    final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (trimmedDesignation.isEmpty) {
      return 'Designation cannot be empty';
    } else if (trimmedDesignation.length < 2) {
      return 'Must be at least 2 characters';
    } else if (trimmedDesignation.length > 20) {
      return 'Must not exceed 20 characters';
    } else if (!regex.hasMatch(trimmedDesignation)) {
      return 'Only letters are allowed';
    }
    return null;
  }
}
