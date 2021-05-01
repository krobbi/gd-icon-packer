# GD Icon Packer
__Version 1.0.0__  
__Copyright &copy; 2021 Chris Roberts__ (Krobbizoid)

A PNG icon packer written in GDScript. Takes source PNG files, extracts some
meta-data, performs some rudimentary validation on them, and puts them into .ICO
or .ICNS files if they meet the standards for these icon types.

Mostly written for personal use to create .ICO and .ICNS files for Godot
projects.

Not recommended for practical use. There is currently no way to use this without
opening the `src/` as a [Godot](https://github.com/godotengine/godot) project
and hard-coding the source and target files in `src/main/main.gd`, before
running the project.

_This project is not affiliated with the Godot game engine or any of its
authors, copyright holders, or contributors._

Creates the directories `krobbizoid/gd_icon_packer/` alongside the Godot user
data folder when run.

# License
MIT License - https://krobbi.github.io/license/2021/mit.txt

---

MIT License

Copyright (c) 2021 Chris Roberts

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
