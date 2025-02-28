// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/shipping_address_model.dart';
import 'package:nfc_app/provider/shipping_address_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';

import 'package:provider/provider.dart';

class AddShippingAddress extends StatefulWidget {
  const AddShippingAddress({super.key});

  @override
  State<AddShippingAddress> createState() => _AddShippingAddressState();
}

class _AddShippingAddressState extends State<AddShippingAddress> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _locationNameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _streetAddressController =
      TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load shipping address if passed in arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shippingAddress =
          ModalRoute.of(context)?.settings.arguments as ShippingAddressModel?;

      if (shippingAddress != null) {
        _loadShippingAddress(shippingAddress); // Load the address
      } else if (Provider.of<ShippingAddressProvider>(context, listen: false)
          .shippingAddress
          .isEmpty) {
        _loadUserData();
      }
    });
  }

  Future<void> _loadShippingAddress(
      ShippingAddressModel shippingAddress) async {
    try {
      setState(() {
        isLoading = true; // Start loading before data population
      });

      // Prefill the text controllers with the loaded data
      _firstNameController.text = shippingAddress.firstName;
      _lastNameController.text = shippingAddress.lastName;
      _locationNameController.text = shippingAddress.locationName;
      _companyController.text = shippingAddress.company ?? '';
      _phoneController.text = shippingAddress.phone;
      _countryController.text = shippingAddress.country;
      _streetAddressController.text = shippingAddress.streetAddress;
      _apartmentController.text = shippingAddress.apartment ?? '';
      _cityController.text = shippingAddress.city;
      _stateController.text = shippingAddress.state;
      _zipCodeController.text = shippingAddress.zipCode;
    } catch (e) {
      // Handle any errors during the loading process (e.g., show a Snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading shipping address: $e')),
      );
    } finally {
      // Set loading to false after data is loaded or in case of an error
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });

    // Get user data from userProvider
    final userProvider =
        Provider.of<UserInfoFormStateProvider>(context, listen: false);

    // Populate the controllers with user data
    _firstNameController.text = userProvider.firstName;
    _lastNameController.text = userProvider.lastName;
    _companyController.text = userProvider.companyName;
    _phoneController.text = userProvider.contact;
    _countryController.text = userProvider.countryName;
    _cityController.text = userProvider.city;

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _locationNameController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _streetAddressController.dispose();
    _apartmentController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  // Error messages for each field
  String? firstNameError;
  String? lastNameError;
  String? locationNameError;
  String? phoneError;
  String? countryError;
  String? streetAddressError;
  String? cityError;
  String? stateError;
  String? zipCodeError;

  Future<void> _saveShippingAddress() async {
    // Reset error messages
    firstNameError = null;
    lastNameError = null;
    locationNameError = null;
    phoneError = null;
    countryError = null;
    streetAddressError = null;
    cityError = null;
    stateError = null;
    zipCodeError = null;

    bool isValid = true;

    // Validate each field
    if (_firstNameController.text.isEmpty) {
      firstNameError = "Please enter first name";
      isValid = false;
    }
    if (_lastNameController.text.isEmpty) {
      lastNameError = "Please enter last name";
      isValid = false;
    }
    if (_locationNameController.text.isEmpty) {
      locationNameError = "Please enter location name";
      isValid = false;
    }
    if (_phoneController.text.isEmpty) {
      phoneError = "Please enter phone";
      isValid = false;
    }
    if (_countryController.text.isEmpty) {
      countryError = "Please select country";
      isValid = false;
    }
    if (_streetAddressController.text.isEmpty) {
      streetAddressError = "Please enter street address";
      isValid = false;
    }
    if (_cityController.text.isEmpty) {
      cityError = "Please enter city";
      isValid = false;
    }
    if (_stateController.text.isEmpty) {
      stateError = "Please enter state";
      isValid = false;
    }
    if (_zipCodeController.text.isEmpty) {
      zipCodeError = "Please enter zip code";
      isValid = false;
    }

    // If any field is invalid, show the error messages
    if (!isValid) {
      setState(() {}); // Trigger UI update to show errors
      return; // Stop execution if validation fails
    }

    setState(() {
      isLoading = true; // Show the loader when saving starts
    });

    final shippingAddress = ShippingAddressModel(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      locationName: _locationNameController.text,
      company: _companyController.text.isEmpty ? null : _companyController.text,
      phone: _phoneController.text,
      country: _countryController.text,
      streetAddress: _streetAddressController.text,
      apartment:
          _apartmentController.text.isEmpty ? null : _apartmentController.text,
      city: _cityController.text,
      state: _stateController.text,
      zipCode: _zipCodeController.text,
    );

    try {
      final shippingAddressProvider =
          Provider.of<ShippingAddressProvider>(context, listen: false);
      await shippingAddressProvider.saveShippingAddress(shippingAddress);
    } catch (e) {
      // Optionally, handle save errors here.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving shipping address: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false; // Hide the loader after saving
        });
      }
    }

    // Ensure the widget is mounted before popping context
    if (mounted) {
      Navigator.pop(context); // Close the form after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: Column(
          children: [
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.0001,
            ),
            AbsherAppBar(
              title: 'Add Shipping Address',
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
              child: Center(
                child: Container(
                  width: DeviceDimensions.screenWidth(context) * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.010),
                              textfield(
                                context,
                                "*First name",
                                _firstNameController,
                                firstNameError,
                              ),
                              textfield(
                                context,
                                "*Last name",
                                _lastNameController,
                                lastNameError,
                              ),
                              textfield(
                                context,
                                "*Location e.g. Home, Office",
                                _locationNameController,
                                locationNameError,
                              ),
                              textfield(
                                context,
                                "Company (optional)",
                                _companyController,
                                null,
                                optional: true,
                              ),
                              textfield(
                                context,
                                "*Phone",
                                _phoneController,
                                phoneError,
                              ),
                              textfield(
                                context,
                                "*Country",
                                _countryController,
                                countryError,
                              ),
                              textfield(
                                context,
                                "*Street address",
                                _streetAddressController,
                                streetAddressError,
                              ),
                              textfield(
                                context,
                                "Apartment, suite, unit, etc (optional)",
                                _apartmentController,
                                null,
                                optional: true,
                              ),
                              textfield(
                                context,
                                "*City / Town",
                                _cityController,
                                cityError,
                              ),
                              textfield(
                                context,
                                "*State",
                                _stateController,
                                stateError,
                              ),
                              textfield(
                                context,
                                "*Zip code",
                                _zipCodeController,
                                zipCodeError,
                              ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.040),
                              SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.058,
                                width: DeviceDimensions.screenWidth(context) *
                                    0.85,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await _saveShippingAddress(); // Call your save method
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.appBlueColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    "Save shipping address",
                                    style: TextStyle(
                                      fontSize: DeviceDimensions.responsiveSize(
                                              context) *
                                          0.048,
                                      fontFamily: 'Barlow-Regular',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.030),
                            ],
                          ),
                        ),
                      ),
                      if (isLoading)
                        // Show loader on top when loading
                        Container(
                          color: Colors.white54,
                          child: const Center(
                            child: DualRingLoader(),
                          ),
                        ),
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

  Padding textfield(BuildContext context, String hintText,
      TextEditingController controller, String? errorText,
      {bool optional = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1.5, color: const Color(0xFFD9D9D9)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                      fontFamily: 'Barlow-Regular',
                      fontSize:
                          DeviceDimensions.responsiveSize(context) * 0.039),
                  border: InputBorder.none,
                  errorStyle: const TextStyle(color: Colors.red),
                ),
                validator: (value) {
                  if (!optional && (value == null || value.isEmpty)) {
                    return errorText;
                  }
                  return null; // No error
                },
              ),
            ),
          ),
          // Display error text outside the TextFormField
          if (errorText != null && errorText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 8),
              child: Text(
                errorText,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
