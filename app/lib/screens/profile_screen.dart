import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _selectedPanelSize;
  String? _selectedEfficiency;
  String _panelAge = '';

  final List<String> panelSizes = ['60 Cell', '72 Cell', '96 Cell'];
  final Map<String, String> efficiencyRatings = {
    'Polycrystalline': '13-16%',
    'Monocrystalline': '18-24%',
    'Thin-film': '7-13%',
    'Transparent': '1-10%',
    'Solar tiles': '10-20%',
    'Perovskite': '24-27%',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Account Details
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.orange[50],
            child: ListTile(
              leading: Icon(Icons.account_circle,
                  size: 40, color: Colors.orange[400]),
              title: Text('User Account'),
              subtitle: Text('user@example.com'),
              trailing: TextButton(
                onPressed: () {}, // Implement login/logout logic
                child: Text('Log Out',
                    style: TextStyle(color: Colors.orange[400])),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Solar Panel Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Panel Size Dropdown
          DropdownButtonFormField<String>(
            value: _selectedPanelSize,
            decoration: InputDecoration(
              labelText: 'Panel Size',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: panelSizes.map((size) {
              return DropdownMenuItem(value: size, child: Text(size));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedPanelSize = value;
              });
            },
          ),
          const SizedBox(height: 10),

          // Efficiency Dropdown
          DropdownButtonFormField<String>(
            value: _selectedEfficiency,
            decoration: InputDecoration(
              labelText: 'Efficiency',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: efficiencyRatings.entries.map((entry) {
              return DropdownMenuItem(
                  value: entry.key,
                  child: Text('${entry.key} (${entry.value})'));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedEfficiency = value;
              });
            },
          ),
          const SizedBox(height: 10),

          // Panel Age Input
          TextField(
            decoration: InputDecoration(
              labelText: 'Age of Panels (Years)',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _panelAge = value;
              });
            },
          ),
          const SizedBox(height: 20),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle save logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Solar Panel Data Saved')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[400],
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Save',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
