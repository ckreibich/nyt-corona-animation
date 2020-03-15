#! /bin/bash
#
# This produces an animation of the Coronavirus outbreak in the US, based on image data from
# https://web.archive.org/web/*/https://www.nytimes.com/interactive/2020/world/coronavirus-maps.html#us
#
cleanup() {
    rm -f imgs/raw*
}

trap cleanup EXIT

date_0=3
morph=16

# Produce the raw frames for the animation. This includes the
# "morphing" from one input image to the next, and a bit of padding at
# the bottom to put the annotations.
rm -f imgs/raw*
echo "Producing raw frames..."
convert imgs/screen* -morph $morph \
        -gravity south -background white -splice 0x40 \
        imgs/raw_%04d.png

# Add the date stamp to each frame. Process all raw images, and label
# $morph+1 of them with the next applicable date.
echo "Date-stamping frames..."
idx=0
for raw in imgs/raw_????.png; do
    date_inc=$((idx / (morph+1)))
    date_str="March $((date_0 + date_inc)), 2020"
    outfile=$(printf "imgs/raw_labeled_%04d.png" $idx)
    convert $raw -font helvetica \
            -fill "rgb(204,0,0)" -pointsize 16 -gravity northeast -draw "text 10,26 '$date_str'" \
            -fill "rgb(90,90,90)" -pointsize 13 -gravity southeast -draw "text 10,24 'Animation: @ckreibich'" \
            -fill "rgb(128,128,128)" -pointsize 12 -gravity southeast -draw "text 10,10 'Image data: https://www.nytimes.com/interactive/2020/world/coronavirus-maps.html & https://web.archive.org'" \
            $outfile
    idx=$((idx + 1))
done

echo "Composing animation..."
convert -delay 8 imgs/raw_labeled_*.png animation.gif

echo "Converting to video..."
ffmpeg -y -i animation.gif -movflags faststart -pix_fmt yuv420p -vf "crop=trunc(iw/2)*2:trunc(ih/2)*2" video.mp4
