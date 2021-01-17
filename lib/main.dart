import 'package:flutter/material.dart';

// import 'package:flutter/services.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Quicksand',
      ),
      title: "Personal Expenses",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> transactions = [
    // Transaction(id: 1, title: "shopping", amount: 33.0, date: DateTime.now()),
    // Transaction(id: 1, title: "payment2", amount: 33.0, date: DateTime.now())
  ];

  bool showCart = false;

  List<Transaction> get _recentTransactions {
    return transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void addTransaction(String title, double amount, DateTime chosenDate) {
    final newtrs = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: chosenDate,
    );

    setState(() {
      transactions.add(newtrs);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (ctxe) {
          return NewTransaction(addTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      transactions.removeWhere((tx) => tx.id == id);
    });
  }

  void clearTransaction() {
    setState(() {
      transactions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final islandscap =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final myAppBar = AppBar(
      actions: [
        transactions.length > 0
            ? IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () => clearTransaction(),
              )
            : SizedBox(),
        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () => startAddNewTransaction(context),
        ),
      ],
      title: Text(
        "Personal Expenses",
        style: TextStyle(
          fontFamily: 'OpenSans',
        ),
      ),
    );
    return Scaffold(
      appBar: myAppBar,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (islandscap)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart'),
                  Switch(
                      value: showCart,
                      onChanged: (val) {
                        setState(() {
                          showCart = val;
                        });
                      })
                ],
              ),
            if (!islandscap)
              Container(
                height: (MediaQuery.of(context).size.height -
                        myAppBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!islandscap)
              Container(
                height: (MediaQuery.of(context).size.height -
                        myAppBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.7,
                child: TransactionList(transactions, _deleteTransaction),
              ),
            if (islandscap)
              showCart
                  ? Container(
                      height: (MediaQuery.of(context).size.height -
                              myAppBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  : Container(
                      height: (MediaQuery.of(context).size.height -
                              myAppBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          1,
                      child: TransactionList(transactions, _deleteTransaction),
                    ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => startAddNewTransaction(context),
      ),
    );
  }
}
