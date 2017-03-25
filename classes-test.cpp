#include <cstdio>
#include <cstdlib>

extern "C" double c_puts(const char *s) {

  puts(s);
  return 0;
}

extern "C" double c_puti(int i) {
  printf("%d\n", i);
  return 0;
}

extern "C" double c_putd(double d) {
  printf("%f\n", d);
  return 0;
}

// clang++ -S -emit-llvm classes-test.cpp -o classes-test.ll && clang++ -g
// classes-test.cpp -o classes-test.app && ./classes-test.app

class MyClass {
private:
  int age;
};

class Person {
private:
  int age;
  double chilndreAgeAVG;
  const char *name;
  int z;

public:
  Person(int age) : age(age), name("foo bar baz quux"), chilndreAgeAVG(3.2){};

  int getAge() { return age; }
  int getX() { return 0; }
  int getY() { return 0; }
  int getZ() { return z; }
  const char *getName() { return name; }
  double getChildrenAgeAVG() { return chilndreAgeAVG; }
};

void do_loop_1(Person &person) {

  for (int counter = 0; counter < 3; counter++) {
    c_puti(person.getAge());
  }
}

void do_loop_2(Person &person) {

  for (double counter = 0.0; counter < 7.0; counter++) {
    c_puti(person.getAge());
  }
}

int main() {

  MyClass myClassInstance;
  Person person1(34);

  do_loop_1(person1);
  do_loop_2(person1);

  c_putd(person1.getChildrenAgeAVG());
  c_puts(person1.getName());

  person1.getZ();
  person1.getName();

  return 0;
}