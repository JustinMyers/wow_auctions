import 'package:http_auth/http_auth.dart' as http_auth;
import 'dart:convert' as convert;

final String clientID = '58f085b109d747b7b0f124fe6e041a18';
final String clientSecret = 'BY7xLZ4nIJCBKS6dcha4s1Dw9KOdohps';

getAccessToken() async {
  var client = http_auth.BasicAuthClient(clientID, clientSecret);
  var response = await client.post('https://us.battle.net/oauth/token',
      body: {'grant_type': 'client_credentials'});
  return convert.jsonDecode(response.body)['access_token'];
}
