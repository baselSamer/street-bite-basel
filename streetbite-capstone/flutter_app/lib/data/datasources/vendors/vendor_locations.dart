import '../../../domain/entities/vendor_location.dart';

/// Demo vendor locations across five Egyptian cities.
const vendorLocations = <VendorLocation>[
  VendorLocation(
    id: 'cairo',
    nameKey: 'vendorCairo',
    cuisineKey: 'cuisineEgyptian',
    rating: 4.7,
    latitude: 30.0444,
    longitude: 31.2357,
  ),
  VendorLocation(
    id: 'alexandria',
    nameKey: 'vendorAlexandria',
    cuisineKey: 'cuisineSeafood',
    rating: 4.6,
    latitude: 31.2001,
    longitude: 29.9187,
  ),
  VendorLocation(
    id: 'giza',
    nameKey: 'vendorGiza',
    cuisineKey: 'cuisineGrill',
    rating: 4.5,
    latitude: 30.0131,
    longitude: 31.2089,
  ),
  VendorLocation(
    id: 'mansoura',
    nameKey: 'vendorMansoura',
    cuisineKey: 'cuisineLevantine',
    rating: 4.4,
    latitude: 31.0409,
    longitude: 31.3785,
  ),
  VendorLocation(
    id: 'aswan',
    nameKey: 'vendorAswan',
    cuisineKey: 'cuisineEgyptian',
    rating: 4.8,
    latitude: 24.0889,
    longitude: 32.8998,
  ),
];
