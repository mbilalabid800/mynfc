import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/employee_model.dart';
import 'package:nfc_app/provider/employee_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/utils/no_back_button_observer.dart';
import 'package:provider/provider.dart';

import '../shared/common_widgets/custom_loader_widget.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => AddEmployeeScreenState();
}

class AddEmployeeScreenState extends State<EmployeeListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeProvider>(context, listen: false)
          .fetchEmployeesFromFirestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    List<EmployeeModel> addedEmployees = employeeProvider.employees;

    return SafeArea(
<<<<<<< HEAD
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: DeviceDimensions.screenHeight(context) * 0.0001,
                ),
                AbsherAppBar(
                  title: 'Employees List',
                  onLeftButtonTap: () {
                    Navigator.pop(context);
                  },
                  rightButton: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                        width: DeviceDimensions.screenWidth(context) * 0.035),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 10),
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
                                Text(
                                  'You have added ${addedEmployees.length} employees in your account.',
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
                              border: Border.all(
                                  width: 1, color: Colors.grey.shade300),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/icons/added.svg"),
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
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: addedEmployees.length,
                                          itemBuilder: (context, index) {
                                            final employee =
                                                addedEmployees[index];
                                            return ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              title: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '${index + 1}.',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              'Barlow-Bold',
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
                                                          fontFamily:
                                                              'Barlow-Bold',
                                                          color: AppColors
                                                              .textColorBlue,
                                                          fontSize: 17),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 60),
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
                          SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Loader Overlay
            if (employeeProvider.isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.white54,
                  child: Center(
                    child: DualRingLoader(),
                  ),
                ),
              ),
          ],
=======
      child: GlobalBackButtonHandler(
        child: Scaffold(
          backgroundColor: AppColors.screenBackground,
          body: Column(
            children: [
              SizedBox(
                height: DeviceDimensions.screenHeight(context) * 0.0001,
              ),
              AbsherAppBar(
                title: 'Employees List',
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
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 40),
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
                              Text(
                                'You have added ${addedEmployees.length} employees in your account.',
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
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3.0),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/icons/added.svg"),
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
                                          final employee =
                                              addedEmployees[index];
                                          return ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${index + 1}.',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            'Barlow-Bold',
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
                                                        fontFamily:
                                                            'Barlow-Bold',
                                                        color: AppColors
                                                            .textColorBlue,
                                                        fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 60),
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
>>>>>>> 46fbcb408323d4f285404608f8dee62760a6aa41
        ),
      ),
    );
  }
}
