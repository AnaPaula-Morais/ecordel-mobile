import 'package:ecordel/app/commons/models/ecordel.dart';
import 'package:ecordel/app/commons/providers/cordel_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadScreen extends StatefulWidget {
  static String route = '/readScreen';

  final int cordelId;
  ReadScreen({this.cordelId});

  @override
  _ReadScreenState createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  void _textResize(bool addSize) {
    if (addSize && this._textSizeMultiplier <= 1.8) {
      setState(() {
        this._textSizeMultiplier += 0.2;
      });

      return;
    }
    if (!addSize && this._textSizeMultiplier >= 1.2) {
      setState(() {
        this._textSizeMultiplier -= 0.2;
      });

      return;
    }
  }

  void _textPlus() {
    _textResize(true);
  }

  void _textMinor() {
    _textResize(false);
  }

  Ecordel _ecordel;
  bool _isLoading = false;
  bool _firstBuild = true;
  double _textSizeMultiplier = 1.0;

  @override
  void didChangeDependencies() {
    if (_firstBuild) {
      setState(() {
        this._isLoading = true;
      });

      Provider.of<EcordelProvider>(context, listen: false)
          .fethById(widget.cordelId)
          .then((cordel) {
        this._ecordel = cordel;

        setState(() {
          this._isLoading = false;
        });
      });
    }

    this._firstBuild = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "Tamanho do texto: ",
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.add),
                  onPressed: _textPlus,
                ),
                IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.remove),
                  onPressed: _textMinor,
                )
              ],
            ),
          ],
          centerTitle: true,
        ),
        // body: Center(child: Text("testando"),)
        body: this._isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      this._isLoading
                          ? Text('')
                          : Image.network("${this._ecordel.xilogravura.url}"),
                      Text(
                        this._ecordel.content,
                        style: TextStyle(fontSize: 20 * _textSizeMultiplier),
                      ),
                      Text("Autor: ${this._ecordel.author.name}")
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
