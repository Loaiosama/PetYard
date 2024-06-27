import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/core/widgets/search_text_field.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/models/pet_breed.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/models/pet_model.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/widgets/linear_percent_indecator.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/widgets/pet_type_bar.dart';

class PetBreedScreen extends StatefulWidget {
  final PetModel petModel;
  const PetBreedScreen({
    super.key,
    required this.petModel,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PetBreedScreenState createState() => _PetBreedScreenState();
}

class _PetBreedScreenState extends State<PetBreedScreen> {
  List<String> filteredBreeds = catBreed;

  void filterBreeds(String query) {
    setState(() {
      filteredBreeds = catBreed
          .where((breed) => breed.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void validateAndNavigate() {
    if (widget.petModel.breed == null || widget.petModel.breed!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a breed.'),
        ),
      );
    } else {
      context.pushNamed(Routes.kAddPetInfo, extra: widget.petModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PetTypeBar(
              step: '2',
              subtitle: 'Breed',
            ),
            heightSizedBox(10),
            const LinearIndicator(
              percent: 0.4,
            ),
            heightSizedBox(10),
            Column(
              children: [
                SearchTextField(
                  onChanged: filterBreeds,
                ),
              ],
            ),
            heightSizedBox(10),
            Expanded(
              child: BreedNameListView(
                petModel: widget.petModel,
                filteredBreeds: filteredBreeds,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 20.0.w, right: 20.0.w, bottom: 20.0.h),
              child: PetYardTextButton(
                onPressed: validateAndNavigate,
                style: Styles.styles14NormalBlack.copyWith(color: Colors.white),
                height: 50.h,
                text: 'Continue',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BreedNameListView extends StatefulWidget {
  final PetModel petModel;
  final List<String> filteredBreeds;
  const BreedNameListView({
    super.key,
    required this.petModel,
    required this.filteredBreeds,
  });

  @override
  State<BreedNameListView> createState() => _BreedNameListViewState();
}

class _BreedNameListViewState extends State<BreedNameListView> {
  int selectedIndex = -1;

  void handleSelection(int index) {
    setState(() {
      selectedIndex = index;
      widget.petModel.breed = widget.filteredBreeds[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.filteredBreeds.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return BreedNameItem(
          onTap: () {
            handleSelection(index);
          },
          index: index,
          isSelected: index == selectedIndex,
          breedName: widget.filteredBreeds[index],
        );
      },
    );
  }
}

class BreedNameItem extends StatelessWidget {
  final bool isSelected;
  final void Function()? onTap;
  final int index;
  final String breedName;
  const BreedNameItem({
    super.key,
    required this.isSelected,
    this.onTap,
    required this.index,
    required this.breedName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightSizedBox(10),
          InkWell(
            onTap: onTap,
            splashColor: kPrimaryGreen.withOpacity(0.3),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    breedName,
                    style: Styles.styles14NormalBlack.copyWith(),
                  ),
                  isSelected ? const Icon(Icons.check) : Container(),
                ],
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
