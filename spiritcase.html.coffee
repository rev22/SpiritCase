# Copyright (c) 2013, 2014 Michele Bini

# This program is free software: you can redistribute it and/or modify
# it under the terms of the version 3 of the GNU General Public License
# as published by the Free Software Foundation.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

{ htmlcup } = require 'htmlcup'

title = "Simple sprite Editor"

fs = require 'fs'

# icon = datauriIcon "vaquita.ico"

htmlcup.html5Page ->
  @head ->
    @meta charset:"utf-8"
    @link rel:"shortcut icon", href:icon if icon?
    @title title
    @style type: "text/css",
      """
      body {
        background: #222;
        text-align: center;
        font-size: 22px;
        font-family: 'Helvetica', 'Times', serif;
        text-shadow: 0 1px 1px blue;
      }
      .banner {
        border: 5px solid white;
        border: 5px solid white rgba(255,255,255,0.9);
        box-shadow: 0 2px 4px blue;
        margin: 1em;
      }
      p {
        color:white;
        color:rgba(255,255,255,0.9);
        margin-top:0.418em;
        margin-bottom:0.418em;
        margin-left:auto;
        margin-right:auto;
        width:22em;
        max-width:100%;
      }
      a {
        /*
        color:rgb(200,255,255);
        color:rgba(200,255,255,0.9);
        */
        color:white;
        color:rgba(255,255,255,0.9);
        text-decoration:none;
        display: inline-block;
        border: 1px solid white;
        padding: 0 0.2em;
        border-radius: 0.2em;
        -moz-border-radius: 0.2em;
        -webkit-border-radius: 0.2em;
        -ie-border-radius: 0.2em;
      }
      a:hover {
        background-color:rgba(20,70,180,1.0);
      }
      .petition {
        margin:0.418em;
        padding:0.618em;
      }
      .petition a {
        font-size:127.2%;
        box-shadow: 0 2px 4px blue;
        margin:0.3em;
      }
      .page {
        width: 100%;
        height: 100%;
        margin: 0;
        border: 0;
      }
      .centering {
        display: table;
        padding: 0;
      }
      .centered {
        display: table-cell;
        vertical-align: middle;
        text-align: center;
      }
      .inline-block {
        display: inline-block;
      }
      .dynamic-section {
        display: inline-block;
        vertical-align:middle;
        max-width:100%;
      }
      .dynamic-section.dynsec-vertical {
        display: block;
      }
      .flip-lr {
        -moz-transform:     scaleX(-1);
        -o-transform:       scaleX(-1);
        -webkit-transform:  scaleX(-1);
        transform:          scaleX(-1);
        filter:             FlipH;
        -ms-filter:         "FlipH";
      }
      .pixelart {
        image-rendering:optimizeSpeed;             /* Legal fallback */
        image-rendering:-moz-crisp-edges;          /* Firefox        */
        image-rendering:-o-crisp-edges;            /* Opera          */
        image-rendering:-webkit-optimize-contrast; /* Safari         */
        image-rendering:optimize-contrast;         /* CSS3 Proposed  */
        image-rendering:crisp-edges;               /* CSS4 Proposed  */
        image-rendering:pixelated;                 /* CSS4 Proposed  */
        -ms-interpolation-mode:nearest-neighbor;   /* IE8+           */
      }
      """
  factorY = factorX = factor = 32
  sizeX = Math.floor(960 / factor)
  sizeY = Math.floor(720 / factor)
  gridSize = 1
  checkersSize = 8
  params = { factor, factorX, factorY, sizeX, sizeY, gridSize, checkersSize }
  @body style:"width:100%;height:100%;overflow:hidden", ->
    @div class:"centering page", ->
     @section class:"centered", ->
      @section class:"dynamic-section dynsec-vertical", ->
        @canvas id:"icon", width:"#{sizeX}", height:"#{sizeY}"
      @section class:"dynamic-section dynsec-vertical", ->
        @canvas id:"canvas", width:"#{ sizeX * factorX + gridSize }", height:"#{ sizeY * factorY + gridSize }"
    @script type:"text/javascript", "spiritcase=#{JSON.stringify(params)};"
    @coffeeScript ->
      extensible = extendObject: extendObject = ->
        r = { }
        r[k] = v for k,v of @
        r[k] = v for k,v of x for x in arguments
        r
      dynmod = extensible.extendObject
        symCall: (object, method, pkg = @)-> ->
          (if object[method]? then object else pkg)[method].apply object, arguments
      icon = extensible.extendObject
        sizeX: spiritcase.sizeX
        sizeY: spiritcase.sizeY
        el: document.getElementById "icon"
        getData: ->
          { sizeX, sizeY } = @
          @el.getContext("2d").getImageData(0, 0, sizeX, sizeY)
      canvas = extensible.extendObject spiritcase, { icon },
        el: document.getElementById "canvas"
        redraw: ->
          { gridSize, factor, factorY, sizeY, factorX, sizeX, checkersSize } = @
          iconData = icon.getData()
          ctx = @el.getContext "2d"
          if checkersSize > 0 and checkersSize * 2 <= factor
            x_s = sizeX * factorX
            y_s = sizeY * factorY
            x_i = 0
            y_i = 0
            y = 0
            while y < y_s
              x = 0
              x_i = 0
              while x < x_s
                ctx.fillStyle = "#{ [ "000", "222" ][ (x_i ^ y_i) & 1] }"
                # ctx.fillStyle = "#f00"
                ctx.fillRect x, y, checkersSize, checkersSize
                x += checkersSize
                x_i++
              y += checkersSize
              y_i++
          if gridSize > 0
            x = 0
            while x <= sizeX
              ctx.fillStyle = "#777"
              ctx.fillRect(x * factorX, 0, gridSize, sizeY * factorY)
              x++
            y = 0
            while y <= sizeY
              ctx.fillStyle = "#777"
              ctx.fillRect(0, y * factorY, sizeX * factorX, gridSize)
              y++
      # spiritcase = extensible.extendObject { icon, canvas }
      canvas.redraw()
    # @table id:"overlay", style:"position:absolute;top:0;bottom:0;left:0;right:0;margin:auto;overflow:hidden:",
    #   @div style:"position:absolute;top:0;left:0;right:0;color:white;width:100%;overflow:hidden;background:rgba(0,0,255,0.1);border:1px solid white", "top"
    #   @div style:"position:absolute;bottom:0;left:0;right:0;color:white;width:100%;overflow:hidden;background:rgba(0,0,255,0.1);border:1px solid white", "bottom"
    @coffeeScript ->
      #
