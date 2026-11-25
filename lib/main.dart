import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const MyApp());

final Map<String, String> usuarios = {
  'sebastian@correo.com': '123456',
  'maria@correo.com': 'abcdef',
  'carlos@correo.com': 'qwerty1',
};

final Map<String, String> nombres = {
  'sebastian@correo.com': 'Sebastián',
  'maria@correo.com': 'María',
  'carlos@correo.com': 'Carlos',
};

String? usuarioActual;

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final logueado = usuarioActual != null;
    final enLogin = state.matchedLocation == '/login';
    if (!logueado && !enLogin) return '/login';
    if (logueado && enLogin) return '/dashboard';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/dashboard', builder: (context, state) => const DashboardPage()),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nova app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6654F1),
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
      ),
      routerConfig: _router,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _oculta = true;
  bool _recordarme = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final pass = _passController.text;

    if (usuarios[email] == pass) {
      usuarioActual = email;
      context.go('/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF252A3A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Text('Usuario o contraseña incorrectos'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE9E8FF), Color(0xFFF8F9FC), Color(0xFFF0EFFF)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: Card(
                elevation: 14,
                shadowColor: const Color(0x225F50D8),
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (MediaQuery.sizeOf(context).width >= 760)
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.all(48),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF7161F4), Color(0xFF4D3CC7)],
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.auto_awesome_rounded, size: 42, color: Colors.white),
                                SizedBox(height: 24),
                                Text('Tu espacio\npersonal', style: TextStyle(color: Colors.white, fontSize: 42, height: 1.05, fontWeight: FontWeight.w800)),
                                SizedBox(height: 16),
                                Text('Organiza tu actividad y consulta tu progreso desde un solo lugar.', style: TextStyle(color: Color(0xFFE9E7FF), fontSize: 17, height: 1.5)),
                              ],
                            ),
                          ),
                        ),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 48),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const NovaLogo(),
                                const SizedBox(height: 20),
                                const Text('Bienvenido', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Color(0xFF24263A))),
                                const SizedBox(height: 6),
                                const Text('Ingresa tus datos para continuar', style: TextStyle(color: Color(0xFF7D8196), fontSize: 15)),
                                const SizedBox(height: 30),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Correo electrónico',
                                    prefixIcon: const Icon(Icons.email_outlined),
                                    filled: true,
                                    fillColor: const Color(0xFFF8F8FB),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) return 'Ingresa tu correo';
                                    if (!value.contains('@')) return 'Correo no válido';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _passController,
                                  obscureText: _oculta,
                                  onFieldSubmitted: (_) => _login(),
                                  decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                                    filled: true,
                                    fillColor: const Color(0xFFF8F8FB),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                                    suffixIcon: IconButton(
                                      icon: Icon(_oculta ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                      onPressed: () => setState(() => _oculta = !_oculta),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Ingresa tu contraseña';
                                    if (value.length < 6) return 'Mínimo 6 caracteres';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _recordarme,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      onChanged: (value) => setState(() => _recordarme = value ?? false),
                                    ),
                                    const Text('Recordarme'),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF6654F1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                    onPressed: _login,
                                    child: const Text('Iniciar sesión', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NovaLogo extends StatelessWidget {
  const NovaLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 18, vertical: compact ? 8 : 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E8FF),
        borderRadius: BorderRadius.circular(compact ? 12 : 16),
      ),
      child: Text(
        'Nova app',
        style: TextStyle(
          fontSize: compact ? 18 : 22,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF6654F1),
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<void> _logout(BuildContext context) async {
    final email = usuarioActual ?? '';
    final nombre = nombres[email] ?? 'Usuario';

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.logout_rounded, color: Color(0xFF6654F1)),
        title: const Text('Cerrar sesión'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Quieres cerrar la sesión de $nombre?'),
            const SizedBox(height: 16),
            const Text('Usuario autenticado', style: TextStyle(fontSize: 12, color: Color(0xFF9296A8))),
            const SizedBox(height: 4),
            Text(nombre, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(email, style: const TextStyle(color: Color(0xFF55596F))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Cerrar sesión')),
        ],
      ),
    );

    if (confirmar == true) {
      usuarioActual = null;
      if (context.mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = usuarioActual ?? '';
    final nombre = nombres[email] ?? 'Usuario';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const NovaLogo(compact: true),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: PopupMenuButton<String>(
              tooltip: 'Opciones de usuario',
              onSelected: (value) {
                if (value == 'logout') _logout(context);
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nombre, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF24263A))),
                      const SizedBox(height: 3),
                      Text(email, style: const TextStyle(fontSize: 12, color: Color(0xFF9296A8))),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(children: [Icon(Icons.logout_rounded, color: Color(0xFFE05D66)), SizedBox(width: 10), Text('Cerrar sesión', style: TextStyle(color: Color(0xFFE05D66)))]),
                ),
              ],
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://i.pravatar.cc/100?u=$email'),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('¡Hola, $nombre!', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Color(0xFF24263A))),
          const SizedBox(height: 6),
          const Text('Aquí tienes un resumen de tu actividad.', style: TextStyle(color: Color(0xFF7D8196), fontSize: 16)),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth >= 900 ? (constraints.maxWidth - 36) / 4 : (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatCard(width: cardWidth, icon: Icons.folder_rounded, title: 'Proyectos', value: '12', color: const Color(0xFF6654F1), change: '+3 este mes'),
                  _StatCard(width: cardWidth, icon: Icons.task_alt_rounded, title: 'Completados', value: '86', color: const Color(0xFF26A69A), change: '94% del objetivo'),
                  _StatCard(width: cardWidth, icon: Icons.schedule_rounded, title: 'Pendientes', value: '8', color: const Color(0xFFFFA726), change: '2 con prioridad'),
                  _StatCard(width: cardWidth, icon: Icons.groups_rounded, title: 'Equipo', value: '24', color: const Color(0xFFEC6A82), change: '5 nuevos'),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                return const Column(children: [_ProgressCard(), SizedBox(height: 16), _ActivityCard()]);
              }
              return const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _ProgressCard()),
                  SizedBox(width: 16),
                  Expanded(flex: 2, child: _ActivityCard()),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.width, required this.icon, required this.title, required this.value, required this.color, required this.change});

  final double width;
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final String change;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFECECF3))),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color)), const Icon(Icons.more_horiz_rounded, color: Color(0xFFAEB1C1))]),
              const SizedBox(height: 14),
              Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF24263A))),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF55596F))),
              const SizedBox(height: 8),
              Text(change, style: TextStyle(fontSize: 12, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFECECF3))),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Progreso semanal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            for (final item in const [('Diseño', 0.82, Color(0xFF6654F1)), ('Desarrollo', 0.68, Color(0xFF26A69A)), ('Marketing', 0.54, Color(0xFFFFA726))]) ...[
              Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: item.$2, minHeight: 9, backgroundColor: const Color(0xFFF0F1F5), color: item.$3)),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFECECF3))),
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Actividad reciente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            SizedBox(height: 16),
            _ActivityItem(icon: Icons.check_circle_outline_rounded, color: Color(0xFF26A69A), title: 'Tarea completada', detail: 'Hace 12 minutos'),
            _ActivityItem(icon: Icons.person_add_alt_1_rounded, color: Color(0xFF6654F1), title: 'Nuevo miembro', detail: 'Hace 1 hora'),
            _ActivityItem(icon: Icons.folder_copy_outlined, color: Color(0xFFFFA726), title: 'Proyecto actualizado', detail: 'Ayer'),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({required this.icon, required this.color, required this.title, required this.detail});

  final IconData icon;
  final Color color;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), Text(detail, style: const TextStyle(fontSize: 12, color: Color(0xFF9296A8)))])),
        ],
      ),
    );
  }
}
