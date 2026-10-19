import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_bite_test/presentation/widgets/auth/sign_up_body_widget.dart';

import '../../../injection.dart';
import '../../blocs/auth/auth_cubit.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: const SignUpBodyWidget(),
    );
  }
}
