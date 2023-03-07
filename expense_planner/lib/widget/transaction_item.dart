import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.deleteTransation,
  });

  final Transaction transaction;
  final Function deleteTransation;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
                child: Text('\$${transaction.amount}')),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 450
            ? TextButton.icon(
                onPressed: () =>
                    deleteTransation(transaction.id),
                icon: Icon(Icons.delete),
                label: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).errorColor,
                ),
              )
            : IconButton(
                icon: Icon(Icons.delete),
                onPressed: () =>
                    deleteTransation(transaction.id),
              ),
      ),
    );
  }
}
