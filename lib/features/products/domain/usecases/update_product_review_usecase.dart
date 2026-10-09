import '../entities/product_review.dart';
import '../repositories/product_review_repository.dart';

class UpdateProductReviewUseCase {
  final ProductReviewRepository repository;

  const UpdateProductReviewUseCase({required this.repository});

  Future<ProductReview> call(ProductReview review) {
    return repository.updateProductReview(review);
  }
}
