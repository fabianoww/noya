import 'package:flutter/material.dart';
import 'package:noya2/components/horizontal_divider.dart';
import 'package:noya2/components/timeline_bar.dart';
import 'package:noya2/components/transaction_card.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/model/timeline_data.dart';
import 'package:noya2/model/transaction_record.dart';
import 'package:noya2/notifiers/refresh_controller.dart';
import 'package:noya2/services/date_service.dart';
import 'package:noya2/services/transaction_service.dart';
import 'package:provider/provider.dart';

class Timeline extends StatefulWidget {
  final DateTime _date;
  final ValueNotifier<String>? searchNotifier;

  const Timeline(this._date, {super.key, this.searchNotifier});

  @override
  State<StatefulWidget> createState() {
    return _TimelineState();
  }
}

class _TimelineState extends State<Timeline> {
  late DateTime _date;
  final ScrollController _scrollController = ScrollController();
  final List<TransactionRecord> _transactions = [];
  TimelineData? _summaryData;
  int _offset = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isInitialLoading = true;
  RefreshController? _refreshController;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _date = widget._date;
    _searchTerm = widget.searchNotifier?.value ?? '';
    widget.searchNotifier?.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newRefreshController = Provider.of<RefreshController>(context, listen: false);
    if (_refreshController != newRefreshController) {
      _refreshController?.removeListener(_onRefresh);
      _refreshController = newRefreshController;
      _refreshController?.addListener(_onRefresh);
    }
  }

  @override
  void dispose() {
    widget.searchNotifier?.removeListener(_onSearchChanged);
    _scrollController.dispose();
    _refreshController?.removeListener(_onRefresh);
    super.dispose();
  }

  void _onSearchChanged() {
    final newSearchTerm = widget.searchNotifier?.value ?? '';
    if (newSearchTerm != _searchTerm) {
      setState(() {
        _searchTerm = newSearchTerm;
        _loadInitialData(); // Reload data based on the new search term
      });
    }
  }

  void _onRefresh() {
    _loadInitialData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isInitialLoading = true;
      _offset = 0;
      _transactions.clear();
      _hasMore = true;
    });

    try {
      final data = await TransactionService.getTimelineData(_date, _searchTerm);
      if (mounted) {
        setState(() {
          _summaryData = data;
          _transactions.addAll(data.transactions);
          _offset = _transactions.length;
          _hasMore = data.transactions.length == 10;
          _isInitialLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isInitialLoading = false);
      }
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final newTransactions = await TransactionService.getTimelineTransactions(_offset, 5, _searchTerm);
      if (mounted) {
        setState(() {
          _transactions.addAll(newTransactions);
          _offset += newTransactions.length;
          _hasMore = newTransactions.length == 5;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RefreshController>(builder: (context, controller, child) {
      // Re-load data if a refresh is triggered elsewhere
      // Note: This logic might need refinement depending on how RefreshController is used.
      // If it's used to trigger a full refresh, we should listen to it.
      
      if (_isInitialLoading) {
        return Center(child: CircularProgressIndicator());
      }

      if (_transactions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('😄', style: TextStyle(fontSize: 48)),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  AppLocalizations.of(context)!.text_welcome,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  AppLocalizations.of(context)!.text_orientation,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        controller: _scrollController,
        itemCount: _transactions.length + 6 + (_hasMore ? 1 : 0), // summary items + spacer + optional loader
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                    child: Text(DateService.getMonthDesc(_date, AppLocalizations.of(context)!.localeName),
                        style: Theme.of(context).textTheme.headlineMedium)));
          } else if (index == 1) {
            return Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: TimelineBar(_summaryData!.revenuePercentage, _summaryData!.revenue, TimelineBar.revenue));
          } else if (index == 2) {
            return Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: TimelineBar(_summaryData!.expensePercentage, _summaryData!.expense, TimelineBar.expense));
          } else if (index == 3) {
            return Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: TimelineBar(_summaryData!.goalPercentage, _summaryData!.goal, TimelineBar.goal));
          } else if (index == 4) {
            return HorizontalDivider(AppLocalizations.of(context)!.navbar_ultimasTransacoes);
          } else if (index < _transactions.length + 5) {
            return TransactionCard(_transactions[index - 5]);
          } else if (index == _transactions.length + 5) {
            return Container(height: 50);
          } else {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      );
    });
  }
}
