class Bank {
  Bank({
    required this.name,
    required this.logo,
    required this.account,
    required this.accNumber,
    required this.balance,
    required this.transactions,
    required this.interest,
  });

  String name;
  String logo;
  String account;
  String accNumber;
  double balance;
  double interest;
  List<Transaction> transactions;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        name: json["name"],
        logo: json["logo"],
        account: json["account"],
        accNumber: json["acc_number"],
        balance: json["balance"],
        interest: json["interest"],
        transactions: List<Transaction>.from(
            json["transactions"].map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "logo": logo,
        "account": account,
        "acc_number": accNumber,
        "balance": balance,
        "interest": interest,
        "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
      };
}

class Transaction {
  Transaction({
    required this.date,
    required this.amount,
    required this.credit,
    required this.description,
  });

  DateTime date;
  double amount;
  bool credit;
  String description;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        date: DateTime.parse(json["date"]),
        amount: json["amount"],
        credit: json["credit"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "amount": amount,
        "credit": credit,
        "description": description,
      };
}
