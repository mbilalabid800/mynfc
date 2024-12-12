// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/employee_model.dart';
import 'package:nfc_app/provider/employee_provider.dart';
import 'package:nfc_app/widgets/add_employee_widget.dart';
import 'package:nfc_app/widgets/custom_snackbar_widget.dart';
import 'package:provider/provider.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => AddEmployeeState();
}

class AddEmployeeState extends State<AddEmployee> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<EmployeeModel> addedEmployees = [];

  @override
  void initState() {
    super.initState();
    loadAddedEmployees();
  }

  Future<void> loadAddedEmployees() async {
    final employeeProvider =
        Provider.of<EmployeeProvider>(context, listen: false);
    final employees = await employeeProvider.getLocalEmployees();
    setState(() {
      addedEmployees = employees;
    });
  }

  void submitForm() async {
    if (formKey.currentState!.validate()) {
      final employee = EmployeeModel(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        designation: designationController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );

      try {
        await Provider.of<EmployeeProvider>(context, listen: false)
            .addEmployeeToLocal(employee);
        setState(() {
          addedEmployees.add(employee);
        });
        CustomSnackbar().snakBarMessage(context, 'Employee added locally!');

        // Clear form fields
        firstNameController.clear();
        lastNameController.clear();
        designationController.clear();
        emailController.clear();
        phoneController.clear();
      } catch (e) {
        CustomSnackbar().snakBarError(context, 'Failed to add employee: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 239, 239, 239),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  ' Add Your Company Employee',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Barlow-Bold'),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(251, 243, 205, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/info-circle.svg',
                            // ignore: deprecated_member_use
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Note',
                            style: TextStyle(
                                color: AppColors.textColorBlue,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Barlow-Bold',
                                fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'You can add up to 20 employees in your account.',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontFamily: 'Barlow-Regular'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(width: 1, color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/icons/added.svg"),
                              const SizedBox(width: 5),
                              const Text(
                                'Employee Added',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Barlow-Regular'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        addedEmployees.isEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  'No employees added yet.',
                                  style: TextStyle(
                                    fontFamily: 'Barlow-Regular',
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: addedEmployees.length,
                                itemBuilder: (context, index) {
                                  final employee = addedEmployees[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${index + 1}.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Barlow-Bold',
                                                fontSize: 17),
                                          ),
                                          const SizedBox(width: 30),
                                          Text(
                                            "${employee.firstName} ${employee.lastName}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Barlow-Bold',
                                                fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(left: 60),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "• ${employee.email}",
                                            style: TextStyle(
                                                color: AppColors.textColorBlue,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Barlow-Regular',
                                                fontSize: 15),
                                          ),
                                          Text(
                                            "• ${employee.phone}",
                                            style: TextStyle(
                                                color: AppColors.textColorBlue,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Barlow-Regular',
                                                fontSize: 15),
                                          ),
                                          Text(
                                            "• ${employee.designation}",
                                            style: TextStyle(
                                                color: AppColors.textColorBlue,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Barlow-Regular',
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(width: 1, color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Column(
                      children: [
                        const Text(
                          'Add Your Employees Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Barlow-Regular',
                              fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 10),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              AddEmployeeWidget(
                                  title: ' First Name',
                                  errorMessage: 'First Name',
                                  controller: firstNameController),
                              const SizedBox(height: 20),
                              AddEmployeeWidget(
                                title: ' Last Name',
                                errorMessage: 'Last Name',
                                controller: lastNameController,
                              ),
                              const SizedBox(height: 20),
                              AddEmployeeWidget(
                                title: ' Designation',
                                errorMessage: 'Designation',
                                controller: designationController,
                              ),
                              const SizedBox(height: 20),
                              AddEmployeeWidget(
                                  title: ' Email',
                                  errorMessage: 'Email',
                                  controller: emailController),
                              const SizedBox(height: 20),
                              AddEmployeeWidget(
                                title: ' Mobile Phone',
                                errorMessage: 'Mobile Phone',
                                controller: phoneController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: submitForm,
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.buttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  'Add Employee',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/card-details');
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
