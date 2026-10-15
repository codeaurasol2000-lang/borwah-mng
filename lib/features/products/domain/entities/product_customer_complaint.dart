enum ProductComplaintStatus { open, onHold, resolved, escalated, deleted }

class ProductCustomerComplaint {
  final String id;
  final String customerName;
  final String? customerNameEn;
  final String customerPhone;
  final String title;
  final String? titleEn;
  final String description;
  final String? descriptionEn;
  final DateTime submittedAt;
  final String? productName;
  final String? productNameEn;
  final String? productReference;
  final String? productPrice;
  final String? productPriceEn;
  final ProductComplaintStatus status;
  final String? supervisorNote;
  final String? supervisorNoteEn;

  const ProductCustomerComplaint({
    required this.id,
    required this.customerName,
    this.customerNameEn,
    required this.customerPhone,
    required this.title,
    this.titleEn,
    required this.description,
    this.descriptionEn,
    required this.submittedAt,
    this.productName,
    this.productNameEn,
    this.productReference,
    this.productPrice,
    this.productPriceEn,
    this.status = ProductComplaintStatus.open,
    this.supervisorNote,
    this.supervisorNoteEn,
  });

  bool get isProductComplaint => productName != null;
  String customerNameFor(bool isArabic) => isArabic ? customerName : customerNameEn ?? customerName;
  String titleFor(bool isArabic) => isArabic ? title : titleEn ?? title;
  String descriptionFor(bool isArabic) => isArabic ? description : descriptionEn ?? description;
  String? productNameFor(bool isArabic) => isArabic ? productName : productNameEn ?? productName;
  String? noteFor(bool isArabic) => isArabic ? supervisorNote : supervisorNoteEn ?? supervisorNote;

  ProductCustomerComplaint copyWith({
    ProductComplaintStatus? status,
    String? supervisorNote,
    String? supervisorNoteEn,
    String? customerNameEn,
    String? titleEn,
    String? descriptionEn,
    String? productNameEn,
    String? productPriceEn,
  }) => ProductCustomerComplaint(
        id: id,
        customerName: customerName,
        customerNameEn: customerNameEn ?? this.customerNameEn,
        customerPhone: customerPhone,
        title: title,
        titleEn: titleEn ?? this.titleEn,
        description: description,
        descriptionEn: descriptionEn ?? this.descriptionEn,
        submittedAt: submittedAt,
        productName: productName,
        productNameEn: productNameEn ?? this.productNameEn,
        productReference: productReference,
        productPrice: productPrice,
        productPriceEn: productPriceEn ?? this.productPriceEn,
        status: status ?? this.status,
        supervisorNote: supervisorNote ?? this.supervisorNote,
        supervisorNoteEn: supervisorNoteEn ?? this.supervisorNoteEn,
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'customerName': customerName,
        'customerNameEn': customerNameEn,
        'customerPhone': customerPhone,
        'title': title,
        'titleEn': titleEn,
        'description': description,
        'descriptionEn': descriptionEn,
        'submittedAt': submittedAt.toIso8601String(),
        'productName': productName,
        'productNameEn': productNameEn,
        'productReference': productReference,
        'productPrice': productPrice,
        'productPriceEn': productPriceEn,
        'status': status.name,
        'supervisorNote': supervisorNote,
        'supervisorNoteEn': supervisorNoteEn,
      };

  factory ProductCustomerComplaint.fromJson(Map<String, dynamic> json) =>
      ProductCustomerComplaint(
        id: json['id'] as String,
        customerName: json['customerName'] as String,
        customerNameEn: json['customerNameEn'] as String?,
        customerPhone: json['customerPhone'] as String,
        title: json['title'] as String,
        titleEn: json['titleEn'] as String?,
        description: json['description'] as String,
        descriptionEn: json['descriptionEn'] as String?,
        submittedAt: DateTime.parse(json['submittedAt'] as String),
        productName: json['productName'] as String?,
        productNameEn: json['productNameEn'] as String?,
        productReference: json['productReference'] as String?,
        productPrice: json['productPrice'] as String?,
        productPriceEn: json['productPriceEn'] as String?,
        status: ProductComplaintStatus.values.byName(json['status'] as String),
        supervisorNote: json['supervisorNote'] as String?,
        supervisorNoteEn: json['supervisorNoteEn'] as String?,
      );
}
