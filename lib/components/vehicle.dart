/// klasa vozila za dropdownlistu
class Vehicle {
  int id;
  String name;
  Vehicle(this.id, this.name);
  static List<Vehicle> getVehicle() {
    return <Vehicle>[
      Vehicle(1, "Kiper"),
      Vehicle(2, "Cisterna"),
      Vehicle(3, "Kamion - kran"),
      Vehicle(4, "Šleper sa jednom poluprikolicom"),
      Vehicle(5, "Šleper sa dvije poluprikolice"),
      Vehicle(6, "Šleper sa više poluprikolica"),
      Vehicle(7, "Pick up"),
      Vehicle(8, "Kombi"),
      Vehicle(9, "Traktor"),
    ];
  }
}