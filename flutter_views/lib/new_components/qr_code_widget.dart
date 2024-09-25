// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/helper_model/qr_code.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

enum QrCodeCurrentState { NONE, LOADING, DONE }

class QrCodeNotifierState {
  ViewAbstract? viewAbstract;
  QrCodeCurrentState state;
  QrCodeNotifierState({required this.state, this.viewAbstract});
}

class QrCodeReader extends StatefulWidget {
  bool getViewAbstract;
  ViewAbstract? onlyReadThisType;
  double currentHeight;
  ValueNotifier<QrCodeNotifierState?>? valueNotifierQrState;
  Function(QrCodeNotifierState? codeState)? valueNotifierQrStateFunction;
  QrCodeReader(
      {super.key,
      this.valueNotifierQrState,
      this.onlyReadThisType,
      this.valueNotifierQrStateFunction,
      this.getViewAbstract = true,
      this.currentHeight = 0});

  @override
  State<QrCodeReader> createState() => _QrCodeReaderState();
}

class _QrCodeReaderState extends State<QrCodeReader> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  double currentContainerHeight = 0;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void didUpdateWidget(covariant QrCodeReader oldWidget) {
    if (currentContainerHeight != widget.currentHeight) {
      currentContainerHeight = widget.currentHeight;
      if (currentContainerHeight == 0) {
        controller?.stopCamera();
      } else {
        controller?.resumeCamera();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
    );
  }

  bool hasScanedBefore(Barcode scanedResult) {
    if (result != null) {
      if (result?.code == scanedResult.code &&
          result!.format == scanedResult.format) {
        return true;
      }
    }
    result = scanedResult;
    return false;
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (hasScanedBefore(scanData)) return;
      if (checkCurrentState(QrCodeCurrentState.NONE)) {
        widget.valueNotifierQrState?.value =
            QrCodeNotifierState(state: QrCodeCurrentState.NONE);
        widget.valueNotifierQrStateFunction
            ?.call(QrCodeNotifierState(state: QrCodeCurrentState.NONE));
      }
      QRCodeID? qrCodeID;
      if (scanData.format == BarcodeFormat.qrcode) {
        if (scanData.code != null) {
          qrCodeID = QRCodeID.init(scanData.code!);
          debugPrint("QrCodeReader $qrCodeID");
        }
      }
      if (qrCodeID != null) {
        if (widget.onlyReadThisType != null) {
          if ((widget.onlyReadThisType?.getTableNameApi() ?? "") !=
              qrCodeID.action) {
            return;
          }
        }
        if (checkCurrentState(QrCodeCurrentState.LOADING)) {
          widget.valueNotifierQrState?.value =
              QrCodeNotifierState(state: QrCodeCurrentState.LOADING);
          widget.valueNotifierQrStateFunction
              ?.call(QrCodeNotifierState(state: QrCodeCurrentState.LOADING));
        }
        // await controller.pauseCamera();
        if (widget.getViewAbstract) {
          ViewAbstract? v = context
              .read<AuthProvider<AuthUser>>()
              .getNewInstance(qrCodeID.action);

          v = await v?.viewCallGetFirstFromList(qrCodeID.iD,context: context);
          if (checkCurrentState(QrCodeCurrentState.DONE)) {
            v?.setIsScannedFromQrCode = true;
            widget.valueNotifierQrState?.value = QrCodeNotifierState(
                state: QrCodeCurrentState.DONE, viewAbstract: v);
            widget.valueNotifierQrStateFunction?.call(QrCodeNotifierState(
                state: QrCodeCurrentState.DONE, viewAbstract: v));
          }
        }
        // await controller.resumeCamera();
      }
    });
  }

  bool checkCurrentState(QrCodeCurrentState state) {
    return state != widget.valueNotifierQrState?.value?.state;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
