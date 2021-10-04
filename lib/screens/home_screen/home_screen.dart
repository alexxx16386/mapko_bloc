import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mapko_bloc/blocs/auth/auth_bloc.dart';
import 'package:mapko_bloc/repositories/repositories.dart';
import 'package:mapko_bloc/widgets/widgets.dart';

import 'bloc/home_bloc.dart';
import 'components/components.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/home';
  static Route route() {
    return MaterialPageRoute(
      builder: (context) => BlocProvider<HomeBloc>(
        create: (_) => HomeBloc(
          locationRepository: context.read<LocationRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..add(
            HomeLoad(),
          ),
        child: HomeScreen(),
      ),
    );
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamController<double> _centerCurrentLocationStreamController;
  late MapController _mapController;

  @override
  void initState() {
    _centerCurrentLocationStreamController = StreamController<double>();
    _mapController = MapController();
    super.initState();
  }

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.status == HomeStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              content: state.failure.message,
              title: '',
            ),
          );
        }
        if (state.status == HomeStatus.currentPositionLoaded) {
          context.read<HomeBloc>().add(HomeChangeMyLocation());
        }
        if (state.status == HomeStatus.setMarker) {
          _mapController.move(state.markerLocation, 12);
        }
        if (state.status == HomeStatus.returnLoc) {
          _centerCurrentLocationStreamController.add(12);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Map(
                centerCurrentLocationStreamController:
                    _centerCurrentLocationStreamController,
                mapController: _mapController,
                markerLocation: state.markerLocation,
                places: state.places,
              ),
              CustomAppBar(
                locationName: state.location.name,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Center the location marker on the map and zoom the map to level 18.
              context.read<HomeBloc>().add(HomeChangeMyLocation());
            },
            child: Icon(
              Icons.my_location,
            ),
          ),
        );
      },
    );
  }
}
