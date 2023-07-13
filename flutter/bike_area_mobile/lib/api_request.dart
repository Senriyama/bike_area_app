import 'package:http/http.dart' as http;
import 'package:bike_area_mobile/point_class.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<ApiResults> postPoints(
    int label, double latitude, double longitude) async {
  var url = Uri.parse(dotenv.get('https://nzl3sljeba.execute-api.ap-northeast-3.amazonaws.com/mobile/dev/upload_pins'));
  var request = Point(
      pin_id: -1,
      label: label,
      latitude: latitude,
      longitude: longitude,
      upload_time: DateTime.now());
  final response = await http.post(url,
      body: json.encode(request.toJson()),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    return ApiResults.fromJson({'message': response.body}, response.statusCode);
  } else {
    throw Exception('POST_Failed');
  }
}

class ApiResults {
  final String message;
  final int code;

  ApiResults({
    required this.message,
    required this.code,
  });
  factory ApiResults.fromJson(Map<String, dynamic> json, int code) {
    return ApiResults(message: json['message'], code: code);
  }
}

//fetch point with URL parameter
Future<List<Point>> fetchPoints1(http.Client client) async {
  final response = await client.get(Uri.parse(dotenv.get('GET_PINS_URL')));

  if (response.statusCode == 200) {
    return parsePoints(response.body);
  } else {
    throw Exception('GET_Failed');
  }
}

//fetch point without URL parameter
Future<List<Point>> fetchPoints2() async {
  final url = Uri.parse(dotenv.get(
      'https://nzl3sljeba.execute-api.ap-northeast-3.amazonaws.com/mobile/dev/get_pins'));
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return parsePoints(response.body);
  } else {
    throw Exception('GET_Failed');
  }
}

//fetch point with URL parameter
Future<List<Point>> fetchRadiusPoints1(http.Client client, double radius,
    double latitude, double longitude, int label) async {
  final response = await client.get(Uri.parse(dotenv.get('GET_PINS_URL') +
      '?radius=$radius&latitude=$latitude&longitude=$longitude&label=$label'));

  if (response.statusCode == 200) {
    return parsePoints(response.body);
  } else {
    throw Exception('GET_Radius_Failed');
  }
}

//fetch point without URL parameter
Future<List<Point>> fetchRadiusPoints2(
    double radius, double latitude, double longitude) async {
  final response = await http.get(
      Uri.parse('https://nzl3sljeba.execute-api.ap-northeast-3.amazonaws.com/mobile/dev/get_near_pins?radius=$radius&latitude=$latitude&longitude=$longitude'));

  if (response.statusCode == 200) {
    return parsePoints(response.body);
  } else {
    throw Exception('GET_Radius_Failed');
  }
}

//get_comments
//jsonResponseを返すので、もしかしたらjsonResponseがMap型で、エラーになるかも
Future<String> fetchComments(int pin_id) async {
  final response = await http.get(Uri.parse('URL?pin_id=$pin_id'));
  final jsonResponse = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return jsonResponse;
  } else {
    throw Exception('GET_Comments_Failed');
  }
}

//upload_comment_class
class PinidComment {
  final int pin_id;
  final String comment;
  PinidComment({required this.pin_id, required this.comment});
  Map<String, dynamic> toJson() => {
        'pin_id': pin_id,
        'comment': comment,
      };
}

//upload_comment
Future<ApiResults> postComment(int pin_id, String comment) async {
  var url = Uri.parse("URL");
  var request = PinidComment(pin_id: -1, comment: comment);
  final response = await http.post(url,
      body: json.encode(request.toJson()),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    return ApiResults.fromJson(json.decode(response.body), response.statusCode);
  } else {
    throw Exception('POST_Comment_Failed');
  }
}

//delete_comment
Future<String> deleteComment(int comment_id) async {
  final response = await http.delete(Uri.parse('URL?comment_id=$comment_id'));

  if (response.statusCode == 200) {
    return "Delete successful";
  } else {
    throw Exception('Delete_Comment_Failed');
  }
}

//add_good
//jsonResponseの型がMap型だとエラーが出そう
Future<int> addGood(int comment_id) async {
  final response = await http.get(Uri.parse('URL?comment_id=$comment_id'));
  final jsonResponse = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return jsonResponse;
  } else {
    throw Exception('Add_Good_Failed');
  }
}

//remove_good
Future<int> removeGood(int comment_id) async {
  final response = await http.get(Uri.parse('URL?comment_id=$comment_id'));
  final jsonResponse = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return jsonResponse;
  } else {
    throw Exception('Remove_Good_Failed');
  }
}

//add_bad
Future<int> addBad(int comment_id) async {
  final response = await http.get(Uri.parse('URL?comment_id=$comment_id'));
  final jsonResponse = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return jsonResponse;
  } else {
    throw Exception('Add_Bad_Failed');
  }
}

//remove_bad
Future<int> removeBad(int comment_id) async {
  final response = await http.get(Uri.parse('URL?comment_id=$comment_id'));
  final jsonResponse = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return jsonResponse;
  } else {
    throw Exception('Remove_Bad_Failed');
  }
}
