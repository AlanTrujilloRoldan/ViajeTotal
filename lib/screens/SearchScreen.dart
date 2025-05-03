import 'package:flutter/material.dart';
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController locationController = TextEditingController();
  int guests = 1;
  DateTimeRange? dates;
  List<String> results = [];

  Future<void> _selectDates() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => dates = picked);
    }
  }

  void _search() async {
    // Simulación o llamada real a una API pública
    setState(() {
      results = [
        "Lugar 1 en ${locationController.text}",
        "Lugar 2 en ${locationController.text}",
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Explorar")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: "¿A dónde quieres ir?"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectDates,
              child: Text(dates == null
                  ? "Seleccionar fechas"
                  : "${dates!.start.toLocal()} - ${dates!.end.toLocal()}"),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("Huéspedes:"),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (guests > 1) setState(() => guests--);
                  },
                ),
                Text('$guests'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() => guests++);
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _search,
              child: Text("Buscar"),
            ),
            SizedBox(height: 20),
            ...results.map((r) => ListTile(title: Text(r))).toList(),
          ],
        ),
      ),
    );
  }
}
