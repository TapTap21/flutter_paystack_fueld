import 'package:flutter_paystack_fueld/flutter_paystack_fueld.dart';

abstract class BaseRequestBody {
  final fieldDevice = 'device';
  String? _device;

  BaseRequestBody() {
    _setDeviceId();
  }

  Map<String, String?> paramsMap();

  String? get device => _device;

  _setDeviceId() {
    String deviceId = PaystackPlugin.platformInfo.deviceId;
    this._device = deviceId;
  }
}
