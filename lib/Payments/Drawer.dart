import 'package:flutter/material.dart';
import 'package:paychalet/colors.dart';
import 'package:provider/provider.dart';
import 'package:paychalet/AppLocalizations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Appdrawer extends StatefulWidget {
  final AppLanguage appLanguage;

  Appdrawer({this.appLanguage});

  @override
  _AppdrawerState createState() => _AppdrawerState();
}

class _AppdrawerState extends State<Appdrawer> {



  @override
  Widget build(BuildContext context) {

    double pheight = MediaQuery.of(context).size.height;
    double pwidth = MediaQuery.of(context).size.width;
    var appLanguage = Provider.of<AppLanguage>(context);


    return Drawer(
        child: new ListView(children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: Text(
              'user_name',
              textAlign: TextAlign.start,
            ),
            accountEmail: Text('user_email'),
            /*  otherAccountsPictures: <Widget>[
                 new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: firstColor),
                )

              ],*/
            currentAccountPicture: GestureDetector(
              child: new CircleAvatar(
                backgroundColor: Colors.white,
                child:
                // image:NetworkImage(user_img)
                Icon(Icons.person, color: Red_deep2),
              ),
            ),
            decoration:
            new BoxDecoration(color: Red_deep2),
          ),
          Padding(
            padding: const EdgeInsets.only(left:25.0,right: 25),
            child: Text(AppLocalizations.of(context).translate('Payments'),style: TextStyle(fontWeight: FontWeight.bold),),
          ),

          ListTile(
              leading: Icon(
                Icons.category,
                color: Red_deep2,
              ),

              title:   Align(
                alignment: (appLanguage.appLocal.toString() =='ar') ? Alignment.topRight :  Alignment.topLeft,
                child: Text( AppLocalizations.of(context).translate('Payments'),
                  textAlign: TextAlign.right,
                ),
              ),
              onTap: () => Navigator.pushNamed(
                  context, "/main_page") //Navigator.pop(context),
          ),
          ListTile(
              leading: Icon(
                Icons.category,
                color: Red_deep2,
              ),

              title:   Align(
                alignment: (appLanguage.appLocal.toString() =='ar') ? Alignment.topRight :  Alignment.topLeft,
                child: Text( AppLocalizations.of(context).translate('Shacks'),
                  textAlign: TextAlign.right,
                ),
              ),
              onTap: () => Navigator.pushNamed(
                  context, "/MainShacks") //Navigator.pop(context),
          ),
          ListTile(
              leading: Icon(
                Icons.category,
                color: Red_deep2,
              ),

              title:   Align(
                alignment: (appLanguage.appLocal.toString() =='ar') ? Alignment.topRight :  Alignment.topLeft,
                child: Text( AppLocalizations.of(context).translate('Category'),
                  textAlign: TextAlign.right,
                ),
              ),
              onTap: () => Navigator.pushNamed(
                  context, "/CategoryMain2") //Navigator.pop(context),
          ),

          Divider(height: 4,color: pcolor3,),
          Padding(
            padding: const EdgeInsets.only(left:25.0,right: 25),
            child: Text( AppLocalizations.of(context).translate('Booking'),style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          ListTile(
              leading: Icon(
                Icons.category,
                color: Red_deep2,
              ),

              title:   Align(
                alignment: (appLanguage.appLocal.toString() =='ar') ? Alignment.topRight :  Alignment.topLeft,
                child: Text(//'Booking',
                  AppLocalizations.of(context).translate('Booking'),
                  textAlign: TextAlign.right,
                ),
              ),
              onTap: () => Navigator.pushNamed(
                  context, "/BookingTabs") //Navigator.pop(context),
          ),
          ListTile(
              leading: Icon(
                Icons.category,
                color: Red_deep2,
              ),

              title:   Align(
                alignment: (appLanguage.appLocal.toString() =='ar') ? Alignment.topRight :  Alignment.topLeft,
                child: Text(//'Booking',
                  AppLocalizations.of(context).translate('Notes'),
                  textAlign: TextAlign.right,
                ),
              ),
              onTap: () => Navigator.pushNamed(
                  context, "/Notes") //Navigator.pop(context),
          ),





          Divider(height: 4,color: pcolor3,),

          Padding(
            padding: const EdgeInsets.only(left:25.0,right: 25),
            child: Text( AppLocalizations.of(context).translate('Providers'),style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          ListTile(
              leading: Icon(
                Icons.home,
                color: Red_deep2,
              ),

              title:   Align(
                alignment: (appLanguage.appLocal.toString() =='ar') ? Alignment.topRight :  Alignment.topLeft,
                child: Text(
                  AppLocalizations.of(context).translate('Providers'),
                  textAlign: TextAlign.right,
                ),
              ),
              onTap: () => Navigator.pushNamed(
                  context, "/ProvidersMain") //Navigator.pop(context),
          ),
          ListTile(
              leading: Icon(
                Icons.category,
                color: Red_deep2,
              ),

              title:   Align(
                alignment: (appLanguage.appLocal.toString() =='ar') ? Alignment.topRight :  Alignment.topLeft,
                child: Text(
                  AppLocalizations.of(context).translate('Types'),
                  textAlign: TextAlign.right,
                ),
              ),
              onTap: () => Navigator.pushNamed(
                  context, "/TypeList") //Navigator.pop(context),
          ),






          Divider(height: 4,color: pcolor3,),
          Padding(
            padding: const EdgeInsets.only(left:25.0,right: 25),
            child: Text( AppLocalizations.of(context).translate('Masaref'),style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          ListTile(
              leading: Icon(
                Icons.home,
                color: Red_deep2,
              ),

              title:   Align(
                alignment: (appLanguage.appLocal.toString() =='ar') ? Alignment.topRight :  Alignment.topLeft,
                child: Text(//'Masaref',
                  AppLocalizations.of(context).translate('docs'),
                  textAlign: TextAlign.right,
                ),
              ),
              onTap: () => Navigator.pushNamed(
                  context, "/ProductsMain") //Navigator.pop(context),
          ),
          ListTile(
              leading: Icon(
                Icons.category,
                color: Red_deep2,
              ),

              title:   Align(
                alignment: (appLanguage.appLocal.toString() =='ar') ? Alignment.topRight :  Alignment.topLeft,
                child: Text(AppLocalizations.of(context).translate('Invoices'),
                 // AppLocalizations.of(context).translate('Masaref'),
                  textAlign: TextAlign.right,
                ),
              ),
              onTap: () => Navigator.pushNamed(
                  context, "/Invoice_report") //Navigator.pop(context),
          ),  ListTile(
              leading: Icon(
                Icons.category,
                color: Red_deep2,
              ),

              title:   Align(
                alignment: (appLanguage.appLocal.toString() =='ar') ? Alignment.topRight :  Alignment.topLeft,
                child: Text(AppLocalizations.of(context).translate('Invoices_type'),
                  // AppLocalizations.of(context).translate('Masaref'),
                  textAlign: TextAlign.right,
                ),
              ),
              onTap: () => Navigator.pushNamed(
                  context, "/Main_Invoices") //Navigator.pop(context),
          ),


          ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Red_deep2,
              ),

              title:  Align(
                alignment: (appLanguage.appLocal.toString() =='ar') ? Alignment.topRight :  Alignment.topLeft,
                child: Text(
                  AppLocalizations.of(context).translate('Log Out'),
                  textAlign: TextAlign.right,
                ),
              ),


              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, "/RegistrationWelcome");

              }    ),
          ListTile(
              leading: Icon(
                Icons.language,
                color: Red_deep2,
              ),

              title:  Align(
                alignment: (appLanguage.appLocal.toString() =='ar') ? Alignment.topRight :  Alignment.topLeft,
                child: Text(
                  AppLocalizations.of(context).translate('Language'),
                  textAlign: TextAlign.right,
                ),
              ),


              onTap: () {
                //  final Locale locale =Locale();
                // Locale _appLocale2 = Locale("en");
                 if(appLanguage.appLocal.toString() =='ar') {
          if (this.mounted) {
            setState(() {
              appLanguage.changeLanguage(Locale("en"));
              //  print(appLanguage.appLocal);
            });
          }
                 }
                 else
                   {
                     appLanguage.changeLanguage(Locale("ar"));
                   }
                // }
              }    ),
          //ListDissmisse
        ]
        ));
  }
}

