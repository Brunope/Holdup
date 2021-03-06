#ifndef GAME_H_
#define GAME_H_

#include <vector>
#include <cinttypes>
#include <cstddef>
#include <memory>
#include <map>

#include "Card.h"
#include "Deck.h"
#include "Hand.h"
#include "Player.h"
#include "Agent.h"
#include "IEventListener.h"
#include "EventManager.h"
#include "Action.h"
#include "HandHistory.h"
#include "GameView.h"

class Game {
public:
  Game(uint32_t small_blind, uint32_t big_blind);
  ~Game();

  std::shared_ptr<const GameView> getView() const;


  // Add a player + agent at the lowest available seat number.
  // Fails if no seats are available.
  void addPlayer(std::shared_ptr<Agent> agent,
                 std::string name = "default",
                 size_t chips = STARTING_STACK);
  
  void removePlayer(size_t seat);

  void addEventListener(std::shared_ptr<IEventListener> listener);

  void removeEventListener(std::shared_ptr<IEventListener> listener);

  // Play for 'num_hands' hands or until no other players remain. If
  // 'num_hands' is negative, the Game will run until only 1 player remains.
  void play(int num_hands = -1);

private:
  void updateView();
  void removePlayer(Player player);
  void playHand();
  void setupHand();
  void endHand();
  void dealHoleCards();
  void postBlinds();
  void dealNextStreet();
  bool playRound();
  void setupRound();
  void endRound();
  bool handleAction(Action action, Player *source);
  size_t getNextPlayerSeat(size_t seat);
  size_t getNextLivePlayerSeat(size_t seat);
  bool isGameOver();
  void updateLegalActions();
  bool isLegalAction(const Action &action);
  bool forceLegalAction(Action *action, Player *source);
  void showdown();
  void showdownNoAllIn();
  void showdownAllIn();
  void showdownWin(const Hand &hand, uint32_t pot, Player *player);
  void potWin(uint32_t pot, Player *player);
  void playerBet(Player *source, uint32_t chips);
  std::map<size_t, Hand> getPlayerHands();

  static size_t getBestHand(std::map<size_t, Hand> player_hands);

  static std::map<size_t, Hand>
  getBestHands(std::map<size_t, Hand> player_hands);

  std::shared_ptr<GameView> view_;
  std::shared_ptr<const GameView> const_view_;
  std::map<size_t, std::shared_ptr<Agent>> agents_;
  std::map<size_t, Player> players_;
  std::map<size_t, Player *> live_players_;
  std::map<size_t, Player *> allin_players_;
  std::map<size_t, uint32_t> player_chips_in_pot_per_hand_;
  std::map<size_t, std::pair<Card, Card>> hole_cards_;
  std::vector<Card> board_;
  std::vector<Action> hand_action_[NUM_STREETS];
  HandHistory history_;
  bool legal_actions_[NUM_ACTIONS + 1];
  Deck deck_;
  EventManager event_manager_;
  size_t button_seat_;
  size_t sb_seat_;
  size_t bb_seat_;
  size_t acting_player_seat_;
  uint32_t big_blind_;
  uint32_t small_blind_;
  STREET street_;
  uint32_t hand_num_;
  uint32_t pot_;
  uint32_t current_bet_;
  uint32_t current_raise_by_;
  size_t num_callers_;
  FILE *log_fd_;
};

#endif  // GAME_H_
