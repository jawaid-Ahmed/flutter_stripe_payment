import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stripe_payment/home_page.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey='pk_test_51KMoEjFXvbOoxTqDfnm45rj6T5HGljjo42kzsfJuNgJAQTIOgvKXMLBhcpZCCitN4GT2kKWRNCnfLq9Qyq51ea8g003igyL1Ui';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

