import 'package:flutter/material.dart';
import 'package:proj_03/widgets/expenses_list/expenses_list.dart';
import 'package:proj_03/models/expense.dart';
import 'package:proj_03/widgets/new_expense.dart';
import 'package:proj_03/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerExpenses = [
    Expense(
      title: 'Flutter course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true, //force show in safe Area
      isScrollControlled: true, //force modal show full screen
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registerExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final index = _registerExpenses.indexOf(expense);

    setState(() {
      _registerExpenses.remove(expense);
    });

    //remove all current snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(
          seconds: 3,
        ),
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registerExpenses.insert(index, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //the build() method is executed again when device is rotated

    final width = MediaQuery.of(context).size.width;

    Widget listItemContent = const Center(
      child: Text('Empty List'),
    );

    if (_registerExpenses.isNotEmpty) {
      listItemContent = ExpensesList(
        expenses: _registerExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(
              Icons.add,
            ),
          )
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                // Toolbar with the Add button
                Chart(expenses: _registerExpenses),
                Expanded(
                  child: listItemContent,
                ),
              ],
            )
          : Row(
              children: [
                // Expanded constraints the child to only takes as much width as available in the Row after resizing the other Row children
                Expanded(
                  child: Chart(expenses: _registerExpenses),
                ),
                Expanded(
                  child: listItemContent,
                ),
              ],
            ),
    );
    ;
  }
}
