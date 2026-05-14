import 'package:flutter/material.dart';
import 'package:shopsmart/core/services/revenuecat_service.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Go Premium")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Unlock Premium",

              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            const ListTile(
              leading: Icon(Icons.check),
              title: Text("Remove Ads"),
            ),

            const ListTile(
              leading: Icon(Icons.check),
              title: Text("Premium Badge"),
            ),

            const ListTile(
              leading: Icon(Icons.check),
              title: Text("Exclusive Deals"),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,

              height: 60,

              child: ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        setState(() {
                          loading = true;
                        });

                        final success =
                            await RevenueCatService.purchasePremium();

                        setState(() {
                          loading = false;
                        });

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success ? "Premium Activated" : "Purchase Failed",
                            ),
                          ),
                        );
                      },

                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Upgrade Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
