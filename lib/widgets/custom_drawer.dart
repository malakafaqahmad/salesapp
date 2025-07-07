import 'package:flutter/material.dart';
import 'package:mobileapp/screens/listingscreens/listcustomers.dart';
import 'package:mobileapp/screens/listingscreens/list_phones_screen.dart';
import 'package:mobileapp/screens/listingscreens/list_partners_screen.dart';
import 'package:mobileapp/screens/listingscreens/list_sales.dart';
import 'package:mobileapp/screens/listingscreens/transaction_list_screen.dart';
import 'package:mobileapp/screens/listingscreens/list_installments.dart';
import 'package:mobileapp/screens/reportscreen/reports.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal),
            child: Center(
              child: Text(
                'Navigation',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),

          // Main Navigation Items
          _buildDrawerItem(
            context,
            icon: Icons.person_2,
            text: 'Customers',
            destination: const CustomerListScreen(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.phone_android,
            text: 'Phone',
            destination: const PhoneListScreen(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.receipt_long,
            text: 'Sales',
            destination: const SalesListScreen(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.attach_money,
            text: 'Installments',
            destination: const InstallmentListScreen(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.group,
            text: 'Partners',
            destination: const PartnerListScreen(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.bar_chart,
            text: 'Transactions',
            destination: const TransactionListScreen(),
          ),


          //
          const Divider(),
          //
          // Additional/Optional Items
          _buildDrawerItem(
            context,
            icon: Icons.question_answer,
            text: 'Reports',
            destination: ReportScreen(),
          ),
          // _buildDrawerItem(
          //   context,
          //   icon: Icons.settings,
          //   text: 'Settings',
          //   // destination: const TablesScreen(),
          // ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String text,
        required Widget destination,
      }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => destination),
        );
      },
    );
  }
}
