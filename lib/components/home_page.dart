import 'dart:math';

import 'package:despesas_pessoais/components/transaction_chart.dart';
import 'package:despesas_pessoais/models/transaction.dart';
import 'package:flutter/material.dart';

import 'transaction_form.dart';
import 'transaction_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _transactions = <Transaction>[
    Transaction(
      id: Random().nextDouble().toString(),
      title: 'Novo tênis de corrida',
      value: 310.76,
      date: DateTime.now().subtract(Duration(days: 3, hours: 31)),
    ),
    Transaction(
      id: Random().nextDouble().toString(),
      title: 'Conta antiga',
      value: 251.76,
      date: DateTime.now().subtract(Duration(days: 28)),
    ),
    Transaction(
      id: Random().nextDouble().toString(),
      title: 'Conta de luz',
      value: 211.30,
      date: DateTime.now().subtract(Duration(days: 1, hours: 5)),
    ),
  ];

  List<Transaction> get _recentTransactions {
    return _transactions
        .where((transaction) =>
            DateTime.now().difference(transaction.date).inDays <= 7)
        .toList();
  }

  void _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _openTransactionFormModal(context),
          )
        ],
        title: Text('Despesas Pessoais'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TransactionChart(_recentTransactions),
            TransactionList(this._transactions, _removeTransaction),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });
    Navigator.of(context).pop();
  }
}
