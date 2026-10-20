/* 
Enunciado:
Diseñar una función llamada 'calcularCostoEnvio' para una empresa de logística.

Requerimientos:
1. La función debe utilizar únicamente parámetros con nombre entre llaves {}:
   - 'pesoKg': parámetro obligatorio de tipo double (required double).
   - 'destino': parámetro obligatorio de tipo String (required String).
   - 'envioExpress': parámetro opcional de tipo bool con un valor por defecto de false.
2. Regla de cálculo:
   - El precio base por kilogramo es de $5.0.
   - Si 'envioExpress' es true, la tarifa por kilogramo aumenta a $7.5.
   - Si 'destino' es "Cali" hace un descuento del 10% al costo de envio.
   - La función debe retornar el costo total del envío (pesoKg * tarifaPorKg) como un double.
3. En la función main():
   - Invocar la función con envío normal ('envioExpress' omitido) e imprimir el total.
   - Invocar la función con envío express ('envioExpress: true') e imprimir el total. */

void main() {
  double resultado1 = calcularCostoEnvio(pesoKg: 100, destino: "Monteria");
  double resultado2 = calcularCostoEnvio(pesoKg: 100, destino: "Cali");
  double resultado3 =
      calcularCostoEnvio(pesoKg: 100, destino: "pereira", envioExpress: true);

  print("El precio del envio 1 es de: $resultado1");
  print("El precio del envio 2 es de: $resultado2");
  print("El precio del envio 3 es de: $resultado3");
}

double calcularCostoEnvio(
    {required double pesoKg,
    required String destino,
    bool envioExpress = false}) {
  double precioBase = 5.0;

  if (envioExpress == true) {
    precioBase = 7.5;
  }

  double resultado = pesoKg * precioBase;

  if (destino == "Cali") {
    return resultado * 0.9;
  }

  return resultado;
}
