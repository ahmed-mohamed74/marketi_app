import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:marketi_app/core/services/payment/stripe_payment/stripe_keys.dart';

abstract class PaymentManager {
  static Future<void> makePayment(int amount, String currency) async {
    try {
      String clientSecret = await _getClientSecret(
        (amount * 100).toInt().toString(),
        currency,
      );
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> _initializePaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "marketi",
      ),
    );
  }

  static Future<String> _getClientSecret(String amount, String currency) async {
    try {
      Dio dio = Dio();
      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${StripeKeys.secretKey}',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {'amount': amount, 'currency': currency},
      );
      return response.data["client_secret"];
    } on DioException catch (e) {
      print(e.response?.data ?? "Unknown Error");
      throw Exception(e.response?.data['error']['message'] ?? "Payment Failed");
    }
  }
}
