import subprocess

command = """ffmpeg -i 'foo.webm' -vf "select=gt(scene\\,0.01)" -fps_mode vfr -pix_fmt yuv420p -color_range pc %04d.jpg"""
foo = subprocess.run(command.split())
fish_cmd = """for i in *.jpg; echo "$i"; tesseract -l chi_sim "$i" "$(basename $i .jpg)"; end"""
