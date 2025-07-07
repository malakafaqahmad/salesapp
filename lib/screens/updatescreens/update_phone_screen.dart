import 'package:flutter/material.dart';
import 'package:mobileapp/models/phone.dart';
import 'package:mobileapp/services/db_service.dart';

class UpdatePhoneScreen extends StatefulWidget {
  final Phone phone;

  const UpdatePhoneScreen({super.key, required this.phone});

  @override
  State<UpdatePhoneScreen> createState() => _UpdatePhoneScreenState();
}

class _UpdatePhoneScreenState extends State<UpdatePhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  late TextEditingController _nameController;
  late TextEditingController _imeiController;
  late TextEditingController _costController;
  late TextEditingController _saleController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.phone.name);
    _imeiController = TextEditingController(text: widget.phone.imei);
    _costController = TextEditingController(text: widget.phone.costPrice.toString());
    _saleController = TextEditingController(text: widget.phone.salePrice.toString());
  }

  Future<void> _updatePhone() async {
    if (_formKey.currentState!.validate()) {
      final updated = Phone(
        id: widget.phone.id,
        name: _nameController.text.trim(),
        imei: _imeiController.text.trim(),
        costPrice: double.parse(_costController.text),
        salePrice: double.parse(_saleController.text),
      );
      await _db.updatePhoneTyped(updated);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _imeiController, decoration: const InputDecoration(labelText: 'IMEI'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _costController, decoration: const InputDecoration(labelText: 'Cost Price'), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              TextFormField(controller: _saleController, decoration: const InputDecoration(labelText: 'Sale Price'), keyboardType: TextInputType.number),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _updatePhone, child: const Text('Update')),
            ],
          ),
        ),
      ),
    );
  }
}
