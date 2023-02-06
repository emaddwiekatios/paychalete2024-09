import 'package:flutter/material.dart';
//import 'file:///Users/serviceapp/Desktop/Apps_from_flash/paychalet%20new2/lib/Home.dart';
import 'package:paychalet/AppLocalizations.dart';

import 'package:paychalet/Invoices/Invoice_report.dart';
import 'package:provider/provider.dart';
import './main_page.dart';
import 'Calinder/Booking.dart';
import 'Calinder/Booking.dart';
import 'Calinder/BookingFull.dart';
import 'Calinder/Booking_all.dart';
import 'Calinder/Notes.dart';
import 'Invoices/Main_Invoices_Report.dart';
import 'Payments/ProductsMain.dart';
import 'Providers/AddProvider.dart';
import 'Providers/MainProviders.dart';
import 'Registration/RegistrationWelcome.dart';
import 'Registration/SignIn.dart';
import 'Registration/SignUp.dart';
import 'Splash/Splash.dart';
import 'AppLocalizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:paychalet/PaymentsCategory/CategoryMain2.dart';
import 'package:paychalet/PaymentsCategory/categoryAdd.dart';
import 'package:paychalet/Providers/ProviderList.dart';
import 'package:paychalet/Invoices/Invoice_Sale.dart';
import 'package:paychalet/Types/TypeList.dart';
import 'package:paychalet/Types/Types.dart';
import 'package:paychalet/Documents/ProductsMain.dart';
import 'package:paychalet/Invoices/Invoice_Report_Table.dart';
import 'package:paychalet/Calinder/BookingTabs.dart';
import 'package:paychalet/Payments/KeyBoardsDone.dart';
import 'package:paychalet/Invoices/Invoice_Report_Type.dart';
//import 'package:paychalet/Calinder/add_event.dart';
import 'package:paychalet/Shacks/MainShacksTab.dart';
import 'package:paychalet/Calinder/BookingSum.dart';
/*import 'Category/CategoryMain.dart';
import 'Products/ProductsMain.dart';
import 'Category/categoryAdd.dart';
import 'package:paychalet/Calinder/BookingTabs.dart';
import 'Registration/RegistrationWelcome.dart';

import 'Registration/SignIn.dart';
import 'Registration/SignUp.dart';
import 'package:paychalet/Category/CategoryMain2.dart';

import 'package:paychalet/Masaref/MainTypes.dart';
import 'package:paychalet/Masaref/CategoryTypeMain.dart';

import 'package:paychalet/Orders/OrdersAdd.dart';
//import 'package:device_preview/device_preview.dart';
import 'package:paychalet/Orders/OrdersMain.dart';
*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(

        //enabled: !kReleaseMode,
     SocialApp(
    appLanguage: appLanguage,
  ));
}




class SocialApp extends StatelessWidget {
  final AppLanguage appLanguage;

  SocialApp({this.appLanguage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => appLanguage,
      //builder: ,
      // builder: (_) => appLanguage,

      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return MaterialApp(
            locale: model.appLocal,
            supportedLocales: [
              Locale('en', 'US'),
              Locale('ar', ''),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,



            ],
            //locale: DevicePreview.of(context).locale, // <--- /!\ Add the locale
         //   builder: DevicePreview.appBuilder,
            home: Splash(),
            routes: {

              // When we navigate to the "/" route, build the FirstScreen Widget
            //  '/CategoryMain': (context) => CategoryMain(),
              '/RegistrationWelcome': (context) => RegistrationWelcome(),





              '/SignIn': (context) => SignIn(),
              '/SignUp': (context) => SignUp(),
              '/PaysMain': (context) => PaysMain(),
              '/CategoryMain2': (context) => CategoryMain2(),
              '/ProvidersMain': (context) => ProvidersMain(),
              '/CategoryAdd': (context) => AddCategory(),
              '/main_page': (context) => main_page(),
              '/ProviderList': (context) => ProviderList(),
              '/AddProvider': (context) => AddProvider(),
              '/Invoice_Sale': (context) => Invoice_Sale(),
              '/Main_Invoices': (context) => Main_Invoices(),
              '/TypeList': (context) => TypeList(),
              '/Types': (context) => Types(),
              '/ProductsMain': (context) => ProductsMain(),
              '/Invoice_report': (context) => Invoice_report(),
              '/Invoice_Report_Table': (context) => Invoice_Report_Table(),
              '/Invoice_Report_Type': (context) => Invoice_Report_Type(),
              '/Booking': (context) => Booking(),
'/Booking_all': (context) => Booking_all(),
              '/BookingTabs': (context) => BookingTabs(),
              '/BookingFull': (context) => BookingFull(),
            //  '/add_event': (context) => AddEventPage(),
              '/KeyBoardDone': (context) => KeyBoardDone(),
              '/Notes': (context) => Note(),


              '/MainShacks': (context) => MainShacksTab(),
              '/BookingSum': (context) => BookingSum(),




















    // '/SocialHome': (context) => SocialHome(),



            }

        );
      }),
    );
  }
}

/*
void main() async {
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(SocialApp(
    appLanguage: appLanguage,
  ));
}

class SocialApp extends StatelessWidget {
  final AppLanguage appLanguage;

  SocialApp({this.appLanguage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
        builder: (_) => appLanguage,
    child: Consumer<AppLanguage>(builder: (context, model, child) {
    return MaterialApp(
    locale: model.appLocal,
    supportedLocales: [
    Locale('en', 'US'),
    Locale('ar', ''),
    ],
    localizationsDelegates: [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
 ],

      home: Splash(),

      // routes: pages,
      routes: {
        // When we navigate to the "/" route, build the FirstScreen Widget
        '/CategoryMain': (context) => CategoryMain(),
        '/ProductsMain': (context) => ProductsMain(),
        '/CategoryAdd': (context) => AddCategory(),
        '/RegistrationWelcome': (context) => RegistrationWelcome(),
      }
    );
    }),
    );
    }
  }


 */