import 'package:domain/domain.dart';
import 'package:med_mate/app/app.dart';
import 'package:med_mate/bootstrap.dart';

void main() {
  bootstrap(
    (drugRepository) => App(
      user: User.anonymous,
      drugRepository: drugRepository,
    ),
  );
}
