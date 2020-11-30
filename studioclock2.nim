## Nim studio clock

## needs sdl2 ("nimble install sdl2")

import sdl2, times, math

let
  size = [400, 400]
  center = [size[0] div 2, size[1] div 2]
  ra = 0.4 * float(size[0])
  xpos = [0, 6, 14, 20]
  T = true
  F = false

discard sdl2.init(INIT_EVERYTHING)

var
  window: WindowPtr
  render: RendererPtr

window = createWindow("Studio Clock 2", 100, 100, cint(size[0]), cint(size[1]), SDL_WINDOW_SHOWN)
render = createRenderer(window, -1, Renderer_Accelerated or
    Renderer_PresentVsync or Renderer_TargetTexture)

var
  evt = sdl2.defaultEvent
  runGame = true
  r: Rect
  led: array[25, array[7, bool]]
  digits: array[10, array[35, bool]]

digits = [   
        [F, T, T, T, F,
         T, F, F, F, T,
         T, F, F, F, T,
         T, F, F, F, T,
         T, F, F, F, T,
         T, F, F, F, T,
         F, T, T, T, F],
         
        [F, F, T, F, F,
         F, T, T, F, F,
         F, F, T, F, F,
         F, F, T, F, F,
         F, F, T, F, F,
         F, F, T, F, F,
         F, T, T, T, F],
        
        [F, T, T, T, F,
         T, F, F, F, T,
         F, F, F, F, T,
         F, T, T, T, F,
         T, F, F, F, F,
         T, F, F, F, F,
         T, T, T, T, T],
         
        [F, T, T, T, F,
         T, F, F, F, T,
         F, F, F, F, T,
         F, F, T, T, F,
         F, F, F, F, T,
         T, F, F, F, T,
         F, T, T, T, F],
         
        [F, F, F, T, F,
         F, F, T, T, F,
         F, T, F, T, F,
         T, F, F, T, F,
         T, T, T, T, T,
         F, F, F, T, F,
         F, F, F, T, F],
         
        [T, T, T, T, T,
         T, F, F, F, F,
         T, F, F, F, F,
         T, T, T, T, F,
         F, F, F, F, T,
         T, F, F, F, T,
         F, T, T, T, F],
        
        [F, F, T, T, F,
         F, T, F, F, F,
         T, F, F, F, F,
         T, T, T, T, F,
         T, F, F, F, T,
         T, F, F, F, T,
         F, T, T, T, F],
         
        [T, T, T, T, T,
         F, F, F, F, T,
         F, F, F, T, F,
         F, F, T, F, F,
         F, T, F, F, F,
         F, T, F, F, F,
         F, T, F, F, F],
         
        [F, T, T, T, F,
         T, F, F, F, T,
         T, F, F, F, T,
         F, T, T, T, F,
         T, F, F, F, T,
         T, F, F, F, T,
         F, T, T, T, F],
         
        [F, T, T, T, F,
         T, F, F, F, T,
         T, F, F, F, T,
         F, T, T, T, T,
         F, F, F, F, T,
         T, F, F, F, T,
         F, T, T, T, F]]
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
    for i in 0..6:
      led[j][i] = false
  led[12][2] = true
  led[12][4] = true

  let time = [int(h / 10), h mod 10, int(m / 10), m mod 10]
  for dig in 0..3:
    for j in 0..4:
      for i in 0..6:
        if digits[time[dig]][5 * i + j] == true:
          led[j + xpos[dig]][i] = true

  for j in 0..24:
    for i in 0..6:
      r.x = cint(center[0] + int(-12.5 * 8 + float(j) * 8.0))
      r.y = cint(center[1] + int( -3.5 * 8 + float(i) * 8.0))
      if led[j][i]:
        render.fillRect(r)

  render.present()
  delay(100)

destroy render
destroy window

