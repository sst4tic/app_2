import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yiwumart/bloc/sessions_bloc/sessions_bloc.dart';
import 'package:yiwumart/bloc/sessions_bloc/sessions_repo.dart';

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
        title: const Text('Sessions'),
        centerTitle: false,
      ),
      body: BlocProvider(
        create: (context) => SessionsBloc(SessionsRepository()),
        child: BlocBuilder<SessionsBloc, SessionsState>(
          bloc: sessionsBloc,
          builder: (context, state) {
            print(state);
            if(
              state is SessionsInitial ||
              state is SessionsLoading
            ) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if(state is SessionsLoaded) {
              var items = state.sessions.map((e) => e).toList();
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.sessions[index].ipAddress.toString()),
                    subtitle: Text(state.sessions[0].lastActivity.toString()),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('Error'),
              );
          }}),
        ),
    );
  }
}
