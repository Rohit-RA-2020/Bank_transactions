import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transactions/providers/provider.dart';
import 'package:transactions/widgets/filter.dart';

class TransactionPage extends ConsumerWidget {
  const TransactionPage({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Transactions'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ListView(
          children: [
            BankCard(index: index),
            TransactionCard(index: index),
            TransactionsList(index: index),
          ],
        ),
      ),
    );
  }
}

class TransactionsList extends ConsumerWidget {
  const TransactionsList({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChecked = ref.watch(isCheckedProvider);
    final time = ref.watch(timeProvider);
    final range = ref.watch(rangeProvider);
    sortedBankList = bankList;
    if (time == 'lto') {
      sortedBankList[index]
          .transactions
          .sort(((a, b) => b.date.compareTo(a.date)));
    } else {
      sortedBankList = bankList;
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: sortedBankList[index].transactions.length,
      itemBuilder: (context, idx) {
        if (isChecked[2]) {
          if (sortedBankList[index].transactions[idx].amount > range.start &&
              sortedBankList[index].transactions[idx].amount < range.end) {
            if (isChecked[0] && isChecked[1]) {
              return TransactionCardItem(index: index, idx: idx);
            } else if (isChecked[1]) {
              return !sortedBankList[index].transactions[idx].credit
                  ? TransactionCardItem(index: index, idx: idx)
                  : const SizedBox.shrink();
            } else if (isChecked[0]) {
              return sortedBankList[index].transactions[idx].credit
                  ? TransactionCardItem(index: index, idx: idx)
                  : const SizedBox.shrink();
            } else {
              return TransactionCardItem(index: index, idx: idx);
            }
          } else {
            return const SizedBox.shrink();
          }
        } else {
          if (isChecked[0] && isChecked[1]) {
            return TransactionCardItem(index: index, idx: idx);
          } else if (isChecked[1]) {
            return !sortedBankList[index].transactions[idx].credit
                ? TransactionCardItem(index: index, idx: idx)
                : const SizedBox.shrink();
          } else if (isChecked[0]) {
            return sortedBankList[index].transactions[idx].credit
                ? TransactionCardItem(index: index, idx: idx)
                : const SizedBox.shrink();
          } else {
            return TransactionCardItem(index: index, idx: idx);
          }
        }
      },
    );
  }
}

class TransactionCardItem extends ConsumerWidget {
  const TransactionCardItem({
    Key? key,
    required this.idx,
    required this.index,
  }) : super(key: key);

  final int index;
  final int idx;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                '${bankList[index].transactions[idx].date.year}/${bankList[index].transactions[idx].date.month}/${bankList[index].transactions[idx].date.day}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bankList[index].transactions[idx].description,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '₹ ${bankList[index].transactions[idx].amount} ',
                      style: bankList[index].transactions[idx].credit
                          ? const TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )
                          : const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                    bankList[index].transactions[idx].credit
                        ? const Icon(Icons.arrow_downward, color: Colors.green)
                        : const Icon(Icons.arrow_upward, color: Colors.red),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionCard extends ConsumerWidget {
  const TransactionCard({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Last 10 Transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const FilterSheet(),
                );
              },
              icon: Icon(
                Icons.filter_alt_rounded,
                color: Colors.grey.shade700,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BankCard extends StatelessWidget {
  const BankCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.network(bankList[index].logo, height: 20),
                    const SizedBox(width: 15),
                    Text(
                      bankList[index].name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                Text(
                  '₹ ${bankList[index].balance}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24.0),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 50.0),
            child: Row(
              children: [
                Text(
                  '${bankList[index].account} (${bankList[index].accNumber})',
                  style: const TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\t\t${bankList[index].interest}% p.a.',
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
