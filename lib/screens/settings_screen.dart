import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safekids/screens/provider/language_provider.dart';
import 'package:safekids/screens/provider/theme_provider.dart';
import '../services/auth_service.dart';
import '../services/auth_services.dart';

// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final languageProvider = Provider.of<LanguageProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Settings'),
//         backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('No new notifications')),
//               );
//             },
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           _buildSettingTile(
//             context,
//             icon: Icons.dark_mode,
//             title: "Dark Mode",
//             trailing: Switch(
//               value: themeProvider.isDarkMode,
//               onChanged: (value) => themeProvider.toggleTheme(),
//             ),
//           ),
//           _buildSettingTile(
//             context,
//             icon: Icons.language,
//             title: "Language",
//             trailing: DropdownButton<String>(
//               value: languageProvider.currentLanguage,
//               items: ["en", "es", "fr"].map((String lang) {
//                 return DropdownMenuItem(value: lang, child: Text(lang.toUpperCase()));
//               }).toList(),
//               onChanged: (String? newLang) {
//                 if (newLang != null) languageProvider.setLocale(newLang);
//               },
//             ),
//           ),
//           _buildSettingTile(
//             context,
//             icon: Icons.settings,
//             title: "Enable/Disable Features",
//             onTap: () {
//               // Navigate to feature settings page
//               Navigator.of(context).pushNamed('/feature-settings');
//             },
//           ),
//           _buildSettingTile(
//             context,
//             icon: Icons.logout,
//             title: "Logout",
//             textColor: Colors.red,
//             onTap: () async {
//               await AuthService().logout();
//               Navigator.of(context).pushReplacementNamed('/login');
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSettingTile(BuildContext context,
//       {required IconData icon,
//         required String title,
//         Widget? trailing,
//         VoidCallback? onTap,
//         Color? textColor}) {
//     return Card(
//       child: ListTile(
//         leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
//         title: Text(title, style: TextStyle(color: textColor ?? Colors.black)),
//         trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: onTap,
//       ),
//     );
//   }
// }

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingTile(
            context,
            icon: Icons.dark_mode,
            title: "Dark Mode",
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),

            // trailing: Switch(
            //   value: themeProvider.isDarkMode,
            //   onChanged: (value) {
            //     setState(() {
            //       themeProvider.toggleTheme();
            //     });
            //   },
            // ),
          ),
          _buildSettingTile(
            context,
            icon: Icons.language,
            title: "Language",
            trailing: DropdownButton<String>(
              value: languageProvider.currentLanguage,
              items: ["en", "es", "fr"].map((String lang) {
                return DropdownMenuItem(value: lang, child: Text(lang.toUpperCase()));
              }).toList(),
              onChanged: (String? newLang) {
                if (newLang != null) {
                  setState(() {
                    languageProvider.setLocale(newLang);
                  });
                }
              },
            ),
          ),
          _buildSettingTile(
            context,
            icon: Icons.settings,
            title: "Enable/Disable Features",
            onTap: () {
              Navigator.of(context).pushNamed('/feature-settings');
            },
          ),
          _buildSettingTile(
            context,
            icon: Icons.logout,
            title: "Logout",
            textColor: Colors.red,
            // onTap: () async {
            //   try {
            //     await AuthService().logout(); // Ensure AuthService.logout() is async
            //     if (mounted) {
            //       Navigator.of(context).pushReplacementNamed('/login');
            //     }
            //   } catch (e) {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(content: Text('Logout failed: $e')),
            //     );
            //   }
            // },
            // onTap: () async {
            //   await Provider.of<AuthService>(context, listen: false).logout();
            //   if (mounted) {
            //     Navigator.of(context).pushReplacementNamed('/login');
            //   }
            // },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        Widget? trailing,
        VoidCallback? onTap,
        Color? textColor,
      }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: TextStyle(color: textColor ?? Colors.black)),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

