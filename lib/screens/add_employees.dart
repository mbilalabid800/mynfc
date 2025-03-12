// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/employee_model.dart';
import 'package:nfc_app/provider/employee_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';

import 'package:nfc_app/widgets/add_employee_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_snackbar_widget.dart';
import 'package:provider/provider.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => AddEmployeeScreenState();
}

class AddEmployeeScreenState extends State<AddEmployeeScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final int maxEmployees = 20;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    Provider.of<EmployeeProvider>(context, listen: false).getLocalEmployees();
    firstNameController.addListener(checkFields);
    lastNameController.addListener(checkFields);
    designationController.addListener(checkFields);
    emailController.addListener(checkFields);
    phoneController.addListener(checkFields);
  }

  void checkFields() {
    bool allFieldsFilled = firstNameController.text.trim().isNotEmpty &&
        lastNameController.text.trim().isNotEmpty &&
        designationController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        phoneController.text.trim().isNotEmpty;

    if (isButtonEnabled != allFieldsFilled) {
      // Only update if there's a change
      setState(() {
        isButtonEnabled = allFieldsFilled;
      });
    }
  }

  List<EmployeeModel> get addedEmployees =>
      context.watch<EmployeeProvider>().employeesLocal;

  void submitForm() async {
    if (!formKey.currentState!.validate()) {
      return; // Stop execution if validation fails
    }

    final employee = EmployeeModel(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      designation: designationController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
    );

    try {
      await Provider.of<EmployeeProvider>(context, listen: false)
          .addEmployeeToLocal(context, employee);
      setState(() {});
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

  // void submitForm() async {
  //   if (formKey.currentState!.validate()) {
  //     final employee = EmployeeModel(
  //       firstName: firstNameController.text.trim(),
  //       lastName: lastNameController.text.trim(),
  //       designation: designationController.text.trim(),
  //       email: emailController.text.trim(),
  //       phone: phoneController.text.trim(),
  //     );

  //     try {
  //       await Provider.of<EmployeeProvider>(context, listen: false)
  //           .addEmployeeToLocal(context, employee);
  //       setState(() {});
  //       CustomSnackbar().snakBarMessage(context, 'Employee added locally!');

  //       // Clear form fields
  //       firstNameController.clear();
  //       lastNameController.clear();
  //       designationController.clear();
  //       emailController.clear();
  //       phoneController.clear();
  //     } catch (e) {
  //       CustomSnackbar().snakBarError(context, 'Failed to add employee: $e');
  //     }
  //   }
  // }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    designationController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final selectedCard = args?['selectedCard'];
    final selectedColorOption = args?['selectedColorOption'];
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: Column(
          children: [
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.0001,
            ),
            AbsherAppBar3(
              title: 'Add Your Employees',
              onLeftButtonTap: () {
                Navigator.pop(context);
              },
              rightButton: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                    width: DeviceDimensions.screenWidth(context) * 0.035),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
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
                          border:
                              Border.all(width: 1, color: Colors.grey.shade300),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
                                child: Row(
                                  children: [
                                    SvgPicture.asset("assets/icons/added.svg"),
                                    const SizedBox(width: 5),
                                    const Text(
                                      'Employee Added',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textColorBlue,
                                          fontFamily: 'Barlow-Regular'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              addedEmployees.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Barlow-Bold',
                                                      color: AppColors
                                                          .textColorBlue,
                                                      fontSize: 17),
                                                ),
                                                const SizedBox(width: 30),
                                                Text(
                                                  "${employee.firstName} ${employee.lastName}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Barlow-Bold',
                                                      color: AppColors
                                                          .textColorBlue,
                                                      fontSize: 17),
                                                ),
                                              ],
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 60),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "• ${employee.email}",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .textColorBlue,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'Barlow-Regular',
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  "• ${employee.phone}",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .textColorBlue,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'Barlow-Regular',
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  "• ${employee.designation}",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .textColorBlue,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'Barlow-Regular',
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
                          border:
                              Border.all(width: 1, color: Colors.grey.shade300),
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
                                    color: AppColors.textColorBlue,
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
                                      title: 'First Name',
                                      errorMessage: 'First Name',
                                      controller: firstNameController,
                                    ),
                                    const SizedBox(height: 20),
                                    AddEmployeeWidget(
                                      title: 'Last Name',
                                      errorMessage: 'Last Name',
                                      controller: lastNameController,
                                    ),
                                    const SizedBox(height: 20),
                                    AddEmployeeWidget(
                                      title: 'Designation',
                                      errorMessage: 'Designation',
                                      controller: designationController,
                                    ),
                                    const SizedBox(height: 20),
                                    AddEmployeeWidget(
                                      title: 'Email',
                                      errorMessage: 'Email',
                                      controller: emailController,
                                    ),
                                    const SizedBox(height: 20),
                                    AddEmployeeWidget(
                                      title: 'Contact',
                                      errorMessage: 'Contact',
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
                                    //onPressed: submitForm,
                                    onPressed:
                                        isButtonEnabled ? submitForm : null,
                                    style: TextButton.styleFrom(
                                      backgroundColor: isButtonEnabled
                                          ? AppColors.appBlueColor
                                          : Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
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
                            onPressed: addedEmployees.isNotEmpty
                                ? () {
                                    Navigator.pushNamed(
                                      context,
                                      '/place-order-screen',
                                      arguments: {
                                        'selectedCard': selectedCard,
                                        'selectedColorOption':
                                            selectedColorOption,
                                      },
                                    );
                                  }
                                : null, //Disable the button if no employees added
                            style: TextButton.styleFrom(
                              backgroundColor: addedEmployees.isNotEmpty
                                  ? Colors.green
                                  : Colors.grey,
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
          ],
        ),
      ),
    );
  }
}
