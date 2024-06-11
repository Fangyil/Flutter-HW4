import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transmed/sign/welcome_page.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile(
      {super.key,
      required this.name,
      required this.email,
      required this.token});

  final String token;
  final String name;
  final String email;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static const List<Widget> sexual = <Widget>[
    Text('Male'),
    Text('Female'),
    Text('Others')
  ];
  final List<bool> _selectedsexual = <bool>[false, false, true];
  final dateFormatter = DateFormat('yyyy-MM-dd');
  late DateTime selectedDate = DateTime.now();
  int age = 0;
  double _currentSliderPrimaryValue = 0;
  String countryName = 'No country';
  String click = 'click';
  String pic = '';

  Future<void> logout() async {
    // 删除登录数据，
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    setState(() {
      if (pickedDate != null) {
        selectedDate = pickedDate;
        debugPrint(dateFormatter.format(selectedDate));
        age = DateTime.now().year - pickedDate.year;
        _currentSliderPrimaryValue = age.toDouble();
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(5.0),
        children: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: const Text('CHOOSE YOUR PICTURE'),
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () {
                          _takePhoto(click);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Text('TAKE A PHOTO 📷'),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          _openGallery(click);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Text('FROM YOUR ALBUM 🖼️'),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              width: 165,
              height: 165,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                // 圆角边框
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                    image: (pic == '')
                        ? const AssetImage('assets/cat.jpg')
                        : FileImage(File(pic)) as ImageProvider,
                    fit: BoxFit.cover),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Name'),
            trailing: Text(
              widget.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // Navigate to edit profile information screen
            },
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Country',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: TextButton(
              onPressed: () {
                showCountryPicker(
                  context: context,
                  moveAlongWithKeyboard: true,
                  onSelect: (Country country) {
                    setState(() {
                      countryName = RegExp(r'^[^(]+')
                          .stringMatch(country.displayName)!
                          .trim();
                    });
                  },
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(countryName),
                  const Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Date of Birth'),
            trailing: FilledButton(
              onPressed: _presentDatePicker,
              child: Text(dateFormatter.format(selectedDate)),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Age'),
            trailing: SizedBox(
              width: 255,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Slider(
                    value: (_currentSliderPrimaryValue != 0)
                        ? _currentSliderPrimaryValue
                        : age.toDouble(),
                    label: _currentSliderPrimaryValue.round().toString(),
                    max: 150,
                    divisions: 150,
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderPrimaryValue = value;
                      });
                    },
                  ),
                  Text(
                    _currentSliderPrimaryValue.round().toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Sexual'),
            trailing: ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  // The button that is tapped is set to true, and the others to false.
                  for (int i = 0; i < _selectedsexual.length; i++) {
                    _selectedsexual[i] = i == index;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.red[700],
              selectedColor: Colors.white,
              fillColor: Colors.red[200],
              color: Colors.red[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 70.0,
              ),
              isSelected: _selectedsexual,
              children: sexual,
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('E-mail'),
            trailing: Text(
              widget.email,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            onTap: () {},
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  logout();
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Welcome()),
                  );
                },
                child: const Text('LOG OUT'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Welcome()),
                  );
                },
                child: const Text('LEAVE'),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  _takePhoto(String a) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        if (a == 'click') {
          pic = File(image.path).path;
        }
        Navigator.of(context).pop();
      }
    });
  }

  /*相册*/
  _openGallery(String a) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        if (a == 'click') {
          pic = File(image.path).path;
        }
        Navigator.of(context).pop();
      }
    });
  }
}
