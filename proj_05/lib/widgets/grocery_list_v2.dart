import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proj_05/data/categories.dart';
import 'package:proj_05/models/grocery_item.dart';
import 'package:proj_05/widgets/new_item.dart';

class GroceryListV2 extends StatefulWidget {
  const GroceryListV2({super.key});

  @override
  State<GroceryListV2> createState() => _GroceryListV2State();
}

class _GroceryListV2State extends State<GroceryListV2> {
  late Future<List<GroceryItem>> _loadedItems;

  @override
  void initState() {
    super.initState();
    _loadedItems = _loadItem();
  }

  Future<List<GroceryItem>> _loadItem() async {
    final url = Uri.https(
        'flutter-a-z-05-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list.json');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Could not fetch data!');
    }

    if (response.body.toLowerCase() == 'Null'.toLowerCase()) {
      return [];
    }

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];

    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere((c) => c.value.title == item.value['category'])
          .value;

      final groceryItem = GroceryItem(
        id: item.key,
        name: item.value['name'],
        quantity: item.value['quantity'],
        category: category,
      );
      loadedItems.add(groceryItem);
    }

    return loadedItems;
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _loadedItems = _loadItem();
    });
  }

  void _removeItem(GroceryItem item) async {
    final url = Uri.https(
        'flutter-a-z-05-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list/${item.id}.json');
    //not wait for the response
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      setState(() {
        _loadedItems = _loadItem();
      });

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Cannot remove item!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      //FutureBuilder is a widget that listen for a future and update itself when the future resolved
      body: FutureBuilder(
        future: _loadedItems,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No items added yet.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, index) => Dismissible(
              onDismissed: (direction) {
                _removeItem(snapshot.data![index]);
              },
              key: ValueKey(snapshot.data![index].id),
              child: ListTile(
                title: Text(snapshot.data![index].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: snapshot.data![index].category.color,
                ),
                trailing: Text(
                  snapshot.data![index].quantity.toString(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
