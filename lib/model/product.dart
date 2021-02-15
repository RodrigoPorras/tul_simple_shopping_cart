import 'dart:convert';

Product productFromJson(String str) => Product.fromMap(json.decode(str));

class Product {
  Product({this.id, this.nombre, this.sku, this.descripcion, this.imagesSrc});

  String id;
  String nombre;
  String sku;
  String descripcion;
  List<String> imagesSrc;

  factory Product.fromMap(Map<String, dynamic> map) => Product(
      id: map["id"],
      nombre: map["nombre"],
      sku: map["sku"],
      descripcion: map["descripcion"],
      imagesSrc: map["images_src"] != null
          ? List<String>.from(map["images_src"])
          : null);
}
