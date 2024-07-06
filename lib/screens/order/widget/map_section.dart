import 'dart:async';
import 'dart:ui' as ui;

import 'package:e_waste/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSection extends StatefulWidget {
  const MapSection({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  final String latitude;
  final String longitude;

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  getLocation() async {
    final Uint8List markerIcon =
        await getBytesFromAsset(AppConstants.adjustPin, 100);
    double lat = double.parse(widget.latitude);
    double lon = double.parse(widget.longitude);
    final String markerIdVal = UniqueKey().toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    setState(() {
      _markers.add(
        Marker(
          icon: BitmapDescriptor.fromBytes(markerIcon),
          markerId: markerId,
          position: LatLng(lat, lon),
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 180,
          width: MediaQuery.of(context).size.width,
          child: IgnorePointer(
            ignoring: true,
            child: GoogleMap(
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
              myLocationButtonEnabled: false,
              onCameraMove: (CameraPosition newPosition) {},
              initialCameraPosition: CameraPosition(
                zoom: 13,
                target: LatLng(
                  double.parse(widget.latitude),
                  double.parse(widget.longitude),
                ),
              ),
              zoomControlsEnabled: false,
              markers: _markers,
              gestureRecognizers: Set(),
            ),
          ),
        ),
      ],
    );
  }
}
