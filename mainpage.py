import serial
import time
import datetime
import PySimpleGUI as sg
from playsound import playsound
import array as arr

display_time = 0

sg.theme('Black')
layout_title = [[sg.Text("Alarm Clock", justification = 'c', font = ("Times New Roman", 100, 'bold'), text_color = ('red'))]]
time_elem = sg.Text(display_time, key = 'text', font = ("Times New Roman", 100, 'bold'))
layout_time = [[time_elem]]
layout = [[sg.Column(layout_title, justification = 'c')], [sg.Column(layout_time, justification = 'c')], [sg.Button("Ok")]]
window = sg.Window("Alarm Clock", layout).Finalize()
window.Maximize()

def change_time():
    global display_time
    while 1:
        curr = datetime.datetime.now()
        currentHour = curr.hour
        currentMinute = curr.minute
        display_time = str(currentHour) + ":" + str(currentMinute)
        window.write_event_value('-THREAD EVENT-', 1)
        if(display_time == set_time):
            playsound('testsound.mp3')

window.start_thread(lambda: change_time(), "DONE")
num = 0

while True:
   event, values= window.read()
   if event == sg.WIN_CLOSED:
       break
   if event == '-THREAD EVENT-':
       window['text'].update(display_time)
       window.refresh()

window.close()
print("Done.")

