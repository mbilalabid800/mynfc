class ValidationService {
  static String? validateEmail(String email) {
    final trimmedEmail = email.trim();
    final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (trimmedEmail.isEmpty) {
      return 'Email cannot be empty';
    } else if (!emailPattern.hasMatch(trimmedEmail)) {
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
    } else if (trimmedName.length > 25) {
      return 'Must not exceed 25 characters';
    } else if (!regex.hasMatch(trimmedName)) {
      return 'Only letters are allowed in $fieldName';
    }
    return null;
  }

  static String? validateFullName(String fullName, String fieldName) {
    final trimmedName = fullName.trim();
    final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (trimmedName.isEmpty) {
      return '$fieldName cannot be empty';
    } else if (trimmedName.length < 2) {
      return 'Must be at least 2 characters';
    } else if (trimmedName.length > 50) {
      return 'Must not exceed 50 characters';
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
    } else if (trimmedName.length > 25) {
      return 'Must not exceed 25 characters';
    } else if (!regex.hasMatch(trimmedName)) {
      return 'Only letters are allowed in $fieldName';
    }
    return null;
  }

  static String? validateContact(String contact, String fieldName) {
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

  static String? validateCity(String city, String fieldName) {
    final trimmedCity = city.trim();
    final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (trimmedCity.isEmpty) {
      return 'City name cannot be empty';
    } else if (trimmedCity.length < 2) {
      return 'Must be at least 2 characters';
    } else if (trimmedCity.length > 25) {
      return 'Must not exceed 25 characters';
    } else if (!regex.hasMatch(trimmedCity)) {
      return 'Only letters are allowed';
    }
    return null;
  }

  static String? validateCountryName(String country, String fieldName) {
    final trimmedCountry = country.trim();
    final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (trimmedCountry.isEmpty) {
      return 'Country name cannot be empty';
    } else if (trimmedCountry.length < 2) {
      return 'Must be at least 2 characters';
    } else if (trimmedCountry.length > 25) {
      return 'Must not exceed 25 characters';
    } else if (!regex.hasMatch(trimmedCountry)) {
      return 'Only letters are allowed';
    }
    return null;
  }

  static String? validateState(String state, String fieldName) {
    final trimmedState = state.trim();
    final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (trimmedState.isEmpty) {
      return 'State name cannot be empty';
    } else if (trimmedState.length < 2) {
      return 'Must be at least 2 characters';
    } else if (trimmedState.length > 20) {
      return 'Must not exceed 20 characters';
    } else if (!regex.hasMatch(trimmedState)) {
      return 'Only letters are allowed';
    }
    return null;
  }

  static String? validateZipCode(String zipCode, String fieldName) {
    final trimmedZipcode = zipCode.trim();
    final regex = RegExp(r'^[0-9]+$');
    if (trimmedZipcode.isEmpty) {
      return 'Zip Code cannot be empty';
    } else if (trimmedZipcode.length < 2) {
      return 'Must be at least 2 characters';
    } else if (trimmedZipcode.length > 10) {
      return 'Must not exceed 10 characters';
    } else if (!regex.hasMatch(trimmedZipcode)) {
      return 'Only numbers are allowed';
    }
    return null;
  }

  static String? validateLocationTag(String location, String fieldName) {
    final trimmedLocation = location.trim();
    final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (trimmedLocation.isEmpty) {
      return 'Location name cannot be empty';
    } else if (trimmedLocation.length < 2) {
      return 'Must be at least 2 characters';
    } else if (trimmedLocation.length > 25) {
      return 'Must not exceed 25 characters';
    } else if (!regex.hasMatch(trimmedLocation)) {
      return 'Only letters are allowed';
    }
    return null;
  }

  static String? validateDesignation(String designation, String fieldName) {
    final trimmedDesignation = designation.trim();
    final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (trimmedDesignation.isEmpty) {
      return 'Designation cannot be empty';
    } else if (trimmedDesignation.length < 2) {
      return 'Must be at least 2 characters';
    } else if (trimmedDesignation.length > 50) {
      return 'Must not exceed 50 characters';
    } else if (!regex.hasMatch(trimmedDesignation)) {
      return 'Only letters are allowed';
    }
    return null;
  }

  static String? validateCompanyName(String company, String fieldName) {
    final trimmedCompany = company.trim();
    final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (trimmedCompany.isEmpty) {
      return 'Company Name cannot be empty';
    } else if (trimmedCompany.length < 2) {
      return 'Must be at least 2 characters';
    } else if (trimmedCompany.length > 20) {
      return 'Must not exceed 20 characters';
    } else if (!regex.hasMatch(trimmedCompany)) {
      return 'Only letters are allowed';
    }
    return null;
  }
}
