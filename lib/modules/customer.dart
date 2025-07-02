class Customer {
  int? id;
  String name;
  String dob;
  double balance;

  Customer({this.id, required this.name, required this.dob, required this.balance});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dob': dob,
      'balance': balance,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      dob: map['dob'],
      balance: map['balance'],
    );
  }
}
