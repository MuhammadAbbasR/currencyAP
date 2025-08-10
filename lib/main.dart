import 'package:currencyapp/confi/routes/routes.dart';
import 'package:currencyapp/repository/AuthRepository/AuthRepositoryImpl.dart';
import 'package:currencyapp/repository/ConversionRepository/ConversionRepository.dart';
import 'package:currencyapp/repository/CurrencyRepository/CurrencyRepository.dart';
import 'package:currencyapp/repository/CurrencyRepository/CurrencyRepositoryImpl.dart';
import 'package:currencyapp/services/ShareServices.dart';
import 'package:currencyapp/viewmodel/History_viewmodel.dart';
import 'package:currencyapp/viewmodel/auth_viewmodel.dart';
import 'package:currencyapp/viewmodel/currency_viewmodel.dart';
import 'package:currencyapp/viewmodel/exchange_viewmodel.dart';
import 'package:currencyapp/viewmodel/favouirte_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';


import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'repository/ConversionRepository/ConversionRepositoryImpl.dart';


GetIt getIt = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: 'AIzaSyAAVxxqWVxb_0yYNW9zwnHONjh71GUmGZg',
        appId: '1:222135710420:android:f6d719753101e38ce04141',
        messagingSenderId: '222135710420',
        projectId: 'practicefyp-c3931',
        storageBucket: 'practicefyp-c3931.firebasestorage.app'),
  );
  await SharedPrefencesService.initialize_SharedPrefence();
  await dotenv.load(fileName: ".env");

  getIt.registerLazySingleton<ConversionRepository>(
          () => ConversionRepositoryImpl());


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConversionHistoryViewModel()),
        ChangeNotifierProvider(create: (_) => CurrencyExchangeViewModel()),
        ChangeNotifierProvider(create: (context) {
          final viewModel = CurrencyViewModel(currencyRepository: CurrencyRepositoryImpl());
          viewModel.fetchMoviesListApi();
          return viewModel;
        }),

        ChangeNotifierProvider(
          create: (context) => FavoriteCurrenciesViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(AuthRepositoryImpl()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routerConfig: AppRoutes.router,
    );
  }
}
