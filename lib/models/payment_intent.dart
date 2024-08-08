import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

createPaymentIntent({
  required String name,
  required String address,
  required String pin,
  required String city,
  required String country,
  required String state,
  required String currency,
  required String ammount,
}) async {
  try {
    var url = Uri.parse('https://api.stripe.com/v1/payment_intents');

    Map<String, dynamic> body = {
      'amount': ((int.parse(ammount)) * 100).toString(),
      'currency': currency,
      'automatic_payment_methods[enabled]': 'true',
      'description': "Test",
      'shipping[name]': name,
      'shipping[address][line1]': address,
      'shipping[address][postal_code]': pin,
      'shipping[address][city]': city,
      'shipping[address][state]': state,
      'shipping[address][country]': country,
    };
    var secretKey = dotenv.env["STRIPE_SECRET_KEY"];

    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      print(json);
      return json;
    } else {
      print("Error in creating payment intent: ${response.body}");
    }
  } catch (err) {
    print('Error charging user: ${err.toString()}');
  }
}
