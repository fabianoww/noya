import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noya2/activities/credit_card_activity.dart';
import 'package:noya2/theme/app_theme.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:noya2/components/noya_fab.dart';
import 'package:noya2/activities/configuration.dart';
import 'package:noya2/activities/timeline.dart';
import 'package:noya2/activities/spreadsheet.dart';
import 'package:noya2/activities/category_activity.dart';
import 'package:noya2/activities/analytics.dart';
import 'package:noya2/notifiers/refresh_controller.dart';

void main() {
  runApp(const NoyaApp());
}

class NoyaApp extends StatelessWidget {
  const NoyaApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NOYA2',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ListenableProvider<RefreshController>(create: (context) => RefreshController(), child: MainPage())
      //home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _navIndex = 0;
  late List<Widget> _children;
  bool _searchMode = false;
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _searchQueryNotifier = ValueNotifier<String>('');
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _children = [
      Timeline(DateTime.now(), searchNotifier: _searchQueryNotifier),
      Spreadsheet(DateTime.now(), searchNotifier: _searchQueryNotifier),
      const Analytics(),
    ];
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _searchQueryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _searchMode
              ? TextFormField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  onChanged: _onSearchChanged,
                )
              : const Text('NOYA'),
          actions: [
            IconButton(
              icon: Icon(_searchMode ? Icons.close : Icons.search),
              onPressed: _toggleSearchMode,
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(title: Text(AppLocalizations.of(context)!.menu_home), onTap: () {
                Navigator.pop(context);
              }),
              ListTile(title: Text(AppLocalizations.of(context)!.menu_category), onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryActivity())).then((value) {
                  if (context.mounted) {
                    Provider.of<RefreshController>(context, listen: false).notifyListeners();
                  }
                });
              }),
              ListTile(title: Text(AppLocalizations.of(context)!.menu_credit_card), onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreditCardActivity())).then((value) {
                  if (context.mounted) {
                    Provider.of<RefreshController>(context, listen: false).notifyListeners();
                  }
                });
              }),
              ListTile(title: Text(AppLocalizations.of(context)!.menu_settings), onTap: () {
                Navigator.pop(context);
                Navigator.push(context,MaterialPageRoute(builder: (context)  => Configuration())).then((value) {
                  if (context.mounted) {
                    Provider.of<RefreshController>(context, listen: false).notifyListeners();
                  }
                });
              }),
            ],
          ),
        ),
        body: _children[_navIndex],
        //body: Text('Teste'),
        bottomNavigationBar: BottomNavigationBar(currentIndex: _navIndex, onTap: onNavTap, items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted), label: AppLocalizations.of(context)!.navbar_ultimasTransacoes),
          BottomNavigationBarItem(icon: Icon(Icons.view_module), label: AppLocalizations.of(context)!.navbar_planilha),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: AppLocalizations.of(context)!.navbar_analytics)
        ]),
        floatingActionButton: NoyaFab());
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _searchQueryNotifier.value = value;
      }
    });
  }

  void _toggleSearchMode() {
    setState(() {
      _searchMode = !_searchMode;

      if (!_searchMode) {
        _searchController.clear();
        _searchDebounce?.cancel();
        _searchQueryNotifier.value = '';
      }
    });
  }

  void onNavTap(int index) {
    setState(() {
      _navIndex = index;
    });
  }
}
