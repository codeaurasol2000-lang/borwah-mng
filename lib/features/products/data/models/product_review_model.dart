import '../../domain/entities/product_review.dart';

class ProductReviewModel extends ProductReview {
  const ProductReviewModel({
    required super.id,
    required super.reference,
    required super.titleAr,
    required super.titleEn,
    required super.merchantNameAr,
    required super.merchantNameEn,
    required super.category,
    super.condition,
    required super.imageKind,
    required super.photoCount,
    required super.receivedMinutesAgo,
    required super.priceAr,
    required super.priceEn,
    super.descriptionAr,
    super.descriptionEn,
    super.status,
    super.decisionNote,
    super.isFeatured,
    super.merchantNotificationRequested,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    T enumValue<T extends Enum>(List<T> values, Object? value) {
      if (value is! String) {
        throw const FormatException('Stored product review enum is invalid.');
      }
      return values.byName(value);
    }

    final requiredStrings = [
      'id',
      'reference',
      'titleAr',
      'titleEn',
      'merchantNameAr',
      'merchantNameEn',
      'priceAr',
      'priceEn',
    ];
    if (requiredStrings.any((key) => json[key] is! String) ||
        json['photoCount'] is! int ||
        json['receivedMinutesAgo'] is! int ||
        json['isFeatured'] is! bool ||
        json['merchantNotificationRequested'] is! bool) {
      throw const FormatException('Stored product review is invalid.');
    }
    return ProductReviewModel(
      id: json['id'] as String,
      reference: json['reference'] as String,
      titleAr: json['titleAr'] as String,
      titleEn: json['titleEn'] as String,
      merchantNameAr: json['merchantNameAr'] as String,
      merchantNameEn: json['merchantNameEn'] as String,
      category: enumValue(ProductCategory.values, json['category']),
      condition: enumValue(ProductCondition.values, json['condition']),
      imageKind: enumValue(ProductImageKind.values, json['imageKind']),
      photoCount: json['photoCount'] as int,
      receivedMinutesAgo: json['receivedMinutesAgo'] as int,
      priceAr: json['priceAr'] as String,
      priceEn: json['priceEn'] as String,
      descriptionAr: json['descriptionAr'] as String? ?? '',
      descriptionEn: json['descriptionEn'] as String? ?? '',
      status: enumValue(ProductReviewStatus.values, json['status']),
      decisionNote: json['decisionNote'] as String?,
      isFeatured: json['isFeatured'] as bool,
      merchantNotificationRequested:
          json['merchantNotificationRequested'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'reference': reference,
        'titleAr': titleAr,
        'titleEn': titleEn,
        'merchantNameAr': merchantNameAr,
        'merchantNameEn': merchantNameEn,
        'category': category.name,
        'condition': condition.name,
        'imageKind': imageKind.name,
        'photoCount': photoCount,
        'receivedMinutesAgo': receivedMinutesAgo,
        'priceAr': priceAr,
        'priceEn': priceEn,
        'descriptionAr': descriptionAr,
        'descriptionEn': descriptionEn,
        'status': status.name,
        'decisionNote': decisionNote,
        'isFeatured': isFeatured,
        'merchantNotificationRequested': merchantNotificationRequested,
      };

  factory ProductReviewModel.fromEntity(ProductReview entity) {
    return ProductReviewModel(
      id: entity.id,
      reference: entity.reference,
      titleAr: entity.titleAr,
      titleEn: entity.titleEn,
      merchantNameAr: entity.merchantNameAr,
      merchantNameEn: entity.merchantNameEn,
      category: entity.category,
      condition: entity.condition,
      imageKind: entity.imageKind,
      photoCount: entity.photoCount,
      receivedMinutesAgo: entity.receivedMinutesAgo,
      priceAr: entity.priceAr,
      priceEn: entity.priceEn,
      descriptionAr: entity.descriptionAr,
      descriptionEn: entity.descriptionEn,
      status: entity.status,
      decisionNote: entity.decisionNote,
      isFeatured: entity.isFeatured,
      merchantNotificationRequested: entity.merchantNotificationRequested,
    );
  }

  @override
  ProductReviewModel copyWith({
    ProductCategory? category,
    ProductCondition? condition,
    String? priceAr,
    String? priceEn,
    String? descriptionAr,
    String? descriptionEn,
    ProductReviewStatus? status,
    String? decisionNote,
    bool clearDecisionNote = false,
    bool? isFeatured,
    bool? merchantNotificationRequested,
  }) {
    return ProductReviewModel(
      id: id,
      reference: reference,
      titleAr: titleAr,
      titleEn: titleEn,
      merchantNameAr: merchantNameAr,
      merchantNameEn: merchantNameEn,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      imageKind: imageKind,
      photoCount: photoCount,
      receivedMinutesAgo: receivedMinutesAgo,
      priceAr: priceAr ?? this.priceAr,
      priceEn: priceEn ?? this.priceEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      status: status ?? this.status,
      decisionNote: clearDecisionNote ? null : decisionNote ?? this.decisionNote,
      isFeatured: isFeatured ?? this.isFeatured,
      merchantNotificationRequested:
          merchantNotificationRequested ?? this.merchantNotificationRequested,
    );
  }
}
