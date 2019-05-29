# This script will create tiles of different zoom levels.

target_dir = "../map-of-rc-tiles"
min_zoom = 1
max_zoom = 5

min_zoom.upto(max_zoom) do |z|
    `rm -rf #{target_dir}/#{z}`

    # Create the required directories.
    0.upto(2**z-1) do |x|
        `mkdir -p #{target_dir}/#{z}/#{x}`
    end

    # Render the raster graphics using Inkscape.
    puts "Rendering zoom level #{z}..."
    `inkscape -z -e /tmp/map-of-rc-#{z}.png -w #{256*2**z} -h #{256*2**z} map-of-rc.svg`

    # Cut the raster graphics into tiles using ImageMagick.
    `convert -density 1200 /tmp/map-of-rc-#{z}.png -crop 256x256 -set filename:tile "%[fx:page.x/256]/%[fx:page.y/256]" +repage +adjoin "#{target_dir}/#{z}/%[filename:tile].jpg"`
    `rm /tmp/map-of-rc-#{z}.png`
end
