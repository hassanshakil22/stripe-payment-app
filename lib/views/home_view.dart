import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_payment/models/payment_intent.dart';
import 'package:stripe_payment/widgets/custom_text_form_field.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

bool hasPayed = false;

TextEditingController amountController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController adressController = TextEditingController();
TextEditingController cityController = TextEditingController();
TextEditingController stateController = TextEditingController();
TextEditingController countryController = TextEditingController();
TextEditingController pincodeController = TextEditingController();

final formkey = GlobalKey<FormState>();
final formkey1 = GlobalKey<FormState>();
final formkey2 = GlobalKey<FormState>();
final formkey3 = GlobalKey<FormState>();
final formkey4 = GlobalKey<FormState>();
final formkey5 = GlobalKey<FormState>();
final formkey6 = GlobalKey<FormState>();

List<String> currencylist = [
  "USD",
  "INR",
  "PKR",
  "EUR",
  "GBP",
  "AED",
];
String selectedCurrency = "PKR";

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
//initializing payment sheet by the code from https://docs.page/flutter-stripe/flutter_stripe/sheet#3-integrate-the-payment-sheet-client-side

    Future<void> initPaymentSheet() async {
      try {
        // 1. create payment intent on the server
        final data = await createPaymentIntent(
            name: nameController.text,
            address: adressController.text,
            ammount: amountController.text,
            city: cityController.text,
            country: countryController.text,
            currency: selectedCurrency,
            pin: pincodeController.text,
            state: stateController.text);

        if (data == null || data['client_secret'] == null) {
          throw Exception('Payment intent creation failed');
        }

        // 2. initialize the payment sheet
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            // Set to true for custom flow
            customFlow: false,
            // Main params
            merchantDisplayName: 'demo Merchant',
            paymentIntentClientSecret: data['client_secret'],
            // Customer keys
            customerEphemeralKeySecret: data['ephemeralKey'],
            customerId: data['id'],

            style: ThemeMode.dark,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        // rethrow;
      }
    }

    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/image.jpg",
              fit: BoxFit.cover,
              height: 300,
              width: MediaQuery.of(context).size.width,
            ),
            hasPayed == true
                ? Column(
                    children: [
                      const Text(
                        "Thank You For Donating !",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              hasPayed = false;
                            });
                          },
                          child: const Text("Donate Again"))
                    ],
                  )
                :
                ////// if not payed
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          "Palestenian Kids Need Your Support",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),

                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: CustomTextFormField(
                                isNumber: true,
                                formkey: formkey,
                                label: "Donation Ammount",
                                hint: "Enter any amount",
                                controller: amountController,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            DropdownMenu<String>(
                              inputDecorationTheme: const InputDecorationTheme(
                                  border: UnderlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20)),
                              initialSelection: selectedCurrency,
                              onSelected: (value) {
                                setState(() {
                                  selectedCurrency = value!;
                                });
                              },
                              dropdownMenuEntries: currencylist
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                return DropdownMenuEntry(
                                    label: value, value: value);
                              }).toList(),
                            ),
                          ],
                        ), //first row
                        CustomTextFormField(
                            isNumber: false,
                            formkey: formkey1,
                            label: "Name",
                            hint: 'Ex : Muhammad Ali',
                            controller: nameController),
                        CustomTextFormField(
                            isNumber: false,
                            label: "Adress",
                            formkey: formkey2,
                            hint: 'Street no 2 / abc society',
                            controller: adressController),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                  isNumber: false,
                                  label: "City",
                                  formkey: formkey3,
                                  hint: "Ex: Karachi",
                                  controller: cityController),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                                child: CustomTextFormField(
                                    isNumber: false,
                                    label: "State (Short code)",
                                    formkey: formkey4,
                                    hint: "Ex: Dl for NewDehli ",
                                    controller: stateController))
                          ],
                        ), //city row
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                  isNumber: false,
                                  label: "Country (short code)",
                                  formkey: formkey5,
                                  hint: "Ex: Pk for Pakistan",
                                  controller: countryController),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                                child: CustomTextFormField(
                                    formkey: formkey6,
                                    isNumber: true,
                                    label: "Pincode",
                                    hint: "Ex: 123412",
                                    controller: pincodeController))
                          ],
                        ), //country row
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formkey.currentState!.validate() &&
                                  formkey1.currentState!.validate() &&
                                  formkey2.currentState!.validate() &&
                                  formkey3.currentState!.validate() &&
                                  formkey4.currentState!.validate() &&
                                  formkey5.currentState!.validate() &&
                                  formkey6.currentState!.validate()) {
                                await initPaymentSheet();
                                await displayPaymentSheet();
                                setState(() {
                                  hasPayed = true;
                                });
                              }
                            },
                            child: const Text(
                              "Donate Now",
                              style: TextStyle(fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                foregroundColor: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ), //main column
    );
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Payment Succesfull",
          ),
          backgroundColor: Colors.green,
        ),
      );
      amountController.clear();
      nameController.clear();
      adressController.clear();
      cityController.clear();
      stateController.clear();
      countryController.clear();
      pincodeController.clear();
    } on StripeException catch (e) {
      print('Error: $e');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Payment Failed",
          ),
          backgroundColor: Colors.red,
        ),
      );
      print(e);
    }
  }
}
