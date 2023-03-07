import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/transaction.dart';

import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> transactions;
  const Chart(this.transactions);

  List<Map<String, Object>> get groupedTransactionValue {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalAmount = 0;
      for (var i = 0; i < transactions.length; i++) {
        if (transactions[i].date.day == weekDay.day &&
            transactions[i].date.month == weekDay.month &&
            transactions[i].date.year == weekDay.year) {
          totalAmount += transactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0,1),
        'amount': totalAmount,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValue.fold(
        0.0, (sum, data) => sum += (data['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValue.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'] as String,
                data['amount'] as double,
                totalSpending == 0
                    ? 0.0
                    : (data['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
