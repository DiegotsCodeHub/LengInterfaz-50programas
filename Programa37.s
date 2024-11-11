// ===============================================
// Estudiante y No de control: Cruz Patiño Diego - 22210297
// Descripción: Programa en ensamblador ARM64 Implementar una pila usando un arreglo
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================

/*
using System;

class Pila
{
    private int[] arreglo;
    private int tope;
    private int capacidad;

    // Constructor que inicializa la pila con un tamaño máximo
    public Pila(int capacidad)
    {
        this.capacidad = capacidad;
        arreglo = new int[capacidad];
        tope = -1;  // Inicialmente, la pila está vacía
    }

    // Método para verificar si la pila está vacía
    public bool EstaVacia()
    {
        return tope == -1;
    }

    // Método para verificar si la pila está llena
    public bool EstaLlena()
    {
        return tope == capacidad - 1;
    }

    // Método para agregar un elemento a la pila
    public void Apilar(int valor)
    {
        if (EstaLlena())
        {
            Console.WriteLine("La pila está llena. No se puede apilar el valor.");
            return;
        }

        arreglo[++tope] = valor;
        Console.WriteLine($"Valor {valor} apilado.");
    }

    // Método para quitar un elemento de la pila
    public int Desapilar()
    {
        if (EstaVacia())
        {
            Console.WriteLine("La pila está vacía. No se puede desapilar.");
            return -1; // Indicador de error
        }

        int valorDesapilado = arreglo[tope--];
        Console.WriteLine($"Valor {valorDesapilado} desapilado.");
        return valorDesapilado;
    }

    // Método para ver el elemento en el tope de la pila
    public int VerTope()
    {
        if (EstaVacia())
        {
            Console.WriteLine("La pila está vacía.");
            return -1; // Indicador de error
        }

        return arreglo[tope];
    }
}

class Program
{
    static void Main()
    {
        Console.WriteLine("Introduce el tamaño de la pila:");
        int capacidad = Convert.ToInt32(Console.ReadLine());

        Pila pila = new Pila(capacidad);

        // Menú de operaciones para la pila
        while (true)
        {
            Console.WriteLine("\nOperaciones disponibles:");
            Console.WriteLine("1. Apilar");
            Console.WriteLine("2. Desapilar");
            Console.WriteLine("3. Ver el elemento en el tope");
            Console.WriteLine("4. Ver si la pila está vacía");
            Console.WriteLine("5. Ver si la pila está llena");
            Console.WriteLine("6. Salir");

            Console.Write("Selecciona una operación: ");
            int opcion = Convert.ToInt32(Console.ReadLine());

            switch (opcion)
            {
                case 1: // Apilar
                    Console.Write("Introduce el valor a apilar: ");
                    int valor = Convert.ToInt32(Console.ReadLine());
                    pila.Apilar(valor);
                    break;

                case 2: // Desapilar
                    pila.Desapilar();
                    break;

                case 3: // Ver el tope
                    int tope = pila.VerTope();
                    if (tope != -1)
                    {
                        Console.WriteLine($"El valor en el tope es: {tope}");
                    }
                    break;

                case 4: // Ver si está vacía
                    Console.WriteLine(pila.EstaVacia() ? "La pila está vacía." : "La pila no está vacía.");
                    break;

                case 5: // Ver si está llena
                    Console.WriteLine(pila.EstaLlena() ? "La pila está llena." : "La pila no está llena.");
                    break;

                case 6: // Salir
                    Console.WriteLine("Saliendo...");
                    return;

                default:
                    Console.WriteLine("Opción no válida.");
                    break;
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

// Declaraciones externas para las funciones en ensamblador
extern void init_pila();
extern long push(long value);
extern long pop();
extern int is_empty();

int main() {
    int option;
    long value, result;

    // Inicializar la pila
    init_pila();

    do {
        printf("\nMenu:\n");
        printf("1. Apilar\n");
        printf("2. Desapilar\n");
        printf("3. Verificar si la pila está vacía\n");
        printf("0. Salir\n");
        printf("Seleccione una opción: ");
        scanf("%d", &option);

        switch (option) {
            case 1:
                printf("Ingrese un valor a apilar: ");
                scanf("%ld", &value);
                result = push(value);
                if (result == -1) {
                    printf("Error: Desbordamiento de pila.\n");
                } else {
                    printf("%ld apilado.\n", value);
                }
                break;

            case 2:
                result = pop();
                if (result == -1) {
                    printf("Error: Pila vacía.\n");
                } else {
                    printf("Desapilado: %ld\n", result);
                }
                break;

            case 3:
                if (is_empty()) {
                    printf("La pila está vacía.\n");
                } else {
                    printf("La pila no está vacía.\n");
                }
                break;

            case 0:
                printf("Saliendo...\n");
                break;

            default:
                printf("Opción no válida.\n");
                break;
        }
    } while (option != 0);

    return 0;
}

*/


// ===============================================
// Solucion en ARM54 Assembler
// ===============================================
.data
    // Estructura de datos para la pila
    .align 3                    // Alineamiento a 8 bytes
    stack_array: .skip 800      // Espacio para 100 elementos de 8 bytes
    stack_count: .word 0        // Contador de elementos
    .equ MAX_SIZE, 100         // Constante para tamaño máximo

.text
.align 2
.global init_pila
.global push
.global pop
.global is_empty

// Función para inicializar la pila
init_pila:
    stp     x29, x30, [sp, -16]!   // Guardar frame pointer y link register
    mov     x29, sp
    
    adrp    x0, stack_count        // Cargar dirección de stack_count
    add     x0, x0, :lo12:stack_count
    str     wzr, [x0]              // Inicializar contador a 0
    
    ldp     x29, x30, [sp], 16
    ret

// Función para apilar (push)
push:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    
    // Verificar si hay espacio
    adrp    x1, stack_count
    add     x1, x1, :lo12:stack_count
    ldr     w2, [x1]               // Cargar contador actual
    cmp     w2, MAX_SIZE
    b.ge    push_overflow
    
    // Calcular dirección donde guardar
    adrp    x3, stack_array
    add     x3, x3, :lo12:stack_array
    lsl     x4, x2, #3             // Multiplicar índice por 8
    str     x0, [x3, x4]           // Guardar valor
    
    // Incrementar contador
    add     w2, w2, #1
    str     w2, [x1]
    
    mov     x0, #0                 // Retorno exitoso
    ldp     x29, x30, [sp], 16
    ret

push_overflow:
    mov     x0, #-1                // Código de error
    ldp     x29, x30, [sp], 16
    ret

// Función para desapilar (pop)
pop:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    
    // Verificar si hay elementos
    adrp    x1, stack_count
    add     x1, x1, :lo12:stack_count
    ldr     w2, [x1]
    cbz     w2, pop_empty
    
    // Calcular dirección del elemento a extraer
    sub     w2, w2, #1             // Decrementar contador
    str     w2, [x1]               // Guardar nuevo contador
    
    adrp    x3, stack_array
    add     x3, x3, :lo12:stack_array
    lsl     x4, x2, #3             // Multiplicar índice por 8
    ldr     x0, [x3, x4]           // Cargar valor
    
    ldp     x29, x30, [sp], 16
    ret

pop_empty:
    mov     x0, #-1                // Código de error
    ldp     x29, x30, [sp], 16
    ret

// Función para verificar si está vacía
is_empty:
    adrp    x1, stack_count
    add     x1, x1, :lo12:stack_count
    ldr     w0, [x1]
    cmp     w0, #0
    cset    w0, eq                 // Establecer 1 si está vacía, 0 si no
    ret
