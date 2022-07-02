import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/bank_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<Bank> bankList = [];
List<Bank> sortedBankList = [];

final filtersProvider = StateProvider((ref) => {
      "lto": false,
      "otl": false,
      "credit": false,
      "debit": false,
      "range": false,
    });

final isCheckedProvider = StateProvider((ref) => [false, false, false]);
final timeProvider = StateProvider((ref) => '');
final rangeProvider = StateProvider((ref) => const RangeValues(1000, 80000));

Future<List<Bank>> fetchBank() async {
  final response = await rootBundle.loadString('assets/data.json');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseBank, response);
}

// A function that converts a response body into a List<Photo>.
List<Bank> parseBank(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  bankList = parsed.map<Bank>((json) => Bank.fromJson(json)).toList();
  sortedBankList = bankList;

  return bankList;
}
