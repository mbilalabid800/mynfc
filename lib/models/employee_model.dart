class EmployeeModel {
  final String firstName;
  final String lastName;
  final String designation;
  final String email;
  final String phone;

  EmployeeModel({
    required this.firstName,
    required this.lastName,
    required this.designation,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'designation': designation,
      'email': email,
      'phone': phone,
    };
  }

  factory EmployeeModel.fromFirestore(Map<String, dynamic> json) {
    return EmployeeModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      designation: json['designation'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
