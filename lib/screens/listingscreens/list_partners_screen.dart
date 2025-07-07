import 'package:flutter/material.dart';
import 'package:mobileapp/models/partner.dart';
import 'package:mobileapp/screens/addscreens/add_partner_screen.dart';
import 'package:mobileapp/screens/updatescreens/update_partner_screen.dart';
import 'package:mobileapp/services/db_service.dart';

class PartnerListScreen extends StatefulWidget {
  const PartnerListScreen({super.key});

  @override
  State<PartnerListScreen> createState() => _PartnerListScreenState();
}

class _PartnerListScreenState extends State<PartnerListScreen> {
  final db = DatabaseService();
  late Future<List<Partner>> _partnersFuture;

  @override
  void initState() {
    super.initState();
    _loadPartners();
  }

  void _loadPartners() {
    setState(() {
      _partnersFuture = db.getAllPartnersTyped();
    });
  }

  Future<void> _confirmDelete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Partner'),
        content: const Text('Are you sure you want to delete this partner?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await db.deletePartnerTyped(id);
      _loadPartners();
    }
  }

  void _navigateToAddPartner() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPartnerScreen()));
    _loadPartners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Partners')),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPartner,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Partner>>(
        future: _partnersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          final partners = snapshot.data!;
          if (partners.isEmpty) return const Center(child: Text('No partners found'));

          return ListView.builder(
            itemCount: partners.length,
            itemBuilder: (_, index) {
              final p = partners[index];
              return Card(
                child: ListTile(
                  title: Text(p.name),
                  subtitle: Text('Investment: Rs. ${p.investment}'),
                  trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => _confirmDelete(p.id!)),
                  onLongPress: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => UpdatePartnerScreen(partner: p)),
                    );
                    _loadPartners();
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
