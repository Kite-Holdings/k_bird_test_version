import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET / returns 200 {'key': 'value'}", () async {
    expectResponse(await harness.agent.get("/"), 200, body: {"key": "value"});
  });
}
