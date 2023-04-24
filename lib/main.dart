import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'controller/localizacao_controller.dart';
import 'dto/localizacao_dto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _getLocalizacao() async {
    EasyLoading.show(status: 'Aguarde....');
    Position position = await _determinarPosicao();
    localizacaoCtrl.setLocalizacao(position.latitude.toString(), position.longitude.toString());
    EasyLoading.dismiss();
  }

  Future<Position> _determinarPosicao() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Sem Permissao');
      }
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  final localizacaoCtrl = LocalizacaoController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Localização Atual',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Obx(() => Center(
                  child: Text(
                    'Latitude ${localizacaoCtrl.local.value.latitude}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                )),
            Obx(
              () => Center(
                child: Text(
                  'Longitude ${localizacaoCtrl.local.value.longitude}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocalizacao,
        tooltip: 'Buscar',
        child: const Icon(Icons.location_city),
      ),
    );
  }
}
