import 'package:app_grafico_compartilhado/src/screens/cotacao_screen.dart';
import 'package:app_grafico_compartilhado/src/screens/grafico_screen.dart';
import 'package:app_grafico_compartilhado/src/screens/moeda_screen.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:flutter/material.dart';

class NavigatorButtons {
  static Widget buildNavigatorButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            NavigatorButtons.goToGrafico(context);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.color2),
          ),
          child: const Text(
            "Gráfico",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            NavigatorButtons.goToCotacao(context);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.color2),
          ),
          child: const Text(
            "Cotação",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            NavigatorButtons.goToMoedas(context);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.color2),
          ),
          child: const Text(
            "Moedas",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  static void goToGrafico(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const GraficoScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
      ),
    );
  }

  static void goToCotacao(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const CotacaoScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  static void goToMoedas(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MoedaScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
