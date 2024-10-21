// faq_screen.dart
import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/faq_model.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/widgets/custom_app_bar_widget.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<FaqModel> faqs = [];
  List<bool> _isExpandedList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    faqs = ModalRoute.of(context)!.settings.arguments as List<FaqModel>;
    // final List<FaqModel> faqs =
    //     ModalRoute.of(context)!.settings.arguments as List<FaqModel>;
    _isExpandedList = List.generate(faqs.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final List<FaqModel> faqs =
        ModalRoute.of(context)!.settings.arguments as List<FaqModel>;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: const CustomAppBar(
        title: "FAQs",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Text('FAQs',
                  //       style: TextStyle(
                  //           fontSize:
                  //               DeviceDimensions.responsiveSize(context) * 0.08)),
                  // ),
                  Flexible(child: Image.asset('assets/icons/faqimage.png'))
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                return _buildFaqTile(faqs[index], index);
              },
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.03)
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTile(FaqModel faq, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
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
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                _isExpandedList[index]
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              onPressed: () {
                setState(() {
                  _isExpandedList[index] = !_isExpandedList[index];
                });
              },
            ),
          ),
          if (_isExpandedList[index])
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                faq.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          const SizedBox(
              height: 10), // SizedBox for better spacing after each tile
        ],
      ),
    );
  }
}
