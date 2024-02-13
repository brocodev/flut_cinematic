import 'package:flut_cinematic/core/core.dart';
import 'package:flut_cinematic_common/flut_cinematic_common.dart';
import 'package:flut_cinematic_domain/flut_cinematic_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';

part 'video_provider.freezed.dart';
part 'video_state.dart';

final videoProvider =
    StateNotifierProvider.autoDispose.family<VideoProvider, VideoState, int>(
  (ref, movieId) => VideoProvider(
    VideoState.loading(),
    movieRepository: ref.read(Repositories.movie),
    movieId: movieId,
  ),
);

class VideoProvider extends StateNotifier<VideoState> {
  VideoProvider(
    super.state, {
    required IMovieRepository movieRepository,
    required int movieId,
  })  : _movieRepository = movieRepository,
        _movieId = movieId;

  final IMovieRepository _movieRepository;
  final int _movieId;

  Future<void> loadVideos() async {
    final result = await _movieRepository.videos(movieId: _movieId);
    state = switch (result) {
      Right(value: final response) => VideoState.loaded(
          videos: response.videos,
        ),
      Left(value: final failure) => VideoState.error(failure: failure),
    };
  }
}
