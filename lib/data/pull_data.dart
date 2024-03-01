import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class PullData {
  Future<List<Map<String, dynamic>>> obtenerTiposDeCambio() async {
    final response =
        await http.get(Uri.parse('https://dolarapi.com/v1/dolares'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> tiposDeCambio =
          List<Map<String, dynamic>>.from(data);

      if (tiposDeCambio.isEmpty) {
        throw Exception('No se encontraron tipos de cambio disponibles');
      }

      tiposDeCambio.forEach((tipoCambio) {
        tipoCambio['compra'] = tipoCambio['compra'].toDouble();
        tipoCambio['venta'] = tipoCambio['venta'].toDouble();
      });

      bool oficialEncontrado =
          tiposDeCambio.any((tipoCambio) => tipoCambio['nombre'] == 'Oficial');
      bool blueEncontrado =
          tiposDeCambio.any((tipoCambio) => tipoCambio['nombre'] == 'Blue');

      if (!oficialEncontrado || !blueEncontrado) {
        throw Exception(
            'No se encontraron los tipos de cambio "Oficial" y "Blue"');
      }

      return tiposDeCambio;
    } else {
      throw Exception('Error al cargar datos: ${response.statusCode}');
    }
  }
}

void main() {
  PullData pullData = PullData();

  obtenerDatosYActualizarCadaCincoMinutos(pullData);

  Timer.periodic(Duration(minutes: 5), (timer) {
    obtenerDatosYActualizarCadaCincoMinutos(pullData);
  });
}

void obtenerDatosYActualizarCadaCincoMinutos(PullData pullData) async {
  try {
    List<Map<String, dynamic>> tiposDeCambio =
        await pullData.obtenerTiposDeCambio();
    actualizarInterfazUsuario(tiposDeCambio);
  } catch (e) {
    // Manejo del error
  }
}

void actualizarInterfazUsuario(List<Map<String, dynamic>> tiposDeCambio) {
  // Aquí puedes actualizar tu interfaz de usuario con los nuevos datos obtenidos
}
