import 'package:flutter/material.dart';
import 'package:noya2/activities/credit_card_form.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/model/credit_card.dart';
import 'package:noya2/services/credit_card_service.dart';

class CreditCardActivity extends StatefulWidget {
  const CreditCardActivity({super.key});

  @override
  State<CreditCardActivity> createState() => _CreditCardActivityState();
}

class _CreditCardActivityState extends State<CreditCardActivity> {
  late Future<List<CreditCard>> _creditCardsFuture;

  @override
  void initState() {
    super.initState();
    _loadCreditCards();
  }

  void _loadCreditCards() {
    _creditCardsFuture = CreditCardService.listActive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.menu_credit_card)
      ),
      body: _buildCreditCardList(_creditCardsFuture),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return CreditCardForm(ValueNotifier(null));
            }),
          ).then((value) {
            if (mounted) {
              setState(() {
                _loadCreditCards();
              });
            }
          });
        },
      )
    );
  }

  Widget _buildCreditCardList(Future<List<CreditCard>> creditCardsFuture) {
    return FutureBuilder<List<CreditCard>>(
      future: creditCardsFuture,
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
                    AppLocalizations.of(context)!.credit_card_list_no_data,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    AppLocalizations.of(context)!.credit_card_list_no_data_orientation,
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
              CreditCard creditCard = snapshot.data![index];
              return ListTile(
                title: Text(creditCard.label ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CreditCardForm.edit(creditCard, ValueNotifier(null));
                      },
                    ),
                  ).then((value) {
                    if (mounted) {
                      setState(() {
                        _loadCreditCards();
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
