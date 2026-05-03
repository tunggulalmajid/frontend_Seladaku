import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Import untuk translator alamat

class MapPickerPage extends StatefulWidget {
  final LatLng? initialLocation;

  const MapPickerPage({super.key, this.initialLocation});
  @override
  _MapPickerPageState createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  // Koordinat default (Jember/UNEJ)
  late LatLng _currentLocation;
  String _address = "Ketuk peta atau klik tombol GPS";
  bool _isLoadingAddress = false;
  final MapController _mapController = MapController();
  
  @override
  void initState() {
    super.initState();
    // Jika ada lokasi awal dari DB, pakai itu. Jika null, pakai default (Jember)
    _currentLocation = widget.initialLocation ?? LatLng(-8.1706, 113.7022);

    // Langsung ambil alamatnya agar teks di kotak atas tidak kosong
    _getAddressFromLatLng(_currentLocation);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    setState(() => _isLoadingAddress = true);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];
      setState(() {
        // Menyusun format alamat: Nama Jalan, Kec, Kota, Kode Pos
        _address =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea} ${place.postalCode}";
        _isLoadingAddress = false;
      });
    } catch (e) {
      log("Gagal ambil alamat: $e");
      setState(() {
        _address = "Alamat tidak ditemukan";
        _isLoadingAddress = false;
      });
    }
  }

  // 2. FUNGSI GPS: Ambil lokasi otomatis dari HP
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GPS mati, Wak. Nyalakan dulu!')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    LatLng newPos = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentLocation = newPos;
      _mapController.move(_currentLocation, 15.0);
    });

    _getAddressFromLatLng(newPos); // Translate alamat otomatis
    log("GPS Berhasil: ${position.latitude}, ${position.longitude}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Lokasi"),
        actions: [
          // Tombol Konfirmasi Final
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.green, size: 30),
            onPressed: () {
              // Kirim balik data koordinat dan alamat ke halaman form
              Navigator.pop(context, {
                'lat': _currentLocation.latitude,
                'lon': _currentLocation.longitude,
                'address': _address,
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // LAYER 1: Peta OpenStreetMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 15.0,
              onTap: (tapPosition, point) {
                setState(() => _currentLocation = point);
                _getAddressFromLatLng(point); // Translate saat klik manual
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                additionalOptions: const {
                  'User-Agent': 'FrontendAmbilin_ByTunggul_1.0',
                },
                userAgentPackageName: 'com.example.frontend_ambilin',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation,
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 45,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // LAYER 2: Kotak Alamat (Floating)
          Positioned(
            top: 20,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 8),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.map, color: Colors.blue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _isLoadingAddress ? "Mencari alamat..." : _address,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // LAYER 3: Tombol My Location
          Positioned(
            bottom: 30,
            right: 20,
            child: FloatingActionButton(
              heroTag: "gps_btn",
              backgroundColor: Colors.white,
              onPressed: _determinePosition,
              child: const Icon(Icons.my_location, color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }
}
