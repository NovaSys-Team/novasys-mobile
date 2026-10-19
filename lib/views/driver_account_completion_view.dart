import 'package:flutter/material.dart';

/// Temporary destination until the Driver account completion design is built.
class DriverAccountCompletionView extends StatelessWidget {
  const DriverAccountCompletionView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Complete account')),
    body: const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Text(
          'Driver account completion — pending implementation.\n\n'
          'This demo does not complete your account or unlock trips, requests or earnings.',
        ),
      ),
    ),
  );
}
