import 'package:flutter/material.dart';
import 'package:nfc_app/services/firestore_service/pricing_plan_service.dart';

class PlanDetailsScreen extends StatefulWidget {
  final String
      planType; // "For Individual", "For Companies", "For bigger organization"

  const PlanDetailsScreen({super.key, required this.planType});

  @override
  // ignore: library_private_types_in_public_api
  _PlanDetailsScreenState createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends State<PlanDetailsScreen> {
  Map<String, dynamic>? planDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPlanDetails();
  }

  Future<void> loadPlanDetails() async {
    SubscriptionService service = SubscriptionService();
    var details = await service.fetchPlanDetails(widget.planType);
    setState(() {
      planDetails = details;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Plan'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : planDetails == null
              ? Center(child: Text('No Plan Found'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        planDetails!['id'] ?? '',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${planDetails!['pricing']} OMR per user, per year',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 20),
                      ...List.generate(planDetails!['planValues'].length,
                          (index) {
                        return ListTile(
                          leading: Icon(Icons.check, color: Colors.green),
                          title: Text(planDetails!['planValues'][index]),
                        );
                      }),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // Add your booking logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Center(
                          child: Text(
                            'Book a Demo',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
