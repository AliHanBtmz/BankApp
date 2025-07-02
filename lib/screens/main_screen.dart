import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../modules/customer.dart';
import '../screens/add_customer_screen.dart';
import '../widgets/customer_list.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    final data = await DatabaseHelper.instance.getCustomers();
    setState(() {
      customers = data;
    });
  }

  void _deleteCustomer(int id) async {
    await DatabaseHelper.instance.deleteCustomer(id);
    loadCustomers();
  }

  void _editCustomer(Customer customer) {
    TextEditingController nameController = TextEditingController(
      text: customer.name,
    );
    TextEditingController birthDateController = TextEditingController(
      text: customer.dob,
    );
    TextEditingController balanceController = TextEditingController(
      text: customer.balance.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Customer"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name and Surname'),
              ),
              TextField(
                controller: birthDateController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await DatePicker.showSimpleDatePicker(
                    context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    dateFormat: "dd-MM-yyyy",
                    looping: true,
                  );
                  if (pickedDate != null) {
                    birthDateController.text =
                        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                  }
                },
              ),
              TextField(
                controller: balanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Credit'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Customer updatedCustomer = Customer(
                  id: customer.id,
                  name: nameController.text,
                  dob: birthDateController.text,
                  balance: double.parse(balanceController.text),
                );
                await DatabaseHelper.instance.updateCustomer(updatedCustomer);
                loadCustomers();
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCustomerScreen()),
    );
    if (result == true) loadCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF282474),
      appBar: AppBar(
        title: Center(
          child: const Text(
            "Bank Account Info",
            style: TextStyle(
              fontWeight: FontWeight.bold, //
              fontSize: 25, //
            ),
          ),
        ),
        backgroundColor: Color(0XFF4482D4),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/images/bank_logo.png", fit: BoxFit.cover),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _navigateToAddScreen,
          ),
        ],
      ),
      body: Stack(
        children: [

          Opacity(
            opacity: 0.6,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/zz.png"),
                  fit: BoxFit.contain,

                ),
              ),
            ),
          ),

          customers.isEmpty
              ? Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 50.0,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      "No Customer Records !",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
              : CustomerList(
                customers: customers,
                onDelete: _deleteCustomer,
                onEdit: _editCustomer,
              ),
        ],
      ),
    );
  }
}
