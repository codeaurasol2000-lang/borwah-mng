import '../entities/product_review.dart';
import '../repositories/product_review_repository.dart';

class GetProductReviewsUseCase {
  final ProductReviewRepository repository;

  const GetProductReviewsUseCase({required this.repository});

  Future<List<ProductReview>> call() => repository.getProductReviews();
}
