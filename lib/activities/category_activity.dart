import 'package:flutter/material.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/services/category_service.dart';
import 'package:noya2/activities/category_form.dart';

class CategoryActivity extends StatefulWidget {
  const CategoryActivity({super.key});

  @override
  State<CategoryActivity> createState() => _CategoryActivityState();
}

class _CategoryActivityState extends State<CategoryActivity> {
  late Future<List<Category>> _expenseCategoriesFuture;
  late Future<List<Category>> _revenueCategoriesFuture;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    _expenseCategoriesFuture = CategoryService.listActive(Category.EXPENSE);
    _revenueCategoriesFuture = CategoryService.listActive(Category.REVENUE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.menu_category)
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: AppLocalizations.of(context)!.label_expense),
                Tab(text: AppLocalizations.of(context)!.label_revenue),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCategoryList(_expenseCategoriesFuture, Category.EXPENSE),
                  _buildCategoryList(_revenueCategoriesFuture, Category.REVENUE),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return CategoryForm(Category.EXPENSE, ValueNotifier(null));
            }),
          ).then((value) {
            if (mounted) {
              setState(() {
                _loadCategories();
              });
            }
          });
        },
      )
    );
  }

  Widget _buildCategoryList(
      Future<List<Category>> categoriesFuture, int categoryType) {
    return FutureBuilder<List<Category>>(
      future: categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('😕', style: TextStyle(fontSize: 48)),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    AppLocalizations.of(context)!.category_list_no_data,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    AppLocalizations.of(context)!.category_list_no_data_orientation,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Category category = snapshot.data![index];
              return ListTile(
                leading: Icon(category.icon),
                title: Text(category.label ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CategoryForm.edit(category, ValueNotifier(null));
                      },
                    ),
                  ).then((value) {
                    if (mounted) {
                      setState(() {
                        _loadCategories();
                      });
                    }
                  });
                },
              );
            },
          );
        }
      },
    );
  }
}
