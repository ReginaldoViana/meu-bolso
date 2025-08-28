import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meu_bolso/viewmodels/expense_view_model.dart';
import 'package:meu_bolso/views/dashboard_view.dart' show DashboardView;
import 'package:meu_bolso/views/expense_list_view.dart' show ExpenseListView;
import 'package:meu_bolso/views/add_expense_view.dart';
import 'package:meu_bolso/views/login_screen.dart';
import 'package:meu_bolso/repositories/income_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('userId');
  final initialRoute = userId != null ? '/home' : '/login';

  final viewModel = ExpenseViewModel();
  final incomeRepo = IncomeRepository();
  await Future.wait([
    viewModel.init(),
    incomeRepo.init(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ExpenseViewModel>(create: (_) => viewModel),
        ChangeNotifierProvider<IncomeRepository>(create: (_) => incomeRepo),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.initialRoute,
  });

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Bolso',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4), // Cor roxa principal
          primary: const Color(0xFF6750A4),
          secondary: const Color(0xFF6750A4),
          background: Colors.white,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6750A4),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.white,
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF6750A4).withOpacity(0.1),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
                color: Color(0xFF6750A4), fontWeight: FontWeight.w500),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

String maskValue(String value, bool shouldMask) {
  if (!shouldMask) return value;
  if (value.contains('R\$')) {
    return 'R\$ ●●●●●';
  }
  return '●●●●●';
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _maskValues = false;

  Future<String> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? 'Dashboard';
  }

  Future<void> _exportToExcel() async {
    try {
      final viewModel = Provider.of<ExpenseViewModel>(context, listen: false);
      final filePath = await viewModel.exportToCsv();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Relatório exportado para: $filePath'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao exportar relatório'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            FutureBuilder<String>(
              future: _getUserName(),
              builder: (context, snapshot) {
                return Text(
                  _selectedIndex == 0
                      ? snapshot.data?.split(' ')[0] ?? 'Dashboard'
                      : 'Contas',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
            const Spacer(),
            IconButton(
              icon: Icon(_maskValues
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
              onPressed: () {
                setState(() {
                  _maskValues = !_maskValues;
                });
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) async {
                if (value == 'export') {
                  _exportToExcel();
                } else if (value == 'logout') {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('userId');
                  if (mounted) {
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'export',
                  child: Row(
                    children: [
                      Icon(Icons.download, size: 20),
                      SizedBox(width: 8),
                      Text('Exportar Relatório'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 20),
                      SizedBox(width: 8),
                      Text('Sair'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
        automaticallyImplyLeading: _selectedIndex != 0,
        leading: _selectedIndex != 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              )
            : null,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _selectedIndex == 0
            ? DashboardView(maskValues: _maskValues)
            : ExpenseListView(maskValues: _maskValues),
      ),
      bottomNavigationBar: NavigationBar(
        height: 65,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Contas',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddExpenseView(),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
