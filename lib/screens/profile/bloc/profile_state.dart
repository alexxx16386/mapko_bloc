part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState extends Equatable {
  final UserModel user;
  final ProfileStatus status;
  final Failure failure;

  const ProfileState({
    required this.user,
    required this.failure,
    required this.status,
  });

  factory ProfileState.initial() {
    return ProfileState(
      user: UserModel.empty,
      failure: Failure(),
      status: ProfileStatus.initial,
    );
  }

  @override
  List<Object> get props => [
        failure,
        status,
      ];

  ProfileState copyWith({
    UserModel? user,
    ProfileStatus? status,
    Failure? failure,
  }) {
    return ProfileState(
      user: user ?? this.user,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
