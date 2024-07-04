import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:petprovider_frontend/features/pet%20profile/data/repo/owner_repo.dart';
import 'package:petprovider_frontend/features/pet%20profile/data/model/owner.dart';

import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/pet%20profile/presentation/view%20model/onwer_info_states.dart';

class OwnerInfoCubit extends Cubit<OwnerInfoState> {
  final OwnerRepo ownerRepo;

  OwnerInfoCubit(this.ownerRepo) : super(OwnerInfoInitial());

  Future<void> fetchOwnerInfo(int ownerId) async {
    emit(OwnerInfoLoading());

    var result = await ownerRepo.fetchOwnerInfo(ownerId);

    result.fold(
      (failure) => emit(OwnerInfoFailure(failure.errorMessage)),
      (owner) => emit(OwnerInfoSuccess(owner)),
    );
  }
}
