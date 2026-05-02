import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../../utils/app_colors.dart';
import '../widgets/w_button.dart';
import '../widgets/w_text.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  static const LatLng _initialPosition = LatLng(-8.1652, 113.7170);

  LatLng _pickedLocation = _initialPosition;
  String _currentAddress = "Geser pin ke lokasi kebunmu, Wak!";
  bool _isGettingAddress = false;

  // Fungsi untuk mendapatkan alamat teks dari koordinat
  Future<void> _getAddress(LatLng position) async {
    setState(() => _isGettingAddress = true);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              "${place.street}, ${place.subLocality}, ${place.locality}";
        });
      }
    } catch (e) {
      setState(() => _currentAddress = "Alamat tidak ditemukan");
    } finally {
      setState(() => _isGettingAddress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const WText(
          isi: "Pilih Lokasi Kebun",
          fw: FontWeight.bold,
          ukuranFont: 18,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // MAPS VIEW
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _initialPosition,
              zoom: 15,
            ),
            onMapCreated: (controller) => _getAddress(_initialPosition),
            onCameraMove: (position) {
              _pickedLocation = position.target;
            },
            onCameraIdle: () {
              _getAddress(_pickedLocation); // Update alamat pas berhenti geser
            },
            // Pin tetap di tengah layar
            markers: {
              Marker(
                markerId: const MarkerId("picked_location"),
                position: _pickedLocation,
              ),
            },
          ),

          // OVERLAY INFORMASI ALAMAT
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColor.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _isGettingAddress
                              ? "Mencari alamat..."
                              : _currentAddress,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  WButton(
                    text: "Gunakan Lokasi Ini",
                    onPressed: _isGettingAddress
                        ? () {}
                        : () {
                            // Balikin data ke halaman Edit Profile
                            Navigator.pop(context, {
                              'lat': _pickedLocation.latitude,
                              'lon': _pickedLocation.longitude,
                              'address': _currentAddress,
                            });
                          },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
