# Clobber

Clobber game for AI project.

## About Project

This project developed with Flutter.

learn more about flutter in [flutter.dev](https://flutter.dev)

main code is in "lib" folder

## About game

- This is a two player game. one of players is computer.
- Two algorithms used for computer movements:
    ### 1. max win possibility
    this method calculates the way that possibility of win is more.
    it is a very good algorithm, but it takes too much to calculate; so it's not efficient for big boards.
    - this algorithm is available in this address : "lib/max_win_possibility.dart"
    ### 2. minimum isolate
    this method is not as efficient as previous algorithm, but it helps to do movements in big boards.
    this algorithm counts number of isolated checkers and avoids the ways that leads to maximum number of computers isolated checkers.
    for better performance this algorithm use alpha-beta search.
    - this algorithm is available in this address : "lib/minimum_isolate.dart"
        

## Contact me

Created by [Omid Mosalmani](http://omidmsl.parsaspace.com/)
- [Gmail: omid.intelligent@gmail.com](mailto:omid.intelligent@gmail.com)
- [Telegram: @omidMsl](https://t.me/omidMsl)
