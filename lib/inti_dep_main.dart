part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
      url: SupabaseSecrets.supabaseUrl,
      anonKey: SupabaseSecrets.supabaseAnonKey);

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  //need only one state to be there through the session
  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  //core//maintain the state throughout the session
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  //internet connection
  serviceLocator.registerFactory(() => InternetConnection());

  //internet connection
  serviceLocator.registerFactory<ConnectionCheck>(
      () => ConnectionCheckImpl(serviceLocator()));
}

//auth dependencies
void _initAuth() {
  //AuthRemoteDataSourceImpl
  //data source
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(serviceLocator()))

    //auth repository
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(serviceLocator(), serviceLocator()))

    //use cases
    ..registerFactory(() => UserSignUp(serviceLocator()))

    //current user use case
    ..registerFactory(() => CurrentUser(serviceLocator()))

    //use cases
    ..registerFactory(() => UserLogin(serviceLocator()))

    //need only one state to be there through the session
    //bloc
    ..registerLazySingleton(() => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator()));
}

//blog dependencies
void _initBlog() {
  //data source
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
        () => BlogLocalDataSourceImpl(serviceLocator()))
    //repo
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )

    //use case
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    //bloc
    ..registerLazySingleton(
      () =>
          BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()),
    );
}
