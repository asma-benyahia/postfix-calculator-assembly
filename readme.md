# Postfix Calculator Linux x86_64

## Description (FR)
Projet universitaire en Programmation des Machines – implémentation d’une calculatrice postfixée (RPN) en assembleur.

Ce projet illustre la manipulation de la pile et l'exécution d'opérations arithmétiques simples en assembleur.

---

## Description (EN)
University project in Machine Programming – implementation of a stack-based postfix (RPN) calculator in assembly.

This project demonstrates stack manipulation and execution of basic arithmetic operations in assembly language.

---

## Compilation et exécution (FR)
### Linux
Pour assembler et lier le programme, utilisez les commandes suivantes :

```bash
as -a --gstabs -o calculatrice.o calculatrice.s
ld -o calculatrice calculatrice.o
./calculatrice
```
• as : assembleur pour générer le fichier objet calculatrice.o
• ld : lie le fichier objet pour créer l’exécutable calculatrice
• ./calculatrice : lance le programme

### Mac (avec Docker)
macOS Apple Silicon nécessite Docker car le binaire est pour Linux x86_64.

```bash
docker run -it --rm -v $(pwd):/projet ubuntu:24.04
cd /projet
apt update
apt install -y build-essential
as -o calculatrice.o calculatrice.s
ld -o calculatrice calculatrice.o --no-pie
./calculatrice
```

## Compilation and execution (EN)
### Linux
To assemble and link the program, use the following commands:

```bash
as -a --gstabs -o calculatrice.o calculatrice.s
ld -o calculatrice calculatrice.o
./calculatrice
```
• as : assembler to generate the object file calculatrice.o
• ld : linker to create the executable calculatrice
• ./calculatrice : run the program

### Mac (with Docker)
macOS Apple Silicon requires Docker because the binary is for Linux x86_64.

```bash
docker run -it --rm -v $(pwd):/projet ubuntu:24.04
cd /projet
apt update
apt install -y build-essential
as -o calculatrice.o calculatrice.s
ld -o calculatrice calculatrice.o --no-pie
./calculatrice
```
## Exemple (FR)

```bash
Entrez l’expression postfixée : 3 4 + 2 *
Résultat : 14
```

## Example (EN)

```bash
Enter postfix expression: 3 4 + 2 *
Result: 14
```