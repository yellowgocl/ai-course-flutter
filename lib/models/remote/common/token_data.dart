import 'package:course/models/base_data.dart';
import 'package:course/models/remote/response_data.dart';

class TokenData extends ResponseData{
  TokenData.fromJson(Map<String, dynamic> json): super.fromJson(json);
  Token get token{
    var r = data?.get('token', null);
    return (r != null && r is Map && r.isNotEmpty) ? Token.fromJson(r) : null;
  }
  String get value{
    return token?.value;
  }
  int get expriesIn{
    return token?.expiresIn;
  }
}

class Token extends BaseData{
  Token.fromJson(Map<String, dynamic> json): super.fromJson(json);

  int get type {
    return get<int>('type', 0);
  }
  String get requestId{
    return get<String>('requestId', null);
  }
  String get value{
    return get<String>('value', null);
  }
  int get expiresIn{
    return get<int>('expiresIn', 0);
  }
}