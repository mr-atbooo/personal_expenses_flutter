import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _selectedDate;

  void submitData(BuildContext context) {
    final enterdTitle = titleController.text;
    final enterdAmount = amountController.text;
    print(enterdTitle);
    print(enterdAmount);
    if (enterdTitle.isEmpty || enterdAmount.isEmpty) {
      return;
    }

    final title = titleController.text;
    final amount = double.parse(amountController.text);

    if (title.isEmpty || amount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTransaction(title, amount, _selectedDate);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Navigator.pop(context);
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10),
        child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "title"),
                  controller: titleController,
                  onSubmitted: (val) => submitData(context),
                ),
                TextField(
                    decoration: InputDecoration(labelText: "Amount"),
                    controller: amountController,
                    onSubmitted: (val) => submitData(context),
                    keyboardType: TextInputType.number),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                      FlatButton(
                          onPressed: _presentDatePicker,
                          child: Text(
                            "Choose Date",
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
                RaisedButton(
                  child: Text(
                    'Add Transaction',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.purple,
                  onPressed: () => submitData(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
