# RamerDouglasPeucker.lua
The Ramer–Douglas–Peucker algorithm takes a curve composed of line segments (connected points), and then finds a visually similar curve that requires fewer points.

The module returns a single function that accepts your input and outputs the simplified set of points.

## Parameters:
- **points**
  - Description: An array of points you wish to simplify. The points themselves can be `Vector2` objects or anything with `X` and `Y` properties (such as a simple dictionary).
  - Type: array&lt;Vector2-like&gt;
  - Required
- **tolerance**
  - Description: A number defining the degree you wish to simplify your set of points. Higher means less points, but lower quality and loss in data complexity. Lower means more points, higher quality, and higher data complexity.
  - Type: number
  - Optional: Default is `1`
- **highestQuality**
  - Description: Whether or not to skip the radial distance simplification, which will increase quality but also increases complexity.
  - Type: boolean
  - Optional: Default is `false`
- **X**
  - Description: Specify a key name for X values.
  - type: string
  - Optional: Default is `x`
- **Y**
  - Description: Specify a key name for Y values.
  - type: string
  - Optional: Default is `y`

## Returns:
  - Description: An array of simplified points, re-using a subset of the points you passed in. (If you pass in `Vector2`s, you will get `Vector2`s back; if you pass in a dictionaries with `X` and `Y` properties, you will get that back.)
  - Type: array&lt;Vector2-like&gt;

## Demo use case:
[Simplifying player drawings to reduce instance overhead](https://gfycat.com/MemorableWiltedAnkole)