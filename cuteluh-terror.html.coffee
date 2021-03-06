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

title = "Spiritcase Sprite Editor"

fs = require 'fs'

# icon = datauriIcon "vaquita.ico"

datauri = (t, x)-> "data:#{t};base64,#{new Buffer(fs.readFileSync(x)).toString("base64")}"
datauripng = (x)-> datauri "image/png", x
cuteluh_terror = datauripng "cuteluh-terror.png"

htmlcup.html5Page ->
  @head ->
    @meta charset:"utf-8"
    @link rel:"shortcut icon", href:icon if icon?
    @title title
    @style type: "text/css",
      """
      input, button { margin-top: 0; margin-bottom:0; }
      body { border:0;margin:0;padding:0; }
      #spiritcaseContainer {
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
      #spiritcaseContainer p {
        color:white;
        color:rgba(255,255,255,0.9);
        margin-top:0.418em;
        margin-bottom:0.418em;
        margin-left:auto;
        margin-right:auto;
        width:22em;
        max-width:100%;
      }
      #spiritcaseContainer a {
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
      #spiritcaseContainer a:hover {
        background-color:rgba(20,70,180,1.0);
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
      .coffeecharniaContainer {
        opacity: 0.2;
      }
      .coffeecharniaContainer:hover {
        opacity: 0.8;
      }
      .spiritcaseDialog {
        padding-top:1em;
      }
      .sliderInput {
        cursor:default;
      }
      .sliderInputValue {
          font-size:100%;
          font-weight:bold;
          color:white;
          font-family: sans;
          text-shadow: 0 0 1px black, 0 0 2px black, 0 0 2px black;
      }
      .sliderInputLabel {
          font-size:75%;
          font-weight:bold;
          color:white;
          font-family: sans;
          text-shadow: 0 0 1px black, 0 0 2px black, 0 0 2px black;
      }
      .sliderInputButton {
          font-size:150%;
          font-weight:bold;
          color:white;
          font-family: sans;
          text-align:center;
          cursor:hand;cursor:pointer;
      }
      .sliderInputButton:hover {
          background:rgba(0,0,0,0.2);
      }
      .sliderInputButton:not(:hover) {
          opacity:0.6;
          cursor: cross;
      }
      .framesList {
        cursor:pointer;cursor:hand;
      }
      .framesList canvas, .undoHistory canvas {
        margin:2px;
        padding:1px;
        border:1px solid black;
      }
      .framesList canvas:hover, .undoHistory canvas:hover {
        border:1px solid white;
      }
      canvas.pick_tool {
        cursor:hand;cursor:pointer;
      }
      """
  factorY = factorX = factor = 16
  sizeX = Math.floor(480 / factor)
  sizeY = Math.floor(360 / factor)
  gridSize = 1
  checkersSize = 8
  params = { factor, factorX, factorY, sizeX, sizeY, gridSize, checkersSize }
  params.borderColor = "#000"
  icon =
    borderColor: params.borderColor
    borderWidth: "1"
    padding: "1"
  params.icon = icon
  @body style:"width:100%;height:100%;overflow:hidden", ->
    @div id:"spiritcaseContainer", class:"centering page", ->
     @section class:"centered", ->
      # @section id:"spiritcaseDialogs", class:"dynamic-section dynsec-vertical", ->
      @section class:"dynamic-section dynsec-vertical", ->
        @span style:"border-color:#{icon.borderColor};border-width:#{icon.borderWidth}px;border-style:solid;padding:#{icon.padding}px;display:inline-table", ->
          @canvas id:"icon", width:"#{sizeX}", height:"#{sizeY}"
      @section class:"dynamic-section dynsec-vertical", ->
        @canvas id:"canvas", width:"#{ sizeX * factorX + gridSize }", height:"#{ sizeY * factorY + gridSize }"

    # Data
    @script type:"text/javascript", "window.spiritcase=#{JSON.stringify(params)};"
    @script type:"text/javascript", "window.cuteluh_terror=#{JSON.stringify(cuteluh_terror)};"

    # Libraries
    @embedJavaScriptSource "lib/minified-web.js"
    @embedJavaScriptSource "node_modules/htmlcup/htmlcup.js"
    @coffeeScript ->
      # Create a version of htmlcup that can be used in-browser
      htmlcup = htmlcup.extendObject
        originalLib: htmlcup
        capturedTokens: []
        printHtml: (t) -> @capturedTokens.push t
        captureHtml: (f) ->
          o = @capturedTokens
          @capturedTokens = []
          f.apply @
          p = @capturedTokens
          @capturedTokens = o
          r = p.join ""
          @printHtml r
          r
        captureFirstTag: (f)->
          div = document.createElement "div"
          div.innerHTML = @captureHtml f
          div.firstChild
        stripOuter: (x) ->
          x.replace(/^<[^>]*>/, "").replace(/<[^>]*>$/, "")
        capturedParts: {}
        capturePart: (tagName, stripOuter = @stripOuter) -> ->
          x = arguments
          @capturedParts[tagName] =
            stripOuter (@captureHtml ->
              @originalLib[tagName].apply @, x
            )
        body: -> (@capturePart "body").apply @, arguments 
        head: ->
          lib = @.extendObject
            title: -> (@capturePart "title").apply @, arguments
            headStyles: []
            style: ->
              @headStyles.push (@capturePart "style").apply @, arguments
          r = (lib.capturePart "head").apply lib, arguments
          @capturedParts.headStyles = lib.headStyles
          @capturedParts.headTitle = lib.capturedParts.title
          r
        # script: ->
        #  scripts = (@capturedParts.scripts or= [])
        #  push scripts, ((@capturePart "script").apply @, arguments)
        html5Page: () ->
          x = arguments
          @captureHtml -> @originalLib.html5Page.apply @, x
          r = @capturedParts
          @capturedParts = {}
          r

    # Implementation
    @coffeeScript ->
      $ = require('minified').$
      colorLib =
          Math: Math
          rgb2hex: (c)-> (0x1000000 + (c[0] << 16) + (c[1] << 8) + c[2]).toString(16).substring(1)
          hex2rgb: (x)->
              x.length == 6 then
                  return [ parseInt(x.substr(0, 2), 16), parseInt(x.substr(2, 2), 16), parseInt(x.substr(4, 2), 16) ]
              x.length == 3 then
                  return [ parseInt(x.substr(0, 1), 16)*0x11, parseInt(x.substr(1, 1), 16)*0x11, parseInt(x.substr(2, 1), 16)*0x11 ]
              throw "hex number has odd length: #{x.length}"
          rgb2hsv: ([r,g,b])@>
           { Math } = @
           r=r/255
           g=g/255
           b=b/255;
           v = Math.max(r, Math.max(g,b));
           min = Math.min(r, Math.min(g,b));
           return [0,0,0] if v is 0
           d = v - min
           return [0,0,v] if d is 0
           s = d / v
           if r is v
          	 h = (g - b) / d
           else if g is v
             h = ((b - r) / d) + 2
           else
          	 h = ((r - g) / d) + 4
           h /= 6
           h += 1 if h < 0
           [h,s,v]
           
          hsv2rgb: ([h,s,v])@>
            return [v,v,v] if s is 0
            h  = if h >= 1 then h - 1 else h
            { Math } = @
            hh = h * 6
            hhh = Math.floor hh
            f = hh - hhh
            a = v * (1.0 - s)
            b = v * (1.0 - s * f)
            c = v * (1.0 - s * (1 - f))
            return switch hhh
              when 0 then [ Math.round(v * 255), Math.round(c * 255), Math.round(a * 255) ]
              when 1 then [ Math.round(b * 255), Math.round(v * 255), Math.round(a * 255) ]
              when 2 then [ Math.round(a * 255), Math.round(v * 255), Math.round(c * 255) ]
              when 3 then [ Math.round(a * 255), Math.round(b * 255), Math.round(v * 255) ]
              when 4 then [ Math.round(c * 255), Math.round(a * 255), Math.round(v * 255) ]
              when 5 then [ Math.round(v * 255), Math.round(a * 255), Math.round(b * 255) ]

      sliderInput =
        $: $
        terminateEvent: (ev)@>
          ev.stopPropagation()
          ev.preventDefault()
        mouseEv: (ev,el)@>
          r = el.getClientRects()[0]
          sx = r.width
          # sy = el.offsetHeight
          x = ev.clientX - r.left
          # y = ev.clientY - el.offsetTop
          @barSet(x/(sx - 1), el)
        barSet: (bar, el)@> @setView el, { bar } # { text: "#{bar}" }
        barClick:  (ev,el)@>
          @terminateEvent(ev)
          @mouseEv(ev,el)
        # buttonsPressed: 0
        # mouseDown:  (ev,el)@>
        #   # return unless ev.target is el
        #   @terminateEvent(ev)
        #   # ev.target.setCapture()
        #   @buttonsPressed++ if @buttonsPressed < 1
        #   @mouseEv(ev,el)
        # mouseUp:    (ev,el)@>
        #   # return unless ev.target is el
        #   @terminateEvent(ev)
        #   @buttonsPressed-- if @buttonsPressed > 0
        # mouseMove:  (ev,el)@>
        #   # return unless ev.target is el
        #   @terminateEvent(ev)
        #   @mouseEv(ev,el) if @buttonsPressed > 0
        # mouseOut:   (ev,el)@>
        #   @terminateEvent(ev)
        #   # if ev.target is el
        #   # @buttonsPressed = 0
        # mouseOver:   (ev,el)@>
        #   @terminateEvent(ev)
        #   if ev.target is el
        #     @buttonsPressed = 0
        ignoreEv: (ev, el)@> @terminateEvent(ev)
        setView: (el, {bar, text})@>
          { $ } = @
          el = $(el).up(".sliderInput")[0]
          text?  then $(".sliderInputValue", el)[0].textContent = text
          bar?   then $(".sliderInputBar", el).set("$width", "#{bar*100}%")
        build: ({htmlcup, label, barColor, bgColor, buildModule, module, value, width, noBar, bar })@>
          buildModule? then module = buildModule @
          control = (name)-> "javascript:#{module}.#{name}(event,this)"
          barColor ?= "#888"
          background = if bgColor? then "background:#{bgColor}" else ""
          value ?= "100%"
          width ?= "5em"
          bar ?= 0
          mouseControls = onclick:control("barClick"), onmousedown:control("ignoreEv") # onmousedown:control("mouseDown") # , onmousemove:control("mouseMove") # , onmouseup:control("mouseUp"), onmouseout:control("mouseOut"), onmouseover:control("mouseOver")
          htmlcup.div class:"sliderInput", style:"display:inline-block;position:relative;border:1px solid #{barColor}", ->
              noBar or @div style:"position:absolute;left:0;top:0;bottom:0;right:0;z-index:-1", ->
                  @div class:"sliderInputBar", style:"position:absolute;left:0;top:0;bottom:0;width:#{bar * 100}%;background:#{barColor}"
              @div style:"display:inline-table", mouseControls, ->
                  @div class:"sliderInputButton", style:"display:table-cell;width:1.5em;font-weight:bold", onclick:control("decButton"), onmousedown:control("terminateEvent"), "-"
                  @div style:"display:table-cell;width:#{width};max-width:#{width};text-align:center;overflow:visible;position:relative;background:#{bgColor}", ->
                      @span class:"sliderInputLabel", style:"position:absolute;left:0;top:0", ->
                          @span label
                      @div class:"sliderInputValue", style:"position:absolute;bottom:0;right:0", value
                  @div class:"sliderInputButton", style:"display:table-cell;width:1.5em", onclick:control("incButton"), onmousedown:control("terminateEvent"), "+"
  
      extensible = extendObject: extendObject = ->
        r = { }
        r[k] = v for k,v of @
        r[k] = v for k,v of x for x in arguments
        r
      dynmod = extensible.extendObject
        symCall: (object, method, pkg = @)-> ->
          (if object[method]? then object else pkg)[method].apply object, arguments
      spiritcase = window.spiritcase
      icon = extensible.extendObject spiritcase.icon,
        sizeX: spiritcase.sizeX
        sizeY: spiritcase.sizeY
        el: document.getElementById "icon"
        getData: ->
          { sizeX, sizeY } = @
          @el.getContext("2d").getImageData(0, 0, sizeX, sizeY)
        setImage: (imageData)@>
            c = @el.getContext "2d"
            c.putImageData(imageData, 0, 0)    
            @
            unless @el.width is imageData.width and @el.height is imageData.height
                @el.width = imageData.width
                @el.height = imageData.height
            c = @el.getContext "2d"
            c.putImageData(imageData, 0, 0)    
            @
        redraw: @>
          icon = @
          @el.setAttribute "style", "border-color:#{icon.borderColor};border-width:#{icon.borderWidth}px;border-style:solid;padding:#{icon.padding}px"
          @
      window.spiritcase = spiritcase = extensible.extendObject spiritcase, { icon },
        el: document.getElementById "canvas"
        icon: icon
        redraw: @>
          { gridSize, factor, factorY, sizeY, factorX, sizeX, checkersSize } = @
          canvasSizeX = factorX * sizeX + gridSize
          canvasSizeY = factorY * sizeY + gridSize
          @el.width = canvasSizeX if canvasSizeX isnt @el.width
          @el.height = canvasSizeY if canvasSizeY isnt @el.height
          iconData = @icon.getData()
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
                ctx.fillStyle = [ "#181818", "#303030" ][ (x_i + y_i) & 1]
                ctx.fillRect x, y, checkersSize, checkersSize
                x += checkersSize
                x_i++
              y += checkersSize
              y_i++
          true then (data = @imageData?) then
            x_s = sizeX * factorX
            y_s = sizeY * factorY
            x_i = 0
            y_i = 0
            y = 0
            while y < y_s
              x = 0
              x_i = 0
              while x < x_s
                p = @pixelColor(x_i, y_i)
                ctx.fillStyle = "rgba(#{p[0]},#{p[1]},#{p[2]},#{p[3]/255})"
                ctx.fillRect x, y, factorX, factorY
                x += factorX
                x_i++
              y += factorY
              y_i++
          if gridSize > 0
            x = 0
            while x <= sizeX
              ctx.fillStyle = "#{@borderColor}"
              ctx.fillRect(x * factorX, 0, gridSize, sizeY * factorY)
              x++
            y = 0
            while y <= sizeY
              ctx.fillStyle = "#{@borderColor}"
              ctx.fillRect(0, y * factorY, sizeX * factorX, gridSize)
              y++
          return
        updateCanvasSize: @>
          { imageData } = @
          unless @sizeX is imageData.width and @sizeY is imageData.height
            @sizeX = imageData.width
            @sizeY = imageData.height
        load: (imageData)@>
            @addFrame?()
            @icon.setImage(imageData)
            @modified = true
            @imageData = imageData
            @updateCanvasSize()
            @redraw()
        pixelColor: (x,y)@>
                { imageData: d } = @
                i = (d.width * y + x) * 4
                b = d.data
                [ b[i], b[i+1], b[i+2], b[i+3] ]
        mapPixels: (f)@>
          { imageData: d } = @
          b = d.data
          xs = d.width
          ys = d.height
          y = 0
          i = 0
          while y < ys
            x = 0
            while x < xs
              r = f([ b[i], b[i+1], b[i+2], b[i+3] ])
              if r?
                b[i]    = r[0]
                b[i+1]  = r[1]
                b[i+2]  = r[2]
                b[i+3]  = r[3]
              i += 4
              x++
            y++
        zoomIn: @>
          @factorX = @factorY = ++@factor
          @redraw()
        zoomOut: @>
          @factorX = @factorY = --@factor
          @redraw()
        view: { }
        lib:
          htmlcup: window.htmlcup
          document: document
          window: window
          setTimeout: setTimeout
          FileReader: FileReader
          Math: Math
          color: colorLib
          sliderInput: sliderInput
          $: $

        currentDialog: null
        setDialog: (name, x)@>
            return unless @view?.dialogs?
            c = @view.dialogs.firstChild then @lib.window.deleteNode c
            @currentDialog = name
            return unless x?
            d = @lib.htmlcup.captureFirstTag ->
              @div class:"spiritcaseDialog", ->
                # @div style:"width:0", ->
                    @div style:"display:inline-block", ->
                        x.call @
                    @div style:"display:inline-block", onclick:"deleteNode(this.parentNode)", class:"spiritcaseDeleteDialog", "×"
            @view.dialogs.appendChild d

        
        eventPath: "spiritcase"
        eventHandler: (methodName)@> "javascript:#{@eventPath}.#{methodName}(event,this)"

        pasteLoad: (ev,el)@>
          { alert } = @iib.window
          alert "x" if ev.clipboardData?
  
        saveButtonClick: @>
            @load @imageData
            uri = @icon.el.toDataURL()
            spiritcase = @
            @setDialog "saveFile", ->
                @label "Download: "
                @a download:"file", href:uri, style:"font-size:150%", "file.png"
                
        nextTick: (x)@>
            { setTimeout } = @lib
            setTimeout (=> x.call @), 0

        loadDataUrl: (d)@>
                              img = @lib.document.createElement 'img'
                              img.src = d
                              @nextTick ->
                                  canvas = @lib.document.createElement 'canvas'
                                  canvas.width = img.width
                                  canvas.height = img.height
                                  context = canvas.getContext '2d'
                                  context.drawImage(img, 0, 0)
                                  @load context.getImageData(0, 0, canvas.width, canvas.height)

        loadFile: (event)@>
            for file in event.target.files
                                  do (file)=>
                                      r = new @lib.FileReader
                                      r.onload = (event)=>
                                           @loadDataUrl event.target.result
                                      r.readAsDataURL(file)
        withColorinput: (input)@>
            @colorinput =
                input: input
                spiritcase: @
                onfocus: @>
                    { spiritcase }   = @
                    { sliderInput }  = @spiritcase.lib
                    @spiritcase.setTool
                      name: "pick"
                      spiritcase: @spiritcase
                      readOnly: true
                      buttonElement: @input
                      employ: (x,y)@>
                        x = x|0
                        y = y|0
                        return if x is @x and y is @y
                        @x = x
                        @y = y
                        [ r, g, b ] = @spiritcase.pixelColor x, y
                        c = @spiritcase.toolColor
                        c[0]=r
                        c[1]=g
                        c[2]=b
                        @spiritcase.setToolColor c
                        @aColorWasSelected = true
                        # @spiritcase.setPixel x, y, @spiritcase.toolColor, @spiritcase.toolAlpha
                        # @spiritcase.unsetPixel x, y, @spiritcase.toolAlpha
                        # @spiritcase.redrawPixel x, y
                      done: @>
                        @spiritcase.paintButtonClick noSetdialog: 1 if @aColorWasSelected
                        @x = @y = null
                    @spiritcase.setDialog "selectColor", ->
                        @div class:"spiritcaseToolbarGroup", ->
                          sliderInput.build
                                    htmlcup: @
                                    label: "Opacity"
                                    value: "#{spiritcase.toolAlpha*100 + 0.5 | 0}%"
                                    bar: spiritcase.toolAlpha
                                    width:"4em"
                                    # noBar: true
                                    buildModule: (sliderInput)-> spiritcase.makeWebmodule "sliderInputOpacity", ->
                                        spiritcase: @
                                        __proto__: sliderInput
                                        incScale: 1.035
                                        incDelta: 0.008
                                        incButton: (ev,el)@>
                                          @terminateEvent(ev)
                                          @spiritcase.toolAlpha = @spiritcase.toolAlpha * @incScale + @incDelta
                                          @spiritcase.toolAlpha > 1 then @spiritcase.toolAlpha = 1
                                          @refresh(el)
                                        decButton: (ev,el)@>
                                          @terminateEvent(ev)
                                          @spiritcase.toolAlpha = @spiritcase.toolAlpha / @incScale - @incDelta
                                          @spiritcase.toolAlpha < 0 then @spiritcase.toolAlpha = 0
                                          @refresh(el)
                                        barSet: (bar,el)@>
                                          @spiritcase.toolAlpha = bar
                                          @refresh(el)
                                        refresh: (el)@>
                                          @setView el,
                                            text: "#{@spiritcase.toolAlpha*100 + 0.5 | 0}%"
                                            bar: @spiritcase.toolAlpha
                                        $: @lib.$
                          colorComponentSlider = ({ i, label, barColor })=> sliderInput.build
                                    htmlcup: @
                                    label: label
                                    barColor: barColor
                                    value: "#{(spiritcase.toolColor[i]/255)*100 + 0.5 | 0}%"
                                    bar: spiritcase.toolColor[i]/255
                                    width:"4em"
                                    # noBar: true
                                    buildModule: (sliderInput)-> spiritcase.makeWebmodule "sliderInput#{label}", ->
                                        spiritcase: @
                                        __proto__: sliderInput
                                        colorComponentIndex: i
                                        getComponent: @> @spiritcase.toolColor[@colorComponentIndex]/255
                                        setComponent: (v)@>
                                          c = @spiritcase.toolColor
                                          c[@colorComponentIndex] = v*255 + 0.5 | 0
                                          @spiritcase.setToolColor c
                                        incScale: 1.035
                                        incDelta: 0.008
                                        incButton: (ev,el)@>
                                          @terminateEvent(ev)
                                          c = @getComponent() * @incScale + @incDelta
                                          c > 1 then c = 1
                                          @setComponent(c)
                                          @refresh(el)
                                        decButton: (ev,el)@>
                                          @terminateEvent(ev)
                                          c = @getComponent() / @incScale - @incDelta
                                          c < 0 then c = 0
                                          @setComponent(c)
                                          @refresh(el)
                                        barSet: (bar,el)@>
                                          @setComponent(bar)
                                          @refresh(el)
                                        refresh: (el)@>
                                          c = @getComponent()
                                          @setView el,
                                            text: "#{c*100 + 0.5 | 0}%"
                                            bar: c
                                        $: @lib.$
                          colorComponentSlider i:0, label: "Red",    barColor: "red"
                          colorComponentSlider i:1, label: "Green",  barColor: "green"
                          colorComponentSlider i:2, label: "Blue",   barColor: "blue"
                        @div class:"spiritcaseToolbarGroup", ->
                            color = (n)=> @div style:"font-size:150%;background:##{n};color:#786;width:1.5em;display:inline-block", class:"paletteEntry", onclick:"javascript:spiritcase.setToolColorHex('#{n}')", "#{n}"
                            color "000"
                            color "fff"
                            color "f00"
                            color "0f0"
                            color "00f"
                            color "ff0"
                            color "f0f"
                            color "0ff"
                            # @button "Add", onclick:"javascript:spiritcase.colorinput.saveCurrentColor()"
                        # @div class:"spiritcaseToolbarGroup", ->
                        #    @button "Pick", onclick:"javascript:spiritcase.setColorPickerTool()"
                editingValue: false
                setColor: (c)@>
                        @input.setAttribute "style", "background:##{c}"
                        unless @editingValue
                            @input.value = "##{c}"
                oninput: @>
                    v = @input.value
                    m = /^\s*#?((?:[0-9a-fA-F]{3}){1,2})\s*$/.exec v then
                        try
                            @editingValue = true
                            @spiritcase.setToolColorHex m[1]
                        finally
                            @editingValue = false
                lib: @lib
        toolButtons:
          # "load": "#spiritcaseLoadButton"
          # "save": "#spiritcaseSaveButton"
          "paint": "#spiritcasePaintButton"
          "erase": "#spiritcaseEraseButton"
          # "frames": "#spiritcaseFramesButton"
          # "tools": "#spiritcaseToolsButton"
          # "undo": "#spiritcaseUndoButton"
        setTool: (tool)@>
            { $ } = @lib
            @lib.$("#spiritcaseToolbar .activated")[0]?.classList.remove("activated")
            if (x = @tool?.name)? then
              @el.classList.remove("#{x}_tool")
            if (x = tool?.name)? then
              @el.classList.add("#{x}_tool")
              (x = @toolButtons[x])? and @lib.$(x)[0]?.classList.add("activated")
            @tool = tool

        toolColor: colorLib.hsv2rgb([ Math.random(), 1, 1 ])
        toolAlpha: 0.3
        setColorPickerTool: @> # TODO

        setToolColorHex: (c)@>
            @paintButtonClick noSetdialog: 1
            @toolColor = @lib.color.hex2rgb c
            @colorinput.setColor(c)
            @
        setToolColor: (c)@>
            @paintButtonClick noSetdialog: 1
            @toolColor = c
            @colorinput.setColor(@lib.color.rgb2hex(c))
            @

        paintButtonClick: (opts)@>
          @setDialog() unless opts?.noSetdialog
          @setTool
              name: "paint"
              spiritcase: @
              employ: (x,y)@>
                  x = x|0
                  y = y|0
                  return if x is @x and y is @y
                  @x = x
                  @y = y
                  @spiritcase.setPixel x, y, @spiritcase.toolColor, @spiritcase.toolAlpha
                  @spiritcase.redrawPixel x, y
              done: @>
                  @x = @y = null

        eraseButtonClick: @>
          @setDialog()
          @setTool
              name: "erase"
              spiritcase: @
              employ: (x,y)@>
                  x = x|0
                  y = y|0
                  return if x is @x and y is @y
                  @x = x
                  @y = y
                  # @spiritcase.setPixel x, y, @spiritcase.toolColor, @spiritcase.toolAlpha
                  @spiritcase.unsetPixel x, y, @spiritcase.toolAlpha
                  @spiritcase.redrawPixel x, y
              done: @>
                  @x = @y = null

        setPixel: (x,y,color,alpha)@>
                { imageData: d } = @
                nalpha = 1 - alpha
                i = (d.width * y + x) * 4
                b = d.data
                rnd = @lib.Math.round
                if false
                    b[i] = rnd(color[0] * alpha + b[i] * nalpha)
                    i++ 
                    b[i] = rnd(color[1] * alpha + b[i] * nalpha)
                    i++
                    b[i] = rnd(color[2] * alpha + b[i] * nalpha)
                else
                    calpha = alpha
                    palpha = b[i+3]/255
                    nalpha *= palpha
                    alpha = 1 - nalpha
                    b[i] = rnd(color[0] * alpha + b[i] * nalpha)
                    i++ 
                    b[i] = rnd(color[1] * alpha + b[i] * nalpha)
                    i++
                    b[i] = rnd(color[2] * alpha + b[i] * nalpha)
                    i++
                    b[i] = rnd(255 * (1 - (1 - palpha) * (1 - calpha)))
                
        unsetPixel: (x,y,alpha)@>
                { imageData: d } = @
                i = (d.width * y + x) * 4 + 3
                b = d.data
                rnd = @lib.Math.round
                b[i] = rnd(b[i] * (1 - alpha))
                
        redrawPixel: (x,y)@>
          { gridSize, factor, factorY, sizeY, factorX, sizeX, checkersSize } = @
          ctx = @el.getContext "2d"
          p = @pixelColor(x, y)
          # ctx.fillStyle = (0x1000000 + (c[0] << 16) + (c[1] << 8) + c[2]).toString(16).substring(1) # '#330000' # @pixelColor(x_i, y_i)
          x1 = x * factorX + gridSize
          y1 = y * factorY + gridSize
          x2 = factorX - gridSize
          y2 = factorY - gridSize
          ctx.clearRect x1, y1, x2, y2
          ctx.fillStyle = "rgba(#{p[0]},#{p[1]},#{p[2]},#{p[3]/255})"
          ctx.fillRect x1, y1, x2, y2
          @

        modified: true
        
        mousedown: 0

        employMouse: (el, location, isFirst)@>
          @checkpoint("employMouse") if !@tool?.readOnly and @modified and isFirst and @modified isnt "doneMouse"
          { gridSize, factor, factorY, sizeY, factorX, sizeX, checkersSize } = @
          h = gridSize / 2
          x = location.clientX - el.offsetLeft - gridSize
          y = location.clientY - el.offsetTop - gridSize
          @tool?.employ(x / factorX, y / factorY)

        doneMouse: (el, event, isLast)@>
          @tool?.done?()
          return if @tool?.readOnly
          @updateIcon()
          if isLast
            @modified = "doneMouse"
            @scheduleCheckpoint("doneMouse")

        setup: @>
          @el.spiritcase = @
          @imageData = @icon.getData()
            # width: @sizeX
            # height: @sizeY
            # data: do=>
            #   m = @sizeX * @sizeY * 4
            #   x = [ ]
            #   x.push 0 while m-- > 0
            #   x

          @redraw()
          @paintButtonClick()

          @el.onmousemove = (event)@>
            event.stopPropagation()
            event.preventDefault()
            if @spiritcase.mousedown > 0
                @spiritcase.employMouse @, event, false
          @el.ontouchmove = (event)@>
            event.stopPropagation()
            event.preventDefault()
            if @spiritcase.mousedown > 0
                @spiritcase.employMouse @, event.touches[0], false
          @el.onmouseup = (event)@>
            event.stopPropagation()
            event.preventDefault()
            @spiritcase.employMouse @, event, false
            unless @spiritcase.mousedown <= 0
              @spiritcase.mousedown--
              unless @spiritcase.mousedown > 0
                @spiritcase.doneMouse(@, event, true)
          # @el.ontouchend = (event)@>
          #   event.stopPropagation()
          #   event.preventDefault()
          #   @spiritcase.employMouse @, event.touches[0], false
          #   unless @spiritcase.mousedown <= 0
          #     @spiritcase.mousedown--
          #     unless @spiritcase.mousedown > 0
          #       @spiritcase.doneMouse(@, event, true)
          @el.onmousedown = (event)@>
            event.stopPropagation()
            event.preventDefault()
            @spiritcase.employMouse @, event, 0 is @spiritcase.mousedown++
          # @el.ontouchstart = (event)@>
          #   event.stopPropagation()
          #   event.preventDefault()
          #   @spiritcase.employMouse @, event.touches[0], 0 is @spiritcase.mousedown++
          # @el.ontouchcancel = @el.onmouseout = (event)@>
          #   @spiritcase.doneMouse(@, event, @spiritcase.mousedown > 0)
          #   @spiritcase.mousedown = 0
          @
        makeWebmodule: (name, build)@>
            @webmodule ?= { }
            @webmodule[name] = build.call @
            "spiritcase.webmodule.#{name}"

        maxCheckpoints: 40
        checkpoints: [ ]
        checkpointsCounter: 0
        updateIcon: @>
          @icon.setImage(@imageData)
        checkpoint: (name)@>
          # { console } = @lib.window; console.log "checkpoint #{name}"
          (xx = @checkpointTimeout)? then
            { clearTimeout } = @lib.window
            clearTimeout xx
            @checkpointTimeout = null
          { Date } = @lib.window
          canvas = @getAsCanvas()
          @lastCheckpoint =
                      time: new Date
                      canvas: canvas
                      counter: @checkpointsCounter++
          @checkpoints.push @lastCheckpoint
          if @checkpoints.length > @maxCheckpoints
            for x in @checkpoints
              x.generation = (x.generation ? 0) + 1
            rest = @checkpoints.splice(@checkpoints / 2)
            compressed = [ ]
            for k,v of rest
              if k & 1
                compressed.push v
            @checkpoints = @checkpoints.concat compressed
          if !@currentDialog? or @currentDialog is "undoHistory"
            @undoButtonClick(noCheckpoint: 1)
          @modified = false
        scheduleCheckpointDelay: 3000
        scheduleCheckpoint: (name)@>
          return if @checkpointTimeout
          { setTimeout } = @lib.window
          @checkpointTimeout = setTimeout (=> @checkpointTimeout = null; @checkpoint(name)), @scheduleCheckpointDelay

        undoButtonClick: (opts)@>
          if @modified
            unless opts?.noCheckpoint
              @checkpoint("undo")
          { $ } = @lib
          @setDialog "undoHistory", ->
            @label "History: "
            @span class:"undoHistory"
          $(".undoHistory").add (@setupUndoStep(v.canvas) for v in @checkpoints.concat([]).reverse())
        webmoduleName: "spiritcase"
        eventControl: (name)@> "javascript:#{@webmoduleName}.#{name}(event,this)"
        toolsButtonClick: (opts)@>
          control = => @eventControl.apply @, arguments 
          @setDialog "tools", ->
            
            @div class:"spiritcaseToolbarGroup", ->
              @label "Scale: "
              @button onclick:control("doubleScale"), "2X"
              @button onclick:control("halveScale"), "/2"
            
            @div class:"spiritcaseToolbarGroup", ->
              @button onclick:control("makeTransparent"), title:"Make background of image transparent", "Make transparent"
            
            @div class:"spiritcaseToolbarGroup", ->
              @button onclick:control("startConsole"), "Console"
        startConsole: @>
          @lib.window.coffeecharniaStart()
        setupUndoStep: (v)@>
          v.setAttribute "onclick", "javascript:spiritcase.chooseUndoStep(event,this)"
          v
        chooseUndoStep: (event, el1)@>
            event.stopPropagation()
            event.preventDefault()
            @checkpoint("chooseUndoStep") if @modified and @modified isnt "chooseUndo"
            @imageData = el1.getContext('2d').getImageData(0, 0, el1.width, el1.height)
            @updateIcon()
            @redraw()
            @modified = "chooseUndo"
            
        getAsCanvas: @>
          { document } = @lib.window
          { imageData } = @
          canvas = document.createElement "canvas"
          canvas.height = imageData.height
          canvas.width = imageData.width
          ctx = canvas.getContext "2d"
          ctx.putImageData imageData, 0, 0
          canvas

        frames: []
        addFrame: @>
            @frames.push @getAsCanvas()
            @framesButtonClick()
        framesButtonClick: @>
          { $ } = @lib
          @setDialog "frames", ->
              @label "Frames: "
              @span class:"framesList"
              @button onclick:"javascript:spiritcase.addFrame()", "Add"
          $(".framesList").add @frames
          @setupFrame k, v for k,v of @frames

        swapFrame: (event, el1, i)@>
            @updateIcon()
            event.stopPropagation()
            event.preventDefault()
            el0 = @icon.el
            @icon.el = el1
            @frames[i] = el0
            n0 = el0.nextSibling
            p0 = el0.parentNode
            n1 = el1.nextSibling
            p1 = el1.parentNode
            p0.insertBefore(el1, n0)
            p1.insertBefore(el0, n1)
            @setupFrame i, el0
            @modified = true
            @imageData = el1.getContext('2d').getImageData(0, 0, el1.width, el1.height)
            @updateCanvasSize()            
            @redraw()
        
        setupFrame: (k,v)@>
            v.setAttribute "onclick", "javascript:spiritcase.swapFrame(event,this,#{k})"
        
    
        doubleScale: @>
          @updateIcon()
          @load @intScale(@icon.el, 2, 2)
          
        makeTransparent: @>
          bg = @pixelColor 0, 0
          @mapPixels (p)->
            p[0] is bg[0] and p[1] is bg[1] and p[2] is bg[2] then p[3] = 0
            p
          @updateIcon()
          @redraw()
          
        halveScale: @>
          { document } = @lib.window
          @updateIcon()
          c = @icon.el
          c2 = document.createElement "canvas"
          c2.width   = nw = c.width / 2   | 0
          c2.height  = nh = c.height / 2  | 0
          c2c = c2.getContext "2d"
          c2c.drawImage c, 0, 0, nw, nh
          @load c2c.getImageData(0,0,nw,nh)
          
        intScale2X: (c)@>
          { document } = @lib.window
          w = c.width
          h = c.height
          
          c2 = document.createElement "canvas"
          c2.width = w * 2
          c2.height = h
          
          c2c = c2.getContext "2d"
          
          x = 0
          x2 = 0
          
          while x < w
            if false
                c2c.drawImage c,  x, 0, x + 1, h,  x2, 0, x2 + 1, h
                x2++
                c2c.drawImage c,  x, 0, x + 1, h,  x2, 0, x2 + 1, h
                x++
                x2++
            else
                c2c.drawImage c,  x, 0, 1, h,  x2, 0, 2, h
                x++
                x2 += 2

          # return c2c.getImageData(0, 0, w * 2, h)
          c3 = document.createElement "canvas"
          c3c = c3.getContext "2d"
          c3.width = w = w * 2
          c3.height = h * 2
          
          x = 0
          x2 = 0
          
          while x < h
            if false
                c3c.drawImage c2,  0, x, w, x + 1,  0, x2, w, x2 + 1
                x2++
                c3c.drawImage c2,  0, x, w, x + 1,  0, x2, w, x2 + 1
                x++
                x2++
            else
                c3c.drawImage c2,  0, x, w, 1,  0, x2, w, 2
                x++
                x2 += 2

          c3c.getImageData(0, 0, w, h * 2)

        intScale: (c, mx, my)@>
          { document } = @lib.window
          w = c.width
          h = c.height
          
          c2 = document.createElement "canvas"
          c2.width = w * 2
          c2.height = h
          
          c2c = c2.getContext "2d"
          
          x = 0
          x2 = 0
          
          while x < w
                c2c.drawImage c,  x, 0, 1, h,  x2, 0, mx, h
                x++
                x2 += mx

          # return c2c.getImageData(0, 0, w * 2, h)
          c3 = document.createElement "canvas"
          c3c = c3.getContext "2d"
          c3.width = w = w * 2
          c3.height = h * 2
          
          x = 0
          x2 = 0
          
          while x < h
                c3c.drawImage c2,  0, x, w, 1,  0, x2, w, my
                x++
                x2 += my

          c3c.getImageData(0, 0, w, h * 2)
                
        intScaleBleeding: (c, mx, my)@>
          { document } = @lib.window
          w = c.width
          h = c.height
          
          c2 = document.createElement "canvas"
          c2.width   = nw = w * mx
          c2.height  = nh = h * my
          
          c2c = c2.getContext "2d"
          
          x = 0
          x2 = 0
          
          while x < w
                c2c.drawImage c,  x, 0, 1, h,  x2, 0, mx, h
                x++
                x2 += mx
          
          x = h - 1
          x2 = x * 2
          
          while x >= 0
                c2c.drawImage c2,  0, x, w, 1,  0, x2, w, my
                x--
                x2 -= my

          c2c.getImageData(0, 0, nw, nh)

        eventPath: "spiritcase"
        eventHandler: (methodName)@> "javascript:#{@eventPath}.#{methodName}(event,this)"

        loadFiles: (files)@>
            for file in files
              do (file)=>
                  r = new @lib.FileReader
                  r.onload = (event)=>
                       @loadDataUrl event.target.result
                  r.readAsDataURL(file)
        pasteLoad: (ev,el)@>
          { alert, console, JSON, FileReader } = @lib.window
          (d = ev.clipboardData)? then
            ((items = d.items)? and items.length) then
              for i in items
                i.type is "image/png" and i.kind is "file" then
                  (blob = i.getAsFile())? then
                    r = new FileReader
                    r.onload = (event)=>
                      @loadDataUrl event.target.result # event.target.results contains the base64 code to create the image.
                    r.readAsDataURL(blob) 
    
                    # @getIt = f
                    # @loadDataUrl "data:image/png;base64,#{f.toString("base64")}"
                    # console.log i
                    # console.log i.getAsFile()
                    # console.log i.getAsString()
            return
            console.log JSON.stringify(d) # {"items":{"0":{"type":"text/html","kind":"string"},"1":{"type":"image/png","kind":"file"},"length":2},"files":{"length":0},"types":["text/html","Files"],"effectAllowed":"uninitialized","dropEffect":"none"}
            (data = ev.clipboardData.getData("image/png"))? and data isnt "" then
              alert "png data! #{data}"
            else (data = ev.clipboardData.getData("image/gif"))? and data isnt "" then
              alert "gif data!"
            else (files = d.files)? then # and d.files.length
              console.log "hmm"
              console.log files
              for f in files
                  console.log f
              @loadFiles files
  
        loadButtonClick: @>
            t = spiritcase = @
            @setDialog "loadFile", ->
                @label "Load file: "
                @input type:"file", onchange:"javascript:spiritcase.loadFile(event)"
                @input contentEditable:"true", onpaste:t.eventHandler("pasteLoad"), style:"border:1px solid black", placeholder:"Click and paste image here"

                
      spiritcase.setup()
    # @table id:"overlay", style:"position:absolute;top:0;bottom:0;left:0;right:0;margin:auto;overflow:hidden:",
    #   @div style:"position:absolute;top:0;left:0;right:0;color:white;width:100%;overflow:hidden;background:rgba(0,0,255,0.1);border:1px solid white", "top"
    #   @div style:"position:absolute;bottom:0;left:0;right:0;color:white;width:100%;overflow:hidden;background:rgba(0,0,255,0.1);border:1px solid white", "bottom"

    # A toolbar :-)
    @coffeeScript ->
      
        # deleteNode @coffeecharniaToolbar catch any
        document.body.appendChild do-> spiritcase.view.toolbar = htmlcup.captureFirstTag ->
              style = 
                  ''''
                  position:absolute;
                  top:0;
                  color:yellow;
                  width:100%;
              @div { style }, class:"spiritcaseToolbar", ->
                  @style
                      ''''
                      .spiritcaseToolbar {
                          opacity:0.50;
                      }
                      .spiritcaseToolbar label {
                        font-size: 125%;
                        color:white;
                      }
                      .spiritcaseToolbarGroup {
                        display:inline-block;
                        padding:0 1em;
                        vertical-align:text-top;
                      }
                      button.squarebutton {
                        width: 1.5em;
                        max-width: 1.5em;
                        text-align: center;
                      }
                      .spiritcaseToolbar:hover {
                          opacity:0.80;
                      }
                      #spiritcaseColorInput {
                        font-size:125%;
                        text-align:center;
                      }
                      .spiritcaseToolbar select, .spiritcaseToolbar button { font-size:inherit; text-align:center;   }
                      .spiritcaseToolbar .button { display:inline-block; }
                      .spiritcaseToolbar button, .spiritcaseToolbar .button,  .spiritcaseToolbar input, .spiritcaseToolbar select:not(:focus):not(:hover) {
                          color:white; background:black;
                      }
                      .spiritcaseToolbar button:hover, .spiritcaseToolbar .button:hover,  .spiritcaseToolbar input:hover, .spiritcaseToolbar select:hover {
                          color:black; background:white;
                      }
                      /* select option:not(:checked) { color:red !important; background:black !important; } */
                      /* option:active, option[selected], option:checked, option:hover, option:focus { background:#248 !important; } */
                      .spiritcaseToolbar button, .spiritcaseToolbar .button { min-width:5%; font-size:150%; border: 2px outset grey; }
                      .spiritcaseToolbar button.activated:not(:hover), .spiritcaseToolbar button:active, .spiritcaseToolbar .button.button-on { border: 2px inset grey; background:#248; }
                      .spiritcaseToolbar      .button input[type="checkbox"] { display:none; }
                      .spiritcaseToolbar .paletteEntry { cursor:hand;cursor:pointer; }
                  @div style:"text-align:center;width:100%", ->
                      @div id:"spiritcaseToolbar", style:"display:inline-block;text-align:initial", ->
                          @div class:"spiritcaseToolbarGroup", style:"font-size:initial;text-align:initial", ->
                            @button id:"spiritcaseLoadButton",    onclick:"javascript:spiritcase.loadButtonClick(this)",    "Load"
                            @button id:"spiritcaseSaveButton",    onclick:"javascript:spiritcase.saveButtonClick(this)",    "Save"
                            @button id:"spiritcasePaintButton",  class:"activated", onclick:"javascript:spiritcase.paintButtonClick(this)",  "Paint"
                            # @button id:"spiritcaseBrushButton",   onclick:"javascript:spiritcase.brushButtonClick(this)",   "Brush"
                            @button id:"spiritcaseEraseButton",   onclick:"javascript:spiritcase.eraseButtonClick(this)",   "Erase"
                            # @button id:"spiritcaseSelectButton",  onclick:"javascript:spiritcase.framesButtonClick(this)",  "Frames"
                            @button id:"spiritcaseFramesButton",  onclick:"javascript:spiritcase.framesButtonClick(this)",  "Frames"
                            @button id:"spiritcaseToolsButton",   onclick:"javascript:spiritcase.toolsButtonClick(this)",  "Tools"
                            @button id:"spiritcaseUndoButton",    onclick:"javascript:spiritcase.undoButtonClick(this)",    "Undo"
                          @div class:"spiritcaseToolbarGroup", style:"font-size:initial;text-align:initial", ->
                            spiritcase.lib.sliderInput.build
                                    htmlcup: @
                                    label: "Zoom"
                                    value:"#{spiritcase.factor}"
                                    width:"3em"
                                    noBar: true
                                    buildModule: (sliderInput)-> spiritcase.makeWebmodule "sliderInputZoom", ->
                                        spiritcase: @
                                        __proto__: sliderInput
                                        incButton: (ev,el)@>
                                          @terminateEvent(ev)
                                          @spiritcase.zoomIn()
                                          @refresh(el)
                                        decButton: (ev,el)@>
                                          @terminateEvent(ev)
                                          @spiritcase.zoomOut()
                                          @refresh(el)
                                        refresh: (el)@>
                                          @setView el,
                                            text: "#{@spiritcase.factor}"
                                        $: @lib.$
                          @div class:"spiritcaseToolbarGroup", ->
                            @input id:"spiritcaseColorInput", type:"text", placeholder:"Color", size:"7", onfocus:"javascript:spiritcase.withColorinput(this).onfocus(event)", onclick:"javascript:spiritcase.withColorinput(this).onfocus(event)", oninput:"javascript:spiritcase.withColorinput(this).oninput(event)", style:"background:#{(spiritcase.lib.color.rgb2hex(spiritcase.toolColor))}"
                      @div id:"spiritcaseDialogs", ->
                
        # document.body.firstChild.insertBefore htmlcup.div position:"absolute"
        # @div
        spiritcase.view.dialogs = document.getElementById 'spiritcaseDialogs'
        

    # Import/export images
    @coffeeScript ->
      window.setWindowEventListener = do (listeners = {})-> (name, cb, flag)->
          (old = listeners[name])? then window.removeEventListener(name, old)
          window.addEventListener(name, listeners[name] = cb, flag)
      spiritcase = window.spiritcase
      File and FileList and FileReader and Blob then
              setupDrop = (element, withImageData)->
                  withDataUrl = (d)->
                      img = document.createElement 'img'
                      img.src = d
                      nextTick = (x)-> setTimeout x, 0
                      nextTick ->
                          canvas = document.createElement 'canvas'
                          canvas.width = img.width
                          canvas.height = img.height
                          context = canvas.getContext '2d'
                          context.drawImage(img, 0, 0)
                          withImageData context.getImageData(0, 0, canvas.width, canvas.height)
                  setWindowEventListener "dragover", (event)->
                      event.stopPropagation()
                      event.preventDefault()
                      event.dataTransfer.dropEffect = 'copy'
                  setWindowEventListener "drop", (event)->
                      event.stopPropagation()
                      event.preventDefault()
                      for file in event.dataTransfer.files
                          do (file)->
                              r = new FileReader
                              r.onload = (event)->
                                   withDataUrl event.target.result
                              r.readAsDataURL(file)
              
              setupDrop window, (imageData)->
                  spiritcase.load imageData
    # TODO

    # Explorative developing part follows:

    # Simple module loader!
    @coffeeScript ->
      window.deleteNode = (x)-> x.parentNode.removeChild(x)
      window.assert = (c, msg)-> alert msg unless c
      window.jsLoad = (sym, src, callback)->
        if (!sym) || !(window[sym]?)
          x = document.createElement('script')
          x.type = 'text/javascript'
          x.src = src
          y = 1
          x.onload = x.onreadystatechange = ()->
            assert(window[sym]?, "Symbol #{sym} was not defined after loading library") if sym
            if y and not @readyState or @readyState is 'complete'
              y = 0
              deleteNode x
              callback() if callback
          document.getElementsByTagName('head')[0].appendChild x
      

    # Include coffeecharnia!
    # @script src:"https://github.com/ajaxorg/ace-builds/raw/master/src-min-noconflict/ace.js", type:"text/javascript", charset:"utf-8"
    # @script src:"coffee-script.js", type:"text/javascript"
    @coffeeScript ->
     window.coffeecharniaStart = ->
      coffeecharniaLayout = ({ header, body, footer, minheight, minwidth, style, innerStyle })->
          # return @div "foobar"
          # This seems rather complex, but it appears to be the simplest effective way to get what I want, flex isn't working as expected
          # @printHtml "<!DOCTYPE html>\n"
          htmlcup.captureFirstTag ->
            @div id:"coffeecharniaConsole", class:"coffeecharniaContainer", style:"#{style}", ->
              @div style:"height:100%;display:table;width:100%;max-width:100%;table-layout:fixed", ->
                    innerStyle? then @style innerStyle
                    if false
                      header.call @, style:"display:table-row;min-height:1em;overflow:auto;max-height:5em", class:"consoleHeader"
                    else if false
                      @div style:"display:table-row;min-height:1em;background:pink", ->
                        @div style:"max-height:5em;overflow-y:scroll;overflow-x:hidden;position:relative;display:block", ->
                          @div style:"float:left;width:100%", contentEditable:"true", ->
                            @div "x" for x in [ 0 .. 25 ]
                    else
                      @div style:"display:table-row;min-height:1em", ->
                        @div style:"max-height:5em;overflow:hidden;position:relative;display:block", ->
                          @div style:"float:left;width:100%", ->
                            header?.call @, class:"consoleHeader"
                    if false then @div style:"position:relative;height:100%;overflow:hidden;display:table-row", ->
                      @div style:"position:relative;width:100%;height:100%;min-height:#{minheight}", ->
                        @div style:"position:absolute;top:0;right:0;left:0;bottom:0;overflow:auto", ->
                          # x (container width)  y (contained width)
                          
                          # 2000 px              2000 px
                          # 1500 px              1500 px
                          # 1000 px              1000 px
                          # 800 px               1000 px
                          # 500 px               1000 px
                          # 300 px               600 px
                          # 200 px               400 px
                          # 150 px               300 px
                          # 100 px               200 px
                          
                          # y = ((x * 2) ^ 1000 px) _ x
                          #      min-width width     max-width
                          # This part does not seem to work on my firefox
                          @div style:"width:200%;max-width:50em;min-width:100%;height:100%;overflow:hidden", ->
                            @div style:"position:relative;width:100%;height:100%;display:table", ->
                            # @div style:"position:relative;width:100%;max-width:100%;height:100%;overflow:auto", ->
                            #  @div style:"position:absolute;top:0;right:0;left:0;bottom:0;overflow:auto", ->
                            #    @div style:"position:relative;max-width:200%;min-width:60em;display:table;background:black", ->
                              body.call @
                    else @div style:"position:relative;height:100%;overflow:hidden;display:table-row", ->
                        @div style:"position:relative;width:100%;height:100%;min-height:#{minheight}", ->
                            @div style:"position:absolute;top:0;right:0;left:0;bottom:0;overflow:auto", ->
                                body.call @
                      #
                    footer.call @, id:"footer", style:"display:table-row"
      ((x)-> document.body.appendChild coffeecharniaLayout x)
        style: "position:absolute;overflow:auto;width:40%;height:25%;bottom:0;right:0;background:black;color:#ddd"
        innerStyle:
          ''''
          div,pre { padding: 0; margin:0; }
          a { color: #ffb }
          a:visited { color: #eec }
          a:hover { color: white }
        minheight: "7em",
        minwidth: "60em",
        head: ->
          @meta charset:"utf-8"
          @style """
            body { background:black; color: #ddd; }
            a { color:#5af; }
            a:visited { color:#49f; }
            a:hover { color:#6cf; }
            select, textarea { border: 1px solid #555; }
            """
        header: (opts)->
          @style """
              div.thisHeader, .thisHeader div { text-align:center; }
              """
          @div opts, ->
            @style """
              .coffeecharniaContainer select { min-width:5em; max-width:30%; width:18em; }
              .coffeecharniaContainer select, .coffeecharniaContainer button { font-size:inherit; text-align:center;   }
              .coffeecharniaContainer .button { display:inline-block; }
              .coffeecharniaContainer button, .coffeecharniaContainer .button, .coffeecharniaContainer input, .coffeecharniaContainer select:not(:focus):not(:hover) { color:white; background:black; }
              /* select option:not(:checked) { color:red !important; background:black !important; } */
              /* option:active, option[selected], option:checked, option:hover, option:focus { background:#248 !important; } */
              .coffeecharniaContainer button, .coffeecharniaContainer .button { min-width:5%; font-size:220%; border: 2px outset grey; }
              .coffeecharniaContainer button:active, .coffeecharniaContainer .button.button-on { border: 2px inset grey; background:#248; }
              .coffeecharniaContainer .button input[type="checkbox"] { display:none; }
              .coffeecharniaContainer .arrow { font-weight:bold;  }
              .coffeecharniaContainer .editArea { height:100%;width:100%;box-sizing:border-box; }
              """
            false then @div class:"thisHeader", ->
              return @div ->
                @span "CoffeeCharnia"
                @button id:"killButton", "×"
                @button id:"runButton", "▶"
              @select disabled:"1", ->
                @option "HTML"
                @option "PHP"
              @button id:"fromButton", class:"arrow", "«"
              @label id:"autoButton", class:"button button-on", ->
                @input type:"checkbox", checked:"1", onchange:'this.parentNode.setAttribute("class", "button button-" + (this.checked ? "on" : "off"))'
                @span id:"autoButtonText", "Auto"
              @button id:"toButton", class:"arrow", "»"
              @select disabled:"1", ->
                @option "CoffeeScript (htmlcup)"
                @option "Reflective CoffeeScript (htmlcup)"
        body: (opts)->
            @style """
              .coffeecharniaContainer textarea { background: black; color: #ddd; }
              .coffeecharniaContainer button { opacity: 0.4; }
              .coffeecharniaContainer button:hover, .coffeecharniaContainer button:focus, .coffeecharniaContainer button:active { opacity: 1; }
              """
            @div style:"position:absolute;top:0;right:0;left:0;bottom:0;overflow:hidden", ->
                @button id:"runButton", style:"width:1.5em;right:0;top:45px;position:absolute;z-index:1000000", "▶"
                @button id:"killButton", style:"width:1.5em;right:0;top:0;position:absolute;z-index:1000000", "×"
                @textarea id:"coffeeArea", class:"editArea",
                  ''''
                  # Welcome to CoffeeCharnia!

                ####
                  # Press return twice after a statement to execute it!

                  
        footer: (opts)->
          @style """
              .coffeecharniaContainer div.thisFooter, .coffeecharniaContainer .thisFooter div { text-align:center; }
              """
          @div class:"thisFooter", opts, ->
            @style
              ''''
              #resultFooter {
                /* overflow:auto; */
                vertical-align: middle;
              }
              #resultDatum {
                text-align:initial;
                vertical-align:initial;
                display:inline-block;
              }
            @div id:"resultFooter", style:"display:none", ->
              @div id:"resultDatum", ->
            @div id:"introFooter", ->
              @b "CoffeeCharnia"
              @span ->
                @span ": "
                @i "A Reflective Coffescript Console/Editor!"
              @printHtml " &bull; "
              @a href:"https://github.com/rev22/reflective-coffeescript", "Reflective Coffeescript"

      withAce = (cb)-> jsLoad 'ace', "https://github.com/ajaxorg/ace-builds/raw/master/src-min-noconflict/ace.js", cb
      withCoffee = (cb)-> jsLoad 'CoffeeScript', "lib/coffee-script.js", cb
      withAce -> withCoffee ->
        globalLibs =
          aceRefcoffeeMode:
            setup: ({ace, console, CoffeeScript})@>
                  ace.define "ace/mode/refcoffee_highlight_rules", [
                    "require"
                    "exports"
                    "module"
                    "ace/mode/coffee_highlight_rules"
                  ], (req, exports, module)->
                    RefcoffeeHighlightRules = ->
                      @$rules.start = [
                          {
                            stateName: "litdoc"
                            token: "string"
                            regex: "''''"
                          }
                      ].concat @$rules.start

                      @$rules.start = for x in @$rules.start
                        if x?.regex? and typeof x.regex is 'string'
                          x.regex = x.regex.replace /\[\\-=\]>/, "[\\-=@]>"
                        x
                      
                      @normalizeRules()
                      return
                    "use strict"
                    makeClass = (p)-> c = p.constructor; c:: = p; c
                    CoffeeHighlightRules = req("./coffee_highlight_rules").CoffeeHighlightRules
                    exports.RefcoffeeHighlightRules = makeClass
                      constructor: ->
                        CoffeeHighlightRules.call @
                        RefcoffeeHighlightRules.call @
                        return
                      __proto__: CoffeeHighlightRules::
                    return
                    
                  ace.define "ace/mode/refcoffee", [
                    "require"
                    "exports"
                    "module"
                    "ace/mode/coffee"
                    "ace/mode/refcoffee_highlight_rules"
                  ], (req, exports, module)->
                    WorkerClient = undefined
                    CoffeeMode = req("ace/mode/coffee").Mode
                    makeClass = (p)-> c = p.constructor; c:: = p; c
                    Rules = req("./refcoffee_highlight_rules").RefcoffeeHighlightRules
                    Mode = makeClass
                      __proto__: CoffeeMode::
                      constructor: ->
                        CoffeeMode.call @
                        @HighlightRules = Rules
                        # @$outdent = new Outdent()
                        # @foldingRules = new FoldMode()
                        return
                    "use strict"
                    (->
                      @$id = "ace/mode/refcoffee"
                      @createWorker = (session)-> null
                      return
                    ).call Mode::
                    exports.Mode = Mode
                    return

        window.DynmodPrinter =
          pkgInfo:
            version: "DynmodPrinter 0.2.7-coffeecharnia"
            description: "Generic printer, for data and reflective code"
            copyright: "Copyright (c) 2014 Michele Bini"
            license: "MIT"
          pkgTest: @>
            testPrint = (v, r)=>
              r2 = @print(v)
              if r isnt r2
                throw "Expected representation: '#{r}', obtained: '#{r2}'"
            testPrint [ ], "[ ]"
            testPrint [ { } ], "[ { } ]"
            testPrint new @Date("2014-05-12T23:04:24.627Z"), 'new Date("2014-05-12T23:04:24.627Z")'
          Date: Date
          Array: Array
          RegExp: RegExp
          columns:
            74
          console: console
          window: window
          global: window
          globalName: "window"
          symbolicPackages: true
          # maxLines: 1000
          newline: @> true
          limitLines: (maxLines)@>
            lines: 0
            maxLines: maxLines
            newline: @> @lines++ < @maxLines
            __proto__: @
          print:
            (x, prev, depth = 0, ind = "")@>
              p = arguments.callee
              depth = depth + 1
              print = (y)=> p.call @, y, { prev, x }, depth
              clean = (x)->
                if /^[(]([(@][^\n]*)[)]$/.test x
                  x.substring(1, x.length - 1)
                else
                  x
              if x == null
                ind + "null"
              else if x == @global
                ind + @globalName
              else if x == undefined
                ind + "undefined"
              else
                t = typeof x
                if t is "boolean"
                  ind + if x then "true" else "false"
                else if t is "number"
                  ind + @printNumber x
                else if t is "string"
                  if x.length > 8 and /\n/.test x
                    l = x.split("\n")
                    l = (x.replace /\"\"\"/g, '\"\"\"' for x in l)
                    l.unshift ind + '"""'
                    l.push     ind + '"""'
                    l.join(ind + "\n")
                  else
                    ind + '"' + x.replace(/\"/g, "\\\"") + '"'
                else if t is "function"
                  ni = ind + "  "
                  if x.coffee?
                    # YAY a reflective function!!!
                    s = x.coffee
                    if depth is 1 or /\n/.test s
                      lines = s.split "\n"
                      if lines.length > 1
                        if (mn = lines[1].match(/^[ \t]+/))?
                          mn = mn[0].length
                          id = mn - ni.length
                          if id > 0
                            x = new @RegExp("[ \\t]{#{id}}")
                            lines = (line.replace x, "" for line in lines)
                          else if id < 0
                            ni = @Array(-id + 1).join(" ")
                            lines = (ni + line for line in lines)                
                      lines.join("\n")
                    else
                      ind + "(" + s + ")"
                  else
                    ind + x.toString().replace(/\n/g, '\n' + ni)
                else if (c = (do (p = prev, c = 1)-> (return c if p.x == x; p = p.prev; c++) while p?; 0))
                  # Report cyclic structures
                  "<cycle-#{c}+#{depth - c - 1}>"
                else if t isnt "object"
                  # print object of odd type
                  "<#{t}>"
                else if @Array.isArray x
                  if x.length is 0
                    "[ ]"
                  else
                    cl = 2
                    hasLines = false
                    xxxx = for xx in x
                      break unless @newline()
                      xx = print xx
                      hasLines = true if /\n/.test xx
                      cl += 2 + xx.length
                      xx
                    if not hasLines and depth * 2 + cl + 1 < @columns
                      "[ " + xxxx.join(", ") + " ]"
                    else
                      ni = ind + "  "
                      l = [ ind + "[" ]
                      for xx in xxxx
                        l.push ni + clean(xx).replace(/\n/g, '\n' + ni)
                      l.push ind + "]"
                      l.join "\n"
                else
                  l = [ ]
                  @window?.document?   and   x.id?   and   typeof x.id is "string"   and   x is @window.document.getElementById x.id   then
                    return "#{ind}window.document.getElementById '#{ x.id.replace(/\'/, "\\'") }'"
                  @symbolicPackages and depth > 1 and (packageVersion = x.pkgInfo?.version)? then
                    return ind + "dynmodArchive.load '" + packageVersion.replace(/\ .*/, "") + "'"
                  ind = ""
                  if x instanceof @Date
                    return "new Date(\"#{x.toISOString()}\")"
                  keys = (k for k of x)
                  if keys.length is 0
                    return "{ }"
                  unless (!prev? or typeof prev.x is "object" and !@Array.isArray prev.x)
                    l = [ "do->" ]
                    ind = "  "
                  ni = ind + "  "
                  # keys = (h)@> (x for x of h).sort()
                  for k in keys
                    break unless @newline()
                    v = x[k]
                    if @global[k] is v
                      # l.push ind + k + ": eval " + "'" + k + "'"
                      l.push "#{ind}#{k}: #{@globalName}.#{k}"
                    else
                      v = clean(print v).replace(/\n/g, '\n' + ni)
                      if !/\n/.test(v) and  ind.length + k.toString().length + 2 + v.length < @columns
                        l.push ind + k + ": " + v
                      else
                        l.push ind + k + ":"
                        l.push ni + v
                  if l.length
                    l.join "\n"
                  else
                    "{ }"
          printNumber:
            (x)@> "#{x}"
        
        window.coffeecharnia = app =
          libs:
            CoffeeScript: window.CoffeeScript
            aceRefcoffeeMode: globalLibs.aceRefcoffeeMode
            ace: window.ace
            DynmodPrinter: DynmodPrinter
          
          eval: window.eval
          setTimeout: window.setTimeout
          getInputSelection: window.getInputSelection
          global: window.eval 'window'
          window: window

          view: ((x)-> r = {}; r[v] = document.getElementById(v) for v in x.split(","); r ) "coffeeArea,runButton,killButton,introFooter,resultFooter,resultDatum,coffeecharniaConsole"

          accumulator: [ ]

          printHtml: (s)@>
            @accumulator.push s

          isConverting: false

          processSource: (s)@> "((x)->x.call(spiritcase)) ()->" + ("\n" + s).replace(/\n/g, "\n  ")

          evalCoffeescript: (x)@>
            @eval(@libs.CoffeeScript.compile(@processSource(x), bare:true))

          evalWithSourceMap: (x)@>
            # This technique does not seem to work properly on Chromium 22
            { js, sourceMapV3, file_name } = @libs.CoffeeScript.compile x, sourceMap: 1
            @lastSourceMap = ""
            @eval(js)

          preQuote: (x)@> "<pre>#{ x.replace /</g, "&lt;" }</pre>"

          printVal: (x)@>
            @preQuote(@libs.DynmodPrinter.limitLines(1000).print(x))
            # x.toString()

          recalculateTextareaSize: @>
            { setTimeout } = @
            setTimeout (=>
              editor = @view.coffeeArea.transformed
              editor.resize()
              editor.renderer.scrollCursorIntoView()
            ), 0
          
          runButtonClick: @>
            x = @view.coffeeArea.value
            isError = null
            val = if true
              @evalCoffeescript x catch error
                isError = true
                val = error.stack ? error?.toString() ? error ? "Undefined error"
            else
              @evalWithSourceMap x
            { coffeecharniaConsole: console, introFooter, resultFooter, resultDatum } = @view
            if val?
              introFooter.setAttribute "style", "display:none"
              # resultFooter.setAttribute "style", "max-height:#{console.getBoundingClientRect().height / 2.6 | 0}px"
              resultFooter.setAttribute "style", ""
              if isError
                resultDatum.innerHTML = @preQuote val
              else
                resultDatum.innerHTML = @printVal val              
            else
              introFooter.setAttribute "style", ""
              resultFooter.setAttribute "style", "display:none"
              resultDatum.innerHTML = ""
            (@aceEditor())? then
              @recalculateTextareaSize()
            else
              { setTimeout } = @
              if true
                # Keep it Simple!
                setTimeout (=> @view.coffeeArea.scrollTop += 999999), 0
                return 
              fixUp = =>
                area = @view.coffeeArea
                area.focus()
                (pos = area.selectionEnd)? then
                  pos--
                  area.setSelectionRange?(pos, pos)
              setTimeout fixUp, 0
          setup: @>
            # @fs.readFileSync = (x)=> @readFileSync(x)
            # @fs.writeFileSync = (x)=> @readFileSync(x)
            # @ace? and @setupAce()
            app = @
            @view.runButton.onclick = => @runButtonClick()
            @view.killButton.onclick = => @killButtonClick()
            area = @view.coffeeArea
            area.focus()
            (pos = area.value.length)? then area.setSelectionRange?(pos, pos)
            area.setupTransform = (editor)->
              area.transformed = editor
              app.aceRefcoffeeMode (mode)->
                editor.getSession().setMode(mode)
              editor.setTheme("ace/theme/merbivore")
            window.onkeydown = (event)->
              return app.handleEnterKey?(event) if event.keyCode and event.keyCode is 13
              true

          getElement: @> @view.coffeecharniaConsole

          killButtonClick: @> el = @getElement(); el.setAttribute "style", el.getAttribute("style") + ";display:none"

          getSelection: @>
            (t = @view.coffeeArea.transformed)? then
              t.getSelection()
            else
              @getInputSelection(@view)

          aceEditor: @>
            @view.coffeeArea.transformed
    
          handleEnterKey: (event)@>
            app.captured = event
            if event.shiftKey
              return true
            if event.ctrlKey
                  @runButtonClick()
                  return false
            (editor = @aceEditor())? then
              alert = @alert
              cursorPosition = editor.getCursorPosition()
              doc = editor.session.doc
              lines = doc.getLength()
              # lines - 1 <= cursorPosition.row then
              line = doc.getLine(cursorPosition.row)
              !/\S/.test(line) then
                      line.length is cursorPosition.column then
                          @runButtonClick()
                          return false
            else
              area = @view.coffeeArea
              (end = area.selectionEnd)? then
                text = area.value
                text.length > 0 and text.length <= end and text[text.length - 1] is "\n" then
                    @runButtonClick()
                    return false
            true

          aceRefcoffeeMode: (cb)@>
            cb? then
              ace = @libs.ace
              ace.config.loadModule "ace/mode/coffee", =>
                @libs.aceRefcoffeeMode.setup ace: @libs.ace, CoffeeScript: @libs.CoffeeScript
                cb "ace/mode/refcoffee"
            else
              try
                @libs.aceRefcoffeeMode.setup ace: @libs.ace, CoffeeScript: @libs.CoffeeScript
                @libs.ace.require("ace/mode/refcoffee")
                "ace/mode/refcoffee"
              catch e
                "ace/mode/coffee"

          # ace: ace ? null
          # setupAce: @> @ace.edit(@view.coffeeArea)

          Error: Error

          files: { }

        app.setup()

        
        # Some sane defaults!  However, this code does not seem to effect any change
        false then ace?.options =
            mode:             "coffee"
            theme:            "cobalt"
            gutter:           "true"
            # fontSize:         "10px"
            # softWrap:         "off"
            # keybindings:      "ace"
            # showPrintMargin:  "true"
            # useSoftTabs:      "true"
            # showInvisibles:   "false"

        inject = (options, callback) ->
          baseUrl = options.baseUrl or "../../src-noconflict"
          load = (path, callback) ->
            head = document.getElementsByTagName("head")[0]
            s = document.createElement("script")
            s.src = baseUrl + "/" + path
            head.appendChild s
            s.onload = s.onreadystatechange = (_, isAbort) ->
              if isAbort or not s.readyState or s.readyState is "loaded" or s.readyState is "complete"
                s = s.onload = s.onreadystatechange = null
                callback()  unless isAbort
              return

            return

          if ace?
            
            # load("ace.js", function() {
            ace.config.loadModule "ace/ext/textarea", ->
              if false
                event = ace.require("ace/lib/event")
                areas = document.getElementsByTagName("textarea")
                i = 0

                while i < areas.length
                  event.addListener areas[i], "click", (e) ->
                    ace.transformTextarea e.target, options.ace  if e.detail is 3
                    return

                  i++
              callback and callback()
              return

          return

        # });

        camelcapBookmarklet = (ace)->
          return if document.getElementById "ccapcss"
          ace.require ["ace/layer/text"], ({Text}) ->
            return if document.getElementById "ccapcss"
            orig = Text.prototype.$renderToken
          
            patched = do (
              rgx = new RegExp "[a-z][0-9]*[A-Z]", "g"
            ) -> (builder, col, token, value) ->
              if match = rgx.exec value
                type = token.type
                type_c = type + ".ccap"
                p = 0
                loop
                  q = rgx.lastIndex - 1
                  s = value.substring(p, q)
                  col = orig.call @, builder, col, { type, value: s }, s
                  s = value.substring(q, p = q + 1)
                  col = orig.call @, builder, col, { type: type_c, value: s }, s
                  break unless match = rgx.exec value
                s = value.substring(p)
                orig.call @, builder, col, { type, value: s }, s            
              else
                orig.apply @, arguments
          
            Text.prototype.$renderToken = patched
          
            x = document.createElement "style"
            x.id = "ccapcss"
            x.innerHTML = ".ace_ccap { font-weight: bold; }"
            document.head.appendChild x
        ace? then camelcapBookmarklet(ace)

        # Call the inject function to load the ace files.
        inject {}, ->
          
          # Transform the textarea on the page into an ace editor.
          for a in (x for x in document.getElementsByClassName("editArea")).reverse()
            do (a, e = ace.require("ace/ext/textarea").transformTextarea(a))->
              e = ace.require("ace/ext/textarea").transformTextarea(a)
              e.navigateFileEnd()
              a.setupTransform(e)
              a.onchange = ->
                # alert "a onchange " + x
                e.setValue @value, -1
                return

              e.on "change", ->
                # alert "e change " + x
                a.value = e.getValue()
                a.oninput?()
                return

              e.on "blur", ->
                # alert "e blur " + x
                a.value = e.getValue()
                a.onblur?()
                return

              e.on "focus", ->
                a.onfocus?()
                return
          return      
        
    @coffeeScript ->
      spiritcase.loadDataUrl window.cuteluh_terror
      setTimeout (-> spiritcase.loadDataUrl window.cuteluh_terror), 1000
      setTimeout (-> spiritcase.loadDataUrl window.cuteluh_terror), 3000
      setTimeout (-> spiritcase.loadDataUrl window.cuteluh_terror), 10000
