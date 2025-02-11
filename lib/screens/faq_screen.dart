// faq_screen.dart
import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/faq_model.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<FaqModel> faqs = [];
  //List<bool> _isExpandedList = [];
  int _expandedIndex = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    faqs = ModalRoute.of(context)!.settings.arguments as List<FaqModel>;
    // final List<FaqModel> faqs =
    //     ModalRoute.of(context)!.settings.arguments as List<FaqModel>;
    // _isExpandedList = List.generate(faqs.length, (index) => false);
    faqs = ModalRoute.of(context)!.settings.arguments as List<FaqModel>;
  }

  @override
  Widget build(BuildContext context) {
    final List<FaqModel> faqs =
        ModalRoute.of(context)!.settings.arguments as List<FaqModel>;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: Column(
          children: [
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.0001,
            ),
            AbsherAppBar(
              title: 'FAQs',
              leftButton: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 9),
                    decoration: const BoxDecoration(
                        //color: Color(0xFFFFFFFF),
                        //shape: BoxShape.circle,
                        ),
                    child:
                        Icon(Icons.arrow_back, color: AppColors.appBlueColor)),
              ),
              rightButton: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                    width: DeviceDimensions.screenWidth(context) * 0.035),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
            // SizedBox(
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: Image.asset('assets/icons/faqimage.png'))
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: faqs.length,
                      itemBuilder: (context, index) {
                        return _buildFaqTile(faqs[index], index);
                      },
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.03)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTile(FaqModel faq, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              faq.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.appBlueColor),
            ),
            trailing: IconButton(
              icon: Icon(
                _expandedIndex == index
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                // _isExpandedList[index]
                //     ? Icons.keyboard_arrow_up
                //     : Icons.keyboard_arrow_down,
              ),
              onPressed: () {
                setState(() {
                  _expandedIndex = _expandedIndex == index ? -1 : index;
                });
              },
            ),
          ),
          if (_expandedIndex == index)
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                child: Text(
                  faq.description,
                  style: const TextStyle(
                      fontSize: 16, color: AppColors.appBlueColor),
                ),
              ),
            ),
          SizedBox(
              height: DeviceDimensions.screenHeight(context) *
                  0.01), // SizedBox for better spacing after each tile
        ],
      ),
    );
  }
}
