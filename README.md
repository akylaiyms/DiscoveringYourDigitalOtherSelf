# Discovering Your Digital Other Self
Discovering Your Digital Other Self is a project developed as my thesis work at Bennington College. 

## Artist Statement 

How is data being collected? And how much of it is collected through our daily used devices? How much of it is captured through sound? In this piece, <em>Discovering Your Other Digital Self</em>, I am creating an alter-ego by putting together endless pieces of information that my electronic devices are capturing through sound. Since phones are an irreplaceable part of our everyday life, I decided to use mine as a foundation for this piece.

How is it like being inside your phone’s ‘head’ and recording all of these arbitrary things and making sense out of them? I have decided to create a semi-virtual reality to experience my phone’s point of view as close as I can.

All of the sounds here are processed field recordings from my everyday life. You can hear conversations, whispers, space ambiances, and different daily activities. The sounds are being separately fed to an algorithm that generates random combinations of four sound stems. I think computerizing the sound output through a random algorithm gives a better sense of having your phone’s POV. That creates a sense of chaos and ambiguity as the algorithm is searching through a huge pool of data while capturing more and more information. 

The visual patterns are the representations of how a single ‘drop’ of new data falling into the ocean of information triggers the algorithm to find infinite possibilities of different connections and meanings. 

<em>You get into your phone’s head and hear yourself from its point of view.</em> The message I am trying to carry through this piece is to make the audience simply aware of the amount of information we are unconsciously feeding into the algorithms through sound. 


<em>Discovering Your Other Digital Self</em> debuted as an installation piece in Bennington College, VT in November 2021. The online VR version of the piece will be available in late 2022.


## Setting up the environment to run the project

Needed software Installations: 
1. Unity Hub <https://unity3d.com/get-unity/download>
2. Unity Version 2019.4.16f1 <https://unity3d.com/get-unity/download/archive>

After opening up the project through Unity Hub, install GoogleVR package. 
Follow the instructions here: <https://developers.google.com/cardboard/develop/unity/quickstart>

After completing all of the steps above you should be able to enter play mode and view the project. 

## Scripts, Shaders, Materials

`CameraSwitch` script is for switching the views between the spheres. Up key - sphere 3, down key - sphere 4, right key - sphere 1, left key - sphere 2, space key - sphere 5 <br>
`GenerateAudio` script is for generating random combinations of audioclips from audio library attached to Spheres. <br>
`InverNormals` script is for inverting the material on the spheres. Instead of projecting the material outwards it projects is inwards, creating a 360 degree view. <br>
`Waves` is a shader that generates pattern useing cosine and sine stripes. <br>
`Noise` is a shader that generates pattern with cosine and sine stripes with noise distortion. <br>
`PerlinNoise` is a shader generating pattern using perlin noise and color mapping. <br>
`Fractal` is a shader generating fractal patterns using varying sets between Mandelbrot and Julia sets. <br>
`Waves` is a material from the matching shader. <br>
`Noise` is a material from the matching shader. <br>
`PerlinNoise` is a material from the matching shader. <br>
`Mandelbrot` is a material from `Fractal` shader, mandelbrot variation. <br>
`Julia` is a material `Fractal` shader, Julia variation. <br>
