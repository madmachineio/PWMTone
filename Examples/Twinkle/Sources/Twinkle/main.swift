import SwiftIO
import SwiftIOBoard
import PWMTone

var halfStep = 0
var bpm = 60
let player = PWMTone(PWMOut(Id.PWM2B))


player.setBPM(bpm)

while true {
    player.play(track: Music.twinkle, halfStep: halfStep)

    halfStep += 12
    bpm += 40
    player.setBPM(bpm)
    sleep(ms: 1000)
}
