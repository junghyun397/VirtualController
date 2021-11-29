import 'dart:convert';

import 'dart:typed_data';

import 'package:vfcs/panel/panel_data.dart';

class NetworkProtocol {

  static const int PACKET_HANDSHAKE = 1;
  static const int PACKET_INTEGER = 2;
  static const int PACKET_STRING = 3;
  static const int PACKET_VALIDATION = 4;

  static const int ANALOGUE_INPUT_COUNT = 8;
  static const int DIGITAL_INPUT_COUNT = 128;

  static const int DIGITAL_TRUE = 1;
  static const int DIGITAL_FALSE = 0;

}

// TYPE, optional(TARGET_INPUT), DATA

abstract class NetworkData<T> {

  final T value;

  NetworkData(this.value);

  Uint8List encode();

}

class IntegerNetworkData extends NetworkData<int> {

  final int targetInput;

  IntegerNetworkData(this.targetInput, int value) : super(value);

  @override
  Uint8List encode() => Uint8List.fromList([NetworkProtocol.PACKET_INTEGER, this.targetInput,
    ...(Uint8List(4)..buffer.asByteData().setInt32(0, this.value, Endian.big))]);

}

abstract class StringNetworkData extends NetworkData<String> {
  
  final int networkType;

  StringNetworkData(this.networkType, String value) : super(value);

  @override
  Uint8List encode() => Uint8List.fromList([this.networkType,
    ...utf8.encode(this.value)]);

}

class ValidationNetworkData extends StringNetworkData {
  
  ValidationNetworkData() : super(NetworkProtocol.PACKET_VALIDATION, "VFCS/${DateTime.now().millisecondsSinceEpoch}");

}

class HandshakeNetworkData extends StringNetworkData {
  
  HandshakeNetworkData(PanelData panelData) : super(NetworkProtocol.PACKET_HANDSHAKE, jsonEncode(panelData.toJSON()));
  
}
