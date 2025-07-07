import 'package:flutter/material.dart';
import 'package:mobileapp/models/customer.dart';
import 'package:mobileapp/screens/addscreens/addcustomer.dart';
import 'package:mobileapp/services/db_service.dart';
import 'package:mobileapp/screens/updatescreens/update_customer_screen.dart';



class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final db = DatabaseService();
  late Future<List<Customer>> _customersFuture;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  void _loadCustomers() {
    setState(() {
      _customersFuture = db.getAllCustomersTyped();
    });
  }

  void _navigateToAddCustomer() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCustomerScreen()),
    );
    _loadCustomers(); // Refresh list after returning
  }

  Future<void> _confirmDelete(int customerId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer'),
        content: const Text('Are you sure you want to delete this customer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await db.deleteCustomerTyped(customerId);
      _loadCustomers(); // Refresh list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCustomers,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddCustomer,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Customer>>(
        future: _customersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final customers = snapshot.data!;
            if (customers.isEmpty) {
              return const Center(child: Text('No customers found.'));
            }

            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(customer.name),
                    subtitle: Text('CNIC: ${customer.cnic}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDelete(customer.id!),
                    ),
                    onLongPress: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateCustomerScreen(customer: customer),
                        ),
                      );
                      _loadCustomers(); // refresh after update
                    },

                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
