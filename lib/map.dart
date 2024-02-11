import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/location.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(this.data, {super.key});

  final String? data;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Position? _position;
  late Timer _positionTimer;

  @override
  void initState() {
    super.initState();
    _positionTimer =
        Timer.periodic(const Duration(seconds: 10), positionTimerTick);
    Future.delayed(Duration.zero, () async {
      positionTimerTick(_positionTimer);
    });
  }

  Future<void> positionTimerTick(Timer timer) async {
    final position = await determinePosition();
    setState(() {
      _position = position;
    });
  }

  @override
  void dispose() {
    _positionTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dark = Theme.of(context).brightness == Brightness.dark;
    return FlutterMap(
      options: MapOptions(
        center: const LatLng(49.8236, 15.7712),
        // center: const LatLng(51.32, 14.8264),
        zoom: 8,
        // zoom: 13,
        interactiveFlags: InteractiveFlag.doubleTapZoom |
            InteractiveFlag.drag |
            InteractiveFlag.pinchMove |
            InteractiveFlag.pinchZoom,
      ),
      nonRotatedChildren: [
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
            LogoSourceAttribution(
              Image.asset("assets/madsoft.png"),
              onTap: () => launchUrl(Uri.parse("https://madsoft.cz")),
              tooltip: "MadSoft",
            ),
            LogoSourceAttribution(
              Image.asset("assets/chmi.png"),
              onTap: () => launchUrl(Uri.parse("https://www.chmi.cz/")),
              tooltip: "Český hydrometeorologický ústav",
            ),
          ],
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'cz.madsoft.weather',
          tileBuilder: dark ? darkModeTileBuilder : null,
        ),
        OverlayImageLayer(
          overlayImages: widget.data != null
              ? [
                  OverlayImage(
                    bounds: LatLngBounds(
                      const LatLng(51.34, 11.289),
                      const LatLng(48.468, 19.6125),
                    ),
                    imageProvider: NetworkImage(widget.data!),
                    opacity: 0.5,
                  )
                ]
              : [],
        ),
        MarkerLayer(
          markers: [
            ...(_position != null
                ? [
                    Marker(
                      point: LatLng(_position!.latitude, _position!.longitude),
                      builder: (ctx) => const Icon(
                        Icons.circle,
                        color: Colors.pink,
                        shadows: [Shadow(color: Colors.white, blurRadius: 3)],
                        opticalSize: 100,
                        size: 15,
                      ),
                    ),
                  ]
                : [])
          ],
        ),
      ],
    );
  }
}
