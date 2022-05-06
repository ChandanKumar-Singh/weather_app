// import 'dart:async';
//
// import 'package:geolocator/geolocator.dart';
//
// class NetWork {
//   final LocationSettings locationSettings = LocationSettings(
//     accuracy: LocationAccuracy.high,
//     distanceFilter: 100,
//   );
//   StreamSubscription<Position> positionStream =
//       Geolocator.getPositionStream(locationSettings: locationSettings)
//           .listen((Position? position) {
//     print(position == null
//         ? 'Unknown'
//         : '${position.latitude.toString()}, ${position.longitude.toString()}');
//   });
// }
//
// // Future<WeatherModel> getWeatherModel({String? cityName}){
// //   var finalUrl = 'https://api.openweathermap.org/data/2.5/forecast/daily?q=$cityName&units=metric&cnt=7&appid={ba1a54c4c6667b63d64744d5aa0e95b6}';
// // }
