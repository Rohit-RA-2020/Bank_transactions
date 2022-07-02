import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/bank_model.dart';
import '../providers/provider.dart';
import '../screens/transaction.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({Key? key, required this.banks}) : super(key: key);

  final List<Bank> banks;

  @override
  Widget build(BuildContext context) {
    bankList = banks;
    return ListView.builder(
      itemCount: banks.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          elevation: 0,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Image.network(banks[index].logo, height: 20),
                    const SizedBox(width: 20),
                    Text(
                      banks[index].name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15.0, bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(banks[index].account,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold)),
                    const Text('Your Balance',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(banks[index].accNumber,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold)),
                    Text('₹ ${banks[index].balance}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) {
                              return TransactionPage(index: index);
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'View Transactions',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.grey.shade400,
                thickness: 0.6,
                endIndent: 20,
                indent: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}
