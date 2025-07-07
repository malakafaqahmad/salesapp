import 'package:flutter/material.dart';
import 'package:mobileapp/services/db_service.dart';

class InstallmentDebugScreen extends StatefulWidget {
  const InstallmentDebugScreen({super.key});

  @override
  State<InstallmentDebugScreen> createState() => _InstallmentDebugScreenState();
}

class _InstallmentDebugScreenState extends State<InstallmentDebugScreen> {
  final db = DatabaseService();

  String output = 'Press the button to load installments.';

  Future<void> _printInstallments() async {
    final allInstallments = await db.getAllInstallmentsTyped();

    if (allInstallments.isEmpty) {
      setState(() {
        output = "No installments found.";
      });
      return;
    }

    String data = '';
    for (var ins in allInstallments) {
      data +=
      "ID: ${ins.id}, SaleId: ${ins.saleId}, Amount: ${ins.amount}, Status: ${ins.status}, PaidDate: ${ins.paidDate}\n";
    }

    setState(() {
      output = data;
    });

    // Also log in console
    for (var ins in allInstallments) {
      print("ID: ${ins.id}, SaleId: ${ins.saleId}, Amount: ${ins.amount}, Status: ${ins.status}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Installment Debugger')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _printInstallments,
              child: const Text("Print Installments"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(output),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
