import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yiwumart/bloc/sessions_bloc/sessions_bloc.dart';
import 'package:yiwumart/bloc/sessions_bloc/sessions_repo.dart';
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
        title: const Text('Сессии'),
        centerTitle: false,
      ),
      body: BlocProvider(
        create: (context) => SessionsBloc(SessionsRepository()),
        child: BlocBuilder<SessionsBloc, SessionsState>(
            bloc: sessionsBloc,
            builder: (context, state) {
              if (state is SessionsInitial || state is SessionsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
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
        Text('Текущая сессия', style: TextStyles.headerStyle),
        SizedBox(height: 8.0.h),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: REdgeInsets.only(
                  top: 8.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Row(children: [
                  const Icon(
                    Icons.phone_iphone,
                    size: 35,
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sessions[currentSessionIndex].userAgent,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Last activity: ${sessions[currentSessionIndex].lastActivity}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.0,
                        ),
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
                    sessionsBloc.add(const DestroyAllSessions());
                  },
                  child: const Text(
                    'Завершить другие сеансы',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.0.h),
        if (sessions.length > 1)
          Text('Другие сеансы', style: TextStyles.headerStyle),
        SizedBox(height: 8.0.h),
        Column(
          children: List.generate(
            sessions.length,
            (index) {
              if (sessions[index].id == currentSession) {
                return Container();
              }
              String deviceName =
                  Func().getDeviceNameFromUserAgent(sessions[index].userAgent);
              String browserName =
                  Func().getBrowserNameFromUserAgent(sessions[index].userAgent);
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
                    )
                  ],
                ),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[300]!)),
                    ),
                    child: Row(
                      children: [
                        deviceName == 'Android' || deviceName == 'iPhone'
                            ? const Icon(Icons.phone_iphone, size: 35)
                            : const Icon(Icons.computer, size: 35),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$deviceName, $browserName',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Last activity: ${sessions[index].lastActivity}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              );
            },
          ),
        ),
      ],
    );
  }
}
