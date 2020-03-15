# nyt-corona-animation
A video animation of the New York Times' US coronavirus outbreak maps.

The `imgs` folder contains screenshots of the US map on the
[NYT web site](https://www.nytimes.com/interactive/2020/world/coronavirus-maps.html),
of the SVG object rendering the map. The starting date is March 3 2002, when the NYT
began plotting the sizes of the outbreaks. ImageMagic produces the input frames and
a raw GIF, ffmpeg converts to video.
