# Soda

Gorgeous and powerful GUI/ button library for [Codea](http://codea.io) projects.

I'm calling it Soda as it is inspired by Cider (but is not a fork).

## Features

#### Simple but powerful parent-child relationship between interface elements

+ Positions and dimensions of elements are defined relative to the parent of the element (ie the frame or window that they are in). Positions can be defined relative to any edge of the enclosing frame, or as a proportion of the parent frame. Decide a window is too cluttered? No need to move all of the elements around, just resize the parent window.

+ Elements automatically and intelligently resize when device orientation changes

+ A collection of elements can be moved around the screen, hidden or made inactive, just by addressing the parent of the collection

+ Drawing and touching are automatically handled in order to get the correct draw and touch order so that, for instance, it is not possible to touch an element through an overlying window.

#### Gorgeous and fast-performing graphics

+ 196-sample Gaussian blur shader used for proper drop-shadows and blurred panel effects

+ True rounded-rectangle mesh with an anti-aliased stroke, allows for translucent rounded-rectangles

+ Graphics kept largely separate from button logic (in the Style tab), making Soda very easily customisable and skinnable

## Screenshots

![various buttons](https://puffinturtle.files.wordpress.com/2015/09/image2.jpg) Various buttons in a segmented panel

![blurred alert](https://puffinturtle.files.wordpress.com/2015/09/image3.jpg) An alert dialog with a blurred effect

![DropDownList](https://puffinturtle.files.wordpress.com/2015/09/image4.jpg) A drop down list for autopopulating a text field

![TextWindow](https://puffinturtle.files.wordpress.com/2015/09/image5.jpg) A window for scrolling through large bodies of text

## Forum Discussion

http://codea.io/talk/discussion/6847/soda-gorgeous-and-powerful-gui-windowing-button-library-for-codea

## Version Notes

#### v1.2

+ Callbacks have been made more consistent and are triggered by more elements. Callbacks are now always triggered as `self:callback` (with a colon) so the first argument passed to the callback will always be the sender's self. If you have any callbacks that take an argument, eg `callback = function(inkey)`, these will now need to have a `self`/`this` variable as their first argument: `callback = function(this, inkey)`.

  - In `Soda.TextEntry`, callback is triggered by hitting return or the close keyboard button (but not by selecting a different interface element, which closes the keyboard and cancels text entry). Callback is passed the string entered.

  - `Soda.Toggle` and `Soda.Switch` have two callbacks: `callback` (when on state is activated) and `callbackOff`

+ new `update` parameter. Like a callback, but triggered every frame, in case any elemenets need constant updating (see the new profiler panel in the demo).

+ The switch button logic has been taken out of `Soda.Switch` and put in a new class `Soda.Toggle`. This means that switch button logic is now separate from the animation of `Soda.Switch`. `Soda.Switch` remains as before, an iOS-style switch with an animated lever. `Soda.Toggle` allows any button to operate as a toggle switch.

+ If you're using iOS 9, TextEntry fields now have cut, copy, and paste ;-)

+ The `Soda.Control` wrapper is now called 'Soda.Window'

## Usage

### Installation

Copy the contents of /SodaInstaller.lua. It is easiest to do this from the RAW page. In Codea, long-press "+ Add New Project", and select "Paste into project".

### Connecting Soda to your project

To incorporate Soda into your own project, make Soda a dependency of your own project. Do this by tapping the plus icon in the top-right corner of the code editor of your project, and checking the box next to Soda.

#### Core function hooks

Soda needs hooks into the five built-in functions `setup`, `draw`, `touched`, `keyboard`, and `orientationChanged`, that pass the arguments of those functions into Soda. These are `Soda.setup()`, `Soda.draw(breakPoint)`,* `Soda.touched(touch)`, `Soda.keyboard(key)`, and `Soda.orientationChanged(ori)` . How to call these hooks can be found in the `Main` tab of Soda.

```lua
function setup()
    -- do your setting up
    Soda.setup()
end

function draw()
    --do your updating
    Soda.drawing()
end

function Soda.drawing(breakPoint) --in order for gaussian blur to work, do all your drawing here
    Soda.camera()
    background(40, 40, 50)
    --do your project's drawing
    Soda.draw(breakPoint)
end

--user inputs:

function touched(touch)
    Soda.touched(touch)
    --do underlying touches (won't trigger if a Soda touch event is called)
end

function keyboard(key)
    Soda.keyboard(key)
end

function orientationChanged(ori)
    --do your orientation changes
    Soda.orientationChanged(ori)
end
```

You can copy this Main tab and use it as a template for your projects that use Soda.

#### * About blurred panels and `Soda.drawing`

If you want blurry panels to blur elements that lie beneath the interface, you will need to place this drawing in a function in your own project titled `Soda.drawing(breakPoint)`. When a new blurred panel is created, `Soda.drawing` is run twice, once to be output to the screen as normal, and a second pass with the gaussian blur effect applied. There needs to be a breakpoint variable in order to prevent the blurred window itself being incorporated into the blurred effect. For best results, separate your drawing from all other code that may be in your draw loop (updating positions etc), and place just the drawing in `Soda.drawing`.

NB for performance reasons, currently the blurred panels do not have live updating of the underlying image being blurred. The blurred image is only generated when the panel is first declared, or the orientation changes. They therefore look best if the underlying image is not moving.

### Adding interface elements to your code

Add interface elements to your code with constructors consisting of a Soda element and a table of arguments. All Soda elements take a single table of parameters as an argument. In Lua, if a function takes a single table or a single string as its argument, then the `()` brackets that ususally enclose the arguments can be omitted. So, `Soda.Button{title = "Press Me"}` is the same as `Soda.Button({title = "Press Me"})`, but with less typing. Keys can be supplied in any order, and very few are compulsory (Soda will supply defaults for certain missing values).

Soda will automatically record each UI element you create. Therefore Soda constructors are "fire and forget". Soda does this in order to ensure the correct order of drawing and touching (so that, for example, you cannot touch a button hidden beneath a pop-up dialog window). You will ony need to define local handles for UI elements if you need to refer to that element, usually in either a callback, or to make that element the parent of others (see /tabs/Demo for examples).

#### Interface elements

+ `Soda.Frame` - A container for other UI elements (a window).

+ `Soda.Button` - One press to activate a callback. Has a variety of built-in defaults for frequently-used interface elements such as:
  - `Soda.SettingsButton` the settings "gear" icon
  - `Soda.MenuButton` the "hamburger" menu button
  - `Soda.BackButton` (add `direction = RIGHT` if you want a right facing button)
  - `Soda.CloseButton` an "X" close icon
  - `Soda.DropdownButton` a triangle pointing down
  - `Soda.AddButton` a big "+"
  - `Soda.QueryButton` a big "?"

* `Soda.Toggle` - Toggles on and off. Additional arguments:
  + `on` - flag. `Soda.Toggle` is off by default. Set this to true to override this behaviour.
  + `callback`, `callbackOff` - in addition to `callback` parameter (see General Parameters below), fired when switch turns on, there is a `callbackOff`, triggered when the switch is turned off.

  Additional methods:

  + `:switchOn()`, `:switchOff()` - methods to switch the toggle on or off (and fire its callbacks), in case you need to automate the switches.

  Built-in defaults:

  + `Soda.MenuToggle` the "hamburger" menu button, as a toggle

+ `Soda.Switch` - An iOS-style toggle with a lever that slides back and forth. Same arguments and methods as `Soda.Toggle`

+ `Soda.Segment` - Horizontally segmented buttons that activate different frames/ panels. Additional arguments:
  + `text` - array of strings. Describes how each segment will be labelled.
  + `panels` - array of UI element identifiers. Identifies which panels the segmented button will flick between, corresponds with `text` array

+ `Soda.List` - A vertically scrolling list of elements that the user can select from. Has elastic snap-back when user scrolls past edge of list. Can easily be set up as a drop down list for auto-populating a text field. Additional arguments:
  + `text` - array of strings. One string for each item in the list.

+ `Soda.TextEntry` - A text entry field with a touchable cursor, and scrolling if the input is too long for the field. Additional arguments:
  + `default` - string. Default text that can be overwritten by the user.

  Additional method:

  + `:inputString(string)` - in case you need to populate the field with a string

+ `Soda.TextScroll`, `Soda.TextWindow`. `Soda.TextScroll` is a window for handling scrolling through large bodies of text. `Soda.TextWindow` is a wrapper that adds a close button to the text window. Additional method:

   + `:inputString(string)` - as above

+ Various alerts and dialogs:
  - `Soda.Alert` - alert message plus single OK button
  - `Soda.Alert2` - OK and cancel buttons. Additional arguments:
    * `ok` - override default "OK" button text
    * `cancel` - overide "cancel" button text
  - `Soda.Window` - a standard window with a title and rounded corners.

#### General Parameters

Not all parameters are currently supported by all Soda UI elements.

+ `parent` - UI element identifier. The parent of this element. Positions and dimensions are defined relative to the parent. Elements without any parent are top-level.

+ `x`,`y`,`w`,`h` - float. Position and dimensions of element, defined relative to the parent, or to the viewable screen if there is no parent, according to 3 rules:
  1. if x,y,w, or h are positive integers, they behave as normal coordinates in rectMode CORNER (ie pixels from the origin)
  2. if x,y,w,or h are floating point between 0 and 1, they describe proportions in CENTER mode (x,y 0.5 is centred)
  3. if x,y,w, or h are negative, they describe distance in pixels from the TOP or RIGHT edge, as in CORNERS mode (ie, w,h become x2,y2 rather than width and height). if x and y are negative, they also behave the same way as w,h, describing the distance between the TOP/RIGHT edge of the parent, and the TOP/RIGHT edge of the child (they also become x2, y2).

  the above 3 rules can be mixed together in one definition. eg a button fixed to the bottom right corner of its parent with a 20 pixel border, with a variable width of a quarter of its parent's width, and a fixed height of 40 pixels, would be: x = -20, y = 20, w = 0.25, h = 40.

+ `title` - string. The text that will label this element

+ `text` - table of strings. Used by elements made of multiple parts such as `Soda.Segment`, `Soda.List`

+ `default` - string. Used by `Soda.textEntry` for default text that can be overwritten by the user.

+ `callback` - function. Triggered by completing actions (pressing a button, hitting return in textEntry). Callbacks are always triggered as `self:callback` (with a colon) so the first argument passed to the callback will always be the sender's self.
  - In `Soda.TextEntry`, callback is triggered by hitting return or the close keyboard button (but not by selecting a different interface element, which closes the keyboard and cancels text entry). Callback is passed the string entered.
  - In `Soda.List`, callback is passed the item that was selected
  - `Soda.Toggle` and `Soda.Switch` have two callbacks: `callback` (when on state is activated) and `callbackOff`

+ `update` - function. Fired every frame, in case an element needs constant live-updating (eg a window displaying constantly changing stats)

+ `on` - flag. `Soda.Switch` is off by default. Set this to true to override this behaviour.

+ `hidden` - flag. Set to true for elements that are hidden initially. (NB make sure you add a button that will `:show()` or `:toggle()` the element)

+ `shape` - function pointer. Set (or override) the default shape of the element. Currently, only `Soda.RoundedRectangle` supports blurred panels

+ `style` - table pointer. set (or override) the default style of the element (see Style tab)

+ `panels` - table of UI element identifiers. Used only by `Soda.Segment` to identify which panels the segmented button will flick between

+ `alert` - flag. Set to true to darken and disable the underlying interface elements until this element has been dismissed. Use sparingly, for important alerts only.

+ `blurred` - flag. Make this a blurry panel. Currently only supported for Rounded Rectangle. Use sparingly. Instead of layering blurs on top of one another, consider making only the underlying element blurred, and overlying elements transparent.

+ `shadow` - flag. Add a drop-shadow.

+ `shapeArgs` - table of parameters to be passed to the shape function. Currently only supported by `Soda.roundedRectangle`. Arguments:
  - `corners` - bitwise flag. Sets which corners to round. Corners are numbered 1,2,4,8 starting in bottom-left and proceeding clockwise. Defaults to 15 (all corners). Use bitwise operators to set. eg to only round the bottom corners set this to `1 | 8` (1 or 8). To round all but the top-right corner, use `~4` (not 4)
  - `radius` - the radius of the rounded corners. Defaults to 6.

### Methods

+ `:show(direction)`, `:hide(direction)`, `:toggle(direction)` - Makes the element, and its chidren if it has any, appear (and become active) and disappear (and become inactive), or toggle between the two states. The optional direction argument can be set to either `LEFT` or `RIGHT`, and will make the element slide in and out of the left and right sides of the screen. If direction is not specified, the element will appear and disappear without animation.

+ `:inputString(string)` - method to add text to `Soda.TextEntry`, `Soda.TextWindow` (and `Soda.TextScroll`)


## Known Issues

* If the height of a scroll box's contents is shorter than the height of the box itself, elastic snap-back behaves strangely
* Sometimes vertical lists return the wrong result
* Can only scroll a textbox by adding and deleting text

## Roadmap

+ Sliders.

+ Improvements to TextEntry:

  + Be able to select a word with a double-tap, or the entire field with a triple-tap.

  + Be able to scroll the field leftwards by moving the cursor (currently you can only scroll leftward by deleting)

+ Add a factory for easier creation of the drop-down list seen in the demo

+ Add a rect shape that supports textures and aliased strokes, so that you can have rectangular blurred panels that match the same stroke as the rounded rectangles