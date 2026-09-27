import 'package:equatable/equatable.dart';

enum SubscriptionType { merchant, serviceProvider }

class SubscriptionRequestEntity extends Equatable {
  final String id;
  final String providerName;          // متجر إلكترونيات النخبة
  final String registrationNumber;    // س.ت أو رقم الرخصة
  final String categoryName;          // اشتراك تاجر مميز / مقدم خدمات منزلية
  final String targetPackageName;     // الباقة الذهبية السنوية / مزود خدمة احترافي
  final String durationText;          // سنوي / نصف سنوي
  final double totalAmount;           // المبلغ الإجمالي بالريال
  final String paymentMethod;         // تحويل بنكي مباشر / خصم مباشر من المحفظة
  final String status;                // قيد المطابقة / جاهز للاعتماد التلقائي
  final SubscriptionType type;

  const SubscriptionRequestEntity({
    required this.id,
    required this.providerName,
    required this.registrationNumber,
    required this.categoryName,
    required this.targetPackageName,
    required this.durationText,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.type,
  });

  @override
  List<Object?> get props => [id, providerName, totalAmount, status];
}