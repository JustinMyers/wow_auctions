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
    if (connectedRealmResponse.body.contains("Roleplaying")) {
      var jsonRealm = convert.jsonDecode(connectedRealmResponse.body);
      print('Scanning realm id ${jsonRealm['id']}.');
      await Directory('connectedRealms/${jsonRealm['id']}/auctionSnapshots')
          .create(recursive: true);
      await new File('connectedRealms/${jsonRealm['id']}/connected_realm.json')
          .writeAsString(connectedRealmResponse.body);
      var auctionResponse =
          await http.get('${jsonRealm['auctions']['href']}&${params}');
      await new File(
              'connectedRealms/${jsonRealm['id']}/auctionSnapshots/${timeStamp}.json')
          .writeAsString(auctionResponse.body);
    }
  }
  print('Done.');
}
