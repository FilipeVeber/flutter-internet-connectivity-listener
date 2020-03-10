import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:network_connection_listener/NetworkProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text("Network connectivity listener"),
      ),
      body: Provider<NetworkProvider>(
        create: (context) => NetworkProvider(),
        child: Consumer<NetworkProvider>(
          builder: (context, value, _) {
            return Center(
              child: NetworkWidget(networkProvider: value),
            );
          },
        ),
      ),
    ),
  ));
}

class NetworkWidget extends StatefulWidget {
  final NetworkProvider networkProvider;

  NetworkWidget({@required this.networkProvider});

  @override
  _NetworkWidgetState createState() => _NetworkWidgetState();
}

class _NetworkWidgetState extends State<NetworkWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityResult>.value(
      value: widget.networkProvider.networkStatusController.stream,
      child: Consumer<ConnectivityResult>(
        builder: (context, value, _) {
          switch (value) {
            case ConnectivityResult.wifi:
              return Text("You're connected over WIFI");
            case ConnectivityResult.mobile:
              return Text("You're connected over mobile network");
            default:
              return Text("You're offline");
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.networkProvider.disposeStreams();
    super.dispose();
  }
}
