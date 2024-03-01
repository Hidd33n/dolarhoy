import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dolartoday/data/constants.dart';
import 'package:dolartoday/data/historical_data.dart';
import 'package:dolartoday/data/pull_data.dart'; // Importa la clase PullData
import 'chart.dart'; // Importa el widget CustomLineChart
import 'package:intl/intl.dart'; // Importa el paquete de formateo de fechas

class BuildTarjeta extends StatefulWidget {
  @override
  _BuildTarjetaState createState() => _BuildTarjetaState();
}

class _BuildTarjetaState extends State<BuildTarjeta> {
  // Variables para almacenar los datos de la API
  Map<String, dynamic> oficial = {};
  Map<String, dynamic> blue = {};
  // Variable para almacenar la fecha y hora de la última actualización
  String ultimaActualizacion = '';
  List<double> oficialData = [];
  List<double> blueData = [];

  @override
  void initState() {
    super.initState();
    // Inicializa la fecha y hora de la última actualización al iniciar la aplicación
    actualizarUltimaActualizacion();
    // Llamar a la función para obtener los datos inicialmente
    obtenerDatosHistoricosYActualizar();
    actualizarDatos();
    // Actualizar cada 5 minutos
    Timer.periodic(const Duration(minutes: 10), (timer) {
      actualizarDatos();
    });
  }

  // Función para actualizar la fecha y hora de la última actualización
  void actualizarUltimaActualizacion() {
    ultimaActualizacion = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
  }

  // Función para actualizar los datos desde la API
  void actualizarDatos() async {
    try {
      // Crear una instancia de PullData
      PullData pullData = PullData();
      // Obtener los tipos de cambio
      List<Map<String, dynamic>> tiposDeCambio =
          await pullData.obtenerTiposDeCambio();
      // Buscar los datos de "Oficial" y "Blue"
      oficial = tiposDeCambio.firstWhere(
          (element) => element['nombre'] == 'Oficial',
          orElse: () => {});
      blue = tiposDeCambio.firstWhere((element) => element['nombre'] == 'Blue',
          orElse: () => {});
      // Actualizar la fecha y hora de la última actualización
      actualizarUltimaActualizacion();
      // Actualizar la interfaz de usuario con los nuevos datos
      setState(() {});
    } catch (e) {
      // Manejo del error
    }
  }

  Future<void> obtenerDatosHistoricosYActualizar() async {
    try {
      // Obtener datos históricos para el dólar oficial y el dólar blue
      List<double> datosOficiales = await obtenerDatosHistoricos('oficial');
      List<double> datosBlue = await obtenerDatosHistoricos('blue');

      // Convertir los valores enteros a flotantes
      List<double> nuevoOficialData =
          datosOficiales.map((e) => e.toDouble()).toList();
      List<double> nuevoBlueData = datosBlue.map((e) => e.toDouble()).toList();

      // Actualizar los datos del gráfico
      setState(() {
        oficialData = nuevoOficialData;
        blueData = nuevoBlueData;
      });
    } catch (e) {
      // Manejar cualquier error que ocurra durante la solicitud
      print('Errosadr: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20), // Espacio entre la fecha y las tarjetas
        // Tarjeta oficial
        Card(
          color: Colors.black,
          elevation: 12,
          shadowColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: Colors.white,
                    ), // Icono de dólar
                    SizedBox(width: 8), // Espacio entre el icono y el texto
                    Text(
                      'Oficial',
                      style: myDolarTypestyle,
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'P. Compra: ${oficial['compra']?.toString() ?? ''}',
                          style: myDolarSellText,
                        ),
                        Text(
                          'P. Venta: ${oficial['venta']?.toString() ?? ''}',
                          style: myDolarSellText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Espacio para el gráfico
              // Espacio para el gráfico
              Container(
                height: 100, // Ajusta la altura según tu necesidad
                width: 100, // Toma todo el ancho disponible
                child: ClipRect(
                  child:
                      LineChartWidget(data: oficialData, color: Colors.green),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10), // Espacio entre las tarjetas

        Card(
          color: Colors.black,
          elevation: 12,
          shadowColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: Colors.white,
                    ), // Icono de dólar
                    SizedBox(width: 8), // Espacio entre el icono y el texto
                    Text(
                      'Blue',
                      style: myDolarTypestyle,
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'P. Compra: ${blue['compra']?.toString() ?? ''}',
                          style: myDolarSellText,
                        ),
                        Text(
                          'P. Venta: ${blue['venta']?.toString() ?? ''}',
                          style: myDolarSellText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Espacio para el gráfico
              // Espacio para el gráfico
              Container(
                height: 100, // Ajusta la altura según tu necesidad
                width: double.infinity, // Toma todo el ancho disponible
                child: ClipRect(
                  child: LineChartWidget(data: blueData, color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
