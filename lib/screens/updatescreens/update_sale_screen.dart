import 'package:flutter/material.dart';
import 'package:mobileapp/models/customer.dart';
import 'package:mobileapp/models/phone.dart';
import 'package:mobileapp/models/sale.dart';
import 'package:mobileapp/services/db_service.dart';

class UpdateSaleScreen extends StatefulWidget {
  final Sale sale;
  const UpdateSaleScreen({super.key, required this.sale});

  @override
  State<UpdateSaleScreen> createState() => _UpdateSaleScreenState();
}

class _UpdateSaleScreenState extends State<UpdateSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  List<Customer> _customers = [];
  List<Phone> _availablePhones = [];

  Customer? _selectedCustomer;
  Phone? _selectedPhone;

  late TextEditingController _totalAmountController;
  late TextEditingController _downPaymentController;
  late TextEditingController _installmentsCountController;
  late TextEditingController _saleDateController;

  @override
  void initState() {
    super.initState();
    _loadData();

    _totalAmountController =
        TextEditingController(text: widget.sale.totalAmount.toString());
    _downPaymentController =
        TextEditingController(text: widget.sale.downPayment.toString());
    _installmentsCountController =
        TextEditingController(text: widget.sale.installmentsCount.toString());
    _saleDateController = TextEditingController(text: widget.sale.saleDate);
  }

  Future<void> _loadData() async {
    final customers = await _db.getAllCustomersTyped();
    final phones = await _db.getUnsoldPhones();

    // Include current phone in update even if it's already sold
    final currentPhone = await _db.getPhoneById(widget.sale.phoneId);

    if (currentPhone != null && !phones.any((p) => p.id == currentPhone.id)) {
      phones.add(currentPhone);
    }


    setState(() {
      _customers = customers;
      _availablePhones = phones;
      _selectedCustomer =
          customers.firstWhere((c) => c.id == widget.sale.customerId);
      _selectedPhone = phones.firstWhere((p) => p.id == widget.sale.phoneId);
    });
  }

  Future<void> _updateSale() async {
    if (_formKey.currentState!.validate() &&
        _selectedCustomer != null &&
        _selectedPhone != null) {
      final updatedSale = Sale(
        id: widget.sale.id,
        customerId: _selectedCustomer!.id!,
        phoneId: _selectedPhone!.id!,
        saleDate: _saleDateController.text,
        totalAmount: double.parse(_totalAmountController.text),
        downPayment: double.parse(_downPaymentController.text),
        installmentsCount: int.parse(_installmentsCountController.text),
        installmentsOver: widget.sale.installmentsOver,
      );

      await _db.updateSaleTyped(updatedSale);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Sale')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _customers.isEmpty || _availablePhones.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Customer>(
                value: _selectedCustomer,
                items: _customers
                    .map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c.name),
                ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCustomer = val),
                decoration: const InputDecoration(labelText: 'Customer'),
                validator: (val) => val == null ? 'Required' : null,
              ),
              DropdownButtonFormField<Phone>(
                value: _selectedPhone,
                items: _availablePhones
                    .map((p) => DropdownMenuItem(
                  value: p,
                  child: Text(p.name),
                ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedPhone = val),
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (val) => val == null ? 'Required' : null,
              ),
              TextFormField(
                controller: _totalAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Total Amount'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _downPaymentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Down Payment'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _installmentsCountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Installments Count'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
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
                    _saleDateController.text =
                        picked.toIso8601String().split('T').first;
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _updateSale, child: const Text("Update Sale"))
            ],
          ),
        ),
      ),
    );
  }
}
