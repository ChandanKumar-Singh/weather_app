import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget getWeatherIcon({required String weatherDescription,required Color color,required double size}){
  Icon icon;
  switch(weatherDescription)
  {
    case 'Clear':
      icon =  Icon(FontAwesomeIcons.sun,color: color,size: size);
      break; case 'Clouds':
      icon =  Icon(FontAwesomeIcons.cloud,color: color,size: size);
      break; case 'Rain':
      icon =  Icon(FontAwesomeIcons.cloudRain,color: color,size: size);
      break; case 'Snow':
      icon =  Icon(FontAwesomeIcons.snowman,color: color,size: size);
      break; default:
      icon =  Icon(FontAwesomeIcons.sun,color: color,size: size);
      break;
  }
  // print(icon);
  return icon;
}