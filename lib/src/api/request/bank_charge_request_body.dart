import 'package:flutter_paystack_fueld/src/api/request/base_request_body.dart';
import 'package:flutter_paystack_fueld/src/models/bank.dart';
import 'package:flutter_paystack_fueld/src/models/charge.dart';

class BankChargeRequestBody extends BaseRequestBody {
  String _accessCode;
  BankAccount _account;
  String? _birthday;
  String? _token;
  String? transactionId;
  String? _splitCode;

  BankChargeRequestBody(Charge charge)
      : this._accessCode = charge.accessCode!,
        this._splitCode = charge.splitCode,
        this._account = charge.account!;

  Map<String, String?> tokenParams() => {fieldDevice: device, 'token': _token};

  @override
  Map<String, String?> paramsMap() {
    var map = {fieldDevice: device, 'account_number': account.number};
    map['birthday'] = _birthday;
    if (_splitCode != null && _splitCode!.isNotEmpty) {
      map['split_code'] = _splitCode;
    }
    return map..removeWhere((key, value) => value == null || value.isEmpty);
  }

  set token(String value) => _token = value;

  set birthday(String value) => _birthday = value;

  BankAccount get account => _account;

  String get accessCode => _accessCode;

}
