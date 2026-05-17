import 'package:flutter/material.dart';
import 'package:shopsmart/core/services/revenuecat_service.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool loading = false;
  bool isPremium = false;

  @override
  void initState() {
    super.initState();
    _checkPremiumStatus();
  }

  Future<void> _checkPremiumStatus() async {
    final status = await RevenueCatService.isPremiumUser();
    setState(() {
      isPremium = status;
    });
  }
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
                onPressed: (loading || isPremium)
                    ? null
                    : () async {
                        setState(() {
                          loading = true;
                        });

                        final errorMessage =
                            await RevenueCatService.purchasePremium();

                        setState(() {
                          loading = false;
                          if (errorMessage == null) isPremium = true;
                        });

                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              errorMessage ?? "Premium Activated",
                            ),
                            backgroundColor: errorMessage == null ? Colors.green : Colors.red,
                          ),
                        );
                      },

                child: loading
                    ? const CircularProgressIndicator()
                    : Text(isPremium ? "Premium Active" : "Upgrade Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
