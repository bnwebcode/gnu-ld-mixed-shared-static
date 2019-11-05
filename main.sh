# Create the source code files
echo "int a(void) {return 2;} " > a.c
echo "int b(void) {return 3;} " > b.c
# Prototypes are included straight into the .c file
echo "int a(void); int b(void); int c(void) {return a()+b();}; " > c.c

# This will be application
echo "int c(void);  int main(void) {return c();}; " > d.c

# NB compilation must be with -fPIC
gcc a.c -shared -o liba.so
gcc b.c -shared -o libb.so
gcc -fPIC  -c a.c -o a.o
ar rcs liba.a a.o
gcc -fPIC  -c b.c -o b.o
ar rcs libb.a b.o
gcc -fPIC -c c.c -o c.o

# Create the mixed static/shared library
gcc -nostdlib -shared  -o libbnc2.so   -L.  c.o    -lb  -Wl,-static -la  

# Create the application
gcc -L.  d.c -o d -lbnc2 -lb 

# Test out
echo "Trying to execute the program: "
LD_LIBRARY_PATH=. ./d
echo "Returned: $?"
