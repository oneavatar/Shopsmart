import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsmart/core/utils/recommendation_engine.dart';
import 'package:shopsmart/features/products/bloc/product_bloc.dart';
import 'package:shopsmart/features/products/bloc/product_event.dart';
import 'package:shopsmart/features/products/bloc/product_state.dart';
import 'package:shopsmart/presentation/screens/product_cart.dart';
import 'package:shopsmart/presentation/widgets/banner_ad_widget.dart';
import 'package:shopsmart/presentation/widgets/product_skeleton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProducts());
  }

  final categories = ["Electronics", "Fashion", "Shoes", "Beauty", "Gaming"];
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Discover',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Find your perfect product',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                // search bar
                TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.black87),
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products',
                    hintStyle: const TextStyle(color: Colors.black54),
                    prefixIcon: const Icon(Icons.search, color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 20),
                // Promo Banner
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Colors.black, Colors.grey],
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "50% OFF",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "On select products",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Categories
                SizedBox(
                  height: 45,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.black,

                          borderRadius: BorderRadius.circular(30),
                        ),

                        child: Center(
                          child: Text(
                            categories[index],

                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemCount: categories.length,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Popular Products",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Center(child: const BannerAdWidget()),
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.62,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) => const ProductSkeleton(),
                      );
                    }
                    if (state is ProductLoaded) {
                      final recommendedProducts =
                          RecommendationEngine.getRecommendations(
                            state.products,
                          );
                      final filteredProducts = state.products.where((product) {
                        return product.title.toLowerCase().contains(
                          searchController.text.toLowerCase(),
                        );
                      }).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            "Recommended For You",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          SizedBox(
                            height: 310,

                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,

                              itemCount: recommendedProducts.length,

                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 12),

                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 190,

                                  child: ProductCart(
                                    product: recommendedProducts[index],
                                    heroTagPrefix: '_',
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            height: 400,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,

                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,

                                    childAspectRatio: 0.62,
                                  ),

                              itemCount: filteredProducts.length,

                              itemBuilder: (BuildContext context, int index) {
                                return ProductCart(
                                  product: filteredProducts[index],
                                  heroTagPrefix: 'filtered_',
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    if (state is ProductError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
