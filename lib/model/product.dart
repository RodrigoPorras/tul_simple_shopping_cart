import 'dart:convert';

Product productFromJson(String str) => Product.fromMap(json.decode(str));

class Product {
  Product({
    this.id,
    this.nombre,
    this.sku,
    this.descripcion,
  });

  String id;
  String nombre;
  String sku;
  String descripcion;

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map["id"],
        nombre: map["nombre"],
        sku: map["sku"],
        descripcion: map["descripcion"],
      );
}
