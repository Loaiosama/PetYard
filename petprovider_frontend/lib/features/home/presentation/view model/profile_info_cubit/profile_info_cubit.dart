import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petprovider_frontend/features/home/data/models/profile_info/profile_info.dart';
import 'package:petprovider_frontend/features/home/data/repo/home_repo_impl.dart';

part 'profile_info_state.dart';

class ProfileInfoCubit extends Cubit<ProfileInfoState> {
  ProfileInfoCubit(this.homeRepoImppl) : super(ProfileInfoInitial());
  final HomeRepoImppl homeRepoImppl;

  Future<void> fetchProviderInfo() async {
    emit(ProfileInfoLoading());
    var result = await homeRepoImppl.fetchProviderInfo();
    result.fold(
        (failue) => emit(ProfileInfoFailure(errorMessage: failue.errorMessage)),
        (profileInfo) => emit(ProfileInfoSuccess(profileInfo: profileInfo)));
  }
}
