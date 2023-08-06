from tkinter import *

def main():
    a = Tk()
    horizontalScroll = Scrollbar(a, width = 30, orient = HORIZONTAL)
    verticalScroll = Scrollbar(a, width = 30, orient = VERTICAL)
    horizontalScroll.pack(fill=X, side = BOTTOM)
    verticalScroll.pack(fill=Y, side = RIGHT)
    textbox = Text(a, xscrollcommand = horizontalScroll.set, yscrollcommand = verticalScroll.set, wrap = "none")
    horizontalScroll.config(command=textbox.xview)
    verticalScroll.config(command=textbox.yview)
    textbox.pack(fill  = BOTH, expand = TRUE)

    git


    a.mainloop()

if __name__ == "__main__":
    main()