import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:seladaku/utils/app_colors.dart';
import 'package:seladaku/ui/widgets/w_text.dart';

class MapPickerPage extends StatefulWidget {
  final LatLng? initialLocation;

  const MapPickerPage({super.key, this.initialLocation});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  late LatLng _currentLocation;
  String _address = "Ketuk peta atau klik tombol GPS";
  bool _isLoadingAddress = false;
  final MapController _mapController = MapController();

  @override
  @override
  void initState() {
    super.initState();

    if (widget.initialLocation != null &&
        !widget.initialLocation!.latitude.isNaN &&
        !widget.initialLocation!.longitude.isNaN) {
      _currentLocation = widget.initialLocation!;
    } else {
      _currentLocation = const LatLng(-8.1706, 113.7022);
    }

    _getAddressFromLatLng(_currentLocation);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    setState(() => _isLoadingAddress = true);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _address =
              "${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea} ${place.postalCode}";
        });
      }
    } catch (e) {
      log("Gagal ambil alamat: $e");
      setState(() {
        _address = "Alamat tidak ditemukan";
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingAddress = false);
      }
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GPS mati, Wak. Nyalakan dulu!')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission GPS ditolak, Wak!')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission GPS ditolak permanen di pengaturan HP!'),
        ),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    LatLng newPos = LatLng(position.latitude, position.longitude);

    if (mounted) {
      setState(() {
        _currentLocation = newPos;
        _mapController.move(_currentLocation, 15.0);
      });

      _getAddressFromLatLng(newPos);
    }

    log("GPS Berhasil: ${position.latitude}, ${position.longitude}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const WText(
          isi: "Pilih Lokasi Kebun",
          fw: FontWeight.bold,
          ukuranFont: 16,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context, {
                'lat': _currentLocation.latitude,
                'lon': _currentLocation.longitude,
                'address': _address,
              });
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,

              initialZoom: 17.5,
              maxZoom: 19.0,
              minZoom: 12.0,
              onTap: (tapPosition, point) {
                setState(() => _currentLocation = point);
                _getAddressFromLatLng(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                additionalOptions: const {
                  'User-Agent':
                      'SeladakuApp_ByTunggulAbdulMajid_ClassOf2024_UNEJ',
                },
                userAgentPackageName: 'com.tunggul.seladaku',
              ),

              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation,
                    width: 60,
                    height: 60,
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.redAccent,
                      size: 45,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            top: 15,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.stars_rounded, color: AppColor.primary, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _isLoadingAddress
                          ? "Mencari alamat detail kebun..."
                          : _address,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            right: 20,
            child: FloatingActionButton(
              heroTag: "gps_seladaku_btn",
              backgroundColor: AppColor.primary,
              onPressed: _determinePosition,
              child: const Icon(Icons.my_location_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
