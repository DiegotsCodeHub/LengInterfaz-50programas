// ===============================================
// Estudiante y No de control: Cruz Patiño Diego - 22210297
// Descripción: Programa en ensamblador ARM64 Calculadora simple (Suma, Resta, Multiplicación, División)
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================

/*
using System;

class Calculadora
{
    static void Main()
    {
        bool continuar = true;
        
        while (continuar)
        {
            Console.WriteLine("Seleccione la operación que desea realizar:");
            Console.WriteLine("1 - Suma");
            Console.WriteLine("2 - Resta");
            Console.WriteLine("3 - Multiplicación");
            Console.WriteLine("4 - División");
            Console.WriteLine("5 - Salir");
            
            Console.Write("Ingrese su opción: ");
            int opcion = int.Parse(Console.ReadLine());

            if (opcion == 5)
            {
                continuar = false;
                Console.WriteLine("Saliendo de la calculadora...");
                break;
            }

            Console.Write("Ingrese el primer número: ");
            double num1 = double.Parse(Console.ReadLine());
            
            Console.Write("Ingrese el segundo número: ");
            double num2 = double.Parse(Console.ReadLine());
            
            double resultado = 0;

            switch (opcion)
            {
                case 1:
                    resultado = num1 + num2;
                    Console.WriteLine($"Resultado de la suma: {resultado}");
                    break;
                case 2:
                    resultado = num1 - num2;
                    Console.WriteLine($"Resultado de la resta: {resultado}");
                    break;
                case 3:
                    resultado = num1 * num2;
                    Console.WriteLine($"Resultado de la multiplicación: {resultado}");
                    break;
                case 4:
                    if (num2 != 0)
                    {
                        resultado = num1 / num2;
                        Console.WriteLine($"Resultado de la división: {resultado}");
                    }
                    else
                    {
                        Console.WriteLine("Error: No se puede dividir entre cero.");
                    }
                    break;
                default:
                    Console.WriteLine("Opción no válida. Intente de nuevo.");
                    break;
            }

            Console.WriteLine(); // Línea en blanco para separar las operaciones
        }
    }
}

*/

// ===============================================
// Archivo C
// ===============================================

/*
#include <stdio.h>

// Declaración de las funciones en ensamblador
extern int Sumar(int a, int b);
extern int Restar(int a, int b);
extern int Multiplicar(int a, int b);
extern int Dividir(int a, int b);

int main() {
    int num1, num2, opcion, resultado;

    // Solicitar al usuario los dos números
    printf("Introduce el primer número: ");
    scanf("%d", &num1);
    
    printf("Introduce el segundo número: ");
    scanf("%d", &num2);

    // Mostrar las opciones para seleccionar la operación
    printf("Selecciona la operación:\n");
    printf("1 - Suma\n");
    printf("2 - Resta\n");
    printf("3 - Multiplicación\n");
    printf("4 - División\n");
    printf("Ingrese su opción: ");
    scanf("%d", &opcion);

    // Realizar la operación correspondiente según la opción seleccionada
    switch (opcion) {
        case 1:
            resultado = Sumar(num1, num2); // Suma
            printf("Resultado: %d + %d = %d\n", num1, num2, resultado);
            break;
        case 2:
            resultado = Restar(num1, num2); // Resta
            printf("Resultado: %d - %d = %d\n", num1, num2, resultado);
            break;
        case 3:
            resultado = Multiplicar(num1, num2); // Multiplicación
            printf("Resultado: %d * %d = %d\n", num1, num2, resultado);
            break;
        case 4:
            if (num2 != 0) { // Verificar división por cero
                resultado = Dividir(num1, num2); // División
                printf("Resultado: %d / %d = %d\n", num1, num2, resultado);
            } else {
                printf("Error: División por cero.\n");
            }
            break;
        default:
            printf("Opción inválida.\n");
            break;
    }

    return 0;
}

*/

// ===============================================
// Solucion en ARM64 Assembler
// ===============================================

.global Sumar
.global Restar
.global Multiplicar
.global Dividir

// Suma: retorna a + b
Sumar:
    add w0, w0, w1       // Sumar el primer y segundo argumento en w0
    ret

// Resta: retorna a - b
Restar:
    sub w0, w0, w1       // Restar el segundo argumento de w0
    ret

// Multiplicación: retorna a * b
Multiplicar:
    mul w0, w0, w1       // Multiplicar w0 * w1 y almacenar en w0
    ret

// División: retorna a / b (b debe ser distinto de 0)
Dividir:
    cbz w1, div_by_zero  // Comprobar si el divisor es 0
    sdiv w0, w0, w1      // Dividir w0 / w1 y almacenar en w0
    ret
div_by_zero:
    mov w0, 0            // Si el divisor es 0, retornar 0
    ret
