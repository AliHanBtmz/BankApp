import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../modules/customer.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class AddCustomerScreen extends StatefulWidget {
  final Customer? customer;

  AddCustomerScreen({this.customer});

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  String _selectedDate = '';

  @override
  void initState() {
    super.initState();

    if (widget.customer != null) {
      _nameController.text = widget.customer!.name;
      _selectedDate = widget.customer!.dob;
      _balanceController.text = widget.customer!.balance.toString();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate:
          _selectedDate.isNotEmpty
              ? DateTime.parse(_selectedDate)
              : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      dateFormat: "dd-MM-yyyy",
      looping: true,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked.toIso8601String().split('T')[0];
      });
    }
  }

  void _resetFields() {
    setState(() {
      _nameController.clear();
      _balanceController.clear();
      _selectedDate = '';
    });
  }

  void _saveCustomer() async {
    if (_nameController.text.isEmpty ||
        _selectedDate.isEmpty ||
        _balanceController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fill in all fields!')));
      return;
    }

    Customer customer = Customer(
      id: widget.customer?.id,
      name: _nameController.text,
      dob: _selectedDate,
      balance: double.parse(_balanceController.text),
    );
    int result;
    if (widget.customer == null) {

      result = await DatabaseHelper.instance.insertCustomer(customer);
    } else {
      result = await DatabaseHelper.instance.updateCustomer(customer);
    }

    print("Güncelledi mi: ${result == 1 ? 'yes' : 'no'}");
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF333C92),
      appBar: AppBar(
        title: Center(
          child: const Text(
            "Bank Account Info",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name and Surname ',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 10),

            SizedBox(height: 5),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText:
                        _selectedDate.isEmpty ? 'Date of Birth' : _selectedDate,
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _balanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Credit',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _saveCustomer,
                  child: Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF922C97),
                    foregroundColor: Colors.white,
                  ),
                ),

                ElevatedButton(
                  onPressed: _resetFields,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF922C97),
                  ),
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: Colors.white,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
