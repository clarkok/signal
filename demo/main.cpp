#include <iostream>

#include "signal.h"

int a, b;

int
main(int argc, char **argv)
{
  std::cout << "Hello world!" << std::endl;

  Signal::Slot<int> slot([](int x) -> void {a = x;});
  decltype(slot)::Signal signal;

  signal.Register(&slot);
  slot.Register(&signal);

  signal.Trigger(2);

  std::cout << a << ' ' << b << std::endl;

  return 0;
}
