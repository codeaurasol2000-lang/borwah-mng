import '../../domain/entities/product_review.dart';
import '../../domain/repositories/product_review_repository.dart';
import '../datasources/product_review_data_source.dart';
import '../models/product_review_model.dart';

class ProductReviewRepositoryImpl implements ProductReviewRepository {
  final ProductReviewDataSource dataSource;

  const ProductReviewRepositoryImpl({required this.dataSource});

  @override
  Future<List<ProductReview>> getProductReviews() {
    return dataSource.getProductReviews();
  }

  @override
  Future<ProductReview> updateProductReview(ProductReview review) {
    return dataSource.updateProductReview(
      ProductReviewModel.fromEntity(review),
    );
  }

  @override
  Future<ProductReview> changeProductReviewStatus({
    required String id,
    required ProductReviewStatus status,
    String? decisionNote,
    bool merchantNotificationRequested = false,
  }) {
    return dataSource.changeProductReviewStatus(
      id: id,
      status: status,
      decisionNote: decisionNote,
      merchantNotificationRequested: merchantNotificationRequested,
    );
  }
}
