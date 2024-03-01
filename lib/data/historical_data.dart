import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<double>> obtenerDatosHistoricos(String tipoDolar) async {
  List<double> datos = [];

  try {
    var response = await http.get(
        Uri.parse('https://api.argentinadatos.com/v1/cotizaciones/dolares'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      List<dynamic> datosFiltrados =
          data.where((dato) => dato['casa'] == tipoDolar).toList();

      datosFiltrados.sort((a, b) => a['fecha'].compareTo(b['fecha']));

      int startIndex =
          datosFiltrados.length > 7 ? datosFiltrados.length - 7 : 0;
      List<dynamic> ultimosDatos = datosFiltrados.sublist(startIndex);

      for (var dato in ultimosDatos) {
        datos.add(double.parse(dato['venta'].toString()));
      }
    } else {
      throw Exception('Error al cargar los datos: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  return datos;
}
