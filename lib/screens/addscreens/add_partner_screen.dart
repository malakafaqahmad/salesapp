import 'package:flutter/material.dart';
import 'package:mobileapp/models/partner.dart';
import 'package:mobileapp/services/db_service.dart';

class AddPartnerScreen extends StatefulWidget {
  const AddPartnerScreen({super.key});

  @override
  State<AddPartnerScreen> createState() => _AddPartnerScreenState();
}

class _AddPartnerScreenState extends State<AddPartnerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  final _nameController = TextEditingController();
  final _investmentController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  Future<void> _savePartner() async {
    if (_formKey.currentState!.validate()) {
      final partner = Partner(
        name: _nameController.text,
        investment: int.parse(_investmentController.text),
        phoneNumber: _phoneController.text,
        address: _addressController.text,
      );

      await _db.insertPartnerTyped(partner);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Partner added')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Partner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _investmentController, decoration: const InputDecoration(labelText: 'Investment'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
              const SizedBox(height: 12),
              TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: 'Address')),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _savePartner, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
