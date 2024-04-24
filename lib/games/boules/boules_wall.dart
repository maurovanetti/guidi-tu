import 'package:flame_forge2d/flame_forge2d.dart';

class BoulesWall extends BodyComponent {
  final Vector2 a;
  final Vector2 b;

  BoulesWall(this.a, this.b) : super(renderBody: false);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(a, b);
    final fixtureDef = FixtureDef(shape)
      ..density = 0.5
      ..friction = 1;
    return world.createBody(BodyDef())..createFixture(fixtureDef);
  }
}
