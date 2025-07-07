import 'package:flutter/material.dart';
import 'package:mobileapp/models/installment.dart';
import 'package:mobileapp/services/db_service.dart';

class UpdateInstallmentScreen extends StatefulWidget {
  final Installment installment;

  const UpdateInstallmentScreen({super.key, required this.installment});

  @override
  State<UpdateInstallmentScreen> createState() => _UpdateInstallmentScreenState();
}

class _UpdateInstallmentScreenState extends State<UpdateInstallmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  late TextEditingController _amountController;
  late TextEditingController _dueDateController;
  late String _status;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.installment.amount.toString());
    _dueDateController = TextEditingController(text: widget.installment.dueDate);
    _status = widget.installment.status;
  }

  Future<void> _updateInstallment() async {
    if (_formKey.currentState!.validate()) {
      final updated = Installment(
        id: widget.installment.id,
        saleId: widget.installment.saleId,
        dueDate: _dueDateController.text,
        amount: double.parse(_amountController.text),
        status: _status,
        paidDate: _status == 'paid' ? DateTime.now().toIso8601String() : null,
      );

      await _db.updateInstallmentTyped(updated);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Installment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                    initialDate: DateTime.tryParse(_dueDateController.text) ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    _dueDateController.text =
                    "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                  }
                },
                validator: (val) => val == null || val.isEmpty ? "Pick a due date" : null,
              ),
              DropdownButtonFormField<String>(
                value: _status,
                items: const [
                  DropdownMenuItem(value: 'paid', child: Text("Paid")),
                  DropdownMenuItem(value: 'unpaid', child: Text("Unpaid")),
                ],
                onChanged: (val) => setState(() => _status = val!),
                decoration: const InputDecoration(labelText: "Status"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateInstallment,
                child: const Text("Update Installment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
