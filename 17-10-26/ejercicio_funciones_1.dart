/* Crear una función en Dart llamada 'calcularPrecioFinal' que calcule el costo de un
producto aplicando un porcentaje de descuento opcional.

Requerimientos:
1. La función debe recibir dos parámetros posicionales:
   - 'precioOriginal' (double): parámetro obligatorio.
   - 'porcentajeDescuento' (double opcional entre corchetes 
   [double porcentajeDescuento = 0.0]):
     representa el porcentaje de descuento (ejemplo: 15.0 para 15%). Tiene un valor
     por defecto de 0.0. para calcular el precio con descuento la formula es:
     precioOriginal * (porcentajeDescuento / 100);
2. Si 'porcentajeDescuento' es menor a 0.0 o mayor a 100.0, la función debe imprimir un
   mensaje de advertencia indicando que el porcentaje es inválido y 
   retornar el 'precioOriginal'
   sin modificaciones.
3. De lo contrario, calcula el valor del descuento y retorna el precio final 
  con el descuento aplicado.
4. En la función main(), invocar a 'calcularPrecioFinal' en tres escenarios:
   a) Pasando únicamente el precio original ($100.0) sin descuento.
   b) Pasando un precio original ($200.0) y un descuento válido (15.0%).
   c) Pasando un precio original ($50.0) y un descuento inválido (120.0%).
5. Imprimir los tres resultados formateados a 2 decimales usando .toStringAsFixed(2). */

void main() {
  var result = calcularPrecioFinal(100, 10);
  var result2 = calcularPrecioFinal(100, 200);

  // print("El precio final del resultado 1 es $result");
  print("El precio final del resultado 2 es $result2");
}

double calcularPrecioFinal(double precioOriginal, [double porcentajeDescuento = 0.0]) {

  if (porcentajeDescuento < 0.0 || porcentajeDescuento > 100) {
    print("Error con el porcentaje, valor invalido");
    return precioOriginal;
  }

  double precioDescuento = precioOriginal * (porcentajeDescuento / 100);

  return precioOriginal - precioDescuento;
}