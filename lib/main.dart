import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrawPage(),
    );
  }
}

class MathModel extends Model {
  List<Offset> p = <Offset>[];
  static get hds => 35.0;
  List<Offset> sEdge = [Offset(hds, hds),Offset(hds, 300 - hds)];
  List<double> screen = [];

  void moveSEdge(int i, Offset o) {
    sEdge[i] = o;
    notifyListeners();
  }

  Offset getSEdgePoint(Offset o){
    Offset ao = Offset((o.dx - sEdge[0].dx), (o.dy - sEdge[0].dy));
    Offset ab = Offset((sEdge[1].dx - sEdge[0].dx), (sEdge[1].dy - sEdge[0].dy));
    double c = (ao.dx*ab.dx + ao.dy*ab.dy)/(pow(ab.dx,2)+pow(ab.dy,2));
    return Offset((sEdge[0].dx + c * ab.dx),(sEdge[0].dy + c * ab.dy));
  }

  void addPoint(Offset o) {
    var l = false;
    p.add(o);
    if (p.length > 1) {
      for (int i = 0; i < p.length - 1; i++) {
        if ((p[i].dx - o.dx).abs() < hds / 2 &&
            (p[i].dy - o.dy).abs() < hds / 2) {
          p[p.length - 1] = p[i];
          l=true;
        }
      }
    }
    var r = getSEdgePoint(o);
    if(!l && sqrt(pow(o.dx - r.dx, 2) + pow(o.dy - r.dy, 2)) < MathModel.hds){
      p[p.length - 1] = r;
    }
    notifyListeners();
  }
}

class DrawPage extends StatefulWidget {
  @override
  DrawPageState createState() => new DrawPageState();
}

class DrawPageState extends State<DrawPage> {
  MathModel m = MathModel();
  @override
  Widget build(BuildContext bc) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    m.screen = [MediaQuery.of(bc).size.width,MediaQuery.of(bc).size.height];
    return ScopedModel<MathModel>(
        model: m,
        child:ScopedModelDescendant<MathModel>(builder: (c, h, model) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text("Blueprint Touch"),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.delete),onPressed: () {model.p.clear();}),
                IconButton(icon: Icon(Icons.undo),onPressed: () {model.p.removeLast();})
              ],
            ),
            body: Stack(
              children: [
                Container(width: model.screen[0], height: model.screen[1],
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage("assets/Blueprint-Paper-by-RetinaShots.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Listener(
                      onPointerDown: (e) {RenderBox r = bc.findRenderObject();
                      Offset o = r.globalToLocal(e.position);
                      model.addPoint(Offset(o.dx, o.dy - 80));},
                      child: CustomPaint(painter: Painter(model.p,model.sEdge)),
                    )
                ),
                Stack(children: <Widget>[DarkDot(0, c),DarkDot(1, c)]),
              ],
            ),
          );
        }));
  }
}

class DarkDot extends StatefulWidget {
  int i;
  BuildContext bc;
  DarkDot(this.i, this.bc);
  @override
  DarkDotState createState() => DarkDotState();
}

class DarkDotState extends State<DarkDot> {
  var m;
  @override
  void initState() {
    m = ScopedModel.of<MathModel>(widget.bc);
    setState(() {});
    super.initState();
  }
  @override
  Widget build(BuildContext c1) {
    return Builder(builder: (c2) {
      var hds = MathModel.hds;
      var handle = GestureDetector(
        onVerticalDragUpdate: (d) {
          m.moveSEdge(widget.i,Offset(d.globalPosition.dx.clamp(hds, m.screen[0] - hds),(d.globalPosition.dy - 80).clamp(hds, m.screen[1] - hds - 80)));
        },
        child: Container(width: hds * 2,height: hds * 2,decoration: new BoxDecoration(),
        ),
      );
      return Container(margin: EdgeInsets.only(left: m.sEdge[widget.i].dx - hds,top: m.sEdge[widget.i].dy - hds),child: handle);
    });
  }
}

class Painter extends CustomPainter {
  List<Offset> u;
  List<Offset> sEdge;
  Painter(this.u, this.sEdge);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint();
    paint.strokeWidth = 2;
    canvas.drawLine(sEdge[0], sEdge[1], paint);
    paint.strokeCap = StrokeCap.round;
    for (int i = 0; i < u.length; i++) {
      paint.style = PaintingStyle.stroke;
      paint.color = Colors.white;
      if(u.length.modPow(1, 2) != 0){
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(u[i], MathModel.hds / 5, paint);
      }
      if (i.modPow(1, 2) != 0) {
        paint.color = Colors.white;
        canvas.drawLine(u[i - 1], u[i], paint);
      }
    }
    paint.style = PaintingStyle.fill;
    paint.color = Colors.black;
    for(var r in sEdge){canvas.drawCircle(r, MathModel.hds, paint);}
  }
  @override
  bool shouldRepaint(Painter oldPainter) => true;
}
