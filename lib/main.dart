import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keep/app_bloc_observer.dart';
import 'package:flutter_keep/blocs/blocs.dart';
import 'package:flutter_keep/components/components.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/utils/utils.dart';
import 'package:flutter_keep/widgets/widgets.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_keep/routers/routers.dart' as RRouter;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    if (kReleaseMode) {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    } else {
      FlutterError.dumpErrorToConsole(details);
    }
  };

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  final router = FluroRouter();
  RRouter.Router.configureRouter(router);
  RRouter.Application.router = router;

  await HiveUtils.init();

  runZonedGuarded(() => runApp(MyApp()), (error, stackTrace) {
    if (!kReleaseMode) {
      /// 异常信息收集上报
    }
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ToastFuture _connectivityToastFuture;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  /// 网络检查【ios/android/macos/web】
  void _connectivityHandler(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      _connectivityToastFuture ??= showNoConnectivityDialog;
    } else {
      _connectivityToastFuture?.dismiss(showAnim: true);
      if (_connectivityToastFuture != null) {
        _connectivityToastFuture = null;
      }
    }
  }

  ToastFuture get showNoConnectivityDialog => showToastWidget(
        NoConnectWidget(),
        context: context,
        duration: Duration(days: 1),
        handleTouch: true,
      );

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Connectivity().checkConnectivity().then((_connectivityHandler));
    });
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_connectivityHandler);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryWrapper(
      child: BlocWrapper(
        child: OKToast(
          position: ToastPosition.bottom,
          child: MaterialApp(
            title: 'Example Project',
            theme: R.themeData,
            home: SplashPage(),
            onGenerateRoute: RRouter.Application.router.generator,
            onUnknownRoute: (_) =>
                MaterialPageRoute(builder: (_) => const NotFoundPage()),
          ),
        ),
      ),
    );
  }
}
