// ===============================================
// Estudiante y No de control: Cruz Patiño Diego - 22210297
// Descripción: Programa en ensamblador ARM64 Implementar una cola usando un arreglo
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================
/*
using System;

class Cola
{
    private long[] cola;
    private int frente;
    private int fin;
    private int capacidad;

    // Constructor para inicializar la cola con un tamaño máximo
    public Cola(int capacidad)
    {
        this.capacidad = capacidad;
        cola = new long[capacidad];
        frente = 0;
        fin = 0;
    }

    // Método para verificar si la cola está vacía
    public bool EstaVacia()
    {
        return frente == fin;
    }

    // Método para verificar si la cola está llena
    public bool EstaLlena()
    {
        return (fin + 1) % capacidad == frente;
    }

    // Método para encolar un elemento
    public bool Encolar(long valor)
    {
        if (EstaLlena())
        {
            Console.WriteLine("Error: La cola está llena.");
            return false;
        }
        cola[fin] = valor;
        fin = (fin + 1) % capacidad;
        return true;
    }

    // Método para desencolar un elemento
    public long Desencolar()
    {
        if (EstaVacia())
        {
            Console.WriteLine("Error: La cola está vacía.");
            return -1; // Indicador de error
        }
        long valor = cola[frente];
        frente = (frente + 1) % capacidad;
        return valor;
    }

    // Método para ver el primer elemento sin quitarlo
    public long VerFrente()
    {
        if (EstaVacia())
        {
            Console.WriteLine("Error: La cola está vacía.");
            return -1; // Indicador de error
        }
        return cola[frente];
    }
}

class Program
{
    static void Main()
    {
        Console.Write("Ingrese el tamaño de la cola: ");
        int tamano = Convert.ToInt32(Console.ReadLine());
        
        Cola cola = new Cola(tamano);
        int opcion;

        do
        {
            Console.WriteLine("\nMenú Cola:");
            Console.WriteLine("1. Encolar");
            Console.WriteLine("2. Desencolar");
            Console.WriteLine("3. Ver el primer elemento (frente)");
            Console.WriteLine("4. Verificar si está vacía");
            Console.WriteLine("5. Verificar si está llena");
            Console.WriteLine("0. Salir");
            Console.Write("Seleccione una opción: ");
            
            if (int.TryParse(Console.ReadLine(), out opcion))
            {
                switch (opcion)
                {
                    case 1:
                        Console.Write("Ingrese el valor a encolar: ");
                        if (long.TryParse(Console.ReadLine(), out long valor))
                        {
                            if (cola.Encolar(valor))
                            {
                                Console.WriteLine($"Valor {valor} encolado exitosamente.");
                            }
                        }
                        else
                        {
                            Console.WriteLine("Error: Ingrese un número válido.");
                        }
                        break;

                    case 2:
                        long valorDesencolado = cola.Desencolar();
                        if (valorDesencolado != -1)
                        {
                            Console.WriteLine($"Valor desencolado: {valorDesencolado}");
                        }
                        break;

                    case 3:
                        long valorFrente = cola.VerFrente();
                        if (valorFrente != -1)
                        {
                            Console.WriteLine($"El primer valor en la cola es: {valorFrente}");
                        }
                        break;

                    case 4:
                        if (cola.EstaVacia())
                        {
                            Console.WriteLine("La cola está vacía.");
                        }
                        else
                        {
                            Console.WriteLine("La cola no está vacía.");
                        }
                        break;

                    case 5:
                        if (cola.EstaLlena())
                        {
                            Console.WriteLine("La cola está llena.");
                        }
                        else
                        {
                            Console.WriteLine("La cola no está llena.");
                        }
                        break;

                    case 0:
                        Console.WriteLine("Saliendo del programa...");
                        break;

                    default:
                        Console.WriteLine("Opción no válida.");
                        break;
                }
            }
            else
            {
                Console.WriteLine("Error: Ingrese un número válido.");
                opcion = -1;
            }

        } while (opcion != 0);
    }
}

*/

// ===============================================
// Archivo C
// ===============================================
/*
#include <stdio.h>
#include <stdlib.h>

// Declaraciones externas para las funciones en ensamblador
extern void init_cola();
extern long enqueue(long value);
extern long dequeue();
extern int is_empty();
extern int is_full();

int main() {
    int opcion;
    long valor, resultado, valorDesencolado;

    // Inicializar la cola
    init_cola();

    do {
        printf("\nMenú Cola:\n");
        printf("1. Encolar (Enqueue)\n");
        printf("2. Desencolar (Dequeue)\n");
        printf("3. Verificar si está vacía\n");
        printf("4. Verificar si está llena\n");
        printf("0. Salir\n");
        printf("Seleccione una opción: ");
        
        if (scanf("%d", &opcion) != 1) {
            printf("Error: Ingrese un número válido.\n");
            // Limpiar el buffer de entrada en caso de error de lectura
            while (getchar() != '\n');
            opcion = -1;
        }

        switch (opcion) {
            case 1:
                printf("Ingrese el valor a encolar: ");
                if (scanf("%ld", &valor) != 1) {
                    printf("Error: Ingrese un número válido.\n");
                    break;
                }
                resultado = enqueue(valor);
                if (resultado == -1) {
                    printf("Error: La cola está llena.\n");
                } else {
                    printf("Valor %ld encolado exitosamente.\n", valor);
                }
                break;

            case 2:
                valorDesencolado = dequeue();
                if (valorDesencolado == -1) {
                    printf("Error: La cola está vacía.\n");
                } else {
                    printf("Valor desencolado: %ld\n", valorDesencolado);
                }
                break;

            case 3:
                if (is_empty() == 1) {
                    printf("La cola está vacía.\n");
                } else {
                    printf("La cola no está vacía.\n");
                }
                break;

            case 4:
                if (is_full() == 1) {
                    printf("La cola está llena.\n");
                } else {
                    printf("La cola no está llena.\n");
                }
                break;

            case 0:
                printf("Saliendo del programa...\n");
                break;

            default:
                printf("Opción no válida.\n");
                break;
        }
    } while (opcion != 0);

    return 0;
}

*/


// ===============================================
// Solucion en ARM54 Assembler
// ===============================================
.data
    .align 3                    // Alineamiento a 8 bytes
    queue_array: .skip 800      // Espacio para 100 elementos de 8 bytes
    front: .word 0             // Índice del frente de la cola
    rear: .word 0              // Índice del final de la cola
    count: .word 0             // Contador de elementos
    .equ MAX_SIZE, 100         // Tamaño máximo de la cola

.text
.align 2
.global init_cola
.global enqueue
.global dequeue
.global is_empty
.global is_full

// Inicializar cola
init_cola:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    
    // Reiniciar todos los índices a 0
    adrp    x0, front
    add     x0, x0, :lo12:front
    str     wzr, [x0]
    
    adrp    x0, rear
    add     x0, x0, :lo12:rear
    str     wzr, [x0]
    
    adrp    x0, count
    add     x0, x0, :lo12:count
    str     wzr, [x0]
    
    ldp     x29, x30, [sp], 16
    ret

// Encolar (enqueue) - x0 contiene el valor a encolar
enqueue:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    
    // Verificar si la cola está llena
    bl      is_full
    cbnz    w0, enqueue_full
    
    // Obtener índice rear actual
    adrp    x1, rear
    add     x1, x1, :lo12:rear
    ldr     w2, [x1]
    
    // Guardar valor en la cola
    adrp    x3, queue_array
    add     x3, x3, :lo12:queue_array
    lsl     x4, x2, #3             // Multiplicar índice por 8
    str     x0, [x3, x4]           // Guardar valor
    
    // Actualizar rear
    add     w2, w2, #1
    cmp     w2, MAX_SIZE
    csel    w2, wzr, w2, eq        // Si rear == MAX_SIZE, volver a 0
    str     w2, [x1]
    
    // Incrementar count
    adrp    x1, count
    add     x1, x1, :lo12:count
    ldr     w2, [x1]
    add     w2, w2, #1
    str     w2, [x1]
    
    mov     x0, #0                 // Éxito
    ldp     x29, x30, [sp], 16
    ret

enqueue_full:
    mov     x0, #-1                // Error: cola llena
    ldp     x29, x30, [sp], 16
    ret

// Desencolar (dequeue)
dequeue:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    
    // Verificar si la cola está vacía
    bl      is_empty
    cbnz    w0, dequeue_empty
    
    // Obtener valor del frente
    adrp    x1, front
    add     x1, x1, :lo12:front
    ldr     w2, [x1]
    
    adrp    x3, queue_array
    add     x3, x3, :lo12:queue_array
    lsl     x4, x2, #3
    ldr     x0, [x3, x4]           // Cargar valor a retornar
    
    // Actualizar front
    add     w2, w2, #1
    cmp     w2, MAX_SIZE
    csel    w2, wzr, w2, eq        // Si front == MAX_SIZE, volver a 0
    str     w2, [x1]
    
    // Decrementar count
    adrp    x1, count
    add     x1, x1, :lo12:count
    ldr     w2, [x1]
    sub     w2, w2, #1
    str     w2, [x1]
    
    ldp     x29, x30, [sp], 16
    ret

dequeue_empty:
    mov     x0, #-1                // Error: cola vacía
    ldp     x29, x30, [sp], 16
    ret

// Verificar si está vacía
is_empty:
    adrp    x1, count
    add     x1, x1, :lo12:count
    ldr     w0, [x1]
    cmp     w0, #0
    cset    w0, eq                 // 1 si está vacía, 0 si no
    ret

// Verificar si está llena
is_full:
    adrp    x1, count
    add     x1, x1, :lo12:count
    ldr     w0, [x1]
    cmp     w0, MAX_SIZE
    cset    w0, eq                 // 1 si está llena, 0 si no
    ret
