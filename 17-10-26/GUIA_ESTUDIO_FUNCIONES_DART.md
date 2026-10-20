# Guía de Estudio: Funciones en Dart — Parámetros, Validaciones y Buenas Prácticas

**Curso:** Desarrollo de Aplicaciones Móviles  
**Institución:** Universidad Pontificia Bolivariana (UPB)  
**Tema:** Funciones en Dart: Parámetros Posicionales Opcionales vs. Parámetros Nombrados  
**Fecha de clase:** 17 de Octubre de 2026  

---

## Introducción

En el desarrollo de software (y particularmente en Flutter), las funciones y los métodos son los bloques fundamentales de construcción. Una firma de función mal diseñada genera confusión, bugs y código difícil de mantener.

En esta guía analizamos los dos ejercicios resueltos en clase, desglosando **qué se hizo**, **cómo funciona la sintaxis en Dart** y, lo más importante, **por qué se tomó cada decisión de diseño**.

---

## Ejercicio 1: Parámetros Posicionales Opcionales y Cláusulas de Guarda

### 1.1 Enunciado y Requerimientos

Diseñar una función llamada `calcularPrecioFinal` que calcule el costo de un producto aplicando un porcentaje de descuento opcional.

**Requerimientos técnicos:**
1. **Parámetros posicionales:**
   - `precioOriginal` (`double`): parámetro obligatorio.
   - `porcentajeDescuento` (`double`, opcional entre corchetes `[double porcentajeDescuento = 0.0]`): valor por defecto `0.0`.
2. **Validación:** Si `porcentajeDescuento` es menor a `0.0` o mayor a `100.0`, imprimir una advertencia indicando que el porcentaje es inválido y retornar el `precioOriginal` intacto.
3. **Cálculo:** Si el porcentaje es válido, calcular el descuento y retornar el precio final (`precioOriginal - descuento`).
4. **Ejecución (`main`):** Probar tres escenarios:
   - a) Únicamente precio original ($100.0) sin descuento.
   - b) Precio original ($200.0) con descuento válido (15.0%).
   - c) Precio original ($50.0) con descuento inválido (120.0%).
5. **Formateo:** Imprimir los resultados con dos decimales usando `.toStringAsFixed(2)`.

---

### 1.2 Solución Completa en Dart

```dart
void main() {
  // Escenario A: Sin descuento (se usa el valor por defecto: 0.0%)
  double resultadoSinDescuento = calcularPrecioFinal(100.0);

  // Escenario B: Descuento válido del 15%
  double resultadoConDescuento = calcularPrecioFinal(200.0, 15.0);

  // Escenario C: Descuento fuera de rango (120%)
  double resultadoDescuentoInvalido = calcularPrecioFinal(50.0, 120.0);

  print('--- RESULTADOS EJERCICIO 1 ---');
  print('Escenario A (Sin descuento): \$${resultadoSinDescuento.toStringAsFixed(2)}');
  print('Escenario B (Descuento 15%):  \$${resultadoConDescuento.toStringAsFixed(2)}');
  print('Escenario C (Inválido 120%):  \$${resultadoDescuentoInvalido.toStringAsFixed(2)}');
}

/// Calcula el precio final de un producto aplicando un descuento opcional.
/// 
/// [precioOriginal] es obligatorio.
/// [porcentajeDescuento] es opcional posicional; si se omite, vale 0.0.
double calcularPrecioFinal(double precioOriginal, [double porcentajeDescuento = 0.0]) {
  // 1. Cláusula de guarda: valida el rango permitido (0 a 100)
  if (porcentajeDescuento < 0.0 || porcentajeDescuento > 100.0) {
    print('Advertencia: El porcentaje de descuento ($porcentajeDescuento%) es inválido. Debe estar entre 0 y 100.');
    return precioOriginal;
  }

  // 2. Cálculo del monto a descontar
  double descuento = precioOriginal * (porcentajeDescuento / 100.0);

  // 3. Retorno del valor final
  return precioOriginal - descuento;
}
```

---

### 1.3 Explicación Paso a Paso: ¿Qué se hizo y por qué?

#### A. Parámetros posicionales opcionales `[tipo nombre = defecto]`
- **¿Qué es?** En Dart, encerrar parámetros entre corchetes `[...]` indica que quien llame a la función no está obligado a pasar ese argumento.
- **¿Por qué tiene un valor por defecto (`= 0.0`)?** Si no asignamos un valor por defecto o no usamos tipos nulables (`double?`), Dart no compila debido a su sistema de *Sound Null Safety*. Asignar `0.0` garantiza que la variable siempre contenga un número válido para operar matemáticamente.
- **Regla posicional:** Los parámetros opcionales posicionales siempre deben definirse **al final** de la lista de parámetros.

#### B. Cláusula de Guarda (*Guard Clause*)
- **¿Qué es?** Es el bloque `if` al inicio de la función:
  ```dart
  if (porcentajeDescuento < 0.0 || porcentajeDescuento > 100.0) {
    print('Advertencia: ...');
    return precioOriginal;
  }
  ```
- **¿Por qué se hace así?** En lugar de meter el código principal dentro de un `else` gigante y anidado, evaluamos primero la condición de error y salimos de inmediato con un `return`. Esto reduce la complejidad cognitiva del código (*Clean Code*).

#### C. Formateo con `.toStringAsFixed(2)`
- **¿Por qué no imprimir el `double` directamente?** Los números en punto flotante pueden generar valores como `85.00000000000001` debido a la representación binaria IEEE 754. `.toStringAsFixed(2)` redondea de forma segura a 2 cifras decimales y devuelve un `String` listo para presentar en pantalla.

---

### 1.4 Salida en Consola Esperada

```text
Advertencia: El porcentaje de descuento (120.0%) es inválido. Debe estar entre 0 y 100.
--- RESULTADOS EJERCICIO 1 ---
Escenario A (Sin descuento): $100.00
Escenario B (Descuento 15%):  $170.00
Escenario C (Inválido 120%):  $50.00
```

---

## Ejercicio 2: Parámetros Nombrados (`Named Parameters`) y Reglas de Negocio

### 2.1 Enunciado y Requerimientos

Diseñar una función llamada `calcularCostoEnvio` para una empresa de logística.

**Requerimientos técnicos:**
1. **Parámetros con nombre (entre llaves `{}`):**
   - `pesoKg` (`double`, obligatorio mediante `required`).
   - `destino` (`String`, obligatorio mediante `required`).
   - `envioExpress` (`bool`, opcional con valor por defecto `false`).
2. **Reglas de cálculo:**
   - La tarifa base por kilogramo es de `$5.0`.
   - Si `envioExpress` es `true`, la tarifa base por kilogramo sube a `$7.5`.
   - Si el `destino` es `"Cali"`, se aplica un descuento del `10%` sobre el costo total del envío.
   - Retornar el costo total como un `double`.
3. **Ejecución (`main`):**
   - Invocar con envío normal (`envioExpress` omitido).
   - Invocar con destino "Cali" para verificar el descuento.
   - Invocar con envío express (`envioExpress: true`).

---

### 2.2 Solución Completa en Dart

```dart
void main() {
  // Caso 1: Envío normal a Montería (envioExpress omitido -> toma false)
  double costoMonteria = calcularCostoEnvio(
    pesoKg: 10.0,
    destino: 'Montería',
  );

  // Caso 2: Envío normal a Cali (aplica 10% de descuento sobre tarifa base de $5.0/kg)
  // 10 kg * $5.0 = $50.0 -> con 10% de descuento = $45.0
  double costoCali = calcularCostoEnvio(
    pesoKg: 10.0,
    destino: 'Cali',
  );

  // Caso 3: Envío express a Pereira (tarifa de $7.5/kg)
  // 10 kg * $7.5 = $75.0
  double costoPereiraExpress = calcularCostoEnvio(
    pesoKg: 10.0,
    destino: 'Pereira',
    envioExpress: true,
  );

  print('--- RESULTADOS EJERCICIO 2 ---');
  print('Envío Montería (Normal):        \$${costoMonteria.toStringAsFixed(2)}');
  print('Envío Cali (Normal con desc.):  \$${costoCali.toStringAsFixed(2)}');
  print('Envío Pereira (Express):        \$${costoPereiraExpress.toStringAsFixed(2)}');
}

/// Calcula el costo total de un envío logístico.
/// 
/// Utiliza parámetros nombrados para mejorar la claridad en la llamada.
double calcularCostoEnvio({
  required double pesoKg,
  required String destino,
  bool envioExpress = false,
}) {
  // 1. Determinar tarifa por kilogramo según el tipo de servicio
  double tarifaPorKg = envioExpress ? 7.5 : 5.0;

  // 2. Calcular costo base según peso
  double costoTotal = pesoKg * tarifaPorKg;

  // 3. Regla especial por destino: 10% de descuento para Cali
  // Usamos .toLowerCase().trim() para evitar errores si escriben "cali" o " Cali "
  if (destino.trim().toLowerCase() == 'cali') {
    costoTotal = costoTotal * 0.90;
  }

  return costoTotal;
}
```

---

### 2.3 Explicación Paso a Paso: ¿Qué se hizo y por qué?

#### A. Parámetros Nombrados `{}` y `required`
- **¿Qué problema resuelven?** Si la función fuese posicional:
  ```dart
  // Mala práctica (difícil de leer):
  calcularCostoEnvio(10.0, "Cali", true); // ¿Qué es 10.0? ¿Qué significa true?
  ```
  Al usar parámetros nombrados `{}`:
  ```dart
  // Buena práctica (auto-documentado):
  calcularCostoEnvio(pesoKg: 10.0, destino: "Cali", envioExpress: true);
  ```
  Al momento de leer el código, el programador sabe exactamente qué significa cada argumento sin necesidad de ir a revisar la definición de la función. Este es el patrón estándar usado en todos los Widgets de Flutter (`Container(width: 100, height: 200)`).

- **La palabra clave `required`:**
  Indica que el parámetro con nombre es **obligatorio**. Si el desarrollador olvida pasarlo, el compilador arroja un error antes de ejecutar el programa.

- **Parámetro nombrado opcional (`bool envioExpress = false`):**
  Como no lleva `required` y tiene un valor por defecto, quien llama la función puede omitirlo libremente.

#### B. Operador Ternario vs `if` simple
En clase se usó:
```dart
double precioBase = 5.0;
if (envioExpress == true) {
  precioBase = 7.5;
}
```
Podemos optimizarlo a:
```dart
double tarifaPorKg = envioExpress ? 7.5 : 5.0;
```
- **Por qué evitar `== true`:** La variable `envioExpress` ya es booleana. Comparar `booleano == true` es redundante. Basta con evaluar `if (envioExpress)`.
- **Por qué el operador ternario:** Permite definir la variable con un valor inicial coherente de forma directa y limpia.

#### C. Comparación Segura de Cadenas de Texto (`String`)
- En el código original teníamos `if (destino == "Cali")`.
- Si un usuario escribe `"cali"` (en minúsculas) o `"Cali "` (con un espacio al final), la condición fallaría silenciosamente.
- Usar `destino.trim().toLowerCase() == 'cali'` elimina espacios accidentales y homologa mayúsculas/minúsculas, haciendo la función robusta ante entradas de usuario.

---

### 2.4 Salida en Consola Esperada

```text
--- RESULTADOS EJERCICIO 2 ---
Envío Montería (Normal):        $50.00
Envío Cali (Normal con desc.):  $45.00
Envío Pereira (Express):        $75.00
```

---

## Tabla Resumen de Arquitectura: ¿Cuándo usar cada tipo de parámetro?

| Criterio | Parámetros Posicionales Opcionales `[...]` | Parámetros Nombrados `{...}` |
| :--- | :--- | :--- |
| **Sintaxis en la llamada** | `funcion(arg1, arg2);` | `funcion(param1: arg1, param2: arg2);` |
| **Orden de argumentos** | Estricto (el orden importa). | Flexible (se pueden pasar en cualquier orden). |
| **Legibilidad** | Baja cuando hay más de 2 parámetros. | **Muy alta** (cada valor lleva su etiqueta). |
| **Cuándo usarlo** | En funciones cortas y matemáticas con 1 o 2 parámetros muy intuitivos (ej: `dividir(10, [2])`). | **Estándar en Flutter**. En funciones o constructores con múltiples opciones de configuración. |

---

## Reto Extra para los Estudiantes (Para afianzar conocimientos)

1. En el **Ejercicio 1**, modifica la función para que reciba un tercer parámetro opcional llamado `impuestoIVA` con un valor por defecto de `19.0%` y calcula el precio final sumando primero el IVA y luego aplicando el descuento.
2. En el **Ejercicio 2**, agrega una nueva regla: si el `pesoKg` supera los `50.0` kg, debe cobrar un recargo por sobrepeso de `$20.0` fijos al costo final.
