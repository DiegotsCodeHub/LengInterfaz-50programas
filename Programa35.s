// ===============================================
// Estudiante y No de control: Cruz Patiño Diego - 22210297
// Descripción: Programa en ensamblador ARM64 Rotación de un arreglo (izquierda/derecha)
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================

/*
using System;

class Program
{
    // Función para rotar el arreglo hacia la izquierda
    static void RotarIzquierda(int[] arreglo, int posiciones)
    {
        int n = arreglo.Length;
        posiciones = posiciones % n; // En caso de que posiciones sea mayor que el tamaño del arreglo
        int[] temp = new int[posiciones];

        // Guardar los primeros elementos que se desplazarán al final
        Array.Copy(arreglo, 0, temp, 0, posiciones);

        // Desplazar los elementos del arreglo a la izquierda
        Array.Copy(arreglo, posiciones, arreglo, 0, n - posiciones);

        // Copiar los elementos guardados al final del arreglo
        Array.Copy(temp, 0, arreglo, n - posiciones, posiciones);
    }

    // Función para rotar el arreglo hacia la derecha
    static void RotarDerecha(int[] arreglo, int posiciones)
    {
        int n = arreglo.Length;
        posiciones = posiciones % n; // En caso de que posiciones sea mayor que el tamaño del arreglo
        int[] temp = new int[posiciones];

        // Guardar los últimos elementos que se desplazarán al principio
        Array.Copy(arreglo, n - posiciones, temp, 0, posiciones);

        // Desplazar los elementos del arreglo a la derecha
        Array.Copy(arreglo, 0, arreglo, posiciones, n - posiciones);

        // Copiar los elementos guardados al principio del arreglo
        Array.Copy(temp, 0, arreglo, 0, posiciones);
    }

    static void Main()
    {
        // Solicitar el número de elementos en el arreglo
        Console.WriteLine("Introduce el número de elementos en el arreglo:");
        int n = Convert.ToInt32(Console.ReadLine());
        int[] arreglo = new int[n];

        // Solicitar los elementos del arreglo
        Console.WriteLine("Introduce los elementos del arreglo:");
        for (int i = 0; i < n; i++)
        {
            Console.Write($"Elemento {i + 1}: ");
            arreglo[i] = Convert.ToInt32(Console.ReadLine());
        }

        // Solicitar la dirección y las posiciones de rotación
        Console.WriteLine("Introduce la dirección de rotación (izquierda/derecha):");
        string direccion = Console.ReadLine().ToLower();

        Console.WriteLine("Introduce el número de posiciones a rotar:");
        int posiciones = Convert.ToInt32(Console.ReadLine());

        // Realizar la rotación
        if (direccion == "izquierda")
        {
            RotarIzquierda(arreglo, posiciones);
        }
        else if (direccion == "derecha")
        {
            RotarDerecha(arreglo, posiciones);
        }
        else
        {
            Console.WriteLine("Dirección no válida. Debe ser 'izquierda' o 'derecha'.");
            return;
        }

        // Mostrar el arreglo rotado
        Console.WriteLine("Arreglo después de la rotación:");
        foreach (int elemento in arreglo)
        {
            Console.Write(elemento + " ");
        }
        Console.WriteLine();
    }
}
*/

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================
.data
arreglo: .word 32145435, 5345, 12345, 6789, 10234  // Arreglo de ejemplo con 5 elementos
tamano: .word 5                                    // Tamaño del arreglo
msg_elemento: .string "%d\n"                       // Formato para imprimir cada elemento

.text
.global main
.align 2

main:
    // Prologo de la función main
    stp     x29, x30, [sp, #-16]!   // Guardar el frame pointer y el link register
    mov     x29, sp

    // Preparar variables
    mov     w1, #5                  // Tamaño del arreglo
    adrp    x2, arreglo             // Dirección base del arreglo
    add     x2, x2, :lo12:arreglo
    add     x3, x2, #16             // Dirección del último elemento (4 bytes * 4 = 16)

    // Cargar el último elemento, que se moverá al inicio
    ldr     w4, [x3]

    // Bucle para desplazar todos los elementos a la derecha
loop_rotar_derecha:
    sub     w1, w1, #1              // Decrementar el tamaño
    cbz     w1, fin_rotar_derecha   // Si el tamaño es 0, terminar el bucle

    ldr     w5, [x3, #-4]!          // Cargar el elemento previo y retroceder la dirección
    str     w5, [x3, #4]            // Desplazar el elemento a la posición actual

    b       loop_rotar_derecha      // Repetir para el siguiente elemento

fin_rotar_derecha:
    // Colocar el último elemento en la primera posición
    str     w4, [x2]

    // Imprimir el arreglo rotado
    mov     w1, #5                  // Reiniciar el tamaño del arreglo
    adrp    x2, arreglo             // Dirección base del arreglo
    add     x2, x2, :lo12:arreglo

loop_imprimir_derecha:
    cbz     w1, fin_programa_derecha // Si no quedan elementos, terminar

    ldr     w4, [x2], #4            // Cargar elemento y avanzar dirección del arreglo
    adrp    x0, msg_elemento        // Cargar el mensaje para printf
    add     x0, x0, :lo12:msg_elemento
    mov     w1, w4                  // Colocar el elemento en w1 para printf
    bl      printf                  // Llamar a printf para imprimir el elemento

    sub     w1, w1, #1              // Decrementar el contador de elementos
    b       loop_imprimir_derecha   // Repetir para el siguiente elemento

fin_programa_derecha:
    // Epílogo de la función main
    ldp     x29, x30, [sp], #16     // Restaurar el frame pointer y el link register
    mov     x0, #0                  // Código de salida 0
    ret
