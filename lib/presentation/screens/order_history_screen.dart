import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsmart/features/order/bloc/order_bloc.dart';
import 'package:shopsmart/features/order/bloc/order_event.dart';
import 'package:shopsmart/features/order/bloc/order_state.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(LoadOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OrderLoaded) {
            if (state.orders.isEmpty) {
              return const Center(child: Text("No orders found"));
            }

            return ListView.builder(
              itemCount: state.orders.length,

              itemBuilder: (context, index) {
                final order = state.orders[index];

                return Card(
                  margin: const EdgeInsets.all(12),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text("Order ID: ${order.id}"),

                        const SizedBox(height: 10),

                        Text(
                          "Total: \$${order.total.toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 10),

                        Text("Products: ${order.products.length}"),

                        const SizedBox(height: 10),

                        Text(order.createdAt.toString()),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (state is OrderError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
