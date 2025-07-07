// lib/screens/addscreens/add_installment_screen.dart
import 'package:flutter/material.dart';
import 'package:mobileapp/models/installment.dart';
import 'package:mobileapp/models/sale.dart';
import 'package:mobileapp/services/db_service.dart';

class AddInstallmentScreen extends StatefulWidget {
  const AddInstallmentScreen({super.key});

  @override
  State<AddInstallmentScreen> createState() => _AddInstallmentScreenState();
}

class _AddInstallmentScreenState extends State<AddInstallmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  late TextEditingController _amountController;
  late TextEditingController _dueDateController;
  List<Sale> _sales = [];
  Sale? _selectedSale;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _dueDateController = TextEditingController();
    _loadSales();
  }

  Future<void> _loadSales() async {
    final sales = await _db.getAllSalesTyped();
    setState(() {
      _sales = sales;
    });
  }

  Future<void> _saveInstallment() async {
    if (_formKey.currentState!.validate() && _selectedSale != null) {
      final installment = Installment(
        saleId: _selectedSale!.id!,
        dueDate: _dueDateController.text, // already in yyyy-MM-dd format
        amount: double.parse(_amountController.text),
        status: "paid", // consider making this dynamic later
        paidDate: DateTime.now().toIso8601String(), // you can use null if not paid yet
      );

      await _db.insertInstallmentTyped(installment);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Installment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Sale>(
                items: _sales.map((sale) {
                  return DropdownMenuItem(
                    value: sale,
                    child: Text("Sale ID: ${sale.id}"),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedSale = value),
                decoration: const InputDecoration(labelText: "Select Sale"),
                validator: (val) => val == null ? "Please select a sale" : null,
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _dueDateController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Due Date"),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    // Format date as yyyy-MM-dd
                    _dueDateController.text =
                    "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                  }
                },
                validator: (val) => val == null || val.isEmpty ? "Pick a due date" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveInstallment,
                child: const Text("Add Installment"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
