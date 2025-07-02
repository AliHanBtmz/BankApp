import 'package:flutter/material.dart';
import '../modules/customer.dart';

class CustomerList extends StatelessWidget {
  final List<Customer> customers;
  final Function(int) onDelete;
  final Function(Customer) onEdit;

  CustomerList({required this.customers, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];

        return GestureDetector(
          onTap: () => onEdit(customer),
          onLongPress: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm Deletion"),
                  content: Text('Are you sure you want to delete the user named "${customer.name}" ?'),
                  actions: [
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("Delete", style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        onDelete(customer.id!);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(children: [Text("Customer Name :"), Text(customer.name)]),
                  Row(children: [Text("Date of Birth       :"), Text(customer.dob)]),
                  Row(children: [Text("Credit                  :"), Text("\$${customer.balance}")]),
                ],
              ),

            ),
          ),
        );
      },
    );
  }
}
