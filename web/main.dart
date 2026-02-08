import 'package:fitness/services.dart';
import 'ui/handlers.dart';

void main() {
  final db = InMemoryDb();
  final app = Handlers(db, lockerCount: 5);
  app.bind();
}
