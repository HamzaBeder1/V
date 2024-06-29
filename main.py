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
    timeout=10
)

buff = []

def processInput():
    global buff
    display = ser.read()
    display = str(display)
    if(display != "b''"):
        buff.append(display)
    if(len(buff) == 4):
        convertBuff = [str(digit) for digit in buff]
        result = ' '.join(convertBuff).replace('b', '')
        result = result[::-1]
        print(result)
        buff = []

def main():
    processInput()

if __name__ == "__main__":
    main()
