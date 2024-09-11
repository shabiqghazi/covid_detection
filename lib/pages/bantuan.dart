import 'package:flutter/material.dart';

class Bantuan extends StatelessWidget {
  const Bantuan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green[600],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Rumah Sakit 1'),
                subtitle: const Text('Jl Gayo 2'),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.local_hospital,
                    size: 30,
                    color: Colors.pink,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Rumah Sakit 2'),
                subtitle: const Text('Jl Babakan Dangdeur'),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.local_hospital,
                    size: 30,
                    color: Colors.pink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
