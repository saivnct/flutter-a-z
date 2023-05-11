import 'package:flutter/material.dart';
import 'package:proj_03/models/expense.dart';
import 'package:proj_03/widgets/expenses_list/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;

  final void Function(Expense expense) onRemoveExpense;

  Widget itemBuilder(BuildContext ctx, int index) {
    return Dismissible(
      key: ValueKey(expenses[index].id),
      background: Container(
        color: Theme.of(ctx).colorScheme.error.withOpacity(0.75),
        margin: EdgeInsets.symmetric(
          horizontal: Theme.of(ctx).cardTheme.margin!.horizontal,
        ),
      ),
      onDismissed: (direction) {
        onRemoveExpense(expenses[index]);
      },
      child: ExpenseItem(
        expense: expenses[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //we should not use Column() for list that we do not know length -> behind the scene, Column() will create all item event Item is not visible -> affect performance

    //ListView is scrollable by default
    //ListView.builder create list items only when they're visible or about to become visible
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: itemBuilder,
    );
  }
}
