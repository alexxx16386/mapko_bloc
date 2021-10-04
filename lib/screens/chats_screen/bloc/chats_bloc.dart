import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:mapko_bloc/models/models.dart';
import 'package:mapko_bloc/repositories/repositories.dart';
import 'package:mapko_bloc/repositories/token/token_repository.dart';
import 'package:meta/meta.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatRepository _chatRepository;
  final LocationRepository _locationRepository;

  ChatsBloc({
    required ChatRepository chatRepository,
    required LocationRepository locationRepository,
  })  : _chatRepository = chatRepository,
        _locationRepository = locationRepository,
        super(ChatsState.initial());

  @override
  Stream<ChatsState> mapEventToState(
    ChatsEvent event,
  ) async* {
    if (event is ChatsUpdateList) {
      yield* _mapChatsUpdateListToState(event);
    }
  }

  Stream<ChatsState> _mapChatsUpdateListToState(ChatsUpdateList event) async* {
    yield state.copyWith(status: ChatsStatus.loading);

    try {
      LatLng location =
          _locationRepository.getMyLocation ?? await _getLocation();
      City city = await _locationRepository.getLocationInfo(
        location: location,
      );
      List<Chat> chats = await _chatRepository.getChatsByCityId(
        id: city.id,
      );
      yield state.copyWith(status: ChatsStatus.loaded, chats: chats);
    } catch (e) {
      yield state.copyWith(
        status: ChatsStatus.error,
        failure: Failure(message: 'error'),
      );
    }
  }

  Future<LatLng> _getLocation() async {
    final position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }
}
