import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:dolartoday/data/constants.dart';
import 'package:dolartoday/data/pull_data.dart';

class ConversionWidget extends StatefulWidget {
  const ConversionWidget({Key? key}) : super(key: key);

  @override
  _ConversionWidgetState createState() => _ConversionWidgetState();
}

class _ConversionWidgetState extends State<ConversionWidget> {
  double dolarBlue = 0.0;
  double dolarOficial = 0.0;
  double pesosInput = 0.0;
  final PullData _pullData = PullData();

  @override
  void initState() {
    super.initState();
    _obtenerValoresDolar();
  }

  Future<void> _obtenerValoresDolar() async {
    try {
      List<Map<String, dynamic>> tiposDeCambio =
          await _pullData.obtenerTiposDeCambio();

      Map<String, dynamic> oficial = tiposDeCambio
          .firstWhere((tipoCambio) => tipoCambio['nombre'] == 'Oficial');
      Map<String, dynamic> blue = tiposDeCambio
          .firstWhere((tipoCambio) => tipoCambio['nombre'] == 'Blue');

      setState(() {
        dolarOficial = oficial['venta'].toDouble();
        dolarBlue = blue['venta'].toDouble();
      });
    } catch (e) {
      print('Error al obtener valores del Dólar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.monetization_on),
            hintText: 'Pesos',
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.amber, width: 4),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          ),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            setState(() {
              pesosInput = double.tryParse(value) ?? 0.0;
            });
          },
        ),
        const SizedBox(height: 20),
        Text(
          'Dólar Oficial:',
          style: myConversionText,
        ),
        Text(
          '${pesosInput == 0 ? '0.00' : (pesosInput / dolarOficial).toStringAsFixed(2)}',
          style: myConversionText,
        ),
        Text(
          'Dólar Blue:',
          style: myConversionText,
        ),
        Text(
          '${pesosInput == 0 ? '0.00' : (pesosInput / dolarBlue).toStringAsFixed(2)}',
          style: myConversionText,
        ),
      ],
    );
  }
}
