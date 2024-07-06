// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:async';
import 'dart:ui' as ui;
import 'package:e_waste/constants/app_colors.dart';
import 'package:e_waste/constants/app_constants.dart';
import 'package:e_waste/providers/e_waste_provider.dart';
import 'package:e_waste/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

class AdjustPinScreen extends StatefulWidget {
  const AdjustPinScreen({
    Key? key,
    this.text,
    required this.lat,
    required this.lon,
    // required this.isHomePage,
  }) : super(key: key);

  final String? text;
  final double lat;
  final double lon;
  // final bool isHomePage;

  @override
  _AdjustPinScreenState createState() => _AdjustPinScreenState();
}

class _AdjustPinScreenState extends State<AdjustPinScreen> {
  Location location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    checkLocationService();
    _getLocation();
  }

  Future<void> checkLocationService() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {});
  }

  Future<void> enableLocation() async {
    _serviceEnabled = await location.requestService();
    if (_serviceEnabled) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        _locationData = await location.getLocation();
        setState(() {});
      }
    }
  }

  final Completer<GoogleMapController> _controller = Completer();
  LatLng markerPosition = LatLng(0, 0);
  Set<Marker> _markers = Set();

  // Future<void> _requestLocationPermission() async {
  //   final status = await Permission.location.request();
  //   if (status.isGranted) {
  //     // Location permission is granted
  //     Permission.location.request();
  //   } else {
  //     // Location permission is not granted, handle it accordingly
  //     if (status.isPermanentlyDenied) {
  //       // The user denied the permission permanently, you can navigate them to app settings
  //       openAppSettings();
  //     }
  //   }
  // }

  // @override
  // void initState() {
  //   checkLocation();
  //   super.initState();
  //   // _requestLocationPermission();
  //   checkLocationStatus();
  //   _getLocation();
  // }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> _getLocation() async {
    setState(() {
      markerPosition = LatLng(widget.lat, widget.lon);
    });
    final Uint8List markerIcon =
        await getBytesFromAsset(AppConstants.adjustPin, 120);
    try {
      final String markerIdVal = UniqueKey().toString();
      final MarkerId markerId = MarkerId(markerIdVal);

      _markers.clear();
      _markers.add(
        Marker(
          icon: BitmapDescriptor.fromBytes(markerIcon),
          markerId: markerId,
          position: markerPosition,
          infoWindow: InfoWindow(
            title: 'Pinned Address',
          ),
        ),
      );

      setState(() {});
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _updateCameraPosition(CameraPosition position) async {
    final Uint8List markerIcon =
        await getBytesFromAsset(AppConstants.adjustPin, 120);
    final String markerIdVal = UniqueKey().toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    setState(() {
      markerPosition =
          LatLng(position.target.latitude, position.target.longitude);

      _markers.clear();
      _markers.add(
        Marker(
          icon: BitmapDescriptor.fromBytes(markerIcon),
          markerId: markerId,
          position: markerPosition,
          infoWindow: InfoWindow(
            title: 'Pinned Address',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        leading: SizedBox(),
        backgroundColor: Colors.white,
        elevation: 1,
        flexibleSpace: Column(
          children: [
            SizedBox(height: 7),
            Center(
              child: Container(
                height: 4,
                width: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(0xFFD9D9D9),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  child: IconButton(
                    splashRadius: 30,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Select Location',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(width: 50),
              ],
            ),
          ],
        ),
      ),
      // floatingActionButton: IconButton(
      //   onPressed: () {},
      //   icon: Icon(Icons.locatio),
      // ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return GoogleMap(
            myLocationEnabled: true,
            // myLocationButtonEnabled: true,
            onMapCreated: (mapController) {
              _controller.complete(mapController);
            },
            onCameraMove: (CameraPosition newPosition) {
              _updateCameraPosition(newPosition);
            },
            initialCameraPosition: CameraPosition(
              zoom: 14.5,
              target: markerPosition,
            ),
            zoomControlsEnabled: false,
            markers: _markers,
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 30,
            bottom: 20,
            left: 16,
            right: 16,
          ),
          child: ElevatedButton(
            onPressed: () async {
              await context.read<EWasteProvider>().saveLocation(
                    markerPosition.latitude,
                    markerPosition.longitude,
                  );
              debugPrint(
                  '${markerPosition.latitude}, ${markerPosition.longitude}');
              Navigator.pop(context);
              // Provider.of<HomePageProvider>(context, listen: false).lat =
              //     markerPosition.latitude;
              // Provider.of<HomePageProvider>(context, listen: false).lng =
              //     markerPosition.longitude;

              // Helper.openBottomSheet(context, GoogleMapScreen2(isHomepage: widget.isHomePage));
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => GoogleMapScreen2(
              //       isHomepage: widget.isHomePage,
              //     ),
              //   ),
              // );
            },
            child: Text(
              'Save Location',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// // Smooth marker
// import 'dart:async';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class AdjustPinScreen extends StatefulWidget {
//   const AdjustPinScreen({
//     Key? key,
//     this.text,
//     required this.lat,
//     required this.lon,
//   }) : super(key: key);

//   final String? text;
//   final double lat;
//   final double lon;

//   @override
//   _AdjustPinScreenState createState() => _AdjustPinScreenState();
// }

// class _AdjustPinScreenState extends State<AdjustPinScreen> {
//   final Completer<GoogleMapController> _controller = Completer();
//   LatLng markerPosition = LatLng(0, 0);

//   @override
//   void initState() {
//     _getLocation();
//     super.initState();
//   }

//   Future<Uint8List> getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(
//       data.buffer.asUint8List(),
//       targetWidth: width,
//     );
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//         .buffer
//         .asUint8List();
//   }

//   Future<void> _getLocation() async {
//     setState(() {
//       markerPosition = LatLng(widget.lat, widget.lon);
//     });
//   }

//   void _updateCameraPosition(CameraPosition position) async {
//     setState(() {
//       markerPosition =
//           LatLng(position.target.latitude, position.target.longitude);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: (mapController) {
//               _controller.complete(mapController);
//             },
//             onCameraMove: (CameraPosition newPosition) {
//               _updateCameraPosition(newPosition);
//             },
//             initialCameraPosition: CameraPosition(
//               zoom: 14.5,
//               target: markerPosition,
//             ),
//             zoomControlsEnabled: false,
//           ),
//           AnimatedPositioned(
//             duration: Duration(milliseconds: 200),
//             bottom: 100,
//             left: (MediaQuery.of(context).size.width - 40) / 2,
//             child: Icon(
//               Icons.location_on,
//               size: 40,
//               color: Colors.red,
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         height: 100,
//         width: MediaQuery.of(context).size.width,
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.only(
//             top: 30,
//             bottom: 20,
//             left: 16,
//             right: 16,
//           ),
//           child: ElevatedButton(
//             onPressed: () {
//               debugPrint(
//                   '${markerPosition.latitude}, ${markerPosition.longitude}');
//             },
//             child: Text(
//               'Save',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





// import 'dart:async';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class AdjustPinScreen extends StatefulWidget {
//   const AdjustPinScreen({
//     Key? key,
//     this.text,
//     required this.lat,
//     required this.lon,
//   }) : super(key: key);

//   final String? text;
//   final double lat;
//   final double lon;

//   @override
//   _AdjustPinScreenState createState() => _AdjustPinScreenState();
// }

// class _AdjustPinScreenState extends State<AdjustPinScreen>
//     with SingleTickerProviderStateMixin {
//   final Completer<GoogleMapController> _controller = Completer();
//   LatLng markerPosition = LatLng(0, 0);

//   late AnimationController _animationController;
//   late Animation<LatLng> _markerAnimation;

//   @override
//   void initState() {
//     _getLocation();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 200),
//     );
//     _markerAnimation =
//         Tween(begin: LatLng(0, 0), end: LatLng(0, 0)).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.linear,
//     ));
//     super.initState();
//   }

//   Future<Uint8List> getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(
//       data.buffer.asUint8List(),
//       targetWidth: width,
//     );
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//         .buffer
//         .asUint8List();
//   }

//   Future<void> _getLocation() async {
//     setState(() {
//       markerPosition = LatLng(widget.lat, widget.lon);
//     });
//   }

//   void _updateCameraPosition(CameraPosition position) {
//     _animationController.reset();
//     _markerAnimation = Tween(begin: markerPosition, end: position.target)
//         .animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.linear,
//     ));
//     _animationController.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: (mapController) {
//               _controller.complete(mapController);
//             },
//             onCameraMove: (CameraPosition newPosition) {
//               _updateCameraPosition(newPosition);
//             },
//             initialCameraPosition: CameraPosition(
//               zoom: 14.5,
//               target: LatLng(widget.lat, widget.lon),
//             ),
//             zoomControlsEnabled: false,
//           ),
//           AnimatedBuilder(
//             animation: _markerAnimation,
//             builder: (context, child) {
//               return Positioned(
//                 left: (MediaQuery.of(context).size.width - 40) / 2,
//                 bottom: (MediaQuery.of(context).size.height + 100) / 2,
//                 child: Icon(
//                   Icons.location_on,
//                   size: 40,
//                   color: Colors.red,
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         height: 100,
//         width: MediaQuery.of(context).size.width,
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.only(
//             top: 30,
//             bottom: 20,
//             left: 16,
//             right: 16,
//           ),
//           child: ElevatedButton(
//             onPressed: () {
//               debugPrint(
//                   '${markerPosition.latitude}, ${markerPosition.longitude}');
//             },
//             child: Text(
//               'Save',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
// }





// import 'dart:async';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class AdjustPinScreen extends StatefulWidget {
//   const AdjustPinScreen({
//     Key? key,
//     this.text,
//     required this.lat,
//     required this.lon,
//   }) : super(key: key);

//   final String? text;
//   final double lat;
//   final double lon;

//   @override
//   _AdjustPinScreenState createState() => _AdjustPinScreenState();
// }

// class _AdjustPinScreenState extends State<AdjustPinScreen> {
//   final Completer<GoogleMapController> _controller = Completer();
//   LatLng markerPosition = LatLng(0, 0);

//   @override
//   void initState() {
//     _getLocation();
//     super.initState();
//   }

//   Future<Uint8List> getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(
//       data.buffer.asUint8List(),
//       targetWidth: width,
//     );
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//         .buffer
//         .asUint8List();
//   }

//   Future<void> _getLocation() async {
//     setState(() {
//       markerPosition = LatLng(widget.lat, widget.lon);
//     });
//   }

//   void _updateCameraPosition(CameraPosition position) async {
//     setState(() {
//       markerPosition =
//           LatLng(position.target.latitude, position.target.longitude);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: (mapController) {
//               _controller.complete(mapController);
//             },
//             onCameraMove: (CameraPosition newPosition) {
//               _updateCameraPosition(newPosition);
//             },
//             initialCameraPosition: CameraPosition(
//               zoom: 14.5,
//               target: LatLng(0, 0), // Centered initially
//             ),
//             zoomControlsEnabled: false,
//             markers: {
//               Marker(
//                 markerId: MarkerId("customMarker"),
//                 icon: BitmapDescriptor.defaultMarker,
//                 position: markerPosition,
//               ),
//             },
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         height: 100,
//         width: MediaQuery.of(context).size.width,
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.only(
//             top: 30,
//             bottom: 20,
//             left: 16,
//             right: 16,
//           ),
//           child: ElevatedButton(
//             onPressed: () {
//               debugPrint(
//                   '${markerPosition.latitude}, ${markerPosition.longitude}');
//             },
//             child: Text(
//               'Save',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





// import 'dart:async';
// import 'dart:ui' as ui;
// import 'package:e_waste/constants/app_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class AdjustPinScreen extends StatefulWidget {
//   const AdjustPinScreen({
//     Key? key,
//     this.text,
//     required this.lat,
//     required this.lon,
//   }) : super(key: key);

//   final String? text;
//   final double lat;
//   final double lon;

//   @override
//   _AdjustPinScreenState createState() => _AdjustPinScreenState();
// }

// class _AdjustPinScreenState extends State<AdjustPinScreen> {
//   final Completer<GoogleMapController> _controller = Completer();
//   LatLng markerPosition = LatLng(0, 0);
//   BitmapDescriptor? customMarkerIcon;

//   @override
//   void initState() {
//     _getLocation();
//     super.initState();
//   }

//   Future<Uint8List> getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(
//       data.buffer.asUint8List(),
//       targetWidth: width,
//     );
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//         .buffer
//         .asUint8List();
//   }

//   Future<void> _getLocation() async {
//     setState(() {
//       markerPosition = LatLng(widget.lat, widget.lon);
//     });

//     final Uint8List markerIconData = await getBytesFromAsset(
//         AppConstants.adjustPin, 100); // Change to your marker icon path
//     customMarkerIcon = BitmapDescriptor.fromBytes(markerIconData);
//   }

//   void _updateCameraPosition(CameraPosition position) async {
//     setState(() {
//       markerPosition =
//           LatLng(position.target.latitude, position.target.longitude);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: (mapController) {
//               _controller.complete(mapController);
//             },
//             onCameraMove: (CameraPosition newPosition) {
//               _updateCameraPosition(newPosition);
//             },
//             initialCameraPosition: CameraPosition(
//               zoom: 14.5,
//               target: LatLng(0, 0), // Centered initially
//             ),
//             zoomControlsEnabled: false,
//             markers: {
//               Marker(
//                 markerId: MarkerId("customMarker"),
//                 icon: customMarkerIcon!,
//                 position: markerPosition,
//               ),
//             },
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         height: 100,
//         width: MediaQuery.of(context).size.width,
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.only(
//             top: 30,
//             bottom: 20,
//             left: 16,
//             right: 16,
//           ),
//           child: ElevatedButton(
//             onPressed: () {
//               debugPrint(
//                   '${markerPosition.latitude}, ${markerPosition.longitude}');
//             },
//             child: Text(
//               'Save',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
