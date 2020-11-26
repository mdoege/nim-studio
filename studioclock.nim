## Nim studio clock

## needs sdl2 ("nimble install sdl2")

import sdl2, times, math

let
  size = [400, 400]
  center = [size[0] div 2, size[1] div 2]
  ra = 0.4 * float(size[0])
  xpos = [0, 6, 14, 20]

discard sdl2.init(INIT_EVERYTHING)

var
  window: WindowPtr
  render: RendererPtr

window = createWindow("Studio Clock", 100, 100, cint(size[0]), cint(size[1]), SDL_WINDOW_SHOWN)
render = createRenderer(window, -1, Renderer_Accelerated or
    Renderer_PresentVsync or Renderer_TargetTexture)

var
  evt = sdl2.defaultEvent
  runGame = true
  r: Rect
  led: array[25, array[9, bool]]
  digits: array[10, array[5, string]]

digits[0][0..4] = [
"011101110",
"100000001",
"100000001",
"100000001",
"011101110"]
digits[1][0..4] = [
"000000000",
"000000000",
"000000000",
"000000000",
"011101110"]
digits[2][0..4] = [
"000001110",
"100010001",
"100010001",
"100010001",
"011100000"]
digits[3][0..4] = [
"000000000",
"100010001",
"100010001",
"100010001",
"011101110"]
digits[4][0..4] = [
"011100000",
"000010000",
"000010000",
"000010000",
"011101110"]
digits[5][0..4] = [
"011100000",
"100010001",
"100010001",
"100010001",
"000001110"]
digits[6][0..4] = [
"011101110",
"100010001",
"100010001",
"100010001",
"000001110"]
digits[7][0..4] = [
"000000000",
"100000000",
"100000000",
"100000000",
"011101110"]
digits[8][0..4] = [
"011101110",
"100010001",
"100010001",
"100010001",
"011101110"]
digits[9][0..4] = [
"011100000",
"100010001",
"100010001",
"100010001",
"011101110"]

r.w = 6
r.h = 6
let rh = r.w div 2

while runGame:
  let
    n = now()
    h = n.hour
    m = n.minute
    s = n.second
  while pollEvent evt:
    if evt.kind == QuitEvent:
      runGame = false
      break
  render.setDrawColor(0, 0, 0)
  render.clear
  render.setDrawColor(255, 0, 0)

  for i in 0..11:
    r.x = cint(center[0] - rh + int(ra * sin(2.0 * PI * float(i) / 12.0)))
    r.y = cint(center[1] - rh - int(ra * cos(2.0 * PI * float(i) / 12.0)))
    render.fillRect(r)
  for i in 0..s:
    r.x = cint(center[0] - rh + int(0.9 * ra * sin(2.0 * PI * float(i) / 60.0)))
    r.y = cint(center[1] - rh - int(0.9 * ra * cos(2.0 * PI * float(i) / 60.0)))
    render.fillRect(r)

  for j in 0..24:
    for i in 0..8:
      led[j][i] = false
  led[12][3] = true
  led[12][5] = true

  let time = [int(h / 10), h mod 10, int(m / 10), m mod 10]
  for dig in 0..3:
    for j in 0..4:
      for i in 0..8:
        if digits[time[dig]][j][i] == '1':
          led[j + xpos[dig]][i] = true

  for j in 0..24:
    for i in 0..8:
      r.x = cint(center[0] + int(-12.5 * 8 + float(j) * 8.0))
      r.y = cint(center[1] + int( -4.5 * 8 + float(i) * 8.0))
      if led[j][i]:
        render.fillRect(r)

  render.present()
  delay(100)

destroy render
destroy window

