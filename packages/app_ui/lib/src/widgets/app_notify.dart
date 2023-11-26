import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum NotifyType { loading, error, successful, none }

extension NotifyTypeExtension on NotifyType {
  bool get isLoading => this == NotifyType.loading;
  bool get isError => this == NotifyType.error;
  bool get isNone => this == NotifyType.none;
  bool get isSuccessful => this == NotifyType.successful;
}

/// Displays a confirmation dialog
class AppNotify extends ValueNotifier<(NotifyType, String?, VoidCallback?)> {
  ///
  AppNotify({
    (NotifyType, String?, VoidCallback?) value = (NotifyType.none, null, null),
  }) : super(value);

  ///
  static BuildContext? alertInformationContext;

  ///
  static AppNotify loadingValueNotify = AppNotify();

  ///
  static void dismissNotify() {
    loadingValueNotify.value = (NotifyType.none, null, null);
  }

  ///
  static void showLoading() {
    loadingValueNotify.value = (NotifyType.loading, null, null);
  }

  ///
  static void showError({String? errorMessage, VoidCallback? voidCallback}) {
    loadingValueNotify.value = (NotifyType.error, errorMessage, voidCallback);
  }

  ///
  static void showSuccessful({String? message, VoidCallback? voidCallback}) {
    loadingValueNotify.value = (NotifyType.successful, message, voidCallback);
  }

  /// Displays a confirmation dialog with an icon, a message, and a button
  ///  to confirm the action.
  ///
  /// The `context` argument is the BuildContext of the current widget tree.
  /// The `action` argument is the text that should be displayed on the
  /// confirmation button.
  /// Returns a Future that resolves when the user confirms the action.
  static Future<void> saveConfirmPopUp({
    required BuildContext context,
    required String action,
    required VoidCallback onPressed,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 220,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Animate and shake the save icon.
                const Icon(
                  Icons.save_alt_outlined,
                  size: 50,
                  color: AppColors.green,
                ).animate().shake(
                      duration: const Duration(seconds: 4),
                      offset: const Offset(10, 0),
                      hz: 5,
                      curve: Curves.easeInOut,
                    ),
                // Display the confirmation message.
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.labelLarge,
                    children: const [
                      TextSpan(
                        text: 'Are you sure you want to Save',
                      ),
                    ],
                  ),
                ),
                // Display the confirmation button.
                AppButton.primary(
                  onPressed: () {
                    onPressed();
                    Navigator.pop(context);
                  },
                  child: Text(action),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }

  ///Create a loading snackBar
  static void loadingSnackBar({
    required BuildContext context,
    required String action,
    VoidCallback? onClosed,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(minutes: 1),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(action),
              LinearProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ).closed.whenComplete(onClosed ?? () {});
  }

  ///Create a loading snackBar
  static void informationSnackBar({
    required BuildContext context,
    required String information,
    VoidCallback? onClosed,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(information),
        ),
      ).closed.whenComplete(onClosed ?? () {});
  }

  ///Create a hide current snackbar
  static void hideSnackBar({
    required BuildContext context,
  }) {
    loadingValueNotify.value = (NotifyType.none, null, null);
    if (alertInformationContext != null) {
      Navigator.pop(alertInformationContext!);
      alertInformationContext = null;
    }
  }
}

class LoadingContent extends StatelessWidget {
  const LoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<(NotifyType, String?, VoidCallback?)>(
      valueListenable: AppNotify.loadingValueNotify,
      builder: (
        BuildContext context,
        (NotifyType, String?, VoidCallback?) value,
        Widget? child,
      ) {
        return Container(
          height: value.$1.isNone ? 0 : MediaQuery.sizeOf(context).height,
          width: value.$1.isNone ? 0 : MediaQuery.sizeOf(context).width,
          color: AppColors.black.withOpacity(0.1),
          child: value.$1.isError
              ? Scaffold(
                  backgroundColor: AppColors.transparent,
                  body: Stack(
                    children: [
                      ModalBarrier(
                        onDismiss: () {
                          AppNotify.dismissNotify();
                          if (value.$3 != null) {
                            value.$3!();
                          }
                        },
                      ),
                      Center(
                          child: Text(
                        value.$2 ?? 'error',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.red),
                      )),
                    ],
                  ),
                )
              : value.$1.isSuccessful
                  ? Scaffold(
                      backgroundColor: AppColors.transparent,
                      body: Stack(
                        children: [
                          ModalBarrier(
                            onDismiss: () {
                              AppNotify.dismissNotify();
                              if (value.$3 != null) {
                                value.$3!();
                              }
                            },
                          ),
                          Center(child: Text(value.$2 ?? 'Success')),
                        ],
                      ),
                    )
                  : Container(
                      color: const Color.fromRGBO(0, 0, 0, 0.6),
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: ColoredBox(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  color: Colors.purple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
