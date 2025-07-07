import 'package:flutter/material.dart';
import 'package:mobileapp/models/phone.dart';
import 'package:mobileapp/screens/addscreens/add_phone_screen.dart';
import 'package:mobileapp/screens/updatescreens/update_phone_screen.dart';
import 'package:mobileapp/services/db_service.dart';

class PhoneListScreen extends StatefulWidget {
  const PhoneListScreen({super.key});

  @override
  State<PhoneListScreen> createState() => _PhoneListScreenState();
}

class _PhoneListScreenState extends State<PhoneListScreen> {
  final db = DatabaseService();
  late Future<List<Phone>> _phonesFuture;

  @override
  void initState() {
    super.initState();
    _loadPhones();
  }

  void _loadPhones() {
    setState(() {
      _phonesFuture = db.getAllPhonesTyped();
    });
  }

  Future<void> _confirmDelete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Phone'),
        content: const Text('Are you sure you want to delete this phone?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      await db.deletePhoneTyped(id);
      _loadPhones();
    }
  }

  void _navigateToAddPhone() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPhoneScreen()),
    );
    _loadPhones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phones')),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPhone,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Phone>>(
        future: _phonesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          final phones = snapshot.data!;
          if (phones.isEmpty) return const Center(child: Text('No phones found'));

          return ListView.builder(
            itemCount: phones.length,
            itemBuilder: (_, index) {
              final phone = phones[index];
              return Card(
                child: ListTile(
                  title: Text(phone.name),
                  subtitle: Text('IMEI: ${phone.imei}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _confirmDelete(phone.id!),
                  ),
                  onLongPress: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UpdatePhoneScreen(phone: phone),
                      ),
                    );
                    _loadPhones();
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
