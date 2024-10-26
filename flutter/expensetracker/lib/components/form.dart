import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  bool _isTitleFocused = false;
  bool _shouldReducePadding = false;

  @override
  void initState() {
    super.initState();

    // Listener for the title field focus
    _titleFocusNode.addListener(() {
      setState(() {
        _isTitleFocused = _titleFocusNode.hasFocus;
      });
    });

    // Listener for the amount field focus to clear padding only if both fields are unfocused
    _amountFocusNode.addListener(() {
      if (!_titleFocusNode.hasFocus && !_amountFocusNode.hasFocus) {
        setState(() {
          _shouldReducePadding = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _handleAddTransaction(BuildContext context) {
    setState(() {
      _shouldReducePadding = true;
    });
    // Dismiss the keyboard
    FocusScope.of(context).unfocus();
    // Close the modal form
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.only(
          bottom: _isTitleFocused || !_shouldReducePadding
              ? MediaQuery.of(context).viewInsets.bottom
              : 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              focusNode: _titleFocusNode,
              decoration: InputDecoration(
                labelText: 'Transaction Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              focusNode: _amountFocusNode,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _handleAddTransaction(context),
              child: Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage of TransactionForm in a showModalBottomSheet
void showTransactionForm(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => TransactionForm(),
  );
}
