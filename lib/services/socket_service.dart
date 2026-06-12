import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:developer';

class SocketService {
  late IO.Socket socket;

  void connect() {
    socket = IO.io(
      'http://seladaku.kodetalma.my.id',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) => log('✅ Terhubung ke WebSocket Server'));
    socket.onDisconnect((_) => log('❌ Terputus dari WebSocket'));
    socket.onConnectError((data) => log('⚠️ Koneksi Error: $data'));
  }

  void listenToSensor(int idTandon, Function(Map<String, dynamic>) onData) {
    socket.on('sensor-$idTandon', (data) {
      log('📡 Data sensor masuk: $data');
      onData(data);
    });
  }

  void sendControl({
    required String deviceId,
    required String target,
    required String command,
  }) {
    final payload = {
      "device_id": deviceId,
      "target": target,
      "command": command,
    };
    socket.emit('control-device', payload);
    log('📤 Perintah terkirim: $payload');
  }

  void stopListening(int idTandon) {
    socket.off('sensor-$idTandon');
  }

  void dispose() {
    socket.dispose();
  }
}
