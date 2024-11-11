// ===============================================
// Estudiante y No de control: Cruz Patiño Diego - 22210297
// Descripción: Programa en ensamblador ARM64 para sumar matrices
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================

/*
using System;

class Program
{
    // Función para sumar dos matrices
    static int[,] SumarMatrices(int[,] A, int[,] B)
    {
        // Obtener el número de filas y columnas de las matrices
        int filas = A.GetLength(0);
        int columnas = A.GetLength(1);

        // Crear una matriz para almacenar el resultado de la suma
        int[,] C = new int[filas, columnas];

        // Realizar la suma de las matrices elemento por elemento
        for (int i = 0; i < filas; i++)
        {
            for (int j = 0; j < columnas; j++)
            {
                C[i, j] = A[i, j] + B[i, j];
            }
        }

        return C;
    }

    // Función para imprimir una matriz
    static void ImprimirMatriz(int[,] matriz)
    {
        int filas = matriz.GetLength(0);
        int columnas = matriz.GetLength(1);

        for (int i = 0; i < filas; i++)
        {
            for (int j = 0; j < columnas; j++)
            {
                Console.Write(matriz[i, j] + " ");
            }
            Console.WriteLine();
        }
    }

    static void Main(string[] args)
    {
        // Definir dos matrices A y B
        int[,] A = {
            { 1, 2, 3 },
            { 4, 5, 6 }
        };

        int[,] B = {
            { 7, 8, 9 },
            { 10, 11, 12 }
        };

        Console.WriteLine("Matriz A:");
        ImprimirMatriz(A);

        Console.WriteLine("Matriz B:");
        ImprimirMatriz(B);

        // Sumar las matrices
        int[,] C = SumarMatrices(A, B);

        Console.WriteLine("Matriz C (A + B):");
        ImprimirMatriz(C);
    }
}
*/

// ===============================================
// Archivo Adicional en C
// ===============================================
/*
#include <stdio.h>

// Declaramos la función de ensamblador
extern void suma_matrices();

// Declaramos las matrices como externas
extern int matrizA[3][3];
extern int matrizB[3][3];
extern int resultado[3][3];

int main() {
    // Llamamos a la función de ensamblador
    suma_matrices();

    // Imprimimos el resultado
    printf("Resultado de la suma de matrices:\n");
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            printf("%d ", resultado[i][j]);
        }
        printf("\n");
    }
    return 0;
}
*/

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================

.data
    .global matrizA, matrizB, resultado

matrizA:
    .word 1, 2, 3
    .word 4, 5, 6
    .word 7, 8, 9

matrizB:
    .word 9, 8, 7
    .word 6, 5, 4
    .word 3, 2, 1

resultado:
    .space 36    // 3x3 = 9 elementos de 4 bytes

    .text
    .global suma_matrices

suma_matrices:
    // Cargar las direcciones de las matrices en registros
    ldr x0, =matrizA           // Dirección de matrizA
    ldr x1, =matrizB           // Dirección de resultado
    ldr x2, =resultado         // Dirección de resultado
    
    mov w3, #0                 // Índice i (contador de filas)

fila_loop:
    mov w4, #0                 // Índice j (contador de columnas)

columna_loop:
    // Calcular la posición en el arreglo lineal: pos = i * 3 + j
    mov x5, x3                 // x5 = i
    lsl x6, x5, #1             // x6 = i * 2
    add x5, x6, x5             // x5 = i * 3
    add x5, x5, x4             // x5 = i * 3 + j
    
    // Cargar los elementos de matrizA y matrizB y sumarlos
    ldr w6, [x0, x5, LSL #2]   // w6 = matrizA[i][j]
    ldr w7, [x1, x5, LSL #2]   // w7 = matrizB[i][j]
    add w8, w6, w7             // w8 = matrizA[i][j] + matrizB[i][j]

    // Guardar el resultado en la posición correspondiente
    str w8, [x2, x5, LSL #2]   // resultado[i][j] = matrizA[i][j] + matrizB[i][j]
    
    add w4, w4, #1             // j++
    cmp w4, #3                 // Comparar j con el tamaño de la fila
    blt columna_loop           // Si j < 3, repetir columna_loop

    add w3, w3, #1             // i++
    cmp w3, #3                 // Comparar i con el tamaño de la columna
    blt fila_loop              // Si i < 3, repetir fila_loop

    ret                        // Fin de la función