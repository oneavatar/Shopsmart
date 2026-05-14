import 'package:bloc/bloc.dart';
import 'package:shopsmart/data/repositories/product_repository.dart';
import 'package:shopsmart/features/products/bloc/product_event.dart';
import 'package:shopsmart/features/products/bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  ProductBloc(this.repository) : super(ProductInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await repository.fetchProducts();
        emit(ProductLoaded(products: products));
      } catch (e) {
        emit(ProductError(message: e.toString()));
      }
    });
  }
}
