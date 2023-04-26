import 'dart:async';
import "dart:collection";
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

//throw UnimplementedError();

class QualityLinks {
  String? videoId;
  String? password;

  QualityLinks(this.videoId, {this.password});

  getQualitiesSync() {
    return getQualitiesAsync();
  }

  Future<SplayTreeMap?> getQualitiesAsync() async {
    try {
      final String queryParameters = '?h=${password ?? ''}';
      final Uri? vimeoLink = Uri.tryParse(
          'https://player.vimeo.com/video/${videoId!}/config${queryParameters}');
      var response = await http.get(vimeoLink!);
      var jsonData =
          jsonDecode(response.body)['request']['files']['progressive'];
      SplayTreeMap videoList = SplayTreeMap.fromIterable(
        jsonData,
        key: (item) => "${item['quality']} ${item['fps']}",
        value: (item) => item['url'],
      );
      return videoList;
    } catch (error) {
      log('=====> REQUEST ERROR: $error');
      return null;
    }
  }
}
