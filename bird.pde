class Bird { //<>//
  float x = 64;
  float y = 300;

  float gravity = 0.8;
  int lift = -12;
  float velocity = 0;

  float score = 0;
  float fitness = 0;
  BasicNetwork brain;

  Bird() {
    brain = new BasicNetwork();
    brain.addLayer(new BasicLayer(null, true, 5));
    brain.addLayer(new BasicLayer(new ActivationSigmoid(), true, 8));
    brain.addLayer(new BasicLayer(new ActivationSigmoid(), false, 1));

    brain.getStructure().finalizeStructure();
    brain.reset();
  }

  Bird(BasicNetwork copyBrain) {
    brain = (BasicNetwork) copyBrain.clone();
  }

  void show() {
    stroke(255);
    fill(255, 50);  
    ellipse(x, y, 32, 32);
  }

  void think(ArrayList<Pipe> pipes) {
    Pipe closest = null;
    double closestD = Double.POSITIVE_INFINITY;
    for (int i = 0; i < pipes.size(); i++) {
      double d = pipes.get(i).x - this.x;
      if (d < closestD && d > 0) {
        closest = pipes.get(i);
        closestD = d;
      }
    }

    BasicMLData  inputs = new BasicMLData(5);
    inputs.add(0, map(this.y, 0, height, 0, 1));
    inputs.add(1, map(closest.top, 0, height, 0, 1));
    inputs.add(2, map(closest.bottom, 0, height, 0, 1));
    inputs.add(3, map(closest.x, this.x, width, 0, 1));
    inputs.add(4, map(this.velocity, -5, 5, 0, 1));

    MLData output = brain.compute(inputs);

    //println(output);
    if (output.getData(0) > 0.5) {
      up();
    }
  }

  void mutate() {
    for (int layer = 0; layer < brain.getLayerCount() - 1; layer++) {
      int bias = 0;
      if (brain.isLayerBiased(layer)) {
        bias = 1;
      }

      for (int fromIdx = 0; fromIdx < brain.getLayerNeuronCount(layer)
        + bias; fromIdx++) {
        for (int toIdx = 0; toIdx < brain.getLayerNeuronCount(layer + 1); toIdx++) {
          double weight = brain.getWeight(layer, fromIdx, toIdx);
          brain.setWeight(layer, fromIdx, toIdx, doMutation(weight));
        }
      }
    }
  }
  
  boolean bottomTop() {
    return (this.y > height || this.y < 0);
  }
  
  void update() {
    this.velocity += this.gravity;
    //this.velocity *= 0.9;
    this.y += this.velocity;

    this.score++;
  }

  void up() {
    this.velocity += this.lift;
  }
}

double doMutation(double x){
  if (random(1) < 0.1) {
    double offset = randomGaussian() * 0.5;
    double newx = x + offset;
    return newx;
  } else{
    return x;
  }
}
