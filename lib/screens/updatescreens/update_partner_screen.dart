import 'package:flutter/material.dart';
import 'package:mobileapp/models/partner.dart';
import 'package:mobileapp/services/db_service.dart';

class UpdatePartnerScreen extends StatefulWidget {
  final Partner partner;
  const UpdatePartnerScreen({super.key, required this.partner});

  @override
  State<UpdatePartnerScreen> createState() => _UpdatePartnerScreenState();
}

class _UpdatePartnerScreenState extends State<UpdatePartnerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  late TextEditingController _nameController;
  late TextEditingController _investmentController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.partner.name);
    _investmentController = TextEditingController(text: widget.partner.investment.toString());
    _phoneController = TextEditingController(text: widget.partner.phoneNumber ?? '');
    _addressController = TextEditingController(text: widget.partner.address ?? '');
  }

  Future<void> _updatePartner() async {
    if (_formKey.currentState!.validate()) {
      final updated = Partner(
        id: widget.partner.id,
        name: _nameController.text,
        investment: int.parse(_investmentController.text),
        phoneNumber: _phoneController.text,
        address: _addressController.text,
      );
      await _db.updatePartnerTyped(updated);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Partner')),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
              ElevatedButton(onPressed: _updatePartner, child: const Text('Update')),
            ],
          ),
        ),
      ),
    );
  }
}
