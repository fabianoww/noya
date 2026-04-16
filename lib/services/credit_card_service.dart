import 'package:noya2/dao/credit_card_dao.dart';
import 'package:noya2/model/credit_card.dart';

class CreditCardService {
  

  static Future<int> save(CreditCard creditCard) async {
    if (creditCard.id == null) {
      return await CreditCardDao.insert(creditCard);
    } else {
      await CreditCardDao.update(creditCard);
      return creditCard.id!;
    }
  }

  static Future<List<CreditCard>> listActive() async {
    return CreditCardDao.listActive();
  }
  
  static Future<void> delete(CreditCard creditCard) async {
    await CreditCardDao.delete(creditCard);
  }
}