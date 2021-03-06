#ifndef SLOWAGENT_H_
#define SLOWAGENT_H_

#include "RandomAgent.h"
#include "Sleeper.h"

/**
 * Waits for some amount of time before returning a random action
 */
class SlowAgent : public RandomAgent, public Sleeper {
public:
  Action act(const GameView &view);
};

#endif  // SLOWAGENT_H_
