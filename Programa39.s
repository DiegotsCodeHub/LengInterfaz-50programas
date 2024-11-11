// ===============================================
// Estudiante y No de control: Cruz Patiño Diego - 22210297
// Descripción: Programa en ensamblador ARM64 Convertir decimal a binario
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================

/*
using System;

class Program
{
    static string DecimalToBinary(long number)
    {
        // Si el número es 0, devolver "0"
        if (number == 0)
        {
            return "0";
        }

        string binary = "";

        // Convertir el número decimal a binario
        while (number > 0)
        {
            binary = (number % 2) + binary;  // Concatenar el residuo al inicio
            number /= 2;  // Dividir el número entre 2
        }

        return binary;
    }

    static void Main()
    {
        Console.WriteLine("Conversor de Decimal a Binario");

        while (true)
        {
            Console.Write("\nIngrese un número decimal: ");
            if (long.TryParse(Console.ReadLine(), out long number))
            {
                string binary = DecimalToBinary(number);  // Convertir a binario
                Console.WriteLine($"Número decimal: {number}");
                Console.WriteLine($"Número binario: {binary}");
            }
            else
            {
                Console.WriteLine("Error: Ingrese un número válido.");
            }

            Console.Write("\n¿Desea convertir otro número? (s/n): ");
            string answer = Console.ReadLine();
            if (answer.ToLower() != "s")
            {
                break;  // Salir si el usuario no quiere continuar
            }
        }
    }
}

*/


// ===============================================
// Archivo C
// ===============================================

/*
#include <stdio.h>
#include <stdlib.h>
#include <string.h>  // Incluir string.h para usar strlen

extern void decimal_to_binary(long number);  // Declarar las funciones del ensamblador
extern long get_bit(int index);
extern int get_size();

// Función para obtener la representación binaria de un número
void get_binary_string(long number, char *result)
{
    decimal_to_binary(number);
    int size = get_size();

    // Construir el string binario desde el último bit hasta el primero
    for (int i = size - 1; i >= 0; i--)
    {
        result[size - 1 - i] = get_bit(i) + '0';  // Convertir bit a caracter
    }
    result[size] = '\0';  // Finalizar la cadena de caracteres
}

int main()
{
    while (1)
    {
        int opcion;
        printf("\nConversor de Decimal a Binario\n");
        printf("1. Convertir número\n");
        printf("0. Salir\n");
        printf("Seleccione una opción: ");

        if (scanf("%d", &opcion) != 1)
        {
            printf("Error: Ingrese un número válido.\n");
            while (getchar() != '\n');  // Limpiar el buffer de entrada
            continue;
        }

        switch (opcion)
        {
        case 1:
        {
            long numero;
            printf("\nIngrese un número decimal (0-9223372036854775807): ");
            if (scanf("%ld", &numero) != 1)
            {
                printf("Error: Ingrese un número válido.\n");
                while (getchar() != '\n');  // Limpiar el buffer de entrada
                break;
            }

            if (numero < 0)
            {
                printf("Por favor, ingrese un número positivo.\n");
                break;
            }

            char binario[65];  // Buffer para la cadena binaria (máximo 64 bits + 1 para el '\0')
            get_binary_string(numero, binario);
            printf("\nNúmero decimal: %ld\n", numero);
            printf("Número binario: %s\n", binario);

            // Mostrar información adicional
            printf("Cantidad de bits: %lu\n", strlen(binario));  // Uso de strlen
            if (binario[0] != '\0')
            {
                printf("Bit más significativo: %c\n", binario[0]);
                printf("Bit menos significativo: %c\n", binario[strlen(binario) - 1]);
            }
            break;
        }
        case 0:
            printf("Saliendo del programa...\n");
            return 0;

        default:
            printf("Opción no válida.\n");
            break;
        }
    }

    return 0;
}

*/

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================
.data
    .align 3
    binary_array: .skip 64      // Espacio para 64 bits (suficiente para un long)
    result_size: .word 0        // Cantidad de bits en el resultado

.text
.align 2
.global decimal_to_binary
.global get_bit
.global get_size

// Función para convertir decimal a binario
// Entrada: x0 = número decimal
decimal_to_binary:
    stp     x29, x30, [sp, -32]!
    mov     x29, sp
    str     x19, [sp, 16]      // Guardar x19 para usarlo
    
    mov     x19, x0            // Guardar número original en x19
    
    // Reiniciar contador de bits
    adrp    x0, result_size
    add     x0, x0, :lo12:result_size
    str     wzr, [x0]
    
    // Si el número es 0, manejar caso especial
    cbnz    x19, conversion_loop
    
    // Caso especial para 0
    adrp    x0, binary_array
    add     x0, x0, :lo12:binary_array
    strb    wzr, [x0]
    
    adrp    x0, result_size
    add     x0, x0, :lo12:result_size
    mov     w1, #1
    str     w1, [x0]
    b       end_conversion

conversion_loop:
    // Mientras el número no sea 0
    cbz     x19, end_conversion
    
    // Obtener el bit actual (número & 1)
    and     w1, w19, #1
    
    // Obtener índice actual
    adrp    x2, result_size
    add     x2, x2, :lo12:result_size
    ldr     w3, [x2]
    
    // Guardar el bit en el array
    adrp    x4, binary_array
    add     x4, x4, :lo12:binary_array
    strb    w1, [x4, x3]
    
    // Incrementar contador
    add     w3, w3, #1
    str     w3, [x2]
    
    // Dividir número entre 2 (shift right)
    lsr     x19, x19, #1
    
    b       conversion_loop

end_conversion:
    ldr     x19, [sp, 16]      // Restaurar x19
    ldp     x29, x30, [sp], 32
    ret

// Función para obtener un bit específico del resultado
// Entrada: x0 = índice del bit
// Salida: x0 = valor del bit (0 o 1)
get_bit:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    
    // Verificar que el índice sea válido
    adrp    x1, result_size
    add     x1, x1, :lo12:result_size
    ldr     w1, [x1]
    cmp     w0, w1
    b.ge    invalid_index
    
    // Obtener el bit del array
    adrp    x1, binary_array
    add     x1, x1, :lo12:binary_array
    ldrb    w0, [x1, x0]
    
    ldp     x29, x30, [sp], 16
    ret

invalid_index:
    mov     x0, #-1            // Retornar -1 para índice inválido
    ldp     x29, x30, [sp], 16
    ret

// Función para obtener el tamaño del resultado binario
// Salida: x0 = cantidad de bits
get_size:
    adrp    x0, result_size
    add     x0, x0, :lo12:result_size
    ldr     w0, [x0]
    ret
