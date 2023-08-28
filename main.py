from tkinter import *
from tkinter.ttk import *
import time
import serial

ser = serial.Serial(
    port='COM4',
    baudrate=9600,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS,
    timeout=10000
)

buff = []
root = Tk()
root.title("UART Project")
label = Label(root, text="View the 7-segment digits below", font=("Arial", 25))
label.pack()

def processInput():
    global num1
    global buff
    display = ser.read()
    display = str(display)
    if(display != "b''"):
        buff.append(display)
    if(len(buff) == 4):
        convertBuff = [str(digit) for digit in buff]
        result = ' '.join(convertBuff).replace('b', '')
        result = result[::-1]
        label.config(text=result)
        buff = []
    root.after(5000, processInput)

root.after(5000, processInput)
root.mainloop()


