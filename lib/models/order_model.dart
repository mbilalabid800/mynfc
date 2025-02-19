class OrderModel {
  final String orderId;
  final String orderPrice;
  final String orderStatus;
  final String selectedPlan;
  final String orderHistory;
  final String shippingMethod;
  final String address;
  final String deliveryDate;
  final String orderDateTime;
  final String cardName;
  final String cardColor;
  final String cardImage;
  final int cardQuantity;
  final String userEmail;
  final String profileType;
  final String userUid;

  OrderModel({
    required this.orderId,
    required this.orderPrice,
    required this.orderStatus,
    required this.selectedPlan,
    required this.orderHistory,
    required this.shippingMethod,
    required this.address,
    required this.deliveryDate,
    required this.orderDateTime,
    required this.cardName,
    required this.cardColor,
    required this.cardImage,
    required this.cardQuantity,
    required this.userEmail,
    required this.profileType,
    required this.userUid,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'orderId': orderId,
      'orderPrice': orderPrice,
      'orderHistory': orderHistory,
      'orderStatus': orderStatus,
      'selectedPlan': selectedPlan,
      'shippingMethod': shippingMethod,
      'address': address,
      'deliveryDate': deliveryDate,
      'orderDateTime': orderDateTime,
      'cardName': cardName,
      'cardColor': cardColor,
      'cardImage': cardImage,
      'quantity': cardQuantity,
      'userEmail': userEmail,
      'profileType': profileType,
      'userUid': userUid,
    };
  }

  factory OrderModel.fromFirestore(Map<String, dynamic> data) {
    return OrderModel(
        orderId: data['orderId'] ?? 'Unknown',
        orderPrice: data['orderPrice'] ?? '0.00',
        orderStatus: data['orderStatus'] ?? 'Unknown',
        selectedPlan: data['selectedPlan'] ?? 'Default',
        shippingMethod: data['shippingMethod'] ?? 'Unknown',
        address: data['address'] ?? 'Unknown',
        orderHistory: data['orderHistory'] ?? 'Unknown',
        deliveryDate: data['deliveryDate'] ?? 'Unknown',
        orderDateTime: data['orderDateTime'] ?? 'Unknown',
        cardName: data['cardName'] ?? 'Unknown',
        cardColor: data['cardColor'] ?? 'Unknown',
        cardImage: data['cardImage'] ?? 'Unknown',
        cardQuantity: data['quantity'] ?? 'Unknown',
        userEmail: data['userEmail'] ?? 'Unknown',
        profileType: data['profileType'] ?? 'Unknown',
        userUid: data['userUid'] ?? 'Unknown');
  }
}
