/// lib/providers/quiz_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizzesState {
  final List<dynamic> quizzes;
  final int page;
  final int totalPages;
  final bool isLoading;
  final String? error;

  QuizzesState({
    this.quizzes = const [],
    this.page = 1,
    this.totalPages = 0,
    this.isLoading = false,
    this.error,
  });

  QuizzesState copyWith({
    List<dynamic>? quizzes,
    int? page,
    int? totalPages,
    bool? isLoading,
    String? error,
  }) {
    return QuizzesState(
      quizzes: quizzes ?? this.quizzes,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final quizzesProvider = StateNotifierProvider<
    QuizzesNotifier,
    QuizzesState>((ref) => QuizzesNotifier());

class QuizzesNotifier extends StateNotifier<QuizzesState> {
  QuizzesNotifier() : super(QuizzesState());

  Future<void> loadPage(int page) async {
    state = state.copyWith(isLoading: true);
    try {
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load quizzes: $e',
      );
    }
  }

  Future<void> loadMore() async {
    if (state.page >= state.totalPages) return;
    await loadPage(state.page + 1);
  }

  Future<void> refresh() async {
    await loadPage(1);
  }
}

class QuizDetailState {
  final dynamic quiz;
  final bool isLoading;
  final String? error;

  QuizDetailState({
    this.quiz,
    this.isLoading = false,
    this.error,
  });

  QuizDetailState copyWith({
    dynamic quiz,
    bool? isLoading,
    String? error,
  }) {
    return QuizDetailState(
      quiz: quiz ?? this.quiz,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final quizDetailProvider = StateNotifierProvider.family<
    QuizDetailNotifier,
    QuizDetailState,
    int>((ref, quizId) => QuizDetailNotifier(quizId));

class QuizDetailNotifier extends StateNotifier<QuizDetailState> {
  final int quizId;

  QuizDetailNotifier(this.quizId) : super(QuizDetailState()) {
    loadDetail();
  }

  Future<void> loadDetail() async {
    state = state.copyWith(isLoading: true);
    try {
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load quiz: $e',
      );
    }
  }
}

class QuizSubmissionState {
  final bool isSubmitting;
  final bool success;
  final String? error;
  final Map<String, dynamic>? result;

  QuizSubmissionState({
    this.isSubmitting = false,
    this.success = false,
    this.error,
    this.result,
  });

  QuizSubmissionState copyWith({
    bool? isSubmitting,
    bool? success,
    String? error,
    Map<String, dynamic>? result,
  }) {
    return QuizSubmissionState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      success: success ?? this.success,
      error: error,
      result: result ?? this.result,
    );
  }
}

final quizSubmissionProvider = StateNotifierProvider<
    QuizSubmissionNotifier,
    QuizSubmissionState>((ref) => QuizSubmissionNotifier());

class QuizSubmissionNotifier extends StateNotifier<QuizSubmissionState> {
  QuizSubmissionNotifier() : super(QuizSubmissionState());

  Future<void> submitAnswers({
    required int quizId,
    required int timeSpent,
    required List<Map<String, dynamic>> answers,
  }) async {
    state = state.copyWith(isSubmitting: true);
    try {
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: 'Failed to submit quiz: $e',
      );
    }
  }

  void reset() {
    state = QuizSubmissionState();
  }
}
