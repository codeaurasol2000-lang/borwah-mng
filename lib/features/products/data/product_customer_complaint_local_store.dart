import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/product_customer_complaint.dart';

class ProductCustomerComplaintLocalStore {
  static const _key = 'product_customer_complaints_v1';

  Future<List<ProductCustomerComplaint>> loadExisting() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getString(_key);
    if (saved == null) return const [];
    final decoded = jsonDecode(saved);
    if (decoded is! List<dynamic>) {
      throw const FormatException('Invalid product customer complaints list.');
    }
    return List.unmodifiable(decoded.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Invalid product customer complaint.');
      }
      return ProductCustomerComplaint.fromJson(item);
    }));
  }

  Future<List<ProductCustomerComplaint>> load({
    required List<ProductCustomerComplaint> initialComplaints,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getString(_key);
    if (saved == null) {
      await save(initialComplaints);
      return List.unmodifiable(initialComplaints);
    }
    final decoded = jsonDecode(saved);
    if (decoded is! List<dynamic>) {
      throw const FormatException('Invalid product customer complaints list.');
    }
    final initialById = {for (final complaint in initialComplaints) complaint.id: complaint};
    return List.unmodifiable(decoded.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Invalid product customer complaint.');
      }
      final saved = ProductCustomerComplaint.fromJson(item);
      final initial = initialById[saved.id];
      if (initial == null) return saved;
      return saved.copyWith(
        customerNameEn: initial.customerNameEn,
        titleEn: initial.titleEn,
        descriptionEn: initial.descriptionEn,
        productNameEn: initial.productNameEn,
        productPriceEn: initial.productPriceEn,
        supervisorNoteEn: initial.supervisorNoteEn,
      );
    }));
  }

  Future<void> save(List<ProductCustomerComplaint> complaints) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _key,
      jsonEncode(complaints.map((item) => item.toJson()).toList()),
    );
    if (!saved) throw StateError('Could not save product complaints.');
  }
}
