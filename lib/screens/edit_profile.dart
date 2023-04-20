import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:yiwumart/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:yiwumart/bloc/edit_profile_bloc/edit_repo.dart';
import '../models/date_picker_model.dart';
import '../models/shimmer_model.dart';
import '../util/styles.dart';
import '../util/user.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? selectedGender;
  final _editBloc = EditProfileBloc(editProfileRepo: EditRepo());

  @override
  void initState() {
    super.initState();
    _editBloc.add(LoadEditProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Редактирование'),
      ),
      body: BlocProvider(
         create: (context) => EditProfileBloc(editProfileRepo: EditRepo()),
        child: BlocBuilder<EditProfileBloc, EditProfileState>(
          bloc: _editBloc,
          builder: (context, state) {
            if (state is EditProfileLoading) {
              return buildEditShimmer(context);
            } else if (state is EditProfileLoaded) {
              return buildEdit(state, context);
            } else if (state is EditProfileError) {
              return Center(
                child: Text(state.error.toString()),
              );
            }
            return const Center(
              child: Text('Something went wrong'),
            );
          },
        ),
      ),
    );
  }

  Widget buildEdit(state, context) {
    var selectedGender = state.user.gender == 'Мужчина' ? 'male' : 'female';
    final nameController = TextEditingController(text: state.user.name);
    final surnameController = TextEditingController(text: state.user.surname);
    final bdateController = TextEditingController(text: state.user.bdate);
    final phoneController = TextEditingController(
        text: state.user.phone != null
            ? state.user.phone!.length <= 3
                ? ''
                : state.user.phone!.substring(2)
            : '');
    return ListView(
      padding: REdgeInsets.all(8),
      children: [
        Container(
          padding: REdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).accentColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Имя'.toUpperCase(), style: TextStyles.editStyle),
              const SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  hintText: 'Имя',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Фамилия'.toUpperCase(), style: TextStyles.editStyle),
              const SizedBox(height: 10),
              TextFormField(
                controller: surnameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  hintText: 'Фамилия',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Дата рождения'.toUpperCase(), style: TextStyles.editStyle),
              const SizedBox(height: 10),
              DatePickerModel(
                dateController: bdateController,
              ),
              const SizedBox(height: 20),
              Text('Пол'.toUpperCase(), style: TextStyles.editStyle),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                elevation: 0,
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                value: selectedGender,
                items: const [
                  DropdownMenuItem(
                    value: 'male',
                    child: Text('Мужчина'),
                  ),
                  DropdownMenuItem(
                    value: 'female',
                    child: Text('Женщина'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Номер телефона'.toUpperCase(), style: TextStyles.editStyle),
              const SizedBox(height: 10),
              IntlPhoneField(
                dropdownIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                searchText: 'Выберите страну',
                countries: const [
                  'KZ',
                ],
                initialCountryCode: 'KZ',
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 30.h,
                child: ElevatedButton(
                  onPressed: () {
                    var submitUser = User(
                      name: nameController.text,
                      surname: surnameController.text,
                      bdate: bdateController.text,
                      gender: selectedGender,
                      phoneCode: '7',
                      phone: phoneController.text,
                      id: state.user.id,
                      fullName: state.user.fullName,
                      shortName: state.user.shortName,
                      email: state.user.email,
                      roleName: state.user.roleName,
                    );
                    BlocProvider.of<EditProfileBloc>(context).add(
                        SubmitEditProfile(user: submitUser, context: context));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Сохранить'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 30.h,
                child: ElevatedButton(
                  onPressed: () async {
                _editBloc.add(DeleteAccount(context: context));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Удалить аккаунт'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
