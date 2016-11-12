#include <sstream>
#include <cstdio>

#include "Action.h"
#include "GameView.h"
#include "IEventListener.h"
#include "LoggerEventListener.h"

LoggerEventListener::LoggerEventListener() {
}

void
LoggerEventListener::onGameStart(const GameView *game) {
  game_ = game;
  std::cout << "Starting game" << std::endl;
}

void
LoggerEventListener::onPlayerJoin(std::string playerName) {
  std::cout << playerName << " joined" << std::endl;
}

void
LoggerEventListener::onPlayerLeave(std::string playerName) {
  std::cout << playerName << " left" << std::endl;
}

void
LoggerEventListener::onHandStart(long handNum, const GameView *game) {
  std::cout << "Starting hand #" << handNum << std::endl;
}

void
LoggerEventListener::onDeal(STREET street) {
  std::cout << "Dealing cards" << std::endl;
}

void
LoggerEventListener::onPlayerAction(Action action) {
  std::stringstream ss;
  ss << action.getSource()->getName();
  
  switch(action.getType()) {
  case RAISE:
    ss << " raised to " << action.getAmount();
    break;
  case CALL:
    ss << " called " << action.getAmount();
    break;
  case FOLD:
    ss << " folded";
    break;
  case CHECK:
    ss << " checked";
    break;
  default:
    std::cerr << "Unknown Action type: " << action.getType() << std::endl;
    break;
  }
  std::cout << ss.str() << std::endl;
}

void
LoggerEventListener::onShowdown(Hand bestHand, std::string playerName) {
  std::cout << playerName << " wins with " << bestHand.str() << std::endl;
}

void
LoggerEventListener::onPotWin(int pot, std::string playerName) {
  std::cout << playerName << " wins " << pot << std::endl;;
}