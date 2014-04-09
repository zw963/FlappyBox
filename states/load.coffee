window.load_state =
  preload: ->
    game.stage.backgroundColor = '#71c5cf'
    game.load.image('bird', 'assets/bird.png')
    game.load.image('pipe', 'assets/pipe.png')
    game.load.audio('jump', 'assets/jump.wav')
    return

  create: ->
    # When all assets are loaded, go to the 'menu' state
    game.state.start('menu')
    return
