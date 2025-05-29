# Construcción
En un edificio en construcción se desea subir y bajar materiales de un piso a otro. Los materiales son situados en un sistema electrónico de poleas instalado en un piso, el cual es controlado por un operador, situado en el mismo. En un piso dado puede haber o bien un operador, o bien una cuadrilla de obreros que necesitan los materiales, pero no ambos. Debido a la alta demanda de materiales por parte de los obreros, cada uno de estos sistemas solo puede atender a una cuadrilla. 

Dado un edificio de N pisos, con cierta instalación de poleas y organización de obreros, y sabiendo que cada sistema solo puede trasladar materiales K pisos arriba o abajo, se desea saber la máxima cantidad de pisos con cuadrillas que se pueden atender.
Los edificios serán representados con una secuencia de letras O y C, las cuales representan a los operadores y cuadrillas, respectivamente.

Nota: Se sugiere que su solución sea **greedy**.

# Formato de entrada

Se tiene un archivo el cual contendrá todos los casos de prueba. La primera línea tendrá un número representando la cantidad de casos de prueba, llamémosle P. Las siguientes 3P líneas contendrán a los casos de prueba. Cada caso de prueba consta de tres líneas, en donde: la primera representa el K mencionado previamente en la letra, la segunda N, y finalmente la tercera representa al edificio.

    P
    
    K1
    
    N1 
    
    X1 X2 X3 X4 … XK1
    
    K2
    
    N2 
    
    X1 X2 X3 X4 … XK2
    
    …
    
    KP
    
    NP 
    
    X1 X2 X3 X4 … XNP

Con Xi=O ó Xi=C. 

Por ejemplo, el siguiente archivo representa un solo caso, el cual es un edificio de cinco pisos con cierta organización y con máquinas que pueden transportar materiales solo un piso (hacia arriba o abajo).

    1
    
    1
    
    5
    
    O C C O C


# Formato de salida

La salida tendrá P líneas, cada una correspondiendo a cada caso de prueba.

Siguiendo el ejemplo anterior, la misma deberá ser:

    2

Es decir, para el primer y único caso corresponde la primera y también única línea con “2”, indicando que en el edificio anterior la máxima cantidad de piso atendidos es 2. 
