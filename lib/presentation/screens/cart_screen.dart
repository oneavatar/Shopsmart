import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsmart/data/models/order_model.dart';
import 'package:shopsmart/features/cart/bloc/cart_bloc.dart';
import 'package:shopsmart/features/cart/bloc/cart_event.dart';
import 'package:shopsmart/features/cart/bloc/cart_state.dart';
import 'package:shopsmart/features/order/bloc/order_bloc.dart';
import 'package:shopsmart/features/order/bloc/order_event.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Cart')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.Items.isEmpty) {
            return Center(child: Text('Cart is empty!'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.Items.length,
                  itemBuilder: (context, index) {
                    final item = state.Items[index];
                    return ListTile(
                      leading: Image.network(item.product.imageUrl, width: 50),
                      title: Text(
                        item.product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('Quantity: ${item.quantity}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),

                        onPressed: () {
                          context.read<CartBloc>().add(
                            RemoveFromCart(item.product),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Total: \$${state.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: () {
                          final cartState = context.read<CartBloc>().state;
                          final order = OrderModel(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            total: cartState.totalPrice,
                            products: cartState.Items.map((item) {
                              return {
                                'title': item.product.title,

                                'price': item.product.price,

                                'quantity': item.quantity,
                              };
                            }).toList(),

                            createdAt: DateTime.now(),
                          );

                          context.read<OrderBloc>().add(PlaceOrderEvent(order));

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Order placed successfully"),
                            ),
                          );
                        },
                        child: const Text("Checkout"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
