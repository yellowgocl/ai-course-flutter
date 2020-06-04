import 'package:course/models/remote/course_data.dart';
import 'package:course/models/remote/response_data.dart';

class CourseResponseData extends ResponseData{
  CourseResponseData.fromJson(Map<String, dynamic> json): super.fromJson(json);
  CourseData get course{
    return CourseData(data?.origin);
  }
}