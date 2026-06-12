import 'package:flutter/material.dart';
import 'package:seladaku/models/notifikasi_model.dart';
import 'package:seladaku/providers/notifikasi_provider.dart';
import 'package:seladaku/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotifikasiProvider>(context, listen: false).fetchNotifikasi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,

        title: Text(
          'Riwayat Notifikasi',
          style: GoogleFonts.poppins(
            color: AppColor.text,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF02A697),

        onRefresh: () => Provider.of<NotifikasiProvider>(
          context,
          listen: false,
        ).fetchNotifikasi(),
        child: Consumer<NotifikasiProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF02A697)),
              );
            }

            if (provider.listNotif.isEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  alignment: Alignment.center,
                  child: const Text("Tidak ada riwayat notifikasi"),
                ),
              );
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (provider.totalUnread > 0) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F7F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: Color(0xFF02A697),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${provider.totalUnread} notifikasi belum dibaca',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF02A697),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (provider.listHariIni.isNotEmpty) ...[
                    _buildHeaderSeksi("Hari Ini", provider.listHariIni.length),
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.listHariIni.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _buildCardNotif(
                          provider.listHariIni[index],
                          provider,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],

                  if (provider.listKemarin.isNotEmpty) ...[
                    _buildHeaderSeksi("Kemarin", provider.listKemarin.length),
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.listKemarin.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _buildCardNotif(
                          provider.listKemarin[index],
                          provider,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],

                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        "Tidak ada notifikasi lainnya",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderSeksi(String judul, int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          judul,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        CircleAvatar(
          radius: 10,
          backgroundColor: const Color(0xFFE6F7F5),
          child: Text(
            total.toString(),
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Color(0xFF02A697),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardNotif(NotifikasiModel item, NotifikasiProvider provider) {
    IconData iconData = Icons.notifications;
    Color iconColor = const Color(0xFF02A697);

    if (item.tipe == 'WARNING') {
      if (item.judul.contains('Air')) {
        iconData = Icons.water_drop;
      } else if (item.judul.contains('pH')) {
        iconData = Icons.speed;
      } else {
        iconData = Icons.science;
      }
    } else if (item.tipe == 'INFO') {
      iconData = Icons.cloud_queue;
    } else if (item.judul.contains('Koneksi')) {
      iconData = Icons.wifi_off;
    }

    return GestureDetector(
      onTap: () => provider.bacaNotifikasi(item.idNotifikasi),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F7F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.judul,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            DateFormat('HH:mm').format(item.createdAt),
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          if (!item.isRead) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.circle,
                              size: 6,
                              color: Color(0xFF02A697),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.pesan,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => provider.hapusNotifikasi(item.idNotifikasi),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF2F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
