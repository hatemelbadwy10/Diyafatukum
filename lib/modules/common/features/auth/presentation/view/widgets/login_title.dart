import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/flavor/flavor_config.dart';
import '../../../../../../../core/resources/resources.dart';

import 'package:flutter/material.dart';

class LoginTitle extends StatefulWidget {
  const LoginTitle({super.key});

  @override
  State<LoginTitle> createState() => _LoginTitleState();
}

class _LoginTitleState extends State<LoginTitle> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _showSlogan = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));

    _startAnimation();
  }

  void _startAnimation() {
    _animationController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          _animationController.reverse().then((_) {
            if (mounted) {
              setState(() {
                _showSlogan = !_showSlogan;
              });
              _startAnimation();
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _showSlogan ? _buildSloganWidget(context) : _buildWelcomeWidget(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSloganWidget(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text("${LocaleKeys.app_slogan.tr()} ", style: context.displaySmall.regular.s18),
    );
  }

  Widget _buildWelcomeWidget(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${LocaleKeys.auth_login_welcome.tr()} ",
            style: context.displayLarge.regular.s18.setColor(context.tertiarySwatch.shade800),
          ),
          Text(FlavorConfig.displayName, style: context.displayMedium.regular.s18),
        ],
      ),
    );
  }
}
