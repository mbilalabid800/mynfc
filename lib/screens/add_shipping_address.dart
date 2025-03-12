// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/shipping_address_model.dart';
import 'package:nfc_app/provider/shipping_address_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/validation_service.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_snackbar_widget.dart';

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
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);

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
      _firstNameController.addListener(_validateForm);
      _lastNameController.addListener(_validateForm);
      _locationNameController.addListener(_validateForm);
      _phoneController.addListener(_validateForm);
      _countryController.addListener(_validateForm);
      _stateController.addListener(_validateForm);
      _zipCodeController.addListener(_validateForm);
    });
  }

  void _validateForm() {
    isButtonEnabled.value = _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _locationNameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _countryController.text.isNotEmpty &&
        _stateController.text.isNotEmpty &&
        _zipCodeController.text.isNotEmpty;
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
    //_phoneController.text = userProvider.contact;
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

  Future<void> _saveShippingAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);

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
      CustomSnackbar().snakBarMessage(context, 'Address updated successfully!');
      Navigator.pop(context);
    } catch (e) {
      CustomSnackbar().snakBarError(context, 'Error saving address: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
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
            AbsherAppBar3(
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
                                fieldType: FieldType.firstName,
                              ),
                              textfield(
                                context,
                                "*Last name",
                                _lastNameController,
                                fieldType: FieldType.lastName,
                              ),
                              textfield(
                                context,
                                "*Location e.g. Home, Office",
                                _locationNameController,
                                fieldType: FieldType.location,
                              ),
                              textfield(
                                context,
                                "Company (optional)",
                                _companyController,
                                optional: true,
                                fieldType: FieldType.company,
                              ),
                              textfield(
                                context,
                                "*Phone",
                                _phoneController,
                                isPhoneField: true,
                                fieldType: FieldType.contact,
                              ),
                              textfield(
                                context,
                                "*Country",
                                _countryController,
                                fieldType: FieldType.country,
                              ),
                              textfield(
                                context,
                                "Street address*",
                                _streetAddressController,
                                fieldType: FieldType.street,
                              ),
                              textfield(
                                context,
                                "Apartment, suite, unit, etc (optional)",
                                _apartmentController,
                                fieldType: FieldType.apartment,
                              ),
                              textfield(
                                context,
                                "City / Town*",
                                _cityController,
                                fieldType: FieldType.city,
                              ),
                              textfield(
                                context,
                                "State*",
                                _stateController,
                                fieldType: FieldType.state,
                              ),
                              textfield(
                                context,
                                "Zip code*",
                                _zipCodeController,
                                fieldType: FieldType.zipCode,
                              ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.040),
                              ValueListenableBuilder<bool>(
                                valueListenable: isButtonEnabled,
                                builder: (context, isEnabled, child) {
                                  return SizedBox(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.058,
                                    width:
                                        DeviceDimensions.screenWidth(context) *
                                            0.85,
                                    child: ElevatedButton(
                                      onPressed: isEnabled
                                          ? _saveShippingAddress
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isEnabled
                                            ? AppColors.appBlueColor
                                            : Colors.grey,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        "Save shipping address",
                                        style: TextStyle(
                                          fontSize:
                                              DeviceDimensions.responsiveSize(
                                                      context) *
                                                  0.048,
                                          fontFamily: 'Barlow-Regular',
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                },
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

  Widget textfield(
    BuildContext context,
    String hintText,
    TextEditingController controller, {
    bool optional = false,
    bool isPhoneField = false,
    required FieldType fieldType,
    void Function(String, String, String)? onPhoneChanged,
  }) {
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
              child: isPhoneField
                  ? IntlPhoneField(
                      controller: controller,
                      showDropdownIcon: true,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(
                          fontFamily: 'Barlow-Regular',
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.040,
                          fontWeight: FontWeight.w500,
                        ),
                        errorStyle: const TextStyle(fontSize: 0, height: 0),
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                      initialCountryCode: 'OM',
                      validator: (value) =>
                          _validateField(value?.number ?? '', fieldType),
                      onChanged: (phone) {
                        if (onPhoneChanged != null) {
                          onPhoneChanged(phone.completeNumber,
                              phone.countryCode, phone.countryISOCode);
                        }
                      },
                    )
                  : TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(
                          fontFamily: 'Barlow-Regular',
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.040,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        errorStyle: const TextStyle(fontSize: 0, height: 0),
                      ),
                      validator: (value) =>
                          _validateField(value ?? '', fieldType),
                    ),
            ),
          ),
          // Error message container
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              final error = _validateField(value.text, fieldType);
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: error != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 4.0, left: 8),
                        child: Text(
                          error,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      )
                    : const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }

  String? _validateField(String value, FieldType fieldType) {
    if (value.isEmpty) {
      return null; // Let required fields be handled by the '*' in the hint
    }

    switch (fieldType) {
      case FieldType.firstName:
        return ValidationService.validateFirstName(value, "First Name");
      case FieldType.lastName:
        return ValidationService.validateLastName(value, "Last Name");
      case FieldType.location:
        return ValidationService.validateLocationTag(value, "Location");
      case FieldType.contact:
        return ValidationService.validateContact(value, 'Phone');
      case FieldType.country:
        return ValidationService.validateCountryName(value, "Country");
      case FieldType.city:
        return ValidationService.validateCity(value, "City");
      case FieldType.state:
        return ValidationService.validateState(value, "State");
      case FieldType.zipCode:
        return ValidationService.validateZipCode(value, "Zip Code");
      default:
        return null;
    }
  }
}

enum FieldType {
  firstName,
  lastName,
  location,
  company,
  contact,
  country,
  street,
  apartment,
  city,
  state,
  zipCode,
}
