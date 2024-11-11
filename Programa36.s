// ===============================================
// Estudiante y No de control: Cruz Patiño Diego - 22210297
// Descripción: Programa en ensamblador ARM64 Encontrar el segundo elemento más grande
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
        // Solicitar el número de elementos en el arreglo
        Console.WriteLine("Introduce el número de elementos en el arreglo:");
        int n = Convert.ToInt32(Console.ReadLine());
        
        // Verificar que haya al menos dos elementos
        if (n < 2)
        {
            Console.WriteLine("El arreglo debe tener al menos dos elementos.");
            return;
        }

        int[] arreglo = new int[n];

        // Solicitar los elementos del arreglo
        Console.WriteLine("Introduce los elementos del arreglo:");
        for (int i = 0; i < n; i++)
        {
            Console.Write($"Elemento {i + 1}: ");
            arreglo[i] = Convert.ToInt32(Console.ReadLine());
        }

        // Llamar a la función para encontrar el segundo elemento más grande
        int segundoMayor = EncontrarSegundoMayor(arreglo);

        // Mostrar el resultado
        Console.WriteLine($"El segundo elemento más grande es: {segundoMayor}");
    }

    // Función para encontrar el segundo elemento más grande en el arreglo
    static int EncontrarSegundoMayor(int[] arreglo)
    {
        int mayor = int.MinValue;  // Inicializar el mayor con el valor mínimo posible
        int segundoMayor = int.MinValue;  // Inicializar el segundo mayor con el valor mínimo posible

        foreach (int numero in arreglo)
        {
            if (numero > mayor)
            {
                segundoMayor = mayor;  // El mayor anterior se convierte en el segundo mayor
                mayor = numero;  // Actualizar el mayor
            }
            else if (numero > segundoMayor && numero < mayor)
            {
                segundoMayor = numero;  // Actualizar el segundo mayor
            }
        }

        // Verificar si se encontró un segundo mayor
        if (segundoMayor == int.MinValue)
        {
            Console.WriteLine("No se encontró un segundo elemento más grande.");
            return -1;  // Indicar que no se encontró el segundo mayor
        }

        return segundoMayor;
    }
}
*/

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================

.data
arreglo1: .word 32145435, 5345, 12345, 6789, 10234  // Primer arreglo con 5 elementos
arreglo2: .word 10, 20, 5, 15, 25                   // Segundo arreglo con 5 elementos
tamano: .word 5                                     // Tamaño de los arreglos
msg_resultado: .string "El segundo elemento más grande es: %d\n"

.text
.global main
.align 2

main:
    // Prologo de la función main
    stp     x29, x30, [sp, #-16]!   // Guardar el frame pointer y el link register
    mov     x29, sp

    // Encontrar el segundo elemento más grande en el primer arreglo
    adrp    x2, arreglo1            // Dirección base del primer arreglo
    add     x2, x2, :lo12:arreglo1
    mov     w1, #5                  // Tamaño del arreglo
    mov     w3, #0                  // Mayor actual
    mov     w4, #0                  // Segundo mayor

loop_arreglo1:
    cbz     w1, fin_arreglo1        // Si el tamaño es 0, terminar el bucle

    ldr     w5, [x2], #4            // Cargar el elemento actual y avanzar
    sub     w1, w1, #1              // Decrementar el tamaño

    cmp     w5, w3                  // Comparar con el mayor actual
    b.le    no_actualizar1          // Si no es mayor, saltar

    mov     w4, w3                  // Actualizar el segundo mayor
    mov     w3, w5                  // Actualizar el mayor

    b       loop_arreglo1           // Continuar al siguiente elemento

no_actualizar1:
    cmp     w5, w4                  // Comparar con el segundo mayor
    b.le    loop_arreglo1           // Si no es mayor, continuar

    mov     w4, w5                  // Actualizar el segundo mayor
    b       loop_arreglo1

fin_arreglo1:
    mov     w6, w4                  // Guardar el segundo mayor del primer arreglo

    // Encontrar el segundo elemento más grande en el segundo arreglo
    adrp    x2, arreglo2            // Dirección base del segundo arreglo
    add     x2, x2, :lo12:arreglo2
    mov     w1, #5                  // Tamaño del arreglo
    mov     w3, #0                  // Mayor actual
    mov     w4, #0                  // Segundo mayor

loop_arreglo2:
    cbz     w1, fin_arreglo2        // Si el tamaño es 0, terminar el bucle

    ldr     w5, [x2], #4            // Cargar el elemento actual y avanzar
    sub     w1, w1, #1              // Decrementar el tamaño

    cmp     w5, w3                  // Comparar con el mayor actual
    b.le    no_actualizar2          // Si no es mayor, saltar

    mov     w4, w3                  // Actualizar el segundo mayor
    mov     w3, w5                  // Actualizar el mayor

    b       loop_arreglo2           // Continuar al siguiente elemento

no_actualizar2:
    cmp     w5, w4                  // Comparar con el segundo mayor
    b.le    loop_arreglo2           // Si no es mayor, continuar

    mov     w4, w5                  // Actualizar el segundo mayor
    b       loop_arreglo2

fin_arreglo2:
    mov     w7, w4                  // Guardar el segundo mayor del segundo arreglo

    // Imprimir el segundo mayor del primer arreglo
    adrp    x0, msg_resultado       // Cargar el mensaje para printf
    add     x0, x0, :lo12:msg_resultado
    mov     w1, w6                  // Pasar el segundo mayor del primer arreglo como argumento
    bl      printf                  // Llamar a printf para imprimir el segundo mayor del primer arreglo

    // Imprimir el segundo mayor del segundo arreglo
    adrp    x0, msg_resultado       // Cargar el mensaje para printf
    add     x0, x0, :lo12:msg_resultado
    mov     w1, w7                  // Pasar el segundo mayor del segundo arreglo como argumento
    bl      printf                  // Llamar a printf para imprimir el segundo mayor del segundo arreglo

    // Epílogo de la función main
    ldp     x29, x30, [sp], #16     // Restaurar el frame pointer y el link register
    mov     x0, #0                  // Código de salida 0
    ret
