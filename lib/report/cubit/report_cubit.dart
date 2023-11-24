// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:med_mate/application/application.dart';

enum ReportEnum {
  initial,
  reportForThisMonth,
  reportForLastMonth,
  reportForChooseASpecificTime,
}

extension ReportEnumExtension on ReportEnum {
  bool get isInitial => this == ReportEnum.initial;
  bool get isReportForThisMonth => this == ReportEnum.reportForThisMonth;
  bool get isReportForLastMonth => this == ReportEnum.reportForLastMonth;
  bool get isReportForChooseASpecificTime =>
      this == ReportEnum.reportForChooseASpecificTime;
}

class ReportCubit extends Cubit<ReportState> {
  ReportCubit(this._drugRepository) : super(const ReportState());
  final DrugRepository _drugRepository;
  Future<void> showReport(ReportEnum reportEnum) async {
    final result = await _drugRepository.getDrugs();
    emit(state.copyWith(reportEnum: reportEnum, drugs: result.data));
  }
}

class ReportState extends Equatable {
  const ReportState({
    this.reportEnum = ReportEnum.initial,
    this.drugs = const [],
  });
  final ReportEnum reportEnum;
  final List<Drug> drugs;
  @override
  List<Object> get props => [reportEnum, drugs];

  ReportState copyWith({
    ReportEnum? reportEnum,
    List<Drug>? drugs,
  }) {
    return ReportState(
      reportEnum: reportEnum ?? this.reportEnum,
      drugs: drugs ?? this.drugs,
    );
  }
}
