import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motb_ble/views/mainView.dart';
import 'package:motb_ble/views/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      theme: ThemeData(
        cardColor: Apptheme.mainCardColor,
        colorScheme: ColorScheme(
          background: Apptheme.mainBackgroundColor,
          brightness: Brightness.light,
          error: Colors.red,
          onBackground: Colors.black,
          onError: Apptheme.mainBackgroundColor,
          onPrimary: Colors.white,
          onSecondary: Apptheme.mainBackgroundColor,
          onSurface: Colors.black,
          primary: Apptheme.mainButonColor,
          secondary: Apptheme.mainStatisticColor,
          surface: Apptheme.mainCardColor, primaryVariant: Apptheme.mainButonColor, secondaryVariant: Apptheme.secondaryAccent, //! cards
        ),
        backgroundColor: Apptheme.mainBackgroundColor,
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          headline4: GoogleFonts.bebasNeue(
            textStyle: textTheme.headline4,
            color: Apptheme.mainButonColor,
          ),
          headline3: GoogleFonts.montserrat(
            textStyle: textTheme.headline1,
            fontWeight: FontWeight.normal,
            color: const Color.fromRGBO(112, 112, 112, 1),
            fontSize: 18,
          ),
          button: GoogleFonts.montserrat(
            textStyle: textTheme.headline4,
            color: Apptheme.mainButonColor,
            fontSize: 15,
          ),
          bodyText1: GoogleFonts.bebasNeue(
            textStyle: textTheme.headline4,
            color: Apptheme.mainTextColor,
            fontSize: 10,
          ),
          bodyText2: GoogleFonts.montserrat(
            textStyle: textTheme.headline4,
            color: Apptheme.mainButonColor,
            fontSize: 20,
          ),
          subtitle2: GoogleFonts.montserrat(
            textStyle: textTheme.headline4,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
      home: MainView(),
    );
  }
}
