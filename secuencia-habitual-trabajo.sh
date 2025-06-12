#%/bin/bash
# Secuencia habitual de trabajo con Git
# https://docs.google.com/presentation/d/1aXCCRYnQam-sGmjJX1-kYbpE2raNvtoMX7l6vSspLP4/edit?usp=sharing
# Todas las sentencias echo simulan ediciones por parte de los autores de los ficheros.

# set -x permite que no se vean las órdenes que se van ejecutando
set -x

# Borro los repos
rm -rf plantilla central anna beni ceci dani

# -------------------------------------------------------
# Creo el repositorio plantilla
# -------------------------------------------------------
mkdir plantilla
cd plantilla
git init -b main
echo "# README" > README.md
git add README.md
git commit -m "README inicial"
git branch release
git branch test

# -------------------------------------------------------
# Creo el repositorio central
# -------------------------------------------------------
cd ..
git clone --bare plantilla central

# -------------------------------------------------------
# Creo el repositorio de Anna
# -------------------------------------------------------
git clone central anna
cd anna
git config user.name "Anna"
git config user.email "anna@a.a"

# Anna comprueba qué ramas existen en el remoto
git branch -a

# Crea, enlaza con remoto, actualiza y cambia a la rama test
git checkout test   # NO Equivale a git switch test porque la rama test no existe

# Crea, enlaza con remoto, actualiza y cambia a la rama release
git branch release
git branch release -u origin/release    # git branch --set-upstream-to=origin/release test
git checkout release                    # Equivale a git switch release
git pull


# Crea la rama features/f1 y la publica al remoto
git branch features/f1
git push -u origin features/f1
git branch -a

# Anna realiza trabajo en su repositorio
git switch features/f1
echo "Anna: 10 en f1.txt" >> f1.txt
git add f1.txt
git commit -m "Anna: 10 en f1.txt"
# Anna sube su rama al remoto
git push

# -------------------------------------------------------
# Creo el repositorio de Beni
# -------------------------------------------------------
cd ..
git clone central beni
cd beni
git config user.name "Beni"
git config user.email "beni@b.b"

# Beni comprueba qué ramas existen en el remoto
git branch -a

git checkout test
git cheackout release

# Beni podría "descargar" la rama features/f1 del central, si lo necesita, o crear sus propias ramas
git checkout features/f1


# A partir de aquí, Anna y Beni pueden trabajar en sus ramas locales y subirlas al remoto central,
# con mucho cuidado a la hora de hacer los pull, push y merge

# ------------------- ANNA --------------------
# Anna trabaja en el fichero f1.txt
cd ../anna
git switch features/f1
echo "Anna: 20 en f1.txt" >> f1.txt
# Y añade un nuevo fichero f2.txt
echo "Anna: 10 en f2.txt" >> f2.txt
git add f1.txt f2.txt
git commit -m "Anna: 20 en f1.txt y 10 en f2.txt"
# Anna sube sus cambios al remoto
git push

# ------------------- BENI --------------------
# Beni trabaja en el fichero f1.txt
cd ../beni
git switch features/f1
echo "Beni: 15 en f1.txt" >> f1.txt
git add f1.txt
git commit -m "Beni: 15 en f1.txt"

# Beni INTENTA SUBIR sus cambios al remoto
git push

# Si Beni intenta subir sus cambios al remoto, se encontrará con un error de "rechazo" porque
# Anna ya ha subido cambios a la rama features/f1
# Beni debe hacer un pull para actualizar su rama local y resolver el conflicto configurando el tipo de pull
git pull --no-rebase
# Beni corrige conflictos en f1.txt
echo "Anna: 10 en f1.txt" > f1.txt
echo "Beni: 15 en f1.txt" >> f1.txt
echo "Anna: 20 en f1.txt" >> f1.txt

git add f1.txt
git commit -m "Beni: Resuelto conflicto en f1.txt"
# Beni sube sus cambios al remoto
git push

# ------------------- ANNA --------------------
# Pero Anna ahora NO tiene los cambios de Beni en su rama features/f1
cd ../anna
git switch features/f1
git status # !!! LE DICE QUE TODO ESTÁ ACTUALIZADO !!! Pero no es cierto
# Debe hacer un pull para actualizar su rama local... pero no lo sabe.
# Así que Anna sigue trabajando en su rama features/f1
echo "Anna: 30 en f1.txt" >> f1.txt
git add f1.txt
git commit -m "Anna: 30 en f1.txt"
# Anna intenta subir sus cambios al remoto
git push

# Anna se encuentra con un error de "rechazo" porque Beni ya ha subido cambios a la rama features/f1
# Anna debe hacer un pull para actualizar su rama local
# pero en este caso el conflicto se resuelve automáticamente porque Anna ha añadido una línea nueva simplemente
# Utilizo --no-commit para que no salte el editor del mensaje y me detenga el script
git pull --no-rebase --no-commit
git commit -m "Anna: Resuelto conflicto en f1.txt automáticamente sin intervención manual"
git push

# Muestro el estado final de los repos
echo
cd ../central
pwd
git log --oneline --graph --decorate --all

echo
cd ../anna
pwd
git log --oneline --graph --decorate --all

echo
cd ../beni
pwd
git log --oneline --graph --decorate --all






