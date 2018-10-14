ArrayList<Bird> birds = new ArrayList<Bird>();
ArrayList<Bird> savedBirds = new ArrayList<Bird>();
ArrayList<Pipe> pipes = new ArrayList<Pipe>();

final int TOTAL = 500;
int counter = 0;
int cycles = 1;
int num_generations = 0;
float best_score = 0;

void setup() {
  size(400, 600);
  for (int i = 0; i < TOTAL; i++) { 
    birds.add(new Bird());
  }
}

void draw() {
  for (int n = 0; n < cycles; n++) {
    counter++;
    if (counter % 100 == 0 || counter == 1) {
      pipes.add(new Pipe());
    }

    for (int i = pipes.size() - 1; i >= 0; i--) {
      pipes.get(i).update();

      for (int j = birds.size() - 1; j >= 0; j--) {
        if (pipes.get(i).hits(birds.get(j))) {
          savedBirds.add(birds.get(j));
          if (best_score < birds.get(j).score) {
            best_score = birds.get(j).score;
          }
          birds.remove(j);
        }
      }

      if (pipes.get(i).offscreen()) {
        pipes.remove(i);
      }
    }

    for (int j = birds.size() - 1; j >= 0; j--) {
      birds.get(j).think(pipes);
      birds.get(j).update();
      if(birds.get(j).bottomTop()){
        birds.remove(j);
      }
    }

    if (birds.size() == 0) {
      counter = 0;
      nextGeneration();
      num_generations++;
      println("Generation: " + num_generations + " Best Score: " + best_score);
      best_score = 0.0;
      pipes.clear();
    }
  }

  // Drawings
  background(0);
  for (Bird bird : birds) {
    bird.show();
  }

  for (Pipe pipe : pipes) {
    pipe.show();
  }
}

void keyPressed() {
  if (key == ' ') {
    if (cycles == 100) {
      cycles = 1;
    } else {
      cycles = 100;
    }
  }
}
