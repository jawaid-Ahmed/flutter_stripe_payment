import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var paymentIntentdata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Stripe payment" ,style: TextStyle(color: Colors.blue),),
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(onPressed: () async {
          print("Button CLicked: ");

          await makePayment();
        }, child: const Text("Pay Now")),
      ),
    );
  }

  Future<void> makePayment()async {
    try{

      paymentIntentdata=await createpaymentIntent('20','USD');



      Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentdata['client_secret'],
            applePay: true,
            googlePay: true,
            merchantCountryCode: "eu",
            merchantDisplayName: "Zepta",

          )
      );




      desplayPaymentSheet();

    }catch(e){
      print("makePaymentException: "+e.toString());
    }
  }

 createpaymentIntent(String amount, String currency) async {
   try{

     Map<String,dynamic> body={
       'amount':calculateAmount(amount),
       'currency':currency,
       'payment_method_types[]':'card'
     };
     
     var response=await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
     body: body,
     headers:{
       'Authorization': 'Bearer sk_test_51KMoEjFXvbOoxTqDHUpQb4Hs4QSI4DT8zwcDhPbTeD2OSJisVwlQvL6JFOVK9NYJx5TFc1uHc46B6uIM9xxNpOCo00ZsC2T2TL',
       'Content-Type': 'application/x-www-form-urlencoded'
     });


     return jsonDecode(response.body.toString());

   }catch(e){
     print("createPaymentIntent: "+e.toString());
   }
 }
 calculateAmount(String amount){
    final am=int.parse(amount) * 100;
    return am.toString();

 }

  Future<void> desplayPaymentSheet() async {
    try{

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(paymentIntentdata['client_secret'])));

      await Stripe.instance.presentPaymentSheet(
        parameters: PresentPaymentSheetParameters(
          clientSecret: paymentIntentdata['client_secret'],
          confirmPayment: true,
        ),
      );


      setState(() {
        paymentIntentdata=null;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Payment Successfull")));

    }on StripeException catch(e){
      print("desplayPaymentSheet: "+e.toString());
    }
  }
}
