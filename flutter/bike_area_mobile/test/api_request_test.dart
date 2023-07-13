import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:bike_area_mobile/api_request.dart';
import 'package:bike_area_mobile/point_class.dart';

void main() {
  group('api_request test', () {
    test("post", () async{
      int label = 0;
      double latitude = 0;
      double longitude = 0;
      ApiResults actual = await postPoints(label, latitude, longitude);
      expect(actual, "POSTのresponse.body");
    });
    test("getAllPoints", () async{
      List<Point> expected =
      [
        Point(pin_id: 22, label: 1, latitude: 2.3, longitude: 2.3, upload_time: DateTime(2023, 5, 16, 6, 51, 53)),
        Point(pin_id: 56, label: 1, latitude: 34.95617073120783, longitude: 135.83338547497988, upload_time: DateTime(2023, 5, 22, 4, 35, 47)),
      ];
      List<Point> actual = await fetchPoints2();
      //print(actual);
      //print(expected);
      expect(actual[0].pin_id, expected[0].pin_id);
      expect(actual[0].label, expected[0].label);
      expect(actual[0].latitude, expected[0].latitude);
      expect(actual[0].longitude, expected[0].longitude);
      expect(actual[0].upload_time, expected[0].upload_time);

      expect(actual[34].pin_id, expected[1].pin_id);
      expect(actual[34].label, expected[1].label);
      expect(actual[34].latitude, expected[1].latitude);
      expect(actual[34].longitude, expected[1].longitude);
      expect(actual[34].upload_time, expected[1].upload_time);
    });
    test("getRadiusPoints", () async{
      double radius = 1;
      double latitude = 2.3;
      double longitude = 2.3;
      List<Point> expected =
      [
        Point(pin_id: 22, label: 1, latitude: 2.3, longitude: 2.3, upload_time: DateTime(2023, 5, 16, 6, 51, 53)),
        Point(pin_id: 56, label: 1, latitude: 34.95617073120783, longitude: 135.83338547497988, upload_time: DateTime(2023, 5, 22, 4, 35, 47)),
      ];
      List<Point> actual = await fetchRadiusPoints2(radius, latitude, longitude);
      expect(actual[0].pin_id, expected[0].pin_id);
      expect(actual[0].label, expected[0].label);
      expect(actual[0].latitude, expected[0].latitude);
      expect(actual[0].longitude, expected[0].longitude);
      expect(actual[0].upload_time, expected[0].upload_time);

      expect(actual[34].pin_id, expected[1].pin_id);
      expect(actual[34].label, expected[1].label);
      expect(actual[34].latitude, expected[1].latitude);
      expect(actual[34].longitude, expected[1].longitude);
      expect(actual[34].upload_time, expected[1].upload_time);
    });
    test("fetchComments", () {
      int pin_id = -1;
      expect(fetchComments(pin_id), "comment");
    });
    test("postComment", () {
      int pin_id = -1;
      String comment = "this is a post comment";
      expect(postComment(pin_id, comment), "POSTのresponse.body");
    });
    test("deleteComment", () {
      int comment_id = -1;
      expect(deleteComment(comment_id), "Delete successful");
    });
    test("addGood", () {
      int comment_id = -1;
      expect(addGood(comment_id), -1);
    });
    test("removeGood", () {
      int comment_id = -1;
      expect(removeGood(comment_id), -1);
    });
    test("addBad", () {
      int comment_id = -1;
      expect(addBad(comment_id), -1);
    });
    test("removeBad", () {
      int comment_id = -1;
      expect(removeBad(comment_id), -1);
    });
  });
}