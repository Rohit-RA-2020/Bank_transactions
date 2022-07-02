import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transactions/providers/provider.dart';

class FilterSheet extends ConsumerWidget {
  const FilterSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = ref.watch(timeProvider);
    final range = ref.watch(rangeProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: ListView(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Icon(Icons.close, color: Colors.grey.shade600, size: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sort & Filter',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          const Divider(endIndent: 20.0, indent: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 30.0, bottom: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sort by time',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text("Latest to Oldest"),
            leading: Radio(
              value: "lto",
              groupValue: time,
              onChanged: (value) {
                ref.read(timeProvider.notifier).state = value.toString();
                final lto = ref
                    .read(filtersProvider.notifier)
                    .state
                    .update('lto', (st) => value == 'lto' ? true : false);
                ref
                    .read(filtersProvider.notifier)
                    .state
                    .update('otl', (st) => value == !lto);
              },
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          ),
          ListTile(
            title: const Text("Oldest to Latest"),
            leading: Radio(
              value: "otl",
              groupValue: time,
              onChanged: (value) {
                ref.read(timeProvider.notifier).state = value.toString();
                final otl = ref
                    .read(filtersProvider.notifier)
                    .state
                    .update('otl', (st) => value == 'otl' ? true : false);
                ref
                    .read(filtersProvider.notifier)
                    .state
                    .update('lto', (st) => value == !otl);
              },
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 30.0, bottom: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Filter by',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                Checkbox(
                  value: ref.watch(isCheckedProvider)[0],
                  onChanged: (bool? value) {
                    ref.watch(isCheckedProvider.notifier).state = [
                      value!,
                      ref.watch(isCheckedProvider)[1],
                      ref.watch(isCheckedProvider)[2],
                    ];
                    ref
                        .read(filtersProvider.notifier)
                        .state
                        .update('credit', (st) => value);
                  },
                ),
                const Text('Credit', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                Checkbox(
                  value: ref.watch(isCheckedProvider)[1],
                  onChanged: (bool? value) {
                    ref.watch(isCheckedProvider.notifier).state = [
                      ref.watch(isCheckedProvider)[0],
                      value!,
                      ref.watch(isCheckedProvider)[2],
                    ];
                    ref
                        .read(filtersProvider.notifier)
                        .state
                        .update('debit', (st) => value);
                  },
                ),
                const Text('Debit', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                Checkbox(
                  value: ref.watch(isCheckedProvider)[2],
                  onChanged: (bool? value) {
                    ref.watch(isCheckedProvider.notifier).state = [
                      ref.watch(isCheckedProvider)[0],
                      ref.watch(isCheckedProvider)[1],
                      value!,
                    ];
                    ref
                        .read(filtersProvider.notifier)
                        .state
                        .update('range', (st) => value);
                  },
                ),
                Text(
                  'Amount Between ${range.start.round()} and ${range.end.round()}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          RangeSlider(
            values: range,
            max: 100000,
            divisions: 100,
            labels: RangeLabels(
              '₹${range.start.round()}',
              '₹${range.end.round()}',
            ),
            onChanged: ref.watch(isCheckedProvider)[2]
                ? (RangeValues values) {
                    ref.watch(rangeProvider.notifier).state = values;
                  }
                : null,
          ),
          Row(
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50.0,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side:
                            const BorderSide(width: 1.5, color: Colors.indigo),
                      ),
                      onPressed: () {
                        ref.refresh(isCheckedProvider);
                        ref.refresh(timeProvider);
                        ref.refresh(rangeProvider);
                        ref.refresh(filtersProvider);
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
