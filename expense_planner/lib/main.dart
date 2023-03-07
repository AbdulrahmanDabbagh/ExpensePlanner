import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './model/transaction.dart';

import './widget/chart.dart';
import './widget/new_transaction.dart';
import './widget/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(
                color: Colors.white,
              )),
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          errorColor: Colors.red),
      home: MyHomePage(),
      title: 'Personal Expenses',
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 'tr1',
    //     title: 'New Shoes',
    //     amount: 16.43,
    //     date: DateTime.now().subtract(Duration(days: 1))),
    // Transaction(
    //     id: 'tr2', title: 'Weekly ', amount: 99.56, date: DateTime.now()),
  ];

  void _addNewTransaction(String title, double amount, DateTime selectedDate) {
    final newTX = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: selectedDate,
    );
    setState(() {
      _userTransactions.add(newTX);
    });
  }

  void _newTX(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  List<Transaction> get recentTransaction {
    return _userTransactions
      ..where((tx) {
        return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
      }).toList();
  }

  void deleteTransation(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  List<Widget> buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, txListView) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch(
            value: _showChart,
            onChanged: ((value) {
              setState(() {
                _showChart = value;
              });
            }),
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(recentTransaction))
          : txListView
    ];
  }

  List<Widget> buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, txListView) {
    return [
      Container(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.3,
          child: Chart(recentTransaction)),
      txListView,
    ];
  }

  bool _showChart = true;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          onPressed: () => _newTX(context),
          icon: Icon(Icons.add),
        ),
      ],
    );
    final txListView = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(
          userTransactions: _userTransactions,
          deleteTransation: deleteTransation),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (isLandscape) ...buildLandscapeContent(mediaQuery, appBar, txListView),
            if (!isLandscape) ...buildPortraitContent(mediaQuery, appBar, txListView),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _newTX(context),
      ),
    );
  }
}
