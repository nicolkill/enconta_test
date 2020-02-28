# EncontaTest

## Requerimientos

* Docker
* Maketool

Si estas en Windows debes descargar [Make for Windows](http://gnuwin32.sourceforge.net/packages/make.htm)

## Primeros pasos

Debes primero correr el comando `make` en la terminal, este se encargara
de descargar las dependencias y creara la imagen de docker para que
docker-compose funcione

Se puede hacer este proceso manualmente corriendo `make build` y
`make image` individualmente

## Correr el proyecto en local

Se hace con el comando `make up`, este correra docker-compose e iniciara
todo lo necesario para funcionar

Para correrlo sin docker el comando es `mix run --no-halt`

Sea con o sin docker puedes acceder al proyecto a travez del URL
`http://localhost:4000/calculate_players_payment`

## Correr las pruebas

Se hace con el comando `make testing`.

Para correrlo sin docker el comando es `mix test`

## Deploy

Se puede hacer deploy de esta aplicacion haciendo push de la imagen
docker
