import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopsmart/data/models/produt_model.dart';
import 'package:shopsmart/features/cart/bloc/cart_bloc.dart';
import 'package:shopsmart/features/cart/bloc/cart_event.dart';
import 'package:shopsmart/features/cart/bloc/cart_state.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late CartBloc cartBloc;
  late ProductModel testProduct;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    cartBloc = CartBloc();
    testProduct = ProductModel(
      id: 1,
      title: 'Test Product',
      description: 'Description',
      price: 99.99,
      imageUrl: 'https://example.com/image.jpg',
      category: 'Electronics',
    );
  });

  tearDown(() {
    cartBloc.close();
  });

  group('CartBloc Tests', () {
    test('initial state is empty', () {
      expect(cartBloc.state.items, isEmpty);
    });

    blocTest<CartBloc, CartState>(
      'emits updated state when product is added',
      build: () => cartBloc,
      act: (bloc) => bloc.add(AddToCart(testProduct)),
      expect: () => [
        isA<CartState>().having((s) => s.items.length, 'items length', 1),
      ],
      verify: (_) {
        expect(cartBloc.state.items.first.product.id, testProduct.id);
      },
    );

    blocTest<CartBloc, CartState>(
      'increments quantity when same product is added twice',
      build: () => cartBloc,
      act: (bloc) {
        bloc.add(AddToCart(testProduct));
        bloc.add(AddToCart(testProduct));
      },
      skip: 1, // Skip the first emission
      expect: () => [
        isA<CartState>().having((s) => s.items.first.quantity, 'quantity', 2),
      ],
    );

    blocTest<CartBloc, CartState>(
      'removes product from cart',
      build: () => cartBloc,
      seed: () => CartState(items: []),
      act: (bloc) {
        bloc.add(AddToCart(testProduct));
        bloc.add(RemoveFromCart(testProduct));
      },
      skip: 1,
      expect: () => [
        isA<CartState>().having((s) => s.items, 'items', isEmpty),
      ],
    );

    blocTest<CartBloc, CartState>(
      'clears the cart',
      build: () => cartBloc,
      act: (bloc) {
        bloc.add(AddToCart(testProduct));
        bloc.add(ClearCart());
      },
      skip: 1,
      expect: () => [
        isA<CartState>().having((s) => s.items, 'items', isEmpty),
      ],
    );
  });
}
