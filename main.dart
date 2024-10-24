import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart'; 
import 'weather_service.dart';

//HECHO POR DANIEL DOMINGUEZ/20220786

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarea #6',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.05, 
            left: screenWidth * 0.05, 
            child: Text(
              'Práctica #6',
              style: TextStyle(
                fontSize: screenWidth * 0.06, 
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenWidth * 0.25, 
                  height: screenWidth * 0.25, 
                  child: Image.asset('assets/herramienta.jpg'),
                ),
                SizedBox(height: screenHeight * 0.02), 
                _buildButton(context, 'Predicción de Género', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenderPrediction()),
                  );
                }, screenWidth),
                SizedBox(height: screenHeight * 0.02), 
                _buildButton(context, 'Determinar Edad', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AgePrediction()),
                  );
                }, screenWidth),
                SizedBox(height: screenHeight * 0.02), 
                _buildButton(context, 'Universidades por País', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UniversitySearch()),
                  );
                }, screenWidth),
                SizedBox(height: screenHeight * 0.02), 
                _buildButton(context, 'Clima en RD', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WeatherScreen()),
                  );
                }, screenWidth),
                SizedBox(height: screenHeight * 0.02), 
                _buildButton(context, 'Noticias desde WordPress', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WordPressNews()),
                  );
                }, screenWidth),
                SizedBox(height: screenHeight * 0.02), 
                _buildButton(context, 'Acerca de', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                }, screenWidth),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed, double screenWidth) {
    return Container(
      width: screenWidth * 0.8, 
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ElevatedButton(
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}


class GenderPrediction extends StatefulWidget {
  @override
  _GenderPredictionState createState() => _GenderPredictionState();
}

class _GenderPredictionState extends State<GenderPrediction> {
  TextEditingController nameController = TextEditingController();
  String gender = '';

  Future<void> predictGender(String name) async {
    final response = await http.get(Uri.parse('https://api.genderize.io/?name=$name'));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        gender = jsonResponse['gender'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo.jpg'), 
                fit: BoxFit.cover, 
              ),
            ),
          ),
          
          Column(
            children: [
              
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white), 
                      onPressed: () {
                        Navigator.pop(context); 
                      },
                    ),
                    SizedBox(width: 20), 
                    Text(
                      'Predicción de género',
                      style: TextStyle(color: Colors.white, fontSize: 24), 
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: nameController,
                    style: TextStyle(color: Colors.white), 
                    cursorColor: Colors.white, 
                    decoration: InputDecoration(
                      labelText: 'Ingresa tu nombre',
                      labelStyle: TextStyle(color: Colors.white), 
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), 
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), 
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    predictGender(nameController.text);
                  },
                  child: Text(
                    'Predecir',
                    style: TextStyle(color: Colors.white), 
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, 
                    side: BorderSide(color: Colors.white, width: 2), 
                    elevation: 0, 
                    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5), 
      ),
                  ),
                ),
              ),
              if (gender != null)
                Container(
                  color: gender == 'male' ? Colors.blue : Colors.pink,
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'El género es $gender',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class AgePrediction extends StatefulWidget {
  @override
  _AgePredictionState createState() => _AgePredictionState();
}

class _AgePredictionState extends State<AgePrediction> {
  TextEditingController nameController = TextEditingController();
  int age = 0;
  String ageCategory = '';

  Future<void> predictAge(String name) async {
    final response = await http.get(Uri.parse('https://api.agify.io/?name=$name'));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        age = jsonResponse['age'];
        ageCategory = ageCategoryMessage(age);
      });
    }
  }

  String ageCategoryMessage(int age) {
    if (age < 18) return 'Joven';
    if (age < 60) return 'Adulto';
    return 'Anciano';
  }

  @override
  Widget build(BuildContext context) {
    
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: screenWidth * 0.06,
            left: screenWidth * 0.04,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: screenWidth * 0.05),
                Text(
                  'Determinación de Edad',
                  style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.06),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(0, -150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: TextFormField(
                    controller: nameController,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: 'Ingresa tu nombre',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                  child: ElevatedButton(
                    onPressed: () {
                      predictAge(nameController.text);
                    },
                    child: Text(
                      'Determinar Edad',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: BorderSide(color: Colors.white, width: 2),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                if (ageCategory.isNotEmpty) 
                  Column(
                    children: [
                      Text(
                        'Edad: $age, Categoría: $ageCategory',
                        style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white),
                      ),
                      SizedBox(
                        width: screenWidth * 0.25,
                        height: screenWidth * 0.25,
                        child: FutureBuilder(
                          future: precacheImage(AssetImage('assets/${ageCategory.toLowerCase()}.jpg'), context),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return Image.asset('assets/${ageCategory.toLowerCase()}.jpg');
                            } else if (snapshot.hasError) {
                              return Text('Error al cargar la imagen', style: TextStyle(color: Colors.red));
                            }
                            return CircularProgressIndicator(); 
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class UniversitySearch extends StatefulWidget {
  @override
  _UniversitySearchState createState() => _UniversitySearchState();
}

class _UniversitySearchState extends State<UniversitySearch> {
  TextEditingController countryController = TextEditingController();
  List universities = [];

  Future<void> getUniversities(String country) async {
    try {
      final response = await http.get(Uri.parse('http://universities.hipolabs.com/search?country=$country'));
      if (response.statusCode == 200) {
        setState(() {
          universities = jsonDecode(response.body);
        });
      } else {
        
        setState(() {
          universities = [];
        });
      }
    } catch (e) {
     
      setState(() {
        universities = [];
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/fondo.jpg', fit: BoxFit.cover, height: double.infinity),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15, left: 15),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); 
                      },
                    ),
                    SizedBox(width: 10), 
                    Text(
                      'Universidades por País',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: countryController,
                  style: TextStyle(color: Colors.white), 
                  cursorColor: Colors.white, 
                  decoration: InputDecoration(
                    labelText: 'Ingresa el nombre del país en inglés',
                    labelStyle: TextStyle(color: Colors.white), 
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), 
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), 
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10), 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    getUniversities(countryController.text);
                  },
                  child: Text(
                    'Buscar Universidades',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, 
                    side: BorderSide(color: Colors.white, width: 2),
                    elevation: 0, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), 
                    ),
                  ),
                ),
              ),
              Expanded(
                child: universities.isNotEmpty
                  ? ListView.builder(
                      itemCount: universities.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(universities[index]['name'], style: TextStyle(color: Colors.white)),
                          subtitle: Text(universities[index]['domains'][0], style: TextStyle(color: Colors.white)),
                          trailing: IconButton(
                            icon: Icon(Icons.link, color: Colors.white),
                            onPressed: () {
                              launch(universities[index]['web_pages'][0]);
                            },
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No se encontraron universidades',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.transparent, 
    );
  }
}


class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  String _city = "Santo Domingo"; 

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
  try {
    final data = await _weatherService.getWeather(_city);
    print(data); 
    setState(() {
      _weatherData = data;
    });
  } catch (e) {
    print("Error al obtener el clima: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'), 
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenWidth * 0.06, left: screenWidth * 0.04), 
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white), 
                    onPressed: () {
                      Navigator.pop(context); 
                    },
                  ),
                  SizedBox(width: screenWidth * 0.02), 
                  Text(
                    'Clima en $_city',
                    style: TextStyle(fontSize: screenWidth * 0.06, color: Colors.white), 
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: _weatherData == null
                    ? CircularProgressIndicator()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${_weatherData!['main']['temp']}°C',
                            style: TextStyle(fontSize: screenWidth * 0.12, color: Colors.white), 
                          ),
                          SizedBox(height: screenWidth * 0.02), 
                          Text(
                            _weatherData!['weather'][0]['description'],
                            style: TextStyle(fontSize: screenWidth * 0.06, color: Colors.white), 
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class WordPressNews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'), 
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 15), 
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white), 
                    onPressed: () {
                      Navigator.pop(context); 
                    },
                  ),
                  SizedBox(width: 15), 
                  Text(
                    'Noticias desde WordPress',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'), 
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenWidth * 0.06, left: screenWidth * 0.04), 
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); 
                    },
                  ),
                  SizedBox(width: screenWidth * 0.04), 
                  Text(
                    'Acerca de',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.06, 
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenWidth * 0.25), 
            CircleAvatar(
              radius: screenWidth * 0.12, 
              backgroundImage: AssetImage('assets/yo2.jpeg'), 
            ),
            SizedBox(height: screenWidth * 0.02), 
            Text(
              'Daniel José',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.05, 
              ),
            ),
            SizedBox(height: screenWidth * 0.01), 
            Text(
              '20220786@itla.edu.do',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.04, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}

          
