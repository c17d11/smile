import 'package:app/object/anime_response.dart';
import 'package:app/object/producer_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueUiAnime on AsyncValue<AnimeResponse> {
  bool get isLoading => this is AsyncLoading<AnimeResponse>;
  bool get isError => this is AsyncError<AnimeResponse>;

  void showSnackBarOnError(BuildContext context) =>
      whenOrNull(error: (error, _) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
}

extension AsyncValueUiProducer on AsyncValue<ProducerResponse> {
  bool get isLoading => this is AsyncLoading<ProducerResponse>;
  bool get isError => this is AsyncError<ProducerResponse>;

  void showSnackBarOnError(BuildContext context) =>
      whenOrNull(error: (error, _) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
}
