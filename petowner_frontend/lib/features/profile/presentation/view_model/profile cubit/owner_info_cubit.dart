import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/profile/data/model/owner_info/owner_info.dart';
import 'package:petowner_frontend/features/profile/data/repo/profile_repo.dart';

part 'owner_info_state.dart';

class OwnerInfoCubit extends Cubit<OwnerInfoState> {
  OwnerInfoCubit(this.profileRepo) : super(OwnerInfoInitial());
  final ProfileRepo profileRepo;

  final OwnerInfo ownerInfo = const OwnerInfo();

  Future<void> getOwnerInfo() async {
    emit(OwnerInfoLoading());
    var result = await profileRepo.getOwnerInfo();
    result.fold(
      (failure) => emit(OwnerInfoFailure(errorMessage: failure.toString())),
      (ownerInfo) => emit(
        OwnerInfoSuccess(ownerInfo: ownerInfo),
      ),
    );
  }
}
