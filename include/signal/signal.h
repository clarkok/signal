#ifndef _SIGNAL_H_
#define _SIGNAL_H_

#include <functional>
#include <set>

namespace Signal {

template <class... ArgsType>
class Signal;

template <class... ArgsType>
class Slot;

template <class... ArgsType>
class Signal
{
public:
  typedef Slot<ArgsType...> Slot;

private:
  std::set<Slot *> slots;

public:
  Signal() = default;
  ~Signal()
  {
    for (auto p : slots)
      p->Deregister(this);
  }

  void
  Register(Slot *slot)
  {
    slots.insert(slot);
  }

  void
  Deregister(Slot *slot)
  {
    slots.erase(slot);
  }

  void
  Trigger(ArgsType... args) const
  {
    for (auto p : slots)
      p->Call(args...);
  }
};

template <class... ArgsType>
class Slot
{
public:
  typedef Signal<ArgsType ...> Signal;
  typedef std::function<void(ArgsType...)> Function;

private:
  Function func_;
  std::set<Signal *> signals;

public:
  Slot(Function f)
  : func_(f)
  { }

  ~Slot()
  {
    for (auto &p : signals)
      p->Deregister(this);
  }

  void 
  Call(ArgsType ...args) const
  {
    func_(args...);
  }

  void
  Register(Signal *signal)
  {
    signals.insert(signal);
  }

  void
  Deregister(Signal *signal)
  {
    signals.erase(signal);
  }
};

};

#endif // _SIGNAL_H_
