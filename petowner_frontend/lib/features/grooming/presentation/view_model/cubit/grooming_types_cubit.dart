import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/grooming/data/repo/grooming_repo_impl.dart';

part 'grooming_types_state.dart';

class GroomingTypesCubit extends Cubit<GroomingTypesState> {
  GroomingTypesCubit(this.groomingRepo) : super(GroomingTypesInitial());

  final GroomingRepoImpl groomingRepo;

  void fetchGroomingTypes(int providerId) async {
    emit(GroomingTypesLoading());
    final types = await groomingRepo.getGroomingTypes(providerId: providerId);
    types.fold((failure) => emit(GroomingTypesError(failure.errorMessage)),
        (types) => emit(GroomingTypesLoaded(types)));
    // emit(GroomingTypesLoaded(types));
  }
}
