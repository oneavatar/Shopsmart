import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsmart/data/models/produt_model.dart';
import 'package:shopsmart/features/search/bloc/search_event.dart';
import 'package:shopsmart/features/search/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final List<ProductModel> allProducts;

  SearchBloc(this.allProducts)
    : super(SearchState(filteredProducts: allProducts)) {
    on<SearchProduct>((event, emit) {
      final filtered = allProducts
          .where(
            (product) =>
                product.title.toLowerCase().contains(event.query.toLowerCase()),
          )
          .toList();
      emit(SearchState(filteredProducts: filtered));
    });
  }
}
