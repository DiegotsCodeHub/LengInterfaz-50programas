// ===============================================
// Estudiante y No de control: Cruz Patiño Diego - 22210297
// Descripción: Programa en ensamblador ARM64 para sumar N numeros naturales
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================
// using System;

// class Program
// {
//     static void Main()
//     {
//         Console.Write("Ingrese la cantidad de números naturales a sumar: ");
//         int N = Convert.ToInt32(Console.ReadLine());
//
//         // Verificar que N sea un número positivo
//         if (N <= 0)
//         {
//             Console.WriteLine("Por favor, ingrese un número mayor que 0.");
//         }
//         else
//         {
//             int suma = 0;
//
//             // Sumar los primeros N números naturales
//             for (int i = 1; i <= N; i++)
//             {
//                 suma += i;
//             }
//
//             Console.WriteLine($"La suma de los primeros {N} números naturales es: {suma}");
//         }
//     }
// }



// ===============================================
// Solucion en ARM54 Assembler
// ===============================================
.section .data
prompt: .asciz "Introduce un número N para calcular la suma de los primeros N números naturales: "
result_msg: .asciz "La suma de los primeros %ld números naturales es %ld.\n"
scanf_format: .asciz "%ld"

number: .quad 0
sum: .quad 0

.section .text
.global main

main:
    // Pedir al usuario un número
    ldr x0, =prompt
    bl printf

    // Leer el número
    ldr x0, =scanf_format
    ldr x1, =number
    bl scanf

    // Cargar el número en x1
    ldr x1, =number
    ldr x1, [x1]

    // Inicializar la suma en 0
    mov x2, #0

    // Calcular la suma de los primeros N números naturales
    mov x3, #1        // Inicializar contador en 1
sum_loop:
    cmp x3, x1        // Comparar contador con N
    bgt end_sum       // Si contador > N, salir del bucle

    add x2, x2, x3    // suma += contador
    add x3, x3, #1    // Incrementar contador
    b sum_loop        // Volver al inicio del bucle

end_sum:
    // Guardar el resultado de la suma
    ldr x4, =sum
    str x2, [x4]

    // Imprimir el resultado
    ldr x0, =result_msg
    mov x1, x1        // cargar N
    ldr x2, =sum
    ldr x2, [x2]      // cargar el resultado
    bl printf

    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc 0
