% Parcial ratatouille

vive(remy, gusteaus).
vive(emile, barMalabar).
vive(django, pizzeriaJaSuis).

cocina(linguini, ratatouille, 3).
cocina(linguini, sopa, 5).
cocina(colette, salmonAsado, 9).
cocina(colette, ratatouille, 1).
cocina(horst, ensaladaRusa, 8).

plato(Plato) :- cocina(_, Plato, _).

trabajaEn(linguini, gusteaus).
trabajaEn(colette, gusteaus).
trabajaEn(horst, gusteaus).
trabajaEn(amelie, cafeDes2Moulins).

restaurante(Restaurante) :- vive(_, Restaurante).
restaurante(Restaurante) :- trabajaEn(_, Restaurante).

% Desarrollá los siguientes predicados, asegurando que sean completamente inversibles:

% 1. inspeccionSatisfactoria/1 se cumple para un restaurante cuando
% no viven ratas allí

inspeccionSatisfactoria(Restaurante) :-
    restaurante(Restaurante),
    not(vive(_, Restaurante)).

% 2. chef/2: relaciona un empleado con un restaurante si el empleado
% trabaja allí y sabe cocinar algún plato

chef(Empleado, Restaurante) :-
    trabajaEn(Empleado, Restaurante),
    cocina(Empleado, _, _).

% 3. chefcito/1: se cumple para una rata si vive en el mismo
% restaurante donde trabaja Linguini.

chefcito(Rata) :-
    trabajaEn(linguini, Restaurante),
    vive(Rata, Restaurante).

% 4. cocinaBien/2 es verdadero para una persona si su experiencia
% preparando ese plato es mayor a 7. 
% Además, Remy cocina bien cualquier plato que exista.

cocinaBien(Persona, Plato) :-
    cocina(Persona, Plato, Experiencia),
    Experiencia > 7.

cocinaBien(remy, Plato) :- plato(Plato).

% 5. encargadoDe/3: nos dice el encargado de cocinar un plato 
% en un restaurante, que es quien más experiencia tiene preparándolo
% en ese lugar.

encargadoDe(Encargado, Plato, Restaurante) :-
    trabajaEn(Encargado, Restaurante),
    cocina(Encargado, Plato, MayorExperiencia),
    not((trabajaEn(_, Restaurante), cocina(_, Plato, MenorExperiencia), MenorExperiencia > MayorExperiencia)).

%encargadoDeLISTAS(Encargado, Plato, Restaurante) :-
    %findall(Experiencia, trabajaEn(), Bag).

% Algunos datos mas sobre los platos del menu

plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 25)).
plato(frutillasConCrema, postre(265)).

% - De las entradas sabemos qué ingredientes las componen; 
% - De los principales, qué guarnición los acompaña y cuántos minutos de cocción precisan;  
% - De los postres, cuántas calorías aportan.

% 6. saludable/1: un plato es saludable si tiene menos de 75 calorías.
% ● En las entradas, cada ingrediente suma 15 calorías.
% ● Los platos principales suman 5 calorías por cada minuto de cocción. 
% Las guarniciones agregan a la cuenta total: las papas fritas 50 y el puré 20, mientras que la ensalada no
% aporta calorías.
% ● De los postres ya conocemos su cantidad de calorías.

/* Ejemplos
- cantidadCalorias(ensaladaRusa, X).      --> X = 75
- cantidadCalorias(bifeDeChorizo, X).     --> X = 145
- cantidadCalorias(frutillasConCrema, X). --> X = 265
*/

saludable(Plato) :-
    plato(Plato, TipoDePlato),
    caloriasPlato(TipoDePlato, Calorias),
    Calorias < 75.

cantidadCalorias(Plato, Calorias) :-
    plato(Plato, TipoDePlato),
    caloriasPlato(TipoDePlato, Calorias).

caloriasPlato(entrada(Ingredientes), Calorias) :-
    length(Ingredientes, CantidadIngredientes),
    Calorias is 15 * CantidadIngredientes.
    
caloriasPlato(principal(Guarnicion, MinutosCoccion), Calorias) :-
    caloriasGuarnicion(Guarnicion, CaloriasGuarnicion),
    Calorias is 5 * MinutosCoccion + CaloriasGuarnicion.

caloriasPlato(postre(Calorias), Calorias).

caloriasGuarnicion(papasFritas, 50).
caloriasGuarnicion(pure, 20).
caloriasGuarnicion(ensalada, 0).    % podria NO agregarlo

% 7. criticaPositiva/2: es verdadero para un restaurante si un crítico le escribe una reseña
% positiva. Cada crítico maneja su propio criterio, pero todos están de acuerdo en lo mismo: el
% lugar no debe tener ratas viviendo en él.
% Criterios: 
% ● Anton Ego espera, además, que en el lugar sean especialistas preparando ratatouille.
% Un restaurante es especialista en aquellos platos que todos sus chefs saben cocinar bien.
% ● Christophe, que el restaurante tenga más de 3 chefs.
% ● Cormillot requiere que todos los platos que saben cocinar los empleados del restaurante
% sean saludables y que a ninguna entrada le falte zanahoria.
% ● Gordon Ramsay no le da una crítica positiva a ningún restaurante

criticaPositiva(Critico, Restaurante) :-
    criterioCritico(Critico, Restaurante),
    inspeccionSatisfactoria(Restaurante).

criterioCritico(antonEgo, Restaurante) :-
    especialistaEn(Restaurante, ratatouille).

criterioCritico(christophe, Restaurante) :-
    cantidadChefs(Restaurante, Cantidad),
    Cantidad > 3.

criterioCritico(cormillot, Restaurante) :-
    todoSaludable(Restaurante),
    queNoFalteZanahoria(Restaurante).

% -------------------------------------------

especialistaEn(Restaurante, Plato) :-
    restaurante(Restaurante),
    forall(chef(Empleado, Restaurante), cocinaBien(Empleado, Plato)).

cantidadChefs(Restaurante, Cantidad) :-
    restaurante(Restaurante),
    findall(Chef, distinct(Chef, chef(Chef, Restaurante)), Chefes),     % puse el distinct para que me haga la cantidad sin repetidos
    length(Chefes, Cantidad).

todoSaludable(Restaurante) :-
    restaurante(Restaurante),
    forall(platoRestaurante(Restaurante, Plato), saludable(Plato)).

platoRestaurante(Restaurante, Plato) :-
    trabajaEn(Persona, Restaurante),
    cocina(Persona, Plato, _).

queNoFalteZanahoria(Restaurante) :-
    restaurante(Restaurante),
    forall(platoRestaurante(Restaurante, Plato), tieneZanahoria(Plato)).

tieneZanahoria(Plato) :-
    plato(Plato, entrada(Ingredientes)),
    member(zanahoria, Ingredientes).
    