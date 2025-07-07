import 'package:flutter/material.dart';
import 'package:mobileapp/models/phone.dart';
import 'package:mobileapp/services/db_service.dart';

class AddPhoneScreen extends StatefulWidget {
  const AddPhoneScreen({super.key});

  @override
  State<AddPhoneScreen> createState() => _AddPhoneScreenState();
}

class _AddPhoneScreenState extends State<AddPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  final _nameController = TextEditingController();
  final _imeiController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _salePriceController = TextEditingController();

  Future<void> _savePhone() async {
    if (_formKey.currentState!.validate()) {
      final phone = Phone(
        name: _nameController.text.trim(),
        imei: _imeiController.text.trim(),
        costPrice: double.parse(_costPriceController.text),
        salePrice: double.parse(_salePriceController.text),
      );
      await _db.insertPhoneTyped(phone);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone added')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v!.isEmpty ? 'Name required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imeiController,
                decoration: const InputDecoration(labelText: 'IMEI'),
                validator: (v) => v!.isEmpty ? 'IMEI required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _costPriceController,
                decoration: const InputDecoration(labelText: 'Cost Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _salePriceController,
                decoration: const InputDecoration(labelText: 'Sale Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _savePhone,
                child: const Text('Add Phone'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
