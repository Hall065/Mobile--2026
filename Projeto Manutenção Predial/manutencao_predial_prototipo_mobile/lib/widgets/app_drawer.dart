import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'common_widgets.dart';

class AppDrawer extends StatelessWidget {
  final int currentIndex;
  final String? userName;

  const AppDrawer({super.key, required this.currentIndex, this.userName});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.divider, width: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SenaiLogo(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            (userName?.isNotEmpty == true)
                                ? userName![0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName ?? 'Usuário',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'Manutenção Predial',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Menu items
            _DrawerItem(
              icon: Icons.dashboard_outlined,
              iconActive: Icons.dashboard,
              label: 'Dashboard',
              isActive: currentIndex == 0,
              onTap: () {
                Navigator.pop(context);
                if (currentIndex != 0) {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                }
              },
            ),
            _DrawerItem(
              icon: Icons.assignment_outlined,
              iconActive: Icons.assignment,
              label: 'Chamados',
              isActive: currentIndex == 1,
              onTap: () {
                Navigator.pop(context);
                if (currentIndex != 1) {
                  Navigator.pushReplacementNamed(context, '/chamados');
                }
              },
            ),
            _DrawerItem(
              icon: Icons.task_alt_outlined,
              iconActive: Icons.task_alt,
              label: 'Tarefas',
              isActive: currentIndex == 2,
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.send_outlined,
              iconActive: Icons.send,
              label: 'Solicitações',
              isActive: currentIndex == 3,
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.engineering_outlined,
              iconActive: Icons.engineering,
              label: 'Técnicos',
              isActive: currentIndex == 4,
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.inventory_2_outlined,
              iconActive: Icons.inventory_2,
              label: 'Estoque',
              isActive: currentIndex == 5,
              onTap: () {
                Navigator.pop(context);
                if (currentIndex != 5) {
                  Navigator.pushReplacementNamed(context, '/estoque');
                }
              },
            ),
            const Spacer(),
            const Divider(height: 1),
            _DrawerItem(
              icon: Icons.logout,
              iconActive: Icons.logout,
              label: 'Sair',
              isActive: false,
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final IconData iconActive;
  final String label;
  final bool isActive;
  final bool isDestructive;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.iconActive,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? AppColors.primary
        : isActive
            ? AppColors.primary
            : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(isActive ? iconActive : icon, color: color, size: 22),
        title: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}
