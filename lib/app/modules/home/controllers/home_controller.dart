import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/app/modules/model/WeatherModel.dart';
import 'package:weather_app/app/modules/utils/Util.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  Rx<Coordinates> currentPosition = Coordinates().obs;
  Rx<Coordinates> searchedPosition = Coordinates().obs;
  var query = ''.obs;
  Rx<Address> curAddress = Address().obs;
  Rx<Address> searchedAddress = Address().obs;
  var searchedAdd = ''.obs;

  var home = true.obs;
  var loading = false.obs;

  TextEditingController queryController = TextEditingController();

  Rx<WeatherForecastModel> weatherForecastModel = WeatherForecastModel().obs;

  List<Permission> permission = [
    Permission.location,
    Permission.locationAlways,
  ];

  Future<void> geoCodeCurrentAddress(Coordinates coordinates) async {
    GeoCode geoCode = GeoCode();
    // print('-----$coordinates');

    try {
      Address address = await geoCode.reverseGeocoding(
          latitude: coordinates.latitude!, longitude: coordinates.longitude!);
      // searchedAddress.value = address;
      curAddress.value = address;
      // currentPosition.value = coordinates;
      // print("geoCodeAddress: ${address}");
      // print("geoCodeAddress: ${curAddress.value.city}");
    } catch (e) {
      print(e);
      Get.snackbar('Location Error', e.toString());
    }
  }

  Future<void> getCurrentPosition() async {
    await Geolocator.requestPermission();
    Position curPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    print(curPosition);
    //current address
    await geoCodeCurrentAddress(Coordinates(
        latitude: curPosition.latitude, longitude: curPosition.longitude));

    //set current position
    currentPosition.value = Coordinates(
        latitude: curPosition.latitude, longitude: curPosition.longitude);

    // print(curPosition);
  }

  Future<void> fetchCurrentWeather() async {
    try {
      loading.value = true;
      await getCurrentPosition().then((value) => print('getCurrentPosition'));
      // print(currentPosition);
      var httpResult = await http.get(Uri.parse(Util.baseUrl +
          'lat=${currentPosition.value.latitude}' +
          '&lon=${currentPosition.value.longitude}' +
          '&units=metric&appid=' +
          Util.appId));
      print(httpResult);
      WeatherForecastModel model =
          WeatherForecastModel.fromJson(jsonDecode(httpResult.body));
      // placeName.value = queryController.text.capitalize!;
      home.value = true;
      weatherForecastModel.value = model;
      loading.value = false;
      queryController.clear();

      // print(weatherForecastModel.value.daily![3].humidity);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> geoCode(String address) async {
    GeoCode geoCode = GeoCode();

    try {
      loading.value = true;
      //coordinates from address
      Coordinates coordinates =
          await geoCode.forwardGeocoding(address: address);

      searchedPosition.value = coordinates;

      //get address
      await geoCodeAddress(Coordinates(
              latitude: searchedPosition.value.latitude,
              longitude: searchedPosition.value.longitude))
          .then((value) => home.value = false);
      // print("Latitude: ${coordinates.latitude}");
      // print("Longitude: ${coordinates.longitude}");
    } catch (e) {
      Get.snackbar('Location Error', e.toString());
    }
  }

  Future<void> geoCodeAddress(Coordinates coordinates) async {
    GeoCode geoCode = GeoCode();
    // print('-----$coordinates');

    try {
      Address address = await geoCode.reverseGeocoding(
          latitude: coordinates.latitude!, longitude: coordinates.longitude!);
      // searchedAddress.value = address;
      searchedAddress.value = address;
      // currentPosition.value = coordinates;
      // print("geoCodeAddress: ${address}");
      // print("geoCodeAddress: ${searchedAddress.value.city}");
    } catch (e) {
      Get.snackbar('Location Error', e.toString());
    }
  }

  Future<void> fetchWeather({required String address}) async {
    await geoCode(address);
    // print(searchedPosition);
    var httpResult = await http.get(Uri.parse(Util.baseUrl +
        'lat=${searchedPosition.value.latitude}' +
        '&lon=${searchedPosition.value.longitude}' +
        '&units=metric&appid=' +
        Util.appId));
    WeatherForecastModel model =
        WeatherForecastModel.fromJson(jsonDecode(httpResult.body));
    // placeName.value = queryController.text.capitalize!;
    weatherForecastModel.value = model;
    loading.value = false;
    home.value = false;
    queryController.clear();

    // print(model.daily![3].humidity);
  }

  Future<void> checkPermission() async {
    bool permissionGranted = (await Permission.location.isGranted &&
        await Permission.locationAlways.isGranted);
    print(permissionGranted);

    if (permissionGranted) {
      print('started...');
      await fetchCurrentWeather().then((value) => print('done'));
      // print(permissionGranted);
    } else {
      print('requesting...');

      await permission.request();
      print(permissionGranted);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    // await checkPermission();
    // await getCurrentPosition();

    print('current position: $currentPosition');
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() async {}
}
