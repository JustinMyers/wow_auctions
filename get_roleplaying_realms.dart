import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'access_token.dart';

void main() async {
  String access_token = await getAccessToken();
  print('Received access token!');
  String region = 'us';
  String host_name = 'https://${region}.api.blizzard.com';
  String namespace = 'dynamic-us';
  String locale = 'en_US';
  String params = 'locale=${locale}&access_token=${access_token}';

  String connectedRealmsIndex = '/data/wow/connected-realm/index';
  String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();

  print('Fetching connected realms...');
  var response = await http.get(
      '${host_name}${connectedRealmsIndex}?namespace=${namespace}\&${params}');
  var jsonResponse = convert.jsonDecode(response.body);

  for (var connectedRealm in jsonResponse['connected_realms']) {
    var connectedRealmResponse =
        await http.get(connectedRealm['href'] + '&${params}');
    var jsonRealm = convert.jsonDecode(connectedRealmResponse.body);
    // print('Scanning realm id ${jsonRealm['id']}.');
    if (connectedRealmResponse.body.contains("Roleplaying")) {
      print('Realm id ${jsonRealm['id']} contains Roleplaying.');
    }
  }
  print('Done.');
}
