import 'package:flutter/material.dart';
import 'package:supply_mate/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PeerCard extends StatelessWidget {
  final User user;
  final VoidCallback onTap;
  final VoidCallback onMeetupRequest;

  const PeerCard({
    super.key,
    required this.user,
    required this.onTap,
    required this.onMeetupRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: CachedNetworkImageProvider(user.profileImageUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.getSubjectsString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: onTap,
              tooltip: 'Start Chat',
            ),
            IconButton(
              icon: const Icon(Icons.place),
              onPressed: onMeetupRequest,
              tooltip: 'Suggest Meetup',
            ),
          ],
        ),
      ),
    );
  }
}