# Social Distancing Simulator
Made by Dave Jha

[ACCEPTED] A WWDC 2020 Swift Student Challenge submission

## Recommendations for simulation
**It is recommended that the user turns off "Enable Results", and plays in full screen mode. **
Please note that you may experience lag if you decide to have a lot of people. Enjoy! :)

## Overview
This social distancing simulator attempts to show users the effects they have on public health by social distancing. This idea was inspired by an article by The Washington Post in mid-March that attempted to visualize in an easy way what the effect of social distancing is. This article was helpful, but as we discovered more about the virus, such as the ability to be asymptomatic, I wanted to take this into account visually and develop this for Swift.

People are represented as Dots. A red dot is infected, and a grey dot is healthy. Green dots are infected patients that recover. This is set to 10 seconds after a dot gets infected. There is a mode that can be set that allows aymptomatic dots. These dots do not turn red when infected, and are determined randomly. Roughly 50% of these dots will show that they are infected.

## Graph 
I created a graph to further visually aid the user in seeing how quickly a virus can spread in an environment. It logs the amount of infected and recovered (if enabled) people every half of second and stops if the infected is the total number of dots or zero.

## Configuration

When the playground is run, a configuration screen is shown. Here is a breakdown of what each feature does.

### Number of people (dots)
This configures the amount of people (dots) on the screen. Minimum value is 5. Maximum is 100.

### Speed level 
This controls the speed at which the dots operate on a scale from 1 - 5.

### Asymptomatic people
This will allow some dots to appear unaffected when colliding with an infected dot. They will count towards the infected total, but will not appear infected.

### Recover
This will allow infected dots to recover the virus after a 10 second cooldown.

### Social Distancing
This will allow you to set a percentage of dots that will "socially distance", and not move around. The infected dot **may socially distance**. It is fun to observe how much longer it takes for all people to be infected!

### Forced Distancing
This will create a partition between to sides of the map that gradually opens. It is there to demonstrate what a country like China did, and how effective it was until they generally opened up.

### Game Mode
This allows the user to take control a dot and try to manuever around the infected dots! Have fun and be careful!
