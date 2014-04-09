window.menu_state =
  create: ->
    # Call the 'start' function when pressing the space bar
    spaceKey = game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)
    spaceKey.onDown.add(this.start, this)

    # Defining variables
    style =
      font: "30px Arial",
      fill: "#ffffff"

    x = game.world.width / 2
    y = game.world.height / 2

    # Adding a text centered on the screen
    text = game.add.text(x, y - 50, "Press space to start", style)
    text.anchor.setTo(0.5, 0.5)

    # If the user already played
    if window.score > 0
      # Display its score
      scoreLabel = game.add.text(x, y + 50, "score: " + window.score, style)
      scoreLabel.anchor.setTo(0.5, 0.5)
    return

  # Start the actual game
  start: ->
    game.input.keyboard.removeKey(Phaser.Keyboard.SPACEBAR)
    game.state.start('play')
    return
