// ===============================================
// Estudiante y No de control: Cruz Patiño Diego - 22210297
// Descripción: Programa en ensamblador ARM64 Conversión de hexadecimal a decimal
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================

/*
using System;

class Program
{
    static void Main()
    {
        Console.Write("Ingrese un número hexadecimal: ");
        string hex = Console.ReadLine();

        try
        {
            // Convertimos de hexadecimal a decimal
            int decimalValue = Convert.ToInt32(hex, 16);
            Console.WriteLine($"El valor decimal de {hex} es: {decimalValue}");
        }
        catch (FormatException)
        {
            Console.WriteLine("El valor ingresado no es un número hexadecimal válido.");
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

int main() {
    char hexNumber[100]; // Cadena para almacenar el número hexadecimal

    // Leer el número hexadecimal
    printf("Introduce un número hexadecimal: ");
    scanf("%s", hexNumber);

    // Convertir a decimal usando strtol, especificando base 16
    int decimalNumber = (int)strtol(hexNumber, NULL, 16);

    // Mostrar el resultado
    printf("El número decimal es: %d\n", decimalNumber);

    return 0;
}

*/

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================
.global hex_char_to_dec

// Convierte un carácter hexadecimal a decimal
// Entrada: w0 (carácter hexadecimal, como 'A' o 'F')
// Salida: w0 (valor decimal)
hex_char_to_dec:
    cmp w0, '0'
    blt invalid_hex               // Si es menor que '0', no es hexadecimal
    cmp w0, '9'
    ble convert_digit             // Si está entre '0' y '9', es dígito decimal

    cmp w0, 'A'
    blt invalid_hex               // Si es menor que 'A', no es hexadecimal
    cmp w0, 'F'
    ble convert_upper_letter      // Si está entre 'A' y 'F', es letra mayúscula

    cmp w0, 'a'
    blt invalid_hex               // Si es menor que 'a', no es hexadecimal
    cmp w0, 'f'
    ble convert_lower_letter      // Si está entre 'a' y 'f', es letra minúscula

invalid_hex:
    mov w0, -1                    // Retornar -1 si no es válido
    ret

convert_digit:
    sub w0, w0, '0'               // Convertir '0'-'9' a 0-9
    ret

convert_upper_letter:
    sub w0, w0, 'A'               // Convertir 'A'-'F' a 10-15
    add w0, w0, 10
    ret

convert_lower_letter:
    sub w0, w0, 'a'               // Convertir 'a'-'f' a 10-15
    add w0, w0, 10
    ret
