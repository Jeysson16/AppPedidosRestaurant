import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeWidget extends StatelessWidget {
  final String sucursalId;
  final String pisoId;
  final String mesaId;

  const QRCodeWidget({
    Key? key,
    required this.sucursalId,
    required this.pisoId,
    required this.mesaId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String qrData = '/sucursal/$sucursalId/piso/$pisoId/mesa/$mesaId';

    return Container();
/*
    return QrImage(
      data: qrData,
      version: QrVersions.auto,
      size: 200.0,
    );
    */
  }
}
