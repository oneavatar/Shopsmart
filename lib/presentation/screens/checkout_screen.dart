import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsmart/core/services/payment_service.dart';
import 'package:shopsmart/data/models/order_model.dart';
import 'package:shopsmart/features/cart/bloc/cart_bloc.dart';
import 'package:shopsmart/features/cart/bloc/cart_event.dart';
import 'package:shopsmart/features/order/bloc/order_bloc.dart';
import 'package:shopsmart/features/order/bloc/order_event.dart';
import 'package:shopsmart/routes/route_names.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isProcessing = false;

  Future<void> _handlePayment(BuildContext context) async {
    final cartState = context.read<CartBloc>().state;
    final amount = cartState.totalPrice.toStringAsFixed(2);

    setState(() {
      _isProcessing = true;
    });

    final success = await PaymentService.makePayment(
      amount: amount,
      currency: 'USD',
    );

    setState(() {
      _isProcessing = false;
    });

    if (success) {
      // 1. Create Order
      final order = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        total: cartState.totalPrice,
        products: cartState.items.map((item) {
          return {
            'title': item.product.title,
            'price': item.product.price,
            'quantity': item.quantity,
          };
        }).toList(),
        createdAt: DateTime.now(),
      );

      // 2. Place Order in Bloc
      context.read<OrderBloc>().add(PlaceOrderEvent(order));

      // 3. Clear Cart
      context.read<CartBloc>().add(ClearCart());

      // 4. Show success and navigate
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Successful! Order Placed.")),
      );
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.home, (route) => false);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Failed. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartBloc>().state;

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Summary",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: cartState.items.length,
                itemBuilder: (context, index) {
                  final item = cartState.items[index];
                  return ListTile(
                    title: Text(item.product.title),
                    subtitle: Text("${item.quantity} x \$${item.product.price}"),
                    trailing: Text("\$${(item.quantity * item.product.price).toStringAsFixed(2)}"),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${cartState.totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : () => _handlePayment(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Pay Now with Stripe", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
