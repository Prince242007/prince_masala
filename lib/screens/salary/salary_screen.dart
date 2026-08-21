import 'package:flutter/material.dart';

import 'add_worker_screen.dart';

class SalaryScreen extends StatelessWidget {
  const SalaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('કર્મચારી પગાર'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.people_outline,
                size: 70,
              ),

              const SizedBox(height: 16),

              const Text(
                'હજુ કોઈ કર્મચારી ઉમેરાયો નથી.',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const AddWorkerScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text(
                    'કર્મચારી ઉમેરો',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}