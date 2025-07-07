import 'package:flutter/material.dart';
import 'package:mobileapp/models/customer.dart';
import 'package:mobileapp/services/db_service.dart';

class UpdateCustomerScreen extends StatefulWidget {
  final Customer customer;

  const UpdateCustomerScreen({super.key, required this.customer});

  @override
  State<UpdateCustomerScreen> createState() => _UpdateCustomerScreenState();
}

class _UpdateCustomerScreenState extends State<UpdateCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cnicController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.name);
    _phoneController = TextEditingController(text: widget.customer.phoneNumber ?? '');
    _addressController = TextEditingController(text: widget.customer.address ?? '');
    _cnicController = TextEditingController(text: widget.customer.cnic);
  }

  Future<void> _updateCustomer() async {
    if (_formKey.currentState!.validate()) {
      final updatedCustomer = Customer(
        id: widget.customer.id,
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        cnic: _cnicController.text.trim(),
      );

      await _db.updateCustomerTyped(updatedCustomer);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer updated')),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cnicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Customer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cnicController,
                decoration: const InputDecoration(
                  labelText: 'CNIC *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'CNIC is required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _updateCustomer,
                icon: const Icon(Icons.save),
                label: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
