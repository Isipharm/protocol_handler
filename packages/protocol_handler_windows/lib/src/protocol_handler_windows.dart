import 'dart:io';

import 'package:protocol_handler_platform_interface/protocol_handler_platform_interface.dart';
import 'package:win32_registry/win32_registry.dart';

class ProtocolHandlerWindows extends MethodChannelProtocolHandler {
  /// The [ProtocolHandlerWindows] constructor.
  ProtocolHandlerWindows() : super();

  /// Registers this class as the default instance of [ProtocolHandlerWindows].
  static void registerWith() {
    ProtocolHandlerPlatform.instance = ProtocolHandlerWindows();
  }

  @override
  Future<void> register(String scheme) async {
    String appPath = Platform.resolvedExecutable;

    String protocolRegKey = 'Software\\Classes\\$scheme';
    RegistryValue protocolRegValue = RegistryValue.string(
      'URL Protocol',
      '',
    );
    String protocolCmdRegKey = 'shell\\open\\command';
    RegistryValue protocolCmdRegValue = RegistryValue.string(
      '',
      '$appPath "%1"',
    );

    final regKey = Registry.currentUser.createKey(protocolRegKey);
    regKey.createValue(protocolRegValue);
    regKey.createKey(protocolCmdRegKey).createValue(protocolCmdRegValue);
  }
}
