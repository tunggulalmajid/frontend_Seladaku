import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:developer';

class SocketService {
  late IO.Socket socket;

  void connect() {
    // Sesuaikan URL dengan IP backend Anda
    socket = IO.io(
      'http://10.101.140.218:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) => log('✅ Terhubung ke WebSocket Server'));
    socket.onDisconnect((_) => log('❌ Terputus dari WebSocket'));
    socket.onConnectError((data) => log('⚠️ Koneksi Error: $data'));
  }

  // Mendengarkan update data dari backend
  void listenToSensor(int idTandon, Function(Map<String, dynamic>) onData) {
    socket.on('sensor-$idTandon', (data) {
      log('📡 Data sensor masuk: $data');
      onData(data);
    });
  }

  // Mengirim perintah kontrol ke backend
  void sendControl({
    required String deviceId,
    required String target, // 'pompa', 's1', 's2', atau 'mode'
    required String command, // 'on', 'off', 'auto', atau 'manual'
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
