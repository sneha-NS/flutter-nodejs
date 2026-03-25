import 'package:flutter/material.dart';
import '../models/delivery_location.dart';

class LocationListTile extends StatelessWidget {
  final DeliveryLocation location;
  final VoidCallback onTap;

  const LocationListTile({
    super.key,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorScheme.primaryContainer,
        child: Text(
          '${location.id}',
          style: TextStyle(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        location.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(location.address),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
