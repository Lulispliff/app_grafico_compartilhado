import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class ErrorMessages {
  static void cotacaoAddErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 1200),
        backgroundColor: AppColors.color2,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info, color: AppColors.color4),
            SizedBox(width: 8),
            Text(
              "Insira os dados corretamente!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.color4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void graficoMoedaErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(milliseconds: 1200),
        backgroundColor: AppColors.color2,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info, color: AppColors.color4),
            SizedBox(width: 8),
            Text(
              "Você deve selecionar uma moeda para gerar o gráfico!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.color4),
            )
          ],
        )));
  }

  static void graficoCotacaoErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(milliseconds: 1200),
      backgroundColor: AppColors.color2,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info, color: AppColors.color4),
          SizedBox(width: 8),
          Text(
            "Nenhuma cotação foi encontrada no período de tempo selecionado!",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.color4),
          )
        ],
      ),
    ));
  }

  static void moedaNomeErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 1200),
        backgroundColor: AppColors.color2,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info, color: AppColors.color4),
            SizedBox(width: 8),
            Text(
              "Insira um nome a moeda!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.color4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void moedaNovoNomeErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(milliseconds: 1200),
      backgroundColor: AppColors.color2,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info, color: AppColors.color4),
          SizedBox(width: 8),
          Text(
            "Você deve inserir um novo nome para a moeda que está editando!",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.color4),
          )
        ],
      ),
    ));
  }

  static void errorGraficoNavigatorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 1200),
        backgroundColor: AppColors.color2,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.chartColumn, color: AppColors.color4),
            SizedBox(width: 8),
            Text(
              "Você já está na tela do Gráfico!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.color4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void errorCotacaoNavigatorDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 1200),
        backgroundColor: AppColors.color2,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.fileInvoiceDollar, color: AppColors.color4),
            SizedBox(width: 8),
            Text(
              "Você já está na tela de Cotações!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.color4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void errorMoedaNavigatorDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 1200),
        backgroundColor: AppColors.color2,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.coins, color: AppColors.color4),
            SizedBox(width: 8),
            Text(
              "Você já está na tela de Moedas!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.color4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
