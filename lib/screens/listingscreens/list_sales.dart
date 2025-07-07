import 'package:flutter/material.dart';
import 'package:mobileapp/models/sale.dart';
import 'package:mobileapp/services/db_service.dart';
import 'package:mobileapp/screens/addscreens/add_sale_screen.dart';
import 'package:mobileapp/screens/updatescreens/update_sale_screen.dart';

class SalesListScreen extends StatefulWidget {
  const SalesListScreen({super.key});

  @override
  State<SalesListScreen> createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  final db = DatabaseService();
  late Future<List<Map<String, dynamic>>> _salesFuture;

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  void _loadSales() {
    setState(() {
      _salesFuture = db.getSalesWithDetails();
    });
  }

  Future<void> _confirmDelete(int saleId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Sale'),
        content: const Text('Are you sure you want to delete this sale?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await db.deleteSaleTyped(saleId);
      _loadSales();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sale deleted")));
    }
  }

  void _navigateToAddSale() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddSaleScreen()),
    );
    _loadSales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales')),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddSale,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _salesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final sales = snapshot.data!;
          if (sales.isEmpty) {
            return const Center(child: Text('No sales found.'));
          }

          return ListView.builder(
            itemCount: sales.length,
            itemBuilder: (context, index) {
              final sale = sales[index];
              return Card(
                child: ListTile(
                  title: Text(
                      '${sale['customerName']} bought ${sale['phoneName']}'),
                  subtitle: Text('Amount: ${sale['totalAmount']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _confirmDelete(sale['id']),
                  ),
                  onLongPress: () async {
                    final saleModel = Sale.fromMap(sale);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UpdateSaleScreen(sale: saleModel),
                      ),
                    );
                    _loadSales();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
