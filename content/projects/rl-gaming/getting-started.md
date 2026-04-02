+++
title = "Getting Started with RL for Games"
weight = 1
+++

## Project Goals

Train a reinforcement learning agent to play simple games, starting with classics like:
- **Tetris** - Spatial reasoning, planning ahead
- **Snake** - Pathfinding, self-collision avoidance

## Why These Games?

These games have properties that make them good RL learning environments:
- **Clear reward signals** (score, survival time)
- **Discrete action spaces** (move left/right, rotate, etc.)
- **Observable state** (the game board is fully visible)
- **Fast simulation** (many episodes can run quickly)

## Resources

Inspired by existing work:
- [Tamagotchi RL for Slither.io](https://noahkasmanoff.com/#/blog/tamagotchi-rl-slitherio) - Training agents on browser games
- [Curriculum Learning for 2048/Tetris](https://kywch.github.io/blog/2025/12/curriculum-learning-2048-tetris/) - Progressive difficulty approaches

## Next Steps

- Set up a Tetris or Snake environment (Gymnasium, custom implementation)
- Implement basic Q-learning or DQN
- Explore curriculum learning strategies
