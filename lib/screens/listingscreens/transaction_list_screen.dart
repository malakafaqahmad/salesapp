import 'package:flutter/material.dart';
import 'package:mobileapp/models/installment.dart';
import 'package:mobileapp/models/partner.dart';
import 'package:mobileapp/models/phone.dart';
import 'package:mobileapp/models/sale.dart';
import 'package:mobileapp/services/db_service.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final db = DatabaseService();

  List<Installment> paidInstallments = [];
  List<Sale> sales = [];
  List<Phone> phones = [];
  List<Partner> partners = [];

  double totalIncoming = 0;
  double totalOutgoing = 0;
  double totalInvestment = 0;
  double totalPhoneCost = 0;
  double totalProfit = 0;
  double totalBalance = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final allInstallments = await db.getAllInstallmentsTyped();
    final allSales = await db.getAllSalesTyped();
    final allPhones = await db.getAllPhonesTyped();
    final allPartners = await db.getAllPartnersTyped();

    final paidInstallmentsList = allInstallments
        .where((i) => i.status.toLowerCase() == 'paid')
        .toList();

    final incoming = paidInstallmentsList.fold(0.0, (sum, i) => sum + i.amount) +
        allSales.fold(0.0, (sum, s) => sum + s.downPayment);

    final outgoing = allPhones.fold(0.0, (sum, p) => sum + p.costPrice);
    final investment = allPartners.fold(0.0, (sum, p) => sum + p.investment);

    setState(() {
      paidInstallments = paidInstallmentsList;
      sales = allSales;
      phones = allPhones;
      partners = allPartners;

      totalIncoming = incoming;
      totalOutgoing = outgoing;
      totalInvestment = investment;
      totalPhoneCost = outgoing;
      totalProfit = totalIncoming - totalOutgoing;
      totalBalance = totalInvestment - totalPhoneCost + totalIncoming;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allVirtualTransactions = [
      ...sales.map((s) => {
        'type': 'incoming',
        'amount': s.downPayment,
        'description': 'Down payment for Sale ID ${s.id}',
        'date': 'Sale',
      }),
      ...paidInstallments.map((i) => {
        'type': 'incoming',
        'amount': i.amount,
        'description': 'Installment for Sale ID ${i.saleId}',
        'date': (i.paidDate ?? i.dueDate).split("T").first,
      }),
      ...phones.map((p) => {
        'type': 'outgoing',
        'amount': p.costPrice,
        'description': 'Phone Purchased (ID ${p.id})',
        'date': 'Phone',
      }),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Summary Section
                Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildSummaryRow('Total Investment (Partners)', totalInvestment, Colors.blue),
                        _buildSummaryRow('Total Cost of Phones', totalPhoneCost, Colors.indigo),
                        const Divider(),
                        _buildSummaryRow('Total Incoming', totalIncoming, Colors.green),
                        _buildSummaryRow('Total Outgoing', totalOutgoing, Colors.red),
                        const Divider(),
                        _buildSummaryRow('Total Profit', totalProfit, Colors.orange),
                        _buildSummaryRow('Wallet Balance', totalBalance, Colors.purple),
                        const Divider(),
                        const Text("Partner Profit Share", style: TextStyle(fontWeight: FontWeight.bold)),
                        ...partners.map((p) {
                          final share = totalProfit == 0 || totalInvestment == 0
                              ? 0
                              : ((p.investment / totalInvestment) * totalProfit);
                          return ListTile(
                            title: Text(p.name),
                            subtitle: Text("Share: Rs ${share.toStringAsFixed(2)}"),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "All Transactions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: allVirtualTransactions.length,
                  itemBuilder: (context, index) {
                    final tx = allVirtualTransactions[index];
                    final isIncoming = tx['type'] == 'incoming';
                    final color = isIncoming ? Colors.green : Colors.red;

                    return Card(
                      child: ListTile(
                        leading: Icon(
                          isIncoming ? Icons.arrow_downward : Icons.arrow_upward,
                          color: color,
                        ),
                        title: Text(
                          "${isIncoming ? 'Received' : 'Spent'} Rs ${(tx['amount'] as double).toStringAsFixed(2)}",
                          style: TextStyle(color: color),
                        ),
                        subtitle: Text(tx['description'] as String),
                        trailing: Text(tx['date'] as String),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          Text("Rs ${value.toStringAsFixed(2)}", style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
