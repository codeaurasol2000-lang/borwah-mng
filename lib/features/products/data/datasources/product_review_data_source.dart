import '../../domain/entities/product_review.dart';
import '../models/product_review_model.dart';

abstract class ProductReviewDataSource {
  Future<List<ProductReviewModel>> getProductReviews();

  Future<ProductReviewModel> updateProductReview(ProductReviewModel review);

  Future<ProductReviewModel> changeProductReviewStatus({
    required String id,
    required ProductReviewStatus status,
    String? decisionNote,
    bool merchantNotificationRequested = false,
  });
}
