import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/datasources/vendors/vendor_locations.dart';

class NearbyVendorsScreen extends StatelessWidget {
  const NearbyVendorsScreen({super.key});

  static const _initialCamera = CameraPosition(
    target: LatLng(29.5, 31.2),
    zoom: 6.2,
  );

  @override
  Widget build(BuildContext context) {
    final markers = vendorLocations
        .map(
          (vendor) => Marker(
            markerId: MarkerId(vendor.id),
            position: LatLng(vendor.latitude, vendor.longitude),
            infoWindow: InfoWindow(
              title: vendor.nameKey.tr(),
              snippet:
                  '${vendor.cuisineKey.tr()} · ${'vendorRating'.tr(namedArgs: {'rating': vendor.rating.toStringAsFixed(1)})}',
            ),
          ),
        )
        .toSet();

    return Scaffold(
      appBar: AppBar(title: Text('nearbyVendors'.tr())),
      body: GoogleMap(
        initialCameraPosition: _initialCamera,
        markers: markers,
        mapToolbarEnabled: false,
      ),
    );
  }
}
