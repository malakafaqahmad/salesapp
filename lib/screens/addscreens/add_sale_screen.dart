import 'package:flutter/material.dart';
import 'package:mobileapp/models/customer.dart';
import 'package:mobileapp/models/phone.dart';
import 'package:mobileapp/models/sale.dart';
import 'package:mobileapp/services/db_service.dart';

class AddSaleScreen extends StatefulWidget {
  const AddSaleScreen({super.key});

  @override
  State<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  List<Customer> _customers = [];
  List<Phone> _availablePhones = [];

  Customer? _selectedCustomer;
  Phone? _selectedPhone;

  final _totalAmountController = TextEditingController();
  final _downPaymentController = TextEditingController();
  final _installmentsCountController = TextEditingController();
  final _saleDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _saleDateController.text = DateTime.now().toIso8601String().split("T").first;
  }

  Future<void> _loadData() async {
    final customers = await _db.getAllCustomersTyped();
    final phones = await _db.getUnsoldPhones(); // fetch only phones not sold

    setState(() {
      _customers = customers;
      _availablePhones = phones;
    });
  }

  Future<void> _saveSale() async {
    if (_formKey.currentState!.validate() && _selectedCustomer != null && _selectedPhone != null) {
      final sale = Sale(
        customerId: _selectedCustomer!.id!,
        phoneId: _selectedPhone!.id!,
        saleDate: _saleDateController.text,
        totalAmount: double.parse(_totalAmountController.text),
        downPayment: double.parse(_downPaymentController.text),
        installmentsCount: int.parse(_installmentsCountController.text),
        installmentsOver: false,
      );

      await _db.insertSaleTyped(sale);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Sale')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _customers.isEmpty || _availablePhones.isEmpty
            ? const Center(child: Text("Add customers and available phones first."))
            : Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Customer>(
                value: _selectedCustomer,
                hint: const Text('Select Customer'),
                items: _customers
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCustomer = val),
                validator: (val) => val == null ? 'Select customer' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Phone>(
                value: _selectedPhone,
                hint: const Text('Select Phone'),
                items: _availablePhones
                    .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedPhone = val),
                validator: (val) => val == null ? 'Select phone' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _totalAmountController,
                decoration: const InputDecoration(labelText: 'Total Amount'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _downPaymentController,
                decoration: const InputDecoration(labelText: 'Down Payment'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _installmentsCountController,
                decoration: const InputDecoration(labelText: 'Installments Count'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _saleDateController,
                decoration: const InputDecoration(labelText: 'Sale Date'),
                readOnly: true,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    _saleDateController.text = picked.toIso8601String().split("T").first;
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveSale, child: const Text('Save Sale')),
            ],
          ),
        ),
      ),
    );
  }
}
