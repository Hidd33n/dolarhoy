import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rainingtoday/data/constants.dart';
import 'package:rainingtoday/data/pull_data.dart';
import 'package:rainingtoday/presentation/screens/homescreen/functions/buildcard.dart';
import 'package:rainingtoday/presentation/screens/homescreen/functions/conversion.dart'; // Importa el archivo buildcard.dart

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _tiposDeCambio = [];
  final PullData _pullData = PullData();
  bool _isLoading = true;

  void _actualizarValores() async {
    try {
      List<Map<String, dynamic>> data = await _pullData.obtenerTiposDeCambio();
      setState(() {
        _tiposDeCambio = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar datos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _actualizarValores();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_tiposDeCambio.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No se encontraron tipos de cambio disponibles'),
        ),
      );
    }

    _tiposDeCambio.firstWhere(
      (tipoCambio) => tipoCambio['nombre'] == 'Oficial',
      orElse: () => {},
    );
    _tiposDeCambio.firstWhere(
      (tipoCambio) => tipoCambio['nombre'] == 'Blue',
      orElse: () => {},
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.grey[400]),
        title: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(text: 'Dolar', style: greenTextStyle),
                TextSpan(text: 'Hoy', style: blackTextStyle),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 20),
                child: BuildTarjeta(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  const Text(
                    '¿Querés convertir pesos a dólares?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: const ConversionWidget(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
