import 'package:flutter/material.dart';
import '../models/project.dart';
import '../screens/dashboard_screen.dart';
import '../screens/project_detail_screen.dart';
import 'sidebar_nav.dart';

/// Shell persistente: el sidebar nunca se desmonta al entrar/salir del
/// detalle de un proyecto — solo el panel derecho cambia entre la galería
/// y la vista de detalle, tal como se definió en los wireframes.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _showingDetail = false;
  Project? _detailProject;

  void _openDetail(Project? project) {
    setState(() {
      _detailProject = project;
      _showingDetail = true;
    });
  }

  void _closeDetail() {
    setState(() {
      _showingDetail = false;
      _detailProject = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SidebarNav(),
          Expanded(
            child: _showingDetail
                ? ProjectDetailScreen(initial: _detailProject, onBack: _closeDetail)
                : DashboardScreen(onOpenProject: _openDetail),
          ),
        ],
      ),
    );
  }
}
