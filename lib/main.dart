// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  var maxtemp,
      mintemp,
      curtemp,
      feeltemp,
      city,
      description,
      windspeed,
      humidity;
  Future featchWeather({required place}) async {
    const apikey = 'Your API Key';
    var url =
        'https://api.openweathermap.org/data/2.5/weather?q=$place&units=metric&appid=$apikey';
    var finalURL = Uri.parse(url);
    var response = await http.get(finalURL);
    var json = jsonDecode(response.body);
    setState(() {
      description = json['weather'][0]['description'];
      maxtemp = json['main']['temp_max'];
      mintemp = json['main']['temp_min'];
      curtemp = json['main']['temp'];
      feeltemp = json['main']['feels_like'];
      city = json['name'].toString().toUpperCase();
      windspeed = json['wind']['speed'];
      humidity = json['main']['humidity'];
    });
  }

  @override
  void initState() {
    super.initState();
    featchWeather(place: 'Indore');
  }

  var tf = TextEditingController();
  var valid = true;
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: _size.height * .05,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (String city) {
                featchWeather(place: city);
              },
              controller: tf,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),hintText: 'Search a city'),
                    
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MaxMinTemp(
                  temp: maxtemp != null ? maxtemp.round().toString() : '...',
                  icon: const Icon(Icons.arrow_upward),
                ),
                MaxMinTemp(
                  temp: mintemp != null ? mintemp.round().toString() : '...',
                  icon: const Icon(Icons.arrow_downward),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              curtemp != null ? '${curtemp.round().toString()}°C' : '...',
              style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 60),
            ),
          ),
          Text(
              'Feels like ${feeltemp != null ? feeltemp.round().toString() + '°C' : '...'}'),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              city != null ? city.toString() : '...',
              style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 40),
            ),
          ),
          
          Expanded(
            child: ListView(
              children: <Widget>[
                WeatherListTile(
                  leading: const FaIcon(
                    FontAwesomeIcons.info,
                    color: Colors.teal,
                  ),
                  heading: 'Description',
                  trailing:
                      description != null ? description.toString() : '...',
                ),
                WeatherListTile(
                  leading:
                      const FaIcon(FontAwesomeIcons.wind, color: Colors.teal),
                  heading: 'Wind Speed',
                  trailing: windspeed != null
                      ? (windspeed*3.6).round().toString() + ' KM/H'
                      : '...',
                ),
                WeatherListTile(
                  leading: const FaIcon(FontAwesomeIcons.droplet,
                      color: Colors.teal),
                  heading: 'Humidity',
                  trailing:
                      humidity != null ? humidity.toString() + ' %' : '...',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
            child: Text('Made with ❤ by GDSC Acropolis.',style: TextStyle(fontSize: 20),),
          ),
          
        ],
      ),
    );
  }
}

class WeatherListTile extends StatelessWidget {
  const WeatherListTile(
      {Key? key,
      required this.leading,
      required this.heading,
      required this.trailing})
      : super(key: key);
  final FaIcon leading;
  final String heading, trailing;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            leading,
          ],
        ),
        title: Text(
          heading,
          style: const TextStyle(fontSize: 20, color: Colors.teal),
        ),
        trailing: Text(
          trailing,
          style: const TextStyle(fontSize: 20, color: Colors.teal),
        ),
      ),
    );
  }
}

class MaxMinTemp extends StatelessWidget {
  const MaxMinTemp({
    required this.temp,
    required this.icon,
    Key? key,
  }) : super(key: key);
  final String temp;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$temp °C'),
        icon,
      ],
    );
  }
}
