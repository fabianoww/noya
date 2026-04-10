import 'package:noya2/dao/credit_card_dao.dart';
import 'package:noya2/model/credit_card.dart';

class CreditCardService {
  
  static Future<int> insert(CreditCard creditCard) async {
    return CreditCardDao.insert(creditCard);
  }

  static Future<List<CreditCard>> listActive() async {
    return CreditCardDao.listActive();
  }

}