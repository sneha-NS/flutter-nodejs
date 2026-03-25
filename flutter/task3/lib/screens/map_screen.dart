import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/delivery_location.dart';

class MapScreen extends StatefulWidget {
  final DeliveryLocation destination;

  const MapScreen({super.key, required this.destination});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _mapController = Completer();

  Position? _currentPosition;
  String? _locationError;
  bool _fetchingLocation = true;

  late final LatLng _destination;
  late final Set<Marker> _markers;

  @override
  void initState() {
    super.initState();
    _destination = LatLng(widget.destination.lat, widget.destination.lng);
    _markers = {
      Marker(
        markerId: const MarkerId('destination'),
        position: _destination,
        infoWindow: InfoWindow(
          title: widget.destination.name,
          snippet: widget.destination.address,
        ),
      ),
    };
    _determineCurrentPosition();
  }

  Future<void> _determineCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Location services are disabled.';
          _fetchingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Location permission denied.';
            _fetchingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError =
              'Location permission permanently denied. Enable it in Settings.';
          _fetchingLocation = false;
        });
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      setState(() {
        _currentPosition = pos;
        _fetchingLocation = false;
        _markers.add(
          Marker(
            markerId: const MarkerId('current'),
            position: LatLng(pos.latitude, pos.longitude),
            infoWindow: const InfoWindow(title: 'Your Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        );
      });

      final controller = await _mapController.future;
      final bounds = LatLngBounds(
        southwest: LatLng(
          pos.latitude < _destination.latitude
              ? pos.latitude
              : _destination.latitude,
          pos.longitude < _destination.longitude
              ? pos.longitude
              : _destination.longitude,
        ),
        northeast: LatLng(
          pos.latitude > _destination.latitude
              ? pos.latitude
              : _destination.latitude,
          pos.longitude > _destination.longitude
              ? pos.longitude
              : _destination.longitude,
        ),
      );
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 80),
      );
    } catch (e) {
      setState(() {
        _locationError = 'Could not fetch location: $e';
        _fetchingLocation = false;
      });
    }
  }

  Future<void> _openGoogleMapsNavigation() async {
    final dest = widget.destination;
    Uri uri;

    if (_currentPosition != null) {
      uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&origin=${_currentPosition!.latitude},${_currentPosition!.longitude}'
        '&destination=${dest.lat},${dest.lng}'
        '&travelmode=driving',
      );
    } else {
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1'
        '&query=${dest.lat},${dest.lng}',
      );
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination.name),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _destination,
              zoom: 12,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) {
              if (!_mapController.isCompleted) {
                _mapController.complete(controller);
              }
            },
          ),
          if (_locationError != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                color: Colors.orange.shade100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _locationError!,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_fetchingLocation)
            const Positioned(
              top: 8,
              right: 8,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Getting location…'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openGoogleMapsNavigation,
        icon: const Icon(Icons.directions),
        label: const Text('Navigate'),
      ),
    );
  }
}
