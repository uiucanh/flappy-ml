void nextGeneration() {
  calculateFitness();
  for (int i = 0; i < TOTAL; i++) {
    birds.add(pickOne());
  }
  savedBirds.clear();
}

Bird pickOne() {
  int index = 0;
  double r = random(1);

  while (r > 0) {
    r -= savedBirds.get(index).fitness;
    index++;
  }
  index--;

  Bird chooseBird = savedBirds.get(index);
  //println("Fitnesss: " + chooseBird.fitness);
  Bird child = new Bird(chooseBird.brain);
  child.mutate();
  return child;
}

void calculateFitness() {
  int sum = 0;
  for (int i = 0; i < savedBirds.size(); i++) {
    savedBirds.get(i).score = pow(savedBirds.get(i).score, 2);
  }

  for (int i = 0; i < savedBirds.size(); i++) {
    sum += savedBirds.get(i).score;
  }

  for (int i = 0; i < savedBirds.size(); i++) {
    savedBirds.get(i).fitness = (savedBirds.get(i).score / sum);
    //println("i: " + i + " - fitness: " + savedBirds.get(i).fitness);
  }
}
