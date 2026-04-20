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
  final int _type;
  final TransactionRecord _transaction;

  const TransactionForm(this._type, this._transaction, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _TransactionFormState();
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

  @override
  void initState() {
    super.initState();
    _type = widget._type;
    _transaction = widget._transaction;
    _creditCardVisible = _transaction != null && _transaction!.creditCard != null;
    _categoryList = [];
    _creditCardList = [];

    _paymentMethodFocus = FocusNode();
    _creditCardFocus = FocusNode();
    _installmentsFocus = FocusNode();
    String labelNew = "${AppLocalizations.of(context)!.label_new}...";
    
    CategoryService.listActive(_type).then((categoryList) {
      _categoryList = categoryList;
      _categoryList.add(Category(0, labelNew, null, _type));

      if (_categoryAddedNotifier.value != _transaction?.category) {
        _categoryAddedNotifier.value = _transaction!.category!;
      }

      if (categoryList.length > 1) {
        ConfigurationService.isPredictionEnabled().then(predictCategory);
      }
    });

    CreditCardService.listActive().then((creditCardList) {
      _creditCardList = creditCardList;
      _creditCardList.add(CreditCard(0, labelNew, null, null));

      if (_creditcardAddedNotifier.value != _transaction?.creditCard) {
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
          ? PaymentMethod.credit
          : PaymentMethod.cashDebit;
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
                      visible: Category.expense == _type,
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
                                            PaymentMethod.credit == method?.id;
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
                                      if (PaymentMethod.cashDebit ==
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
                                                  return CreditCardForm(CreditCard(null, null, null, null), _creditcardAddedNotifier);
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
                                        return CategoryForm(Category(null, null, null, _type),
                                            _categoryAddedNotifier);
                                      }),
                                    );
                                  } else {
                                    if (newValue?.icon != null) {
                                      _categoryIconNotifier.value = newValue!.icon!;
                                    }
                                  }
                                },
                                items: _categoryList.map<DropdownMenuItem<Category>>((Category category) {
                                  return DropdownMenuItem<Category>(
                                    value: category,
                                    child: Text(category.label!),
                                  );
                                }).toList(),
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              TransactionService.save(_transaction!, context).then((value) {
                if (context.mounted) {
                  Navigator.pop(context);
                }
              });
            }
          },
        ));
  }

  String getTitle(BuildContext context) {
    if (_transaction != null && _transaction?.id != null) {
      return _transaction?.category?.type == Category.revenue
          ? AppLocalizations.of(context)!.title_edit_revenue
          : AppLocalizations.of(context)!.title_edit_expense;
    } else {
      return _type == Category.revenue
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

  void showConfirmBeforeDelete(BuildContext context) {
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

  void deleteTransaction(BuildContext context) {
    TransactionService.delete(_transaction!).then((value) {
      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    });
  }

  void predictCategory(bool enabled) {
    if (!enabled) {
      return;
    }
    
    if (_transaction?.id == null) {
      // If is new transaction, show predicted category value
      if (_type == Category.expense) {
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

  void predictPaymentMethod(bool enabled) {
    if (!enabled) {
      return;
    }

    PaymentMethod? debito = PaymentMethod.getInstance(PaymentMethod.cashDebit, context);
    PaymentMethod? credito = PaymentMethod.getInstance(PaymentMethod.credit, context);

    if (_type == Category.expense && _transaction?.id == null) {
      // If is new transaction, show predicted payment method and credit card values
      ConfigurationService.getConfigValue('predicted_exp_credit_card')
          .then((creditCardId) {
        if (creditCardId == null || creditCardId == "null") {
          _paymentMethodNotifier.value = debito;
        } else {
          _paymentMethodNotifier.value = credito;
          _creditCardVisible = true;
          _creditcardAddedNotifier.value = _creditCardList.firstWhere(
                    (creditCard) => creditCard.id.toString() == creditCardId);
        }
      });
    }
  }
}
