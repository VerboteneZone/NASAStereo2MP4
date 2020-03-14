#!/bin/bash
for pos in ahead behind; do
        for year in `seq 2006 2020`; do
                for month in `seq -w 1 12`; do
                        for day in `seq -w 1 31`; do
                                prefix="${year}${month}"
                                wget -N -r -l1 -nH --cut-dirs=6 -e robots=off -A "${prefix}*.jpg" https://stereo.gsfc.nasa.gov/browse/$year/$month/$day/${pos}/hi2/1024/
                        done
                        ffmpeg -y -framerate 5 -pattern_type glob -i "1024/${year}${month}*.jpg" -c:v libx264 -r 10 -pix_fmt yuv420p "nasa-stereo-${pos}-${year}-${month}.mp4"
                done
                ffmpeg -y -framerate 10 -pattern_type glob -i "1024/${year}*.jpg" -c:v libx264 -r 10 -pix_fmt yuv420p "nasa-stereo-${pos}-${year}.mp4"
        done
        ffmpeg -y -framerate 30 -pattern_type glob -i "1024/*.jpg" -c:v libx264 -r 30 -pix_fmt yuv420p "nasa-stereo-${pos}.mp4"
        mv 1024 ${pos}
done
