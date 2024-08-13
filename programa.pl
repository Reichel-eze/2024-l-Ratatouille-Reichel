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
