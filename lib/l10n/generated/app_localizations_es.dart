// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Flutter Starter Pro';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get welcomeBack => 'Bienvenido de nuevo';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get resetPassword => 'Restablecer Contraseña';

  @override
  String get createAccount => 'Crear Cuenta';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get rememberMe => 'Recuérdame';

  @override
  String get fullName => 'Nombre Completo';

  @override
  String get settings => 'Configuración';

  @override
  String get appearance => 'Apariencia';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Idioma';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get security => 'Seguridad';

  @override
  String get changePassword => 'Cambiar Contraseña';

  @override
  String get about => 'Acerca de';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get version => 'Versión';

  @override
  String get home => 'Inicio';

  @override
  String get profile => 'Perfil';

  @override
  String get analytics => 'Analíticas';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get next => 'Siguiente';

  @override
  String get back => 'Atrás';

  @override
  String get skip => 'Omitir';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Éxito';

  @override
  String get retry => 'Reintentar';

  @override
  String get noData => 'No hay datos disponibles';

  @override
  String get emailRequired => 'El correo electrónico es requerido';

  @override
  String get invalidEmail => 'Por favor ingrese un correo electrónico válido';

  @override
  String get passwordRequired => 'La contraseña es requerida';

  @override
  String passwordMinLength(int length) {
    return 'La contraseña debe tener al menos $length caracteres';
  }

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';
}
