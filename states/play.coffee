# Creates a new 'play' state that will contain the game
window.play_state =
  create: ->
    # Add gravity to the world
    game.physics.startSystem(Phaser.Physics.ARCADE)

    # Function called after 'preload' to setup the game
    # Display the bird on the screen
    this.bird = game.add.sprite(100, 245, 'bird')

    # Change anchor of bird, make jumping looks better
    this.bird.anchor.setTo(-0.2, 0.5)

    # Allow gravity on bird
    game.physics.arcade.enable(this.bird)

    # Add gravity to the bird to make it fall
    this.bird.body.gravity.y = 1000

    # Call the 'jump'  when the space key is hit
    spaceKey = game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)
    spaceKey.onDown.add(this.jump, this)

    # Create pipes
    this.pipes = game.add.group()
    this.pipes.createMultiple(20, 'pipe')
    game.physics.arcade.enable(this.pipes)

    this.timer = game.time.events.loop(1500, this.addRowOfPipes, this)

    this.jumpSound = game.add.audio('jump')

    window.score = 0
    this.labelScore = game.add.text(20, 20, "0", { font: "30px Arial", fill: "#ffffff" })
    return

  update: ->
    # Function called 60 times per second

    # If the bird is out of the world (too high or too low), call the 'restart_game'
    this.restartGame() if this.bird.inWorld == false

    # Change bird angle
    this.bird.angle += 1 if this.bird.angle < 20

    # Collisions
    game.physics.arcade.overlap(this.bird, this.pipes, this.hitPipe, null, this)
    return

    # Make the bird jump
  jump: ->
    return if this.bird.alive == false
    # Add a vertical velocity to the bird
    this.bird.body.velocity.y = -350
    # Angle change
    # create an animation on the bird
    game.add.tween(this.bird).to({angle: -20}, 100).start()

    this.jumpSound.play()
    return

    # Hit pipe
  hitPipe: ->
    # If the bird has already hit a pipe, we have nothing to do
    return if this.bird.alive == false

    # Set the alive property of the bird to false
    this.bird.alive = false

    # Prevent new pipes from appearing
    game.time.events.remove(this.timer)

    # Go through all the pipes, and stop their movement
    this.pipes.forEachAlive (p) ->
        p.body.velocity.x = 0
        return
    , this
    return

  # Restart the game
  restartGame: ->
    # Stop timer when restart
    game.time.events.remove(this.timer)

    # Go back to the 'menu' state
    game.input.keyboard.removeKey(Phaser.Keyboard.SPACEBAR)
    game.state.start('menu')
    return

  addOnePipe: (x, y) ->
    # Get the first dead pipe of our group
    pipe = this.pipes.getFirstDead()

    # Set the new position of the pipe
    pipe.reset(x, y)

    # Add velocity to the pipe to make it move left
    pipe.body.velocity.x = -200

    # Kill the pipe when it's no longer visible
    pipe.checkWorldBounds = true
    pipe.outOfBoundsKill = true
    return

  addRowOfPipes: ->
    if this.pipes.getFirstAlive()
      window.score += 1
      this.labelScore.text = window.score

    hole = Math.floor(Math.random()*5)+1

    for i in [0...8]
      this.addOnePipe(400, i*60+10) if i != hole and i != hole + 1
    return
