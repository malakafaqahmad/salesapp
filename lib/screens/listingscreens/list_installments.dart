import 'package:flutter/material.dart';
import 'package:mobileapp/models/installment.dart';
import 'package:mobileapp/services/db_service.dart';
import 'package:mobileapp/screens/updatescreens//update_installment_screen.dart';

class InstallmentListScreen extends StatefulWidget {
  const InstallmentListScreen({super.key});

  @override
  State<InstallmentListScreen> createState() => _InstallmentListScreenState();
}

class _InstallmentListScreenState extends State<InstallmentListScreen> {
  final db = DatabaseService();
  List<Installment> installments = [];

  @override
  void initState() {
    super.initState();
    _loadInstallments();
  }

  Future<void> _loadInstallments() async {
    final data = await db.getAllInstallmentsTyped();
    setState(() {
      installments = data;
    });
  }

  Future<void> _deleteInstallment(int id) async {
    await db.deleteInstallmentTyped(id);
    await _loadInstallments();
  }

  void _editInstallment(Installment installment) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateInstallmentScreen(installment: installment),
      ),
    );
    await _loadInstallments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Installments")),
      body: RefreshIndicator(
        onRefresh: _loadInstallments,
        child: ListView.builder(
          itemCount: installments.length,
          itemBuilder: (context, index) {
            final inst = installments[index];
            return Card(
              child: ListTile(
                title: Text("Rs ${inst.amount.toStringAsFixed(2)}"),
                subtitle: Text("Due: ${inst.dueDate} | Status: ${inst.status}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteInstallment(inst.id!),
                ),
                onLongPress: () => _editInstallment(inst),
              ),
            );
          },
        ),
      ),
    );
  }
}
