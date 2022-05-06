import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:geocoder/geocoder.dart';

import 'package:get/get.dart';
import 'package:weather_app/app/modules/model/WeatherModel.dart';
import 'package:weather_app/app/modules/utils/Util.dart';
import 'package:weather_app/app/modules/utils/convertIcons.dart';

import '../controllers/home_controller.dart';

class WeatherForcast extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // print(controller.weatherForecastModel.value.daily!.map((e) => e.dt));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              placeSearchBar(),
              // TypeAheadField(
              //   textFieldConfiguration: TextFieldConfiguration(
              //       autofocus: true,
              //       style: DefaultTextStyle.of(context).style.copyWith(
              //           fontStyle: FontStyle.italic
              //       ),
              //       decoration: InputDecoration(
              //           border: OutlineInputBorder()
              //       )
              //   ),
              //   suggestionsCallback: (pattern) async {
              //     return await controller.getSuggestions(pattern);
              //   },
              //   itemBuilder: (context, Address? suggestion) {
              //     return ListTile(
              //       leading: Icon(Icons.shopping_cart),
              //       title: Text(suggestion.featureName),
              //       subtitle: Text('\$${suggestion.coordinates}'),
              //     );
              //   },
              //   onSuggestionSelected: (suggestion) {
              //     controller.fetchWeather(address: suggestion.toString());
              //   },
              // ),
              Expanded(
                child: Obx(() {
                  if (!controller.loading.value) {
                    if (controller.weatherForecastModel.value.lat != null) {
                      WeatherForecastModel model =
                          controller.weatherForecastModel.value;
                      print(controller.weatherForecastModel.value.lat);
                      // print(model.daily!.map((e) => (e.dt)));
                      print(model.current!.temp.toString());
                      return Column(
                        children: [
                          SizedBox(height: Get.height * 0.02),
                          Text(
                            controller.home.value
                                ? '${controller.curAddress.value.city.toString()},${controller.curAddress.value.countryCode.toString()}'
                                : '${controller.searchedAddress.value.city.toString()},${controller.searchedAddress.value.countryCode.toString()}',
                            style: TextStyle(
                                fontSize: Get.width * 0.07,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(Util.getFormateDate(
                              DateTime.fromMillisecondsSinceEpoch(
                                  model.current!.dt * 1000))),
                          SizedBox(
                            height: Get.height * 0.04,
                          ),
                          getWeatherIcon(
                              weatherDescription: model
                                  .daily!.last.weather!.first.main
                                  .toString(),
                              color: Colors.pink,
                              size: Get.width * 0.5),
                          SizedBox(height: Get.height * 0.03),
                          Row(
                            children: [
                              Text(
                                model.current!.temp.toString() + ' °C',
                                style: TextStyle(
                                    fontSize: Get.width * 0.08,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: Get.width * 0.05,
                              ),
                              Text(
                                model.current!.weather!.first.description
                                    .toString()
                                    .capitalize!,
                                style: TextStyle(
                                    fontSize: Get.width * 0.05,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Get.height * 0.03),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      model.current!.windSpeed.toString() +
                                          ' m/s',
                                      style: TextStyle(
                                          fontSize: Get.width * 0.04,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Icon(Icons.air)
                                  ],
                                ),
                                SizedBox(
                                  width: Get.width * 0.05,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      model.current!.humidity.toString() + ' %',
                                      style: TextStyle(
                                          fontSize: Get.width * 0.04,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Icon(Icons.emoji_emotions_rounded)
                                  ],
                                ),
                                SizedBox(
                                  width: Get.width * 0.05,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      model.current!.temp.toString() + ' °C',
                                      style: TextStyle(
                                          fontSize: Get.width * 0.04,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Icon(Icons.thermostat_rounded)
                                  ],
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                          Container(
                            height: Get.height * 0.25,
                            child: Column(

                              children: [
                                Text(
                                  '7-Day Weather Forecast',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.grey),
                                ),
                                SizedBox(
                                  height: Get.height * 0.01,
                                ),
                                Expanded(
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: model.daily!.length,
                                      separatorBuilder: (context, i) =>
                                          SizedBox(
                                            width: 10,
                                          ),
                                      itemBuilder: (context, i) {
                                        Daily daily = model.daily![i];
                                        return Container(
                                          width: Get.width * 0.4,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Get.width * 0.05),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xff9661C3),
                                                Colors.white
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,

                                            children: [
                                              Text(Util.getFormatedDay(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      daily.dt * 1000))),
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    child: getWeatherIcon(
                                                        weatherDescription:
                                                            daily.weather!.first
                                                                .main!,
                                                        color: Colors.pink,
                                                        size: Get.width * 0.05),
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Icon(
                                                            Icons.air,
                                                            color: Colors.brown,
                                                          ),
                                                          Text(daily.windSpeed
                                                                  .toString() +
                                                              ' m/s'),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .cloud,
                                                            color: Colors.brown,
                                                          ),
                                                          SizedBox(width: 10,),
                                                          Text(daily.humidity
                                                                  .toString() +
                                                              ' °C'),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .thermostat_rounded,
                                                            color: Colors.brown,
                                                          ),
                                                          Text(daily.temp!.day
                                                                  .toString() +
                                                              ' %'),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ],

                            ),
                          ),
                        ],
                      );
                    }

                    return Center(child: CircularProgressIndicator());
                  }
                  return Center(child: CircularProgressIndicator());
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container placeSearchBar() {
    return Container(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.queryController,
              decoration: InputDecoration(
                hintText: 'Search Your Place',
                prefixIcon: Icon(
                  Icons.location_on_rounded,
                  color: Colors.pink,
                ),
                suffixIcon: InkWell(
                  onTap: () {
                    controller.fetchCurrentWeather();
                    print('go Home');
                  },
                  splashColor: Colors.pink,
                  borderRadius: BorderRadius.circular(30),
                  child: Icon(
                    Icons.home,
                    color: Colors.purple,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 3.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.purple,
                    width: 3.0,
                  ),
                ),
              ),
              onSubmitted: (val) {
                if (val.isNotEmpty) {
                  controller.fetchWeather(address: val);
                }
              },
              onChanged: (val) {
                controller.query.value = val;
              },
            ),
          ),
          IconButton(
            onPressed: () {
              if (controller.query.value != '') {
                controller.fetchWeather(address: controller.query.value);
              }
              // controller.fetchWeather();
            },
            icon: Icon(
              Icons.search,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
