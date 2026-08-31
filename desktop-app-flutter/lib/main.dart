import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api/api_client.dart';
import 'api/project_api.dart';
import 'app/app_shell.dart';
import 'state/project_store.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const HatchwayApp());
}

class HatchwayApp extends StatelessWidget {
  const HatchwayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ProjectApi>(create: (_) => ProjectApi(buildDio())),
        ChangeNotifierProxyProvider<ProjectApi, ProjectStore>(
          create: (context) => ProjectStore(context.read<ProjectApi>())..fetchProjects(),
          update: (context, api, previous) => previous ?? (ProjectStore(api)..fetchProjects()),
        ),
      ],
      child: MaterialApp(
        title: 'Hatchway',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const AppShell(),
      ),
    );
  }
}
