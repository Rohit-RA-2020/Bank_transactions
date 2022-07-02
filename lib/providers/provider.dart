import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/bank_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<Bank> bankList = [];
List<Bank> sortedBankList = [];

List filters = [];

final isCheckedProvider = StateProvider((ref) => [false, false, false]);

String? time;
//List<bool> isChecked = [false, false, false];
RangeValues currentRangeValues = const RangeValues(1000, 80000);

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
