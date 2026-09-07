import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

import '../modules/latihan/bindings/latihan_binding.dart';
import '../modules/latihan/views/latihan_view.dart';

import '../modules/materi/bindings/materi_binding.dart';
import '../modules/materi/views/materi_view.dart';

import '../modules/kategori/bindings/kategori_binding.dart';
import '../modules/kategori/views/kategori_view.dart';

import '../modules/riwayat/bindings/riwayat_binding.dart';
import '../modules/riwayat/views/riwayat_detail_view.dart';
import '../modules/riwayat/views/riwayat_view.dart';

import '../modules/pantun/bindings/pantun_binding.dart';
import '../modules/pantun/views/pantun_detail_view.dart';
import '../modules/pantun/views/pantun_view.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

import 'app_routes.dart';

class AppPages {
  static const initial = Routes.login;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: Routes.pantun,
      page: () => const PantunView(),
      binding: PantunBinding(),
    ),

    GetPage(name: Routes.pantunDetail, page: () => const PantunDetailView()),

    GetPage(
      name: Routes.latihan,
      page: () => const LatihanView(),
      binding: LatihanBinding(),
    ),
    GetPage(
      name: Routes.materi,
      page: () => const MateriView(),
      binding: MateriBinding(),
    ),
    GetPage(
      name: Routes.riwayat,
      page: () => const RiwayatView(),
      binding: RiwayatBinding(),
    ),

    GetPage(name: Routes.riwayatDetail, page: () => const RiwayatDetailView()),
    GetPage(
      name: Routes.kategori,
      page: () => const KategoriView(),
      binding: KategoriBinding(),
    ),
  ];
}
