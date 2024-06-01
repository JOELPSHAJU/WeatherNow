import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/bloc/whether_bloc/weather_bloc_bloc.dart';
import 'package:weatherapp/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            fontFamily: GoogleFonts.roboto().fontFamily,
            textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                bodyMedium:
                    TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                bodySmall:
                    TextStyle(color: Color.fromARGB(255, 255, 255, 255)))),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
            future: _determinePosition(),
            builder: (context, snap) {
              if (snap.hasData) {
                return BlocProvider<WeatherBlocBloc>(
                  create: (context) => WeatherBlocBloc()
                    ..add(FetchWeather(snap.data as Position)),
                  child: const HomeScreen(),
                );
              } else {
                return const Scaffold(
                  backgroundColor: Colors.black,
                  body: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                );
              }
            }));
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
   
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
    
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
  
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }


  return await Geolocator.getCurrentPosition();
}
