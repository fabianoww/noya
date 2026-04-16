import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/model/credit_card.dart';
import 'package:noya2/services/credit_card_service.dart';
import 'package:noya2/services/transaction_service.dart';

class CreditCardForm extends StatefulWidget {
  late CreditCard _creditCard;
  late ValueNotifier<CreditCard?> _notifier;

  CreditCardForm(ValueNotifier<CreditCard?> notifier) {
    this._creditCard = new CreditCard(null, null, null, null);
    this._notifier = notifier;
  }
  CreditCardForm.edit(CreditCard creditCard, ValueNotifier<CreditCard?> notifier) {
    this._creditCard = creditCard;
    this._notifier = notifier;
  }

  @override
  State<StatefulWidget> createState() {
    return _CreditCardFormState(this._creditCard, this._notifier);
  }
}

class _CreditCardFormState extends State<CreditCardForm> {
  late CreditCard _creditCard;
  late ValueNotifier<CreditCard?> _notifier;
  final _formKey = GlobalKey<FormState>();

  _CreditCardFormState(CreditCard creditCard, ValueNotifier<CreditCard?> notifier) {
    this._creditCard = creditCard;
    this._notifier = notifier;
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(this.getTitle(context)),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: AppLocalizations.of(context)!.nav_back,
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                          autofocus: true,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.create_rounded),
                              labelText: AppLocalizations.of(context)!.input_creditcard_description_label,
                              hintText: AppLocalizations.of(context)!.input_creditcard_description_hint),
                          textCapitalization: TextCapitalization.sentences,
                          initialValue: this._creditCard.label,
                          validator: (String? value) {
                            return value?.isEmpty ?? true ? AppLocalizations.of(context)!.input_validation_required : null;
                          },
                          onSaved: (value) => this._creditCard.label = value!,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => node.nextFocus())),
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                          autofocus: true,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.text_snippet_rounded),
                              labelText: AppLocalizations.of(context)!.input_creditcard_close_day_label,
                              hintText: AppLocalizations.of(context)!.input_creditcard_close_day_hint),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]+'))],
                          initialValue: this._creditCard.closeDay?.toString(),
                          validator: (String? value) {
                            if (value?.isEmpty ?? true) {
                              return AppLocalizations.of(context)!.input_validation_required;
                            }
                            else if (int.parse(value!) < 1 || int.parse(value) > 30) {
                              return AppLocalizations.of(context)!.input_validation_day_of_month;
                            }
                            return null;
                          },
                          onSaved: (value) => this._creditCard.closeDay = int.parse(value!),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => node.nextFocus())),
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                          autofocus: true,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.local_atm_rounded),
                              labelText: AppLocalizations.of(context)!.input_creditcard_due_day_label,
                              hintText: AppLocalizations.of(context)!.input_creditcard_due_day_hint),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]+'))],
                          initialValue: this._creditCard.dueDay?.toString(),
                          validator: (String? value) {
                            if (value?.isEmpty ?? true) {
                              return AppLocalizations.of(context)!.input_validation_required;
                            }
                            else if (int.parse(value!) < 1 || int.parse(value) > 30) {
                              return AppLocalizations.of(context)!.input_validation_day_of_month;
                            }
                            return null;
                          },
                          onSaved: (value) => this._creditCard.dueDay = int.parse(value!),
                          textInputAction: TextInputAction.done))
                ],
              ),
            )),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.check),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              CreditCardService.save(this._creditCard).then((id) {
                this._creditCard.id = id;
                this._notifier.value = this._creditCard;
                Navigator.pop(context);
              });
            }
          },
        ));
  }

  void validateDelete(BuildContext context) {
    TransactionService.getTransactionsCountByCreditCard(this._creditCard).then((count) {
       if (count > 0) {
        showErrorMessage(AppLocalizations.of(context)!.error_delete_credit_card_exists_transactions(count));
      } else {
        showConfirmBeforeDelete(context);
      }
    });
  }

  void showConfirmBeforeDelete(BuildContext context) {
    // set up the buttons
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirm_delete_credit_card_title),
          content: Text(AppLocalizations.of(context)!.confirm_delete_credit_card_text),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.button_no),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
                child: Text(AppLocalizations.of(context)!.button_yes),
                onPressed: () {
                  deleteCreditCard(context);
                })
          ],
        );
      },
    );
  }

  void showErrorMessage(String message) {
    // set up the buttons
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.error_title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.error_close),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  void deleteCreditCard(BuildContext context) {
    CreditCardService.delete(_creditCard).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  String getTitle(BuildContext context) {
    if (this._creditCard != null && this._creditCard.id != null) {
      return AppLocalizations.of(context)!.title_edit_credit_card;
    } else {
      return AppLocalizations.of(context)!.title_new_credit_card;
    }
  }
}
