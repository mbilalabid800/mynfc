class OrderModel {
  final String orderId;
  final String orderPrice;
  final String orderStatus;
  final String shippingMethod;
  final String address;
  final String deliveryDate;
  final String orderDateTime;
  final String cardName;
  final String cardColor;
  final String cardImage;
  final String userEmail;
  final String userUid;

  OrderModel({
    required this.orderId,
    required this.orderPrice,
    required this.orderStatus,
    required this.shippingMethod,
    required this.address,
    required this.deliveryDate,
    required this.orderDateTime,
    required this.cardName,
    required this.cardColor,
    required this.cardImage,
    required this.userEmail,
    required this.userUid,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'orderId': orderId,
      'orderPrice': orderPrice,
      'orderStatus': orderStatus,
      'shippingMethod': shippingMethod,
      'address': address,
      'deliveryDate': deliveryDate,
      'orderDateTime': orderDateTime,
      'cardName': cardName,
      'cardColor': cardColor,
      'cardImage': cardImage,
      'userEmail': userEmail,
      'userUid': userUid,
    };
  }

  factory OrderModel.fromFirestore(Map<String, dynamic> data) {
    return OrderModel(
        orderId: data['orderId'],
        orderPrice: data['orderPrice'],
        orderStatus: data['orderStatus'],
        shippingMethod: data['shippingMethod'],
        address: data['address'],
        deliveryDate: data['deliveryDate'],
        orderDateTime: data['orderDateTime'],
        cardName: data['cardName'],
        cardColor: data['cardColor'],
        cardImage: data['cardImage'],
        userEmail: data['userEmail'],
        userUid: data['userUid']);
  }
}
