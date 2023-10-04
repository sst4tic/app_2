import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yiwumart/bloc/sessions_bloc/sessions_bloc.dart';
import 'package:yiwumart/bloc/sessions_bloc/sessions_repo.dart';
import 'package:yiwumart/models/shimmer_model.dart';
import 'package:yiwumart/util/function_class.dart';
import '../util/styles.dart';

class Sessions extends StatefulWidget {
  const Sessions({Key? key}) : super(key: key);

  @override
  State<Sessions> createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  final SessionsBloc sessionsBloc = SessionsBloc(SessionsRepository());

  @override
  void initState() {
    super.initState();
    sessionsBloc.add(const LoadSessions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Активные устройства'),
        centerTitle: false,
      ),
      body: BlocProvider(
        create: (context) => SessionsBloc(SessionsRepository()),
        child: BlocBuilder<SessionsBloc, SessionsState>(
            bloc: sessionsBloc,
            builder: (context, state) {
              if (state is SessionsInitial || state is SessionsLoading) {
                return buildSessionShimmer(context);
              } else if (state is SessionsLoaded) {
                var items = state.sessions.map((e) => e).toList();
                return buildSessions(items, state.currentSession);
              } else {
                return const Center(
                  child: Text('Error'),
                );
              }
            }),
      ),
    );
  }

  Widget buildSessions(sessions, currentSession) {
    var currentSessionIndex =
        sessions.indexWhere((element) => element.id == currentSession);
    return ListView(
      padding: REdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      children: <Widget>[
        Text('Текущая сессия'.toUpperCase(), style: TextStyles.headerStyle2),
        SizedBox(height: 8.0.h),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: REdgeInsets.only(
                  top: 8.0,
                  left: 8.0,
                  right: 8.0,
                ),
                child: Row(children: [
                  Container(
                    width: 22.5.w,
                    height: 22.5.h,
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Icon(
                      Icons.phone_iphone,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sessions[currentSessionIndex].userAgent,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            sessions[currentSessionIndex].location,
                            style: const TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                          const SizedBox(width: 2.0),
                          const Text('·',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                          const Text(
                            ' в сети',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
              ),
              const SizedBox(height: 8.0),
              const Divider(
                height: 0,
              ),
              SizedBox(
                height: 35,
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      sessionsBloc.add(DestroyAllSessions(context: context));
                    },
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 8.0),
                        Icon(
                          Icons.logout,
                          color: Colors.red,
                          size: 20,
                        ),
                        SizedBox(width: 15.0),
                        Text(
                          'Завершить другие сеансы',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.0.h),
        Text('Выйти на всех устройствах, кроме текущего.',
            style: TextStyles.headerStyle2),
        SizedBox(height: 16.0.h),
        if (sessions.length > 1)
          Text('Другие сеансы'.toUpperCase(), style: TextStyles.headerStyle2),
        SizedBox(height: 8.0.h),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ClipRect(
            clipBehavior: Clip.hardEdge,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Container();
                }
                return const Divider(height: 1);
              },
              itemCount: sessions.length,
              itemBuilder: (BuildContext context, int index) {
                if (sessions[index].id == currentSession) {
                  return Container();
                }
                String deviceName = Func()
                    .getDeviceNameFromUserAgent(sessions[index].userAgent);
                String browserName = Func()
                    .getBrowserNameFromUserAgent(sessions[index].userAgent);
                return Slidable(
                  dragStartBehavior: DragStartBehavior.down,
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.3,
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          sessionsBloc
                              .add(DestroySession(id: sessions[index].id));
                        },
                        label: 'Завершить',
                        backgroundColor: Colors.red,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                      )
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: Row(children: [
                      browserName.isEmpty
                          ? Container(
                              width: 22.5.w,
                              height: 22.5.h,
                              decoration: BoxDecoration(
                                color: Colors.blue[600],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: const Icon(
                                Icons.phone_iphone,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          : Container(
                              width: 22.5.w,
                              height: 22.5.h,
                              decoration: BoxDecoration(
                                color: Colors.blue[600],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: const Icon(
                                Icons.computer,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (deviceName.length <= 2 ||
                                    deviceName.isEmpty &&
                                        browserName.length <= 2 ||
                                    browserName.isEmpty)
                                ? Text(
                                    sessions[index].userAgent,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : Text(
                                    '$deviceName, $browserName',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            Text(sessions[index].location,
                                style: const TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey)),
                            Text(
                              'В сети: ${sessions[index].lastActivity}',
                              style: const TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
