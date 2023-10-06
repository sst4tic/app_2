import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:yiwumart/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:yiwumart/bloc/edit_profile_bloc/edit_repo.dart';
import '../models/date_picker_model.dart';
import '../models/shimmer_model.dart';
import '../util/function_class.dart';
import '../util/styles.dart';
import '../util/user.dart';
import 'change_pass_screen.dart';

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
              selectedGender =
                  state.user.gender == 'Мужчина' ? 'male' : 'female';
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
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Имя'.toUpperCase(), style: TextStyles.editStyle),
              const SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration:
                    InputDecorations(hintText: 'Введите имя').editDecoration,
              ),
              const SizedBox(height: 20),
              Text('Фамилия'.toUpperCase(), style: TextStyles.editStyle),
              const SizedBox(height: 10),
              TextFormField(
                controller: surnameController,
                decoration: InputDecorations(hintText: 'Введите фамилию')
                    .editDecoration,
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
              DropdownButton2(
                underline: Container(),
                onChanged: (value) {
                  selectedGender = value!;
                },
                value: state.user.gender == 'Мужчина' ? 'male' : 'female',
                isExpanded: true,
                buttonStyleData: ButtonStyleData(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).scaffoldBackgroundColor),
                  padding: REdgeInsets.all(8),
                ),
                dropdownStyleData: DropdownStyleData(
                  elevation: 0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
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
              ),
              // DropdownButtonFormField<String>(
              //   elevation: 0,
              //   dropdownColor: Theme.of(context).scaffoldBackgroundColor,
              //   value: state.user.gender == 'Мужчина' ? 'male' : 'female',
              //   items: const [
              //     DropdownMenuItem(
              //       value: 'male',
              //       child: Text('Мужчина'),
              //     ),
              //     DropdownMenuItem(
              //       value: 'female',
              //       child: Text('Женщина'),
              //     ),
              //   ],
              //   onChanged: (value) {
              //     selectedGender = value!;
              //   },
              //   decoration: InputDecorations(hintText: 'Выберите пол')
              //       .editDecoration,
              // ),
              const SizedBox(height: 20),
              Text('Номер телефона'.toUpperCase(), style: TextStyles.editStyle),
              const SizedBox(height: 10),
              IntlPhoneField(
                enabled: false,
                dropdownIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  PhoneInputFormatter(defaultCountryCode: 'KZ')
                ],
                decoration: InputDecorations(hintText: '').editDecoration,
                flagsButtonPadding: REdgeInsets.only(
                  left: 5,
                  top: 0,
                  bottom: 0,
                ),
                flagsButtonMargin:
                    REdgeInsets.only(top: 1, bottom: 1, left: 0.5, right: 5),
                searchText: 'Выберите страну',
                countries: const [
                  'KZ',
                ],
                dropdownIconPosition: IconPosition.trailing,
                disableLengthCheck: true,
                dropdownTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 12.23,
                  fontFamily: 'Noto Sans',
                  fontWeight: FontWeight.w400,
                ),
                initialCountryCode: 'KZ',
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 25.h,
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
                height: 25.h,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePassScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Изменить пароль'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 25.h,
                child: ElevatedButton(
                  onPressed: () async {
                    Func().showDelete(
                        context: context,
                        submitCallback: () {
                          _editBloc.add(DeleteAccount(context: context));
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[900],
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
