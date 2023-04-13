import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yiwumart/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:yiwumart/bloc/edit_profile_bloc/edit_repo.dart';
import 'package:yiwumart/util/function_class.dart';
import '../authorization/login.dart';
import '../models/date_picker_model.dart';
import '../models/shimmer_model.dart';
import '../util/constants.dart';
import '../util/styles.dart';
import '../util/user.dart';
import 'main_screen.dart';

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
        create: (context) => EditProfileBloc(editProfileRepo: EditRepo())
          ..add(LoadEditProfile()),
        child: BlocBuilder<EditProfileBloc, EditProfileState>(
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
                : state.user.phone!.substring(3)
            : '');
    return ListView(
      padding: REdgeInsets.all(8),
      children: [
        Container(
          padding: REdgeInsets.all(8),
          color: Theme.of(context).accentColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Имя'.toUpperCase(), style: TextStyles.editStyle),
              const SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
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
                dropdownColor: Theme.of(context).primaryColor,
                value: selectedGender,
                items: const [
                  DropdownMenuItem(
                    value: 'male',
                    child: Text('Мужчина'),
                  ),
                  DropdownMenuItem(
                    value: 'female', // unique value
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
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  filled: true,
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
                pickerDialogStyle: PickerDialogStyle(
                  listTileDivider: const Divider(
                    height: 10,
                    color: Colors.grey,
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                searchText: 'Выберите страну',
                countries: const [
                  'KZ',
                  'UZ',
                  'TJ',
                  'KG',
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
                    var resp = await Func().deleteAccount();
                    if (resp['success']) {
                      scakey.currentState?.updateBadgeCount(0);
                      setState(() {
                        Constants.USER_TOKEN = '';
                        Constants.bearer = '';
                        Constants.cookie = '';
                      });
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.remove('login');
                      pref.remove('cookie');
                      Func().getFirebaseToken();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                          (route) => false);
                    } else {
                      Func().showSnackbar(
                          context, resp['message'], resp['success']);
                    }
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
