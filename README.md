# Seladaku 🥬💧

Seladaku adalah aplikasi mobile berbasis **Flutter** yang dirancang untuk memantau (monitor) dan mengontrol sistem pertanian hidroponik tanaman selada secara *real-time*. Aplikasi ini terintegrasi dengan perangkat IoT (Internet of Things) untuk membantu petani hidroponik melacak kondisi kesehatan tanaman serta mengotomatisasi pemeliharaan tandon nutrisi.

---

## 🚀 Fitur Utama

1. **Pemantauan Telemetri Real-Time**:
   - **pH Air**: Memantau tingkat keasaman air dalam tandon.
   - **Nutrisi (PPM)**: Memantau kepekatan nutrisi tanaman.
   - **Volume Air**: Mengukur ketersediaan air tandon menggunakan sensor jarak/ultrasonik.
   - **Status Cuaca & Hujan**: Menampilkan indikasi cuaca lokal serta pendeteksi hujan aktif secara langsung.

2. **Kontrol Aktuator Hidroponik**:
   - **Mode Otomatis**: Menyerahkan penyesuaian pH dan nutrisi ke sistem IoT berdasarkan batas parameter yang ditentukan.
   - **Kontrol Pompa & Solenoid**: Mengontrol status pompa air dan katup solenoid (S1 & S2) untuk pengisian air maupun nutrisi.

3. **Manajemen Kebun & Tandon**:
   - Penambahan dan pengaturan beberapa Kebun (Area).
   - Pendaftaran perangkat IoT ke Tandon tertentu.
   - Kustomisasi parameter ambang batas aman (Min/Max pH, Min/Max PPM, Volume Minimum, Tinggi Tandon, dan Jarak Aman).

4. **Notifikasi Pintar (Push Notifications)**:
   - Terintegrasi dengan **Firebase Cloud Messaging (FCM)** untuk memberikan peringatan instan ketika parameter tandon melewati batas aman.

5. **Visualisasi Data & Riwayat**:
   - Grafik riwayat telemetri interaktif menggunakan `fl_chart` untuk menganalisis tren kondisi tandon dari waktu ke waktu.

6. **Integrasi Peta Interaktif**:
   - Memilih lokasi kebun secara presisi menggunakan Google Maps dan Flutter Map.

---

## 📂 Struktur Proyek

Arsitektur aplikasi menggunakan pola **Provider** untuk manajemen state dan memisahkan logika bisnis (Service/Provider) dari tampilan (UI).

```text
lib/
├── main.dart                  # Titik masuk utama aplikasi & inisialisasi Firebase/Provider
├── dto/                       # Data Transfer Objects untuk pertukaran data API
├── models/                    # Model data terstruktur (Tandon, User, Area, Cuaca, dll.)
├── providers/                 # State management (ChangeNotifier) untuk memproses logika UI
├── services/                  # Integrasi API (Dio) & Real-time WebSockets (Socket.IO)
│   ├── api_service.dart
│   ├── socket_service.dart
│   └── dio_interceptor.dart   # Manajemen autentikasi token otomatis
├── utils/                     # Utilitas pendukung seperti rute aplikasi (`app_routes.dart`)
└── ui/                        # Desain antarmuka pengguna
    ├── widgets/               # Komponen UI yang dapat digunakan kembali (Reusable Widgets)
    └── screens/               # Halaman-halaman aplikasi:
        ├── auth/              # Halaman Login & Register
        ├── kebun/             # Halaman daftar & tambah Kebun
        ├── tandon/            # Halaman monitoring, tambah tandon, tambah IoT, & atur parameter
        ├── cuaca/             # Detail prakiraan cuaca
        ├── notif/             # Riwayat notifikasi sistem
        └── profile/           # Detail profil pengguna & peta lokasi
```

---

## 🛠️ Dependensi Utama

Aplikasi ini menggunakan beberapa paket open-source penting:
*   **State Management**: `provider`
*   **Networking**: `dio` (HTTP Client) & `socket_io_client` (WebSockets)
*   **Keamanan & Penyimpanan**: `flutter_secure_storage`
*   **Maps & Geolocation**: `google_maps_flutter`, `flutter_map`, `geolocator`, `geocoding`
*   **Chart/Grafik**: `fl_chart`
*   **Notifikasi**: `firebase_core`, `firebase_messaging`
*   **Desain**: `google_fonts`, `cupertino_icons`

---

## ⚙️ Cara Memulai & Menjalankan Proyek

### Prasyarat
Sebelum memulai, pastikan Anda telah memasang:
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi yang direkomendasikan sesuai dengan Dart SDK `^3.11.5`).
*   Android Studio / VS Code dengan ekstensi Flutter & Dart.

### Langkah Instalasi

1.  **Clone Repositori**:
    ```bash
    git clone <repository-url>
    cd frontend_ambilin
    ```

2.  **Unduh Dependensi**:
    ```bash
    flutter pub get
    ```

3.  **Jalankan Aplikasi**:
    *   Menggunakan perangkat fisik atau emulator yang terhubung:
    ```bash
    flutter run
    ```
    *   Atau jalankan via VS Code dengan menekan tombol `F5`.

---

## 🔒 Konfigurasi Firebase
Aplikasi ini sudah dikonfigurasi dengan Firebase SDK untuk fitur notifikasi pada file [lib/main.dart](file:///e:/code code/PPLSeladaku/Frontend/frontend_ambilin/lib/main.dart). Jika ingin mengubah ke proyek Firebase Anda sendiri, pastikan untuk memperbarui parameter `FirebaseOptions` pada fungsi `main()` di berkas tersebut serta memperbarui file `google-services.json` (untuk Android) dan `GoogleService-Info.plist` (untuk iOS).
