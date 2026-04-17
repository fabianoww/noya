import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noya2/activities/category_form.dart';
import 'package:noya2/activities/credit_card_form.dart';
import 'package:noya2/components/text_field_date_picker.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/model/credit_card.dart';
import 'package:noya2/model/payment_method.dart';
import 'package:noya2/model/transaction_record.dart';
import 'package:noya2/services/category_service.dart';
import 'package:noya2/services/configuration_service.dart';
import 'package:noya2/services/credit_card_service.dart';
import 'package:noya2/services/transaction_service.dart';

class TransactionForm extends StatefulWidget {
  late int _type;
  TransactionRecord _transaction = TransactionRecord(null, null, null, null, null, DateTime.now(), null, 1, null);

  TransactionForm(this._type, {super.key});
  
  TransactionForm.edit(TransactionRecord transaction, {super.key}) {
    _type = transaction.category!.type!;
    _transaction = transaction;
  }

  @override
  State<StatefulWidget> createState() {
    return _TransactionFormState(_type, _transaction);
  }
}

class _TransactionFormState extends State<TransactionForm> {
  late int _type;
  late TransactionRecord? _transaction;
  final _formKey = GlobalKey<FormState>();
  late bool _creditCardVisible;
  late FocusNode _paymentMethodFocus;
  late FocusNode _creditCardFocus;
  late FocusNode _installmentsFocus;
  late List<Category> _categoryList;
  late List<CreditCard> _creditCardList;
  final ValueNotifier<Category?> _categoryAddedNotifier = ValueNotifier(null);
  final ValueNotifier<IconData> _categoryIconNotifier = ValueNotifier(Icons.label);
  final ValueNotifier<CreditCard?> _creditcardAddedNotifier = ValueNotifier(null);
  final ValueNotifier<PaymentMethod?> _paymentMethodNotifier = ValueNotifier(null);
  late TextEditingController _labelController;

  _TransactionFormState(int type, TransactionRecord? transaction) {
    _type = type;
    _transaction = transaction;
    _creditCardVisible =
        _transaction != null && _transaction!.creditCard != null;
    _categoryList = [];
    _creditCardList = [];
  }

  @override
  void initState() {
    super.initState();

    _paymentMethodFocus = FocusNode();
    _creditCardFocus = FocusNode();
    _installmentsFocus = FocusNode();
    
    CategoryService.listActive(_type).then((categoryList) {
      _categoryList = categoryList;
      _categoryList
          .add(Category(0, AppLocalizations.of(context)!.label_new + "...", null, _type));

      if (_categoryAddedNotifier.value == _transaction?.category) {
        _categoryAddedNotifier.notifyListeners();
      } else {
        _categoryAddedNotifier.value = _transaction!.category!;
      }

      if (categoryList.length > 1) {
        ConfigurationService.isPredictionEnabled().then(predictCategory);
      }
    });

    CreditCardService.listActive().then((creditCardList) {
      _creditCardList = creditCardList;
      _creditCardList
          .add(CreditCard(0, AppLocalizations.of(context)!.label_new + "...", null, null));

      if (_creditcardAddedNotifier.value ==
          _transaction?.creditCard) {
        _creditcardAddedNotifier.notifyListeners();
      } else {
        _creditcardAddedNotifier.value = _transaction!.creditCard!;
      }

      if (creditCardList.length > 1) {
        ConfigurationService.isPredictionEnabled().then(predictPaymentMethod);
      }
    });
    
    _labelController = TextEditingController();

    if (_transaction?.id != null) {
      _labelController.text = _transaction!.label!;
    }
  }

  @override
  Widget build(BuildContext context) {
    int? paymentMethodType;

    if (_transaction?.id == null) {
      paymentMethodType = null;
    } else {
      paymentMethodType = _transaction?.creditCard != null
          ? PaymentMethod.CREDIT
          : PaymentMethod.CASH_DEBIT;
    }

    PaymentMethod? selectedPaymentMethod = PaymentMethod.getInstance(paymentMethodType, context);
    final node = FocusScope.of(context);

    NumberFormat numberFormatter = NumberFormat.currency(locale: AppLocalizations.of(context)!.localeName, symbol: "", decimalDigits: 2);
    CurrencyTextInputFormatter textInputFormatter = CurrencyTextInputFormatter.currency(locale: AppLocalizations.of(context)!.localeName, symbol: '', decimalDigits: 2);

    return Scaffold(
        appBar: AppBar(
            title: Text(getTitle(context)),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                tooltip: AppLocalizations.of(context)!.nav_back,
                onPressed: () {
                  Navigator.pop(context);
                }),
            actions: <Widget>[
              Visibility(
                visible: _transaction?.id != null,
                child: Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () => showConfirmBeforeDelete(context),
                      child: Icon(Icons.delete, size: 26.0),
                    )),
              )
            ]),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                          autofocus: true,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.attach_money),
                              labelText:
                                  AppLocalizations.of(context)!.input_transaction_amount_label,
                              labelStyle: TextStyle(fontSize: 16),
                              hintText:
                                  AppLocalizations.of(context)!.input_transaction_amount_hint),
                          textAlign: TextAlign.end,
                          keyboardType: TextInputType.number,
                          inputFormatters: [textInputFormatter],
                          style: TextStyle(
                            fontSize: 30,
                          ),
                          initialValue: _transaction?.value != null
                              ? numberFormatter.format(_transaction!.value)
                              : null,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.input_validation_required;
                            } else {
                              return numberFormatter.parse(value) == 0.0
                                  ? AppLocalizations.of(context)!.input_validation_transaction_amout_not_zero
                                  : null;
                            }
                          },
                          onSaved: (value) => _transaction!.value = numberFormatter.parse(value!).toDouble(),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => node.nextFocus())),
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                          decoration: InputDecoration(
                              icon: const Icon(Icons.create_rounded),
                              labelText: AppLocalizations
                                  .of(context)!
                                  .input_transaction_description_label,
                              hintText: AppLocalizations
                                  .of(context)!
                                  .input_transaction_description_hint),
                          controller: _labelController,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (String? value) {
                            return value == null || value.isEmpty
                                ? AppLocalizations.of(context)!.input_validation_required
                                : null;
                          },
                          onSaved: (value) => _transaction!.label = value!,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => node.nextFocus())),
                  Visibility(
                      visible: Category.EXPENSE == _type,
                      child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: ValueListenableBuilder(
                              valueListenable: _paymentMethodNotifier,
                              builder: (BuildContext context,
                                  PaymentMethod? newPaymentMethod,
                                  Widget? child) {
                                return DropdownButtonFormField(
                                    isExpanded: true,
                                    initialValue: newPaymentMethod ?? selectedPaymentMethod,
                                    focusNode: _paymentMethodFocus,
                                    decoration: InputDecoration(
                                        icon: const Icon(
                                            Icons.account_balance_wallet),
                                        labelText: AppLocalizations
                                            .of(context)!
                                            .input_transaction_payment_method_label),
                                    onTap: () =>
                                        _paymentMethodFocus.requestFocus(),
                                    onChanged: (PaymentMethod? method) {
                                      setState(() {
                                        selectedPaymentMethod = method;
                                        _creditCardVisible =
                                            PaymentMethod.CREDIT == method?.id;
                                        node.nextFocus();
                                      });
                                    },
                                    items: PaymentMethod.getAllPaymentMethods(
                                            context)
                                        .map<DropdownMenuItem<PaymentMethod>>(
                                            (PaymentMethod method) {
                                      return DropdownMenuItem<PaymentMethod>(
                                        value: method,
                                        child: Text(method.label!),
                                      );
                                    }).toList(),
                                    validator: (PaymentMethod? value) {
                                      return value == null
                                          ? AppLocalizations
                                              .of(context)!
                                              .input_validation_required
                                          : null;
                                    },
                                    onSaved: (PaymentMethod? value) {
                                      if (PaymentMethod.CASH_DEBIT ==
                                          value?.id) {
                                        _transaction!.creditCard = null;
                                      }
                                    });
                              }))),
                  ValueListenableBuilder(
                      valueListenable: _creditcardAddedNotifier,
                      builder: (BuildContext context, CreditCard? newCreditCard,
                          Widget? child) {
                        if (newCreditCard != null &&
                            !_creditCardList.contains(newCreditCard)) {
                          _creditCardList.insert(
                              _creditCardList.length - 1, newCreditCard);
                        }

                        return Visibility(
                            visible: _creditCardVisible,
                            child: Row(children: [
                              Expanded(
                                  flex: 70,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      child: DropdownButtonFormField(
                                          isExpanded: true,
                                          initialValue: newCreditCard,
                                          focusNode: _creditCardFocus,
                                          decoration: InputDecoration(
                                              icon:
                                                  const Icon(Icons.credit_card),
                                              labelText: AppLocalizations
                                                  .of(context)!
                                                  .input_transaction_credit_card_label),
                                          onTap: () =>
                                              _creditCardFocus.requestFocus(),
                                          onChanged: (CreditCard? newValue) {
                                            if (newValue?.id == 0) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return CreditCardForm(_creditcardAddedNotifier);
                                                }),
                                              );
                                            } else {
                                              node.nextFocus();
                                            }
                                          },
                                          items: _creditCardList.map<
                                                  DropdownMenuItem<CreditCard>>(
                                              (CreditCard creditCard) {
                                            return DropdownMenuItem<CreditCard>(
                                              value: creditCard,
                                              child: Text(creditCard.label!),
                                            );
                                          }).toList(),
                                          validator: (CreditCard? value) {
                                            return value == null
                                                ? AppLocalizations
                                                    .of(context)!
                                                    .input_validation_required
                                                : null;
                                          },
                                          onSaved: (value) => _transaction
                                              !.creditCard = value))),
                              Expanded(
                                  flex: 30,
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 10, bottom: 10, left: 20),
                                      child: DropdownButtonFormField(
                                          isExpanded: true,
                                          initialValue: _transaction?.installments,
                                          focusNode: _installmentsFocus,
                                          onChanged: (int? newValue) =>
                                              node.nextFocus(),
                                          decoration: InputDecoration(
                                              labelText: AppLocalizations
                                                  .of(context)!
                                                  .input_transaction_installments_label),
                                          onTap: () =>
                                              _installmentsFocus.requestFocus(),
                                          items: buildInstallmentOptions(),
                                          onSaved: (value) => _transaction
                                              !.installments = value)))
                            ]));
                      }),
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFieldDatePicker(
                        labelText: AppLocalizations.of(context)!.input_transaction_date_label,
                        icon: Icon(Icons.calendar_today),
                        initialDate: _transaction?.date,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        onDateChanged: (selectedDate) {
                          _transaction!.date = selectedDate;
                          node.nextFocus();
                        },
                        locale: Localizations.localeOf(context).toString(),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: ValueListenableBuilder(
                          valueListenable: _categoryAddedNotifier,
                          builder: (BuildContext context, Category? newCategory,
                              Widget? child) {
                            if (newCategory != null &&
                                !_categoryList.contains(newCategory)) {
                              _categoryList.insert(
                                  _categoryList.length - 1, newCategory);
                              _categoryIconNotifier.value =
                                  newCategory.icon!;
                            }

                            return DropdownButtonFormField(
                                isExpanded: true,
                                initialValue: newCategory,
                                decoration: InputDecoration(
                                    icon: ValueListenableBuilder(
                                        valueListenable:
                                            _categoryIconNotifier,
                                        builder: (BuildContext context,
                                            IconData icon, Widget? child) {
                                          return Icon(icon);
                                        }),
                                    labelText: AppLocalizations
                                        .of(context)!
                                        .input_transaction_category_label),
                                onChanged: (Category? newValue) {
                                  if (newValue?.id == 0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return CategoryForm(_type,
                                            _categoryAddedNotifier);
                                      }),
                                    );
                                  } else {
                                    if (newValue?.icon != null) {
                                      _categoryIconNotifier.value = newValue!.icon!;
                                    }
                                  }
                                },
                                items: _categoryList
                                    ?.map<DropdownMenuItem<Category>>(
                                        (Category category) {
                                  return DropdownMenuItem<Category>(
                                    value: category,
                                    child: Text(category.label!),
                                  );
                                })?.toList(),
                                validator: (Category? value) {
                                  return value == null || value.id == 0
                                      ? AppLocalizations.of(context)!.input_validation_required
                                      : null;
                                },
                                onSaved: (value) =>
                                    _transaction!.category = value);
                          }))
                ],
              ),
            )),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.check),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              TransactionService.save(_transaction!, context).then((value) {
                Navigator.pop(context);
              });
            }
          },
        ));
  }

  String getTitle(BuildContext context) {
    if (_transaction != null && _transaction?.id != null) {
      return _transaction?.category?.type == Category.REVENUE
          ? AppLocalizations.of(context)!.title_edit_revenue
          : AppLocalizations.of(context)!.title_edit_expense;
    } else {
      return _type == Category.REVENUE
          ? AppLocalizations.of(context)!.title_new_revenue
          : AppLocalizations.of(context)!.title_new_expense;
    }
  }

  List<DropdownMenuItem<int>> buildInstallmentOptions() {
    List<DropdownMenuItem<int>> list = [];
    for (var i = 1; i <= 12; i++) {
      list.add(DropdownMenuItem<int>(value: i, child: Text(i.toString())));
    }
    return list;
  }

  showConfirmBeforeDelete(BuildContext context) {
    // set up the buttons
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirm_delete_transaction_title),
          content: Text(AppLocalizations.of(context)!.confirm_delete_transaction_text),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.button_no),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
                child: Text(AppLocalizations.of(context)!.button_yes),
                onPressed: () {
                  deleteTransaction(context);
                })
          ],
        );
      },
    );
  }

  deleteTransaction(BuildContext context) {
    TransactionService.delete(_transaction!).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  predictCategory(bool enabled) {
    if (!enabled) {
      return null;
    }
    
    if (_transaction?.id == null) {
      // If is new transaction, show predicted category value
      if (_type == Category.EXPENSE) {
        ConfigurationService.getConfigValue('predicted_exp_category').then((categoryId) {
            _categoryAddedNotifier.value = _categoryList.firstWhere((category) => category.id.toString() == categoryId);
            _categoryIconNotifier.value = _categoryAddedNotifier.value!.icon!;
        });
      } else {
        ConfigurationService.getConfigValue('predicted_rev_category').then((categoryId) {
          _categoryAddedNotifier.value = _categoryList.firstWhere((category) => category.id.toString() == categoryId);
          _categoryIconNotifier.value = _categoryAddedNotifier.value!.icon!;
        });
      }
    }
  }

  predictPaymentMethod(bool enabled) {
    if (!enabled) {
      return null;
    }

    if (_type == Category.EXPENSE && _transaction?.id == null) {
      // If is new transaction, show predicted payment method and credit card values
      ConfigurationService.getConfigValue('predicted_exp_credit_card')
          .then((creditCardId) {
        if (creditCardId == null || creditCardId == "null") {
          _paymentMethodNotifier.value =
              PaymentMethod.getInstance(PaymentMethod.CASH_DEBIT, context)!;
        } else {
          _paymentMethodNotifier.value =
              PaymentMethod.getInstance(PaymentMethod.CREDIT, context)!;
          _creditCardVisible = true;
          _creditcardAddedNotifier.value = _creditCardList.firstWhere(
                    (creditCard) => creditCard.id.toString() == creditCardId);
        }
      });
    }
  }
  /*
  predictLabel(bool enabled) {
    if (!enabled) {
      return null;
    }
    
    if (_transaction?.id == null) {
      // If is new transaction, show predicted label value
      if (_type == Category.EXPENSE) {
        ConfigurationService.getConfigValue('predicted_exp_label')
            .then((label) => _labelController.text = label!);
      } else {
        ConfigurationService.getConfigValue('predicted_rev_label')
            .then((label) => _labelController.text = label!);
      }
    } else {
      // When editing a transaction, show current values
      _labelController.text = _transaction!.label!;
    }
  }
  */
}
