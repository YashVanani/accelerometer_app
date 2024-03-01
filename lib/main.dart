import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AccelerometerApp(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // title: 'Flutter Demo',
      // home: const MyHomePage(title: 'Mimi Bow Bow'),
      // ),
    );
  }
}

class AccelerometerApp extends StatefulWidget {
  @override
  _AccelerometerAppState createState() => _AccelerometerAppState();
}

class _AccelerometerAppState extends State<AccelerometerApp> {
  AccelerometerEvent? _accelerometerValues;
  bool _isBraking = false;
  bool _isAccelerating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      accelerometerEvents.listen((AccelerometerEvent event) {
        setState(() {
          _accelerometerValues = event;
          _detectEvents(context);
        });
      });
    });
  }

  String result = '';

  void _detectEvents(context) {
    final double brakingThreshold = -8.0; // Adjust as needed
    final double accelerationThreshold = 8.0; // Adjust as needed

    if (_accelerometerValues!.x < brakingThreshold) {
      _isBraking = true;
      _isAccelerating = false;
    } else if (_accelerometerValues!.x > accelerationThreshold) {
      _isBraking = false;
      _isAccelerating = true;
    } else {
      _isBraking = false;
      _isAccelerating = false;
    }

    if (_isBraking) {
      result = "Harsh Braking Detected";
      setState(() {});
    } else if (_isAccelerating) {
      result = "Harsh Acceleration Detected";
      setState(() {});
    } else {
      result = "";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accelerometer App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'Accelerometer Values:',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'X: ${_accelerometerValues?.x ?? 0}',
                  ),
                  Text(
                    'Y: ${_accelerometerValues?.y ?? 0}',
                  ),
                  Text(
                    'Z: ${_accelerometerValues?.z ?? 0}',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                'result: $result',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
