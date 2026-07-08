import 'package:flutter/material.dart';

void main() {
  runApp(const FutControlApp());
}

class FutControlApp extends StatelessWidget {
  const FutControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FutControl',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20), // Color verde fútbol institucional
          brightness: Brightness.light,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// =========================================================================
// 1. MODELOS DE DATOS (Entidades del erDiagram.md)
// =========================================================================

class Usuario {
  final int idUsuario;
  final String nombre;
  final String correo;
  final String contrasena;

  Usuario({
    required this.idUsuario,
    required this.nombre,
    required this.correo,
    required this.contrasena,
  });
}

class Equipo {
  final int idEquipo;
  String nombre;
  String pais;
  String liga;
  String entrenador;
  String estadio;
  final int idUsuarioRegistro; // Relación 1-N: USUARIO ||--o{ EQUIPO

  Equipo({
    required this.idEquipo,
    required this.nombre,
    required this.pais,
    required this.liga,
    required this.entrenador,
    required this.estadio,
    required this.idUsuarioRegistro,
  });

  // Clonar objeto para evitar mutaciones directas antes de confirmar guardado
  Equipo copyWith({
    int? idEquipo,
    String? nombre,
    String? pais,
    String? liga,
    String? entrenador,
    String? estadio,
    int? idUsuarioRegistro,
  }) {
    return Equipo(
      idEquipo: idEquipo ?? this.idEquipo,
      nombre: nombre ?? this.nombre,
      pais: pais ?? this.pais,
      liga: liga ?? this.liga,
      entrenador: entrenador ?? this.entrenador,
      estadio: estadio ?? this.estadio,
      idUsuarioRegistro: idUsuarioRegistro ?? this.idUsuarioRegistro,
    );
  }
}

// =========================================================================
// 2. CAPA DE SERVICIO / BASE DE DATOS MOCK (Simulación de Firebase/DB)
// =========================================================================

class MockDatabaseService {
  // Singleton para mantener la consistencia de los datos en toda la app
  static final MockDatabaseService _instance = MockDatabaseService._internal();
  factory MockDatabaseService() => _instance;
  MockDatabaseService._internal();

  // Datos simulados iniciales (Mock Data)
  final List<Usuario> _usuarios = [
    Usuario(idUsuario: 1, nombre: 'Administrador Principal', correo: 'admin@futcontrol.com', contrasena: 'admin123'),
    Usuario(idUsuario: 2, nombre: 'Soporte Técnico', correo: 'soporte@futcontrol.com', contrasena: 'secure456'),
  ];

  final List<Equipo> _equipos = [
    Equipo(idEquipo: 1, nombre: 'Real Madrid CF', pais: 'España', liga: 'LaLiga EA Sports', entrenador: 'Carlo Ancelotti', estadio: 'Santiago Bernabéu', idUsuarioRegistro: 1),
    Equipo(idEquipo: 2, nombre: 'Manchester City FC', pais: 'Inglaterra', liga: 'Premier League', entrenador: 'Pep Guardiola', estadio: 'Etihad Stadium', idUsuarioRegistro: 1),
    Equipo(idEquipo: 3, nombre: 'FC Bayern München', pais: 'Alemania', liga: 'Bundesliga', entrenador: 'Vincent Kompany', estadio: 'Allianz Arena', idUsuarioRegistro: 2),
    Equipo(idEquipo: 4, nombre: 'Boca Juniors', pais: 'Argentina', liga: 'Liga Profesional', entrenador: 'Diego Martínez', estadio: 'La Bombonera', idUsuarioRegistro: 1),
  ];

  Usuario? _usuarioAutenticado;

  Usuario? get usuarioAutenticado => _usuarioAutenticado;

  // Autenticación de Usuarios
  Future<bool> login(String correo, String contrasena) async {
    await Future.delayed(const Duration(milliseconds: 400)); // Simula latencia < 2s (SRS)
    try {
      final user = _usuarios.firstWhere(
        (u) => u.correo.toLowerCase() == correo.trim().toLowerCase() && u.contrasena == contrasena,
      );
      _usuarioAutenticado = user;
      return true;
    } catch (_) {
      return false;
    }
  }

  // Registro de nuevos usuarios (SRS.md)
  Future<bool> registrarUsuario(String nombre, String correo, String contrasena) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (_usuarios.any((u) => u.correo.toLowerCase() == correo.trim().toLowerCase())) {
      return false; // El correo ya existe
    }
    final nuevoUsuario = Usuario(
      idUsuario: _usuarios.length + 1,
      nombre: nombre.trim(),
      correo: correo.trim().toLowerCase(),
      contrasena: contrasena,
    );
    _usuarios.add(nuevoUsuario);
    return true;
  }

  void logout() {
    _usuarioAutenticado = null;
  }

  // CRUD de Equipos
  List<Equipo> obtenerEquipos() {
    return _equipos;
  }

  Future<void> agregarEquipo(String nombre, String pais, String liga, String entrenador, String estadio) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final nuevoId = _equipos.isEmpty ? 1 : _equipos.map((e) => e.idEquipo).reduce((a, b) => a > b ? a : b) + 1;
    final nuevoEquipo = Equipo(
      idEquipo: nuevoId,
      nombre: nombre.trim(),
      pais: pais.trim(),
      liga: liga.trim(),
      entrenador: entrenador.trim(),
      estadio: estadio.trim(),
      idUsuarioRegistro: _usuarioAutenticado?.idUsuario ?? 1,
    );
    _equipos.add(nuevoEquipo);
  }

  Future<void> actualizarEquipo(Equipo equipoActualizado) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _equipos.indexWhere((e) => e.idEquipo == equipoActualizado.idEquipo);
    if (index != -1) {
      _equipos[index] = equipoActualizado;
    }
  }

  Future<void> eliminarEquipo(int idEquipo) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _equipos.removeWhere((e) => e.idEquipo == idEquipo);
  }
}

// =========================================================================
// 3. INTERFAZ GRÁFICA / PANTALLAS (UI)
// =========================================================================

// --- PANTALLA DE INICIO DE SESIÓN ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@futcontrol.com');
  final _passwordController = TextEditingController(text: 'admin123');
  bool _isLoading = false;

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final db = MockDatabaseService();
    final success = await db.login(_emailController.text, _passwordController.text);
    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Bienvenido de nuevo, ${db.usuarioAutenticado?.nombre}!'),
            backgroundColor: Colors.green[700],
          ),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Credenciales incorrectas o usuario no registrado.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.sports_soccer, size: 80, color: Theme.context.findAncestorWidgetOfExactType<MaterialApp>()?.theme?.colorScheme.primary ?? Colors.green[800]),
                const SizedBox(height: 16),
                const Text(
                  'FutControl',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const Text(
                  'Gestión y Registro de Equipos de Fútbol',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val == null || val.isEmpty ? 'Por favor ingrese su correo electrónico' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (val) => val == null || val.isEmpty ? 'Por favor ingrese su contraseña' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Iniciar Sesión', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterUserScreen()));
                  },
                  child: const Text('¿No tienes cuenta? Regístrate aquí'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- PANTALLA DE REGISTRO DE NUEVO USUARIO ---
class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final success = await MockDatabaseService().registrarUsuario(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado con éxito. Ya puede iniciar sesión.'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: El correo electrónico ya se encuentra registrado.'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Complete la información para registrarse en el sistema.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre Completo', prefixIcon: Icon(Icons.person_outline)),
                validator: (val) => val == null || val.isEmpty ? 'El nombre es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo Electrónico', prefixIcon: Icon(Icons.email_outlined)),
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val == null || val.isEmpty ? 'El correo es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock_outline)),
                obscureText: true,
                validator: (val) => val == null || val.length < 6 ? 'La contraseña debe tener al menos 6 caracteres' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800], foregroundColor: Colors.white),
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Registrar Usuario', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- PANTALLA PRINCIPAL / CONSULTA DE EQUIPOS (Epic 2) ---
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _db = MockDatabaseService();

  void _refreshList() {
    setState(() {});
  }

  void _confirmDelete(Equipo equipo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              SizedBox(width: 8),
              Text('Confirmar Acción'),
            ],
          ),
          content: Text('¿Está seguro de que desea eliminar al equipo "${equipo.nombre}"? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () {
                // Escenario: Eliminación no exitosa (Cancelación)
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Eliminación cancelada. El equipo se conserva intacto.')),
                );
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Escenario: Eliminación exitosa
                Navigator.pop(dialogContext);
                await _db.eliminarEquipo(equipo.idEquipo);
                _refreshList();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Equipo eliminado con éxito de la base de datos.'), backgroundColor: Colors.green),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listaEquipos = _db.obtenerEquipos();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FutControl - Equipos', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              _db.logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
        ],
      ),
      body: listaEquipos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open_outlined, size: 72, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay equipos registrados', // Requisito explícito Epic 2
                    style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: listaEquipos.length,
              itemBuilder: (context, index) {
                final equipo = listaEquipos[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[100],
                      child: const Icon(Icons.sports_soccer, color: Colors.green),
                    ),
                    title: Text(equipo.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Liga: ${equipo.liga} • País: ${equipo.pais}
DT: ${equipo.entrenador}
Estadio: ${equipo.estadio}',
                        style: TextStyle(color: Colors.grey[700], height: 1.3),
                      ),
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueForm),
                          color: Colors.blue[700],
                          tooltip: 'Editar',
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => FormEquipoScreen(equipoAEditar: equipo)),
                            );
                            _refreshList();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red[700],
                          tooltip: 'Eliminar',
                          onPressed: () => _confirmDelete(equipo),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormEquipoScreen()),
          );
          _refreshList();
        },
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Equipo'),
      ),
    );
  }
}

// --- FORMULARIO DE REGISTRO / ACTUALIZACIÓN DE EQUIPO (Epic 1 & Epic 3) ---
class FormEquipoScreen extends StatefulWidget {
  final Equipo? equipoAEditar;

  const FormEquipoScreen({super.key, this.equipoAEditar});

  @override
  State<FormEquipoScreen> createState() => _FormEquipoScreenState();
}

class _FormEquipoScreenState extends State<FormEquipoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _paisController;
  late TextEditingController _ligaController;
  late TextEditingController _entrenadorController;
  late TextEditingController _estadioController;
  bool _isSaving = false;

  bool get esEdicion => widget.equipoAEditar != null;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.equipoAEditar?.nombre ?? '');
    _paisController = TextEditingController(text: widget.equipoAEditar?.pais ?? '');
    _ligaController = TextEditingController(text: widget.equipoAEditar?.liga ?? '');
    _entrenadorController = TextEditingController(text: widget.equipoAEditar?.entrenador ?? '');
    _estadioController = TextEditingController(text: widget.equipoAEditar?.estadio ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _paisController.dispose();
    _ligaController.dispose();
    _entrenadorController.dispose();
    _estadioController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    // Escenario de validación obligatoria: si falla, muestra error sin registrar/guardar
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Debe completar todos los campos obligatorios.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final db = MockDatabaseService();

    if (esEdicion) {
      // Escenario: Actualización exitosa
      final equipoActualizado = widget.equipoAEditar!.copyWith(
        nombre: _nombreController.text,
        pais: _paisController.text,
        liga: _ligaController.text,
        entrenador: _entrenadorController.text,
        estadio: _estadioController.text,
      );
      await db.actualizarEquipo(equipoActualizado);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Equipo actualizado con éxito!'), backgroundColor: Colors.green),
        );
      }
    } else {
      // Escenario: Registro exitoso
      await db.agregarEquipo(
        _nombreController.text,
        _paisController.text,
        _ligaController.text,
        _entrenadorController.text,
        _estadioController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Equipo registrado con éxito!'), backgroundColor: Colors.green),
        );
      }
    }

    setState(() => _isSaving = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar Información' : 'Registrar Equipo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                esEdicion 
                    ? 'Modifique los campos correspondientes del equipo.' 
                    : 'Ingrese los datos obligatorios para dar de alta al equipo.',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre del Equipo', prefixIcon: Icon(Icons.shield_outlined)),
                validator: (val) => val == null || val.trim().isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _paisController,
                decoration: const InputDecoration(labelText: 'País de Origen', prefixIcon: Icon(Icons.flag_outlined)),
                validator: (val) => val == null || val.trim().isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ligaController,
                decoration: const InputDecoration(labelText: 'Liga Competitiva', prefixIcon: Icon(Icons.emoji_events_outlined)),
                validator: (val) => val == null || val.trim().isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _entrenadorController,
                decoration: const InputDecoration(labelText: 'Director Técnico / Entrenador', prefixIcon: Icon(Icons.person_pin_outlined)),
                validator: (val) => val == null || val.trim().isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _estadioController,
                decoration: const InputDecoration(labelText: 'Estadio Local', prefixIcon: Icon(Icons.location_city_outlined)),
                validator: (val) => val == null || val.trim().isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  foregroundColor: Colors.white,
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(esEdicion ? 'Actualizar' : 'Guardar', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
