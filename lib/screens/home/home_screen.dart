import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supply_mate/models/user_model.dart';
import 'package:supply_mate/widgets/peer_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _mapController;
  final LatLng _initialPosition = const LatLng(37.7749, -122.4194); // Default to San Francisco
  final Set<Marker> _markers = {};
  final List<User> _nearbyPeers = [];

  @override
  void initState() {
    super.initState();
    _loadNearbyPeers();
  }

  Future<void> _loadNearbyPeers() async {
    // TODO: Implement actual peer loading from Firestore
    setState(() {
      _nearbyPeers.addAll([
        User(
          id: '1',
          name: 'Alex Johnson',
          subjects: ['Math', 'Physics'],
          location: const LatLng(37.7750, -122.4184),
          profileImageUrl: 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg',
        ),
        User(
          id: '2', 
          name: 'Sam Wilson',
          subjects: ['Chemistry', 'Biology'],
          location: const LatLng(37.7760, -122.4204),
          profileImageUrl: 'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
        ),
      ]);

      for (final peer in _nearbyPeers) {
        _markers.add(
          Marker(
            markerId: MarkerId(peer.id),
            position: peer.location,
            infoWindow: InfoWindow(title: peer.name),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Study Partners'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: Navigate to profile screen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14.0,
              ),
              markers: _markers,
              onMapCreated: (controller) => _mapController = controller,
              myLocationEnabled: true,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _nearbyPeers.length,
              itemBuilder: (context, index) {
                return PeerCard(
                  user: _nearbyPeers[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(peer: _nearbyPeers[index]),
                      ),
                    );
                  },
                  onMeetupRequest: () {
                    _suggestMeetup(_nearbyPeers[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _suggestMeetup(User peer) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Suggest Meetup with ${peer.name}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const Text('Select meeting place:'),
              // TODO: Will implement Google Places integration next
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Meetup request sent to ${peer.name}')),
                  );
                },
                child: const Text('Send Meetup Request'),
              ),
            ],
          ),
        );
      },
    );
  }
}
