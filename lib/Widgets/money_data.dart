class money {
  String? image;
  String? name;
  String? time;
  String? fee;
  bool? buy;
}

List<money> geter() {
  //!food
  money food = money();
  food.name = "Food";
  food.fee = "\$ 6";
  food.image = "assets/img/food2.png";
  food.time = "jan 30,2023";
  food.buy = false;
  //!Gym
  money gym = money();
  gym.name = "Gym";
  gym.fee = "\$ 150";
  gym.image = "assets/img/gym.png";
  gym.time = "today";
  gym.buy = true;
  //!gas
  money gas = money();
  gas.name = "Gas";
  gas.fee = "\$ 10";
  gas.image = "assets/img/gas.png";
  gas.time = "today";
  gas.buy = true;
  //!Sim card
  money sim = money();
  sim.name = "SIM";
  sim.fee = "\$ 12";
  sim.image = "assets/img/chip.png";
  sim.time = "today";
  sim.buy = true;

  return [food, gym, gas, food, gas, food, gas];
}

List<money> geter_top() {
  //!food
  money food = money();
  food.name = "Food";
  food.fee = "- \$ 6";
  food.image = "assets/img/food2.png";
  food.time = "jan 30,2023";
  food.buy = false;
  //!Gym
  money gym = money();
  gym.name = "Gym";
  gym.fee = "- \$ 150";
  gym.image = "assets/img/gym.png";
  gym.time = "today";
  gym.buy = true;
  //!gas
  money gas = money();
  gas.name = "Gas";
  gas.fee = "- \$ 10";
  gas.image = "assets/img/gas.png";
  gas.time = "today";
  gas.buy = true;
  //!Sim card
  money sim = money();
  sim.name = "SIM";
  sim.fee = "- \$ 12";
  sim.image = "assets/img/chip.png";
  sim.time = "today";
  sim.buy = true;

  return [food, gym, gas];
}
