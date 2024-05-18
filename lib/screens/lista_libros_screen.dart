import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:examen_1/models/libros.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      home: ListaLibrosScreen(),
    );
  }
}

class ListaLibrosScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Libros'),
        backgroundColor: Color.fromARGB(255, 218, 142, 236), 
        centerTitle: true       
      ),      
      body: Center(
        child: _buildListaLibros(context),
      ),
    );
  }

Widget _buildListaLibros(BuildContext context) {
  return FutureBuilder<List<Libro>>(
    future: _fetchLibros(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Text('Error al cargar los libros');
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Text('No hay libros disponibles');
      } else {
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return Container(
              color: index % 2 == 0 ? Color.fromARGB(255, 141, 56, 35) : Color.fromARGB(255, 0, 0, 0),
              child: ListTile(
                title: Text(snapshot.data![index].title, style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
                subtitle: Text('Año: ${snapshot.data![index].year.toString()}', style: TextStyle(color: const Color.fromARGB(221, 255, 255, 255))),
                trailing: IconButton(
                  icon: Icon(Icons.download_rounded, color: Colors.white),
                  onPressed: () {                    
                    _showDownloadDialog(context);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetallesLibroScreen(libro: snapshot.data![index]),
                    ),
                  );
                },
              ),
            );
          },
        );
      }
    },
  );
}

  Future<List<Libro>> _fetchLibros() async {
    try {
      String jsonString = await rootBundle.loadString('data.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      List<dynamic> jsonList = jsonData['data'];
      List<Libro> libros = jsonList.map((json) => Libro.fromJson(json)).toList();
      return libros;
    } catch (e) {
      print('Error al cargar o decodificar los libros: $e');
      return [];
    }
  }
}

void _showDownloadDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return _DownloadDialog();
    },
  );
}

class _DownloadDialog extends StatefulWidget {
  @override
  __DownloadDialogState createState() => __DownloadDialogState();
}

class __DownloadDialogState extends State<_DownloadDialog> {
  String _message = 'Descargando el archivo...';
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _startDownload();
  }

  void _startDownload() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _message = 'Descarga completada';
      _isCompleted = true;
    });
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Espere un momento'),
      content: Row(
        children: [
          if (_isCompleted)
            Icon(Icons.check, color: Colors.green),
          SizedBox(width: 10),
          Text(_message),
        ],
      ),
    );
  }
}


class DetallesLibroScreen extends StatelessWidget {
  final Libro libro;

  DetallesLibroScreen({required this.libro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          libro.title,
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor:Color.fromARGB(255, 128, 128, 128),
        elevation: 0, 
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 218, 142, 29), 
        ),
        height: double.infinity, 
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Título:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      libro.title,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Año:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      libro.year.toString(),
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Villanos asociados:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: libro.villains.map((villano) {
                    return Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        villano.name,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16.0), 
            ],
          ),
        ),
      ),
    );
  }
}


