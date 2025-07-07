import 'package:flutter/material.dart';
import 'package:mobileapp/widgets/appbar.dart';
import 'package:mobileapp/widgets/custom_drawer.dart';
import 'package:mobileapp/widgets/summary_card.dart';
import 'package:mobileapp/screens/addscreens/addcustomer.dart';
import 'package:mobileapp/screens/addscreens/add_phone_screen.dart';
import 'package:mobileapp/screens/addscreens/add_partner_screen.dart';
import 'package:mobileapp/screens/addscreens/add_sale_screen.dart';
import 'package:mobileapp/screens/addscreens/add_installment_screen.dart';
import 'package:mobileapp/screens/testscreen/test.dart';
import 'package:mobileapp/services/db_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = DatabaseService();
  int totalCustomers = 0;
  int totalPhones = 0;
  int totalSales = 0;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final customers = await db.getAllCustomersTyped();
    final phones = await db.getAllPhonesTyped();
    final sales = await db.getAllSalesTyped();

    setState(() {
      totalCustomers = customers.length;
      totalPhones = phones.length;
      totalSales = sales.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Home'),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Summary cards with live data
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SummaryCard(title: "Customers", count: totalCustomers, color: Colors.green),
                SummaryCard(title: "Phones", count: totalPhones, color: Colors.blue),
                SummaryCard(title: "Sales", count: totalSales, color: Colors.orange),
              ],
            ),
            const SizedBox(height: 24),

            // Navigation List
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Manage Customers"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddCustomerScreen()),
                      );
                      _loadCounts();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone_android),
                    title: const Text("Manage Phones"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddPhoneScreen()),
                      );
                      _loadCounts();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_2_outlined),
                    title: const Text("Manage Partners"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddPartnerScreen()),
                      );
                      _loadCounts();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: const Text("Manage Sales"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddSaleScreen()),
                      );
                      _loadCounts();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.payment),
                    title: const Text("Manage Installments"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddInstallmentScreen()),
                      );
                      _loadCounts();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.payment),
                    title: const Text("test screen"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InstallmentDebugScreen()),
                      );
                      _loadCounts();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
