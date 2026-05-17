import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsmart/features/cart/bloc/cart_bloc.dart';
import 'package:shopsmart/features/cart/bloc/cart_event.dart';
import 'package:shopsmart/features/cart/bloc/cart_state.dart';
import 'package:shopsmart/routes/route_names.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Cart')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(child: Text('Cart is empty!'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
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
                          Navigator.pushNamed(context, RouteNames.checkout);
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
