import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/services/db_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final db = DatabaseService();
  String status = "";

  Future<void> _exportData() async {
    setState(() => status = "Requesting permission...");
    final permission = await Permission.storage.request();

    if (!permission.isGranted) {
      setState(() => status = "Storage permission denied!");
      return;
    }

    setState(() => status = "Loading data...");

    final customers = await db.getAllCustomersTyped();
    final phones = await db.getAllPhonesTyped();
    final partners = await db.getAllPartnersTyped();
    final sales = await db.getAllSalesTyped();
    final installments = await db.getAllInstallmentsTyped();
    final transactions = await db.getAllTransactionsTyped();

    setState(() => status = "Generating CSVs...");

    final dir = Directory("/storage/emulated/0/Download");

    await _writeCsv(
        dir, 'customers.csv',
        [["ID", "Name", "Phone"]]
          ..addAll(customers.map((c) => [c.id, c.name, c.phoneNumber])));

    await _writeCsv(
        dir, 'phones.csv',
        [["ID", "Name", "CostPrice"]]
          ..addAll(phones.map((p) => [p.id, p.name, p.costPrice])));

    await _writeCsv(
        dir, 'partners.csv',
        [["ID", "Name", "Investment"]]
          ..addAll(partners.map((p) => [p.id, p.name, p.investment])));

    await _writeCsv(
        dir, 'sales.csv',
        [["ID", "CustomerId", "PhoneId", "DownPayment"]]
          ..addAll(sales.map((s) => [s.id, s.customerId, s.phoneId, s.downPayment])));

    await _writeCsv(
        dir, 'installments.csv',
        [["ID", "SaleId", "DueDate", "Amount", "Status", "PaidDate"]]
          ..addAll(installments.map((i) => [
            i.id,
            i.saleId,
            i.dueDate,
            i.amount,
            i.status,
            i.paidDate ?? ""
          ])));

    await _writeCsv(
        dir, 'transactions.csv',
        [["ID", "Type", "Amount", "Date", "Description"]]
          ..addAll(transactions.map((t) => [
            t.id,
            t.type,
            t.amount,
            t.date,
            t.description ?? ""
          ])));

    setState(() => status = "✅ CSV files saved to /Download folder.");
  }

  Future<void> _writeCsv(Directory dir, String fileName, List<List<dynamic>> rows) async {
    final file = File('${dir.path}/$fileName');
    final csv = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csv);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Export Reports")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text("Export CSVs to Download Folder"),
              onPressed: _exportData,
            ),
            const SizedBox(height: 20),
            Text(status, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
