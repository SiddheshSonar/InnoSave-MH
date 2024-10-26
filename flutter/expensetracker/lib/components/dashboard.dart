import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'form.dart'; // Import the form.dart file for the form component

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Innosave',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/images/profile.png'), // replace with actual image
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/avatar2.jpeg', // replace with your actual image path
                        width: 90.0,
                        height: 90.0,
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        '#1 Novice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16.0), // Space between image and bars
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.heart_fill,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: _buildStatBar(
                                  'Health Points', 10, 70, Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/level.png',
                              height: 24.0,
                              width: 24.0,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: _buildXPBar('XP Points', 30, 50),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              _buildMonthlyOverview(),
              const SizedBox(height: 20.0),
              _buildExpensesSection(),
              const SizedBox(height: 20.0),
              _buildRecentTransactions(context), // Pass context here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBar(String label, int value, int maxValue, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 4.0),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 8.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              Container(
                width: (value / maxValue) * 100,
                height: 8.0,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildXPBar(String label, int value, int maxValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
              Text(
                'XP: $value/$maxValue',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 10.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              Container(
                width: (value / maxValue) * 100,
                height: 10.0,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true, 
                  builder: (BuildContext context) {
                    return TransactionForm();
                  },
                );
              },
              child: Icon(
                Icons.add_circle_outline,
                color: Colors.white,
                size: 24.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.0),
        _buildTransactionItem('Bought a new phone', 'Rs. 20,000', Colors.red),
        _buildTransactionItem(
            'Bought a new headphone', 'Rs. 5,000', Colors.red),
        _buildTransactionItem('Received salary', 'Rs. 50,000', Colors.green),
      ],
    );
  }

  Widget _buildTransactionItem(String label, String amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          Text(
            amount,
            style: TextStyle(
                color: color, fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyOverview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildIncomeExpenseCard(
            'Income', '₹ 100,000.00', Colors.white, Colors.black),
        _buildIncomeExpenseCard(
            'Expense', '₹ 50,000.00', Colors.black, Colors.white),
      ],
    );
  }

  Widget _buildIncomeExpenseCard(
      String label, String amount, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(color: textColor, fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
          Text(
            amount,
            style: TextStyle(
                color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expenses this month',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        SizedBox(height: 12.0),
        Row(
          children: [
            _buildExpenseCategory('Housing', '₹ 12,500.00', Colors.purple),
            _buildExpenseCategory('Transportation', '₹ 12,500.00', Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildExpenseCategory(String label, String amount, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              amount,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
