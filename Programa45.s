// ===============================================
// Estudiante y No de control: Cruz Patiño Diego - 22210297
// Descripción: Programa en ensamblador ARM64 Verificar si un número es Armstrong
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================

/*
using System;

class ArmstrongNumber
{
    static void Main()
    {
        Console.Write("Introduce un número: ");
        int numero = int.Parse(Console.ReadLine());

        // Convertir el número a string para contar el número de dígitos
        string numeroStr = numero.ToString();
        int numeroDeDigitos = numeroStr.Length;
        
        int suma = 0;
        int temp = numero;

        // Verificar si el número es Armstrong
        while (temp > 0)
        {
            int digito = temp % 10;  // Obtener el último dígito
            suma += (int)Math.Pow(digito, numeroDeDigitos);  // Sumar el dígito elevado a la potencia del número de dígitos
            temp /= 10;  // Eliminar el último dígito
        }

        // Verificar si la suma es igual al número original
        if (suma == numero)
        {
            Console.WriteLine($"{numero} es un número Armstrong.");
        }
        else
        {
            Console.WriteLine($"{numero} no es un número Armstrong.");
        }
    }
}

*/

// ===============================================
// Archivo C
// ===============================================

/*
#include <stdio.h>
#include <math.h>

// Declaración de la función en ensamblador
extern int EsArmstrong(int numero);

int main() {
    int numero;

    // Solicitar al usuario un número
    printf("Introduce un número: ");
    if (scanf("%d", &numero) != 1) {
        printf("Por favor ingresa un número válido.\n");
        return 1;  // Salir si no se ingresa un número válido
    }

    // Llamar a la función para verificar si el número es Armstrong
    int resultado = EsArmstrong(numero);
    if (resultado == 1) {
        printf("%d es un número Armstrong.\n", numero);
    } else {
        printf("%d no es un número Armstrong.\n", numero);
    }

    return 0;
}

*/

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================
.global EsArmstrong

// x0: número de entrada
// x1: copia del número para trabajar
// x2: suma de potencias
// x3: contador de dígitos
// x4: dígito actual
// x5: base para potencia
// x6: resultado de potencia
// x7: contador para potencia
// x8: valor constante 10 (para divisiones)

EsArmstrong:
    // Guardar registros
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    
    mov x19, x0                  // Guardar número original
    mov x1, x0                   // Copiar número para contar dígitos
    mov x3, 0                    // Inicializar contador de dígitos

contar_digitos:
    cbz x1, preparar_calculo     // Si x1 es 0, terminar conteo
    mov x8, #10                  // Cargar el valor 10 en x8 (para divisiones)
    udiv x1, x1, x8              // Dividir por 10 usando x8 como divisor
    add x3, x3, #1               // Incrementar contador
    b contar_digitos

preparar_calculo:
    mov x1, x19                  // Restaurar número original
    mov x2, #0                   // Inicializar suma de potencias
    mov x8, #10                  // Cargar el valor 10 en x8 (para divisiones)

procesar_digitos:
    cbz x1, verificar            // Si no hay más dígitos, verificar resultado
    
    // Obtener último dígito
    mov x4, x1                   // Copiar número actual a x4
    udiv x1, x1, x8              // Actualizar x1 (quitar último dígito)
    mul x5, x4, x8               // x5 = x4 * 10 (base * 10)
    sub x4, x4, x5               // x4 = x4 - (x4 * 10) -> último dígito
    
    // Calcular potencia
    mov x5, x4                   // Base = dígito
    mov x6, #1                   // Resultado inicial = 1
    mov x7, x3                   // Contador = número de dígitos

calcular_potencia:
    cbz x7, sumar_potencia       // Si contador es 0, sumar resultado
    mul x6, x6, x5               // Multiplicar por base
    sub x7, x7, #1               // Decrementar contador
    b calcular_potencia

sumar_potencia:
    add x2, x2, x6               // Sumar potencia al total
    b procesar_digitos

verificar:
    cmp x2, x19                  // Comparar suma con número original
    cset w0, eq                  // Establecer resultado (1 si igual, 0 si no)
    
    // Restaurar registros
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
