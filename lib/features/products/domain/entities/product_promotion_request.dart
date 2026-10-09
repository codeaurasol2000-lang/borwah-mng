enum ProductPromotionStatus { pending, active, rejected, expired }

class ProductPromotionRequest {
  final String id;
  final String adReference;
  final String productNameAr;
  final String productNameEn;
  final String merchantNameAr;
  final String merchantNameEn;
  final String packageKey;
  final int durationDays;
  final int price;
  final DateTime requestedAt;
  final bool paymentConfirmedByFinance;
  final ProductPromotionStatus status;
  final String? decisionNote;

  const ProductPromotionRequest({
    required this.id,
    required this.adReference,
    required this.productNameAr,
    required this.productNameEn,
    required this.merchantNameAr,
    required this.merchantNameEn,
    required this.packageKey,
    required this.durationDays,
    required this.price,
    required this.requestedAt,
    this.paymentConfirmedByFinance = false,
    this.status = ProductPromotionStatus.pending,
    this.decisionNote,
  });

  ProductPromotionRequest copyWith({
    ProductPromotionStatus? status,
    String? decisionNote,
  }) {
    return ProductPromotionRequest(
      id: id,
      adReference: adReference,
      productNameAr: productNameAr,
      productNameEn: productNameEn,
      merchantNameAr: merchantNameAr,
      merchantNameEn: merchantNameEn,
      packageKey: packageKey,
      durationDays: durationDays,
      price: price,
      requestedAt: requestedAt,
      paymentConfirmedByFinance: paymentConfirmedByFinance,
      status: status ?? this.status,
      decisionNote: decisionNote ?? this.decisionNote,
    );
  }
}
