import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTX;
  NewTransaction(this.addTX);

  @override
  State<NewTransaction> createState() => NewTransactionState();
}

class NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submiteTX() {
    if (_amountController.text.isEmpty) return;
    final submitTitle = _titleController.text;
    final submitAmount = double.parse(_amountController.text);

    if (submitAmount <= 0 || submitTitle.isEmpty || _selectedDate == null)
      return;

    widget.addTX(
      submitTitle,
      submitAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _selectDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date == null) return;
      setState(() {
        _selectedDate = date;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                decoration: InputDecoration(label: Text('Title')),
                controller: _titleController,
                onFieldSubmitted: (value) => _submiteTX(),
              ),
              TextFormField(
                decoration: InputDecoration(label: Text('Amount')),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (value) => _submiteTX(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'no date chosen!'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}'),
                    ),
                    TextButton(
                      onPressed: _selectDate,
                      child: Text('Choose Date',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _submiteTX,
                child: Text(
                  'Add Transaction',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Theme.of(context).textTheme.button!.color,
                ),
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
}
