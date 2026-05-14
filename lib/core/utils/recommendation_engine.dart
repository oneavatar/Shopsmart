import 'package:shopsmart/data/models/produt_model.dart';

class RecommendationEngine {
  static List<ProductModel> getRecommendations(List<ProductModel> products) {
    // SIMULATED AI LOGIC
    // Recommend expensive/trending products

    final recommended = List<ProductModel>.from(products);

    recommended.sort((a, b) => b.price.compareTo(a.price));

    return recommended.take(4).toList();
  }

}
